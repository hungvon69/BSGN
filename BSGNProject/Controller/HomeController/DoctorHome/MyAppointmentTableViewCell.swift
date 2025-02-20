//
//  MyAppointmentTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 16/12/24.
//

import UIKit
import FirebaseAuth

class MyAppointmentTableViewCell: UITableViewCell, SummaryMethod {
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var symtomsLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var majorLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    private var isBooked: String?
    
    private var appointmentID: String?
    private var appointment: Appointment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelButton.isHidden = true
        doneButton.isHidden = true
    }
    func configureAppointmentPatient(with ID: String) {
        self.appointmentID = ID
        GlobalService.shared.loadAppointmentWithID(appointmentID: ID) { result in
            switch result {
            case .success(let appointment):
                print(appointment)
                self.majorLabel.text = appointment.specialty
                self.symtomsLabel.text = appointment.symtoms
                self.isBooked = appointment.status
                print("=========\(self.isBooked ?? "No status")")
                self.configurePatient(with: appointment.patientID)
                self.appointment = appointment
                
                // Xử lý liên quan đến `accepted` sau khi isBooked đã được cập nhật
                guard let accepted = self.isBooked else {
                    print("=______________")
                    return
                }
                if accepted == "accepted" {
                    self.acceptButton.setTitle("Đang thực hiện", for: .normal)
                    self.acceptButton.backgroundColor = .white
                    self.acceptButton.layer.borderColor = mainColor.cgColor
                    self.acceptButton.layer.borderWidth = 1
                    self.acceptButton.layer.cornerRadius = 5
                    self.acceptButton.isEnabled = false
                    self.doneButton.isHidden = false
                    self.cancelButton.isHidden = false
                    print("-====+++++")
                } else {
                    print("NOOOOOOOOO")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    func configureDoctor(with ID: String) {
        
    }
    func configurePatient(with ID: String) {
        GlobalService.shared.loadPatientWithID(patientID: ID) { result in
            switch result {
            case .success(let patient):
                self.nameLabel.text = patient.name
                self.ageLabel.text = "Ngày sinh: " + patient.dateOfBirth
                self.addressLabel.text = "Địa chỉ: "+patient.address
                self.avatarImageView.loadAvatar(url: patient.avatar)
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func acceptTapped(_ sender: Any) {
        guard let id = appointment?.id else {
            ToastApp.show("Không tìm thấy cuộc hẹn")
            return
        }
        // Lấy ID của doctor hiện tại từ Firebase Auth
        GlobalService.shared.loadAppointmentWithID(appointmentID: id) { result in
            switch result {
            case .success(let appointment):
                self.appointment = appointment
                if appointment.doctorID == "00" {
                    self.acceptAppointment()
                } else {
                    ToastApp.show("Cuộc hẹn đã được nhận bởi bác sĩ khác")
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }
    
    func acceptAppointment() {
        guard let doctorID = Auth.auth().currentUser?.uid else { return }
        print("")
        // Load thông tin doctor từ Firebase
        GlobalService.shared.loadDoctorWithID(doctorID: doctorID) { result in
            switch result {
            case .success(let doctor):
                if doctor.isInAppointment == 0 {
                    // Đảm bảo có thông tin của cuộc hẹn
                    guard var appointment = self.appointment else { return }
                    
                    // Cập nhật thông tin của cuộc hẹn
                    appointment.doctorID = doctor.id
                    appointment.doctorName = "\(doctor.firstName) \(doctor.lastName)"
                    appointment.status = "accepted" // Cập nhật trạng thái cuộc hẹn
                    appointment.price = doctor.price
                    // Tạo doctor mới với trạng thái đã trong cuộc hẹn
                    var updatedDoctor = doctor
                    updatedDoctor.isInAppointment = 1 // Đánh dấu doctor đang trong cuộc hẹn
                    
                    // Load thông tin patient từ appointment
                    GlobalService.shared.loadPatientWithID(patientID: appointment.patientID) { patientResult in
                        switch patientResult {
                        case .success(let patient):
                            // Tạo patient mới với trạng thái đã trong cuộc hẹn
                            var updatedPatient = patient
                            updatedPatient.isInAppointment = 1 // Đánh dấu patient đang trong cuộc hẹn
                            
                            // Cập nhật trạng thái của doctor và patient lên Firebase
                            let dispatchGroup = DispatchGroup()
                            
                            // Cập nhật doctor
                            dispatchGroup.enter()
                            GlobalService.shared.updateDoctorInfo(doctor: updatedDoctor) { doctorUpdateResult in
                                switch doctorUpdateResult {
                                case .success:
                                    print("Doctor updated successfully.")
                                case .failure(let error):
                                    print("Failed to update doctor: \(error.localizedDescription)")
                                }
                                dispatchGroup.leave()
                            }
                            
                            // Cập nhật patient
                            dispatchGroup.enter()
                            GlobalService.shared.updatePatientInfo(patient: updatedPatient) { patientUpdateResult in
                                switch patientUpdateResult {
                                case .success:
                                    print("Patient updated successfully.")
                                case .failure(let error):
                                    print("Failed to update patient: \(error.localizedDescription)")
                                }
                                dispatchGroup.leave()
                            }
                            
                            // Chờ cả doctor và patient được cập nhật xong
                            dispatchGroup.notify(queue: .main) {
                                print("Both doctor and patient updated successfully.")
                                
                                // Cập nhật trạng thái cuộc hẹn trong Firebase
                                GlobalService.shared.updateAppointmentStatus(appointment: appointment, doctorID: doctor.id, doctorName: "\(doctor.firstName) \(doctor.lastName)")
                                print("Appointment status updated successfully.")
                            }
                        case .failure(let error):
                            print("Failed to load patient: \(error.localizedDescription)")
                        }
                    }
                            
                } else {
                    print("You are in another appointment")
                }
               
                   
                
            case .failure(let error):
                print("Failed to load doctor: \(error.localizedDescription)")
            }
        }
    }
    
}
