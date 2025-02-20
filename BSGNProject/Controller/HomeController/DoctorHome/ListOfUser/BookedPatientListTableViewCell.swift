//
//  BookedPatientListTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 14/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class BookedPatientListTableViewCell: BaseTableViewCell, SummaryMethod {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var symtomsLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    
    var appointment: Appointment?
    var parentVC: BookedPatientListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
        infoView.backgroundColor = UIColor(hex: "#A4E5C7")
    }

    @IBAction func didTapAccept(_ sender: Any) {
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
        
        // Load thông tin doctor từ Firebase
        GlobalService.shared.loadDoctorWithID(doctorID: doctorID) { result in
            switch result {
            case .success(let doctor):
                if doctor.isInAppointment == 0 {  // Kiểm tra bác sĩ có đang bận không
                    guard var appointment = self.appointment else { return }
                    
                    // Cập nhật thông tin cuộc hẹn
                    appointment.doctorID = doctor.id
                    appointment.doctorName = "\(doctor.firstName) \(doctor.lastName)"
                    appointment.status = "accepted"
                    appointment.price = doctor.price
                    
                    // Tạo doctor mới với trạng thái đã trong cuộc hẹn
                    var updatedDoctor = doctor
                    updatedDoctor.isInAppointment = 1  // Đánh dấu bác sĩ đang trong cuộc hẹn
                    
                    // Load thông tin bệnh nhân
                    GlobalService.shared.loadPatientWithID(patientID: appointment.patientID) { patientResult in
                        switch patientResult {
                        case .success(let patient):
                            var updatedPatient = patient
                            updatedPatient.isInAppointment = 1  // Đánh dấu bệnh nhân đang trong cuộc hẹn
                            
                            // Cập nhật thông tin của bác sĩ và bệnh nhân lên Firebase
                            let dispatchGroup = DispatchGroup()
                            
                            // Cập nhật bác sĩ
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
                            
                            // Cập nhật bệnh nhân
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
                            
                            // Cập nhật cuộc hẹn sau khi cả bác sĩ và bệnh nhân đã cập nhật
                            dispatchGroup.notify(queue: .main) {
                                print("Both doctor and patient updated successfully.")
                                GlobalService.shared.updateAppointmentStatus(appointment: appointment, doctorID: doctor.id, doctorName: "\(doctor.firstName) \(doctor.lastName)")
                                print("Appointment status updated successfully.")
                                
                                // Cập nhật giao diện nút "Accept" thành "Đang thực hiện"
                                self.bookButton.setTitle("Đang thực hiện", for: .normal)
                                self.bookButton.backgroundColor = .white
                                self.bookButton.layer.borderColor = mainColor.cgColor
                                self.bookButton.layer.borderWidth = 1
                                self.bookButton.layer.cornerRadius = 5
                                self.bookButton.isEnabled = false  // Vô hiệu hóa nút sau khi bác sĩ đã nhận
                                
                                // Hiển thị Popup
                                self.showSuccessPopup()
                            }
                        case .failure(let error):
                            print("Failed to load patient: \(error.localizedDescription)")
                        }
                    }
                    
                } else {
                    print("You are already in another appointment")
                }
            case .failure(let error):
                print("Failed to load doctor: \(error.localizedDescription)")
            }
        }
    }

    func showSuccessPopup() {
        // Tạo và hiển thị SuccessPopupView
        guard let parentVC else { return }
        let popupView = PopUpView(frame: CGRect(x: 40, y: (self.parentVC?.view.frame.height)! / 2 - 100, width: (self.parentVC?.view.frame.width)! - 80, height: 250))
        
        // Đặt closure onConfirm để xử lý khi bấm nút "Xác nhận"
        popupView.onConfirm = {
            // Ẩn popup khi bấm nút xác nhận
            popupView.removeFromSuperview()
        }
        
        // Thêm popup vào view chính
        self.parentVC?.view.addSubview(popupView)
    }


    func configureCell(appointment: Appointment) {
        symtomsLabel.text = appointment.symtoms
        majorLabel.text = appointment.specialty
        fullNameLabel.text = appointment.patientName
        if appointment.doctorID == Global.doctor?.id {
            self.bookButton.setTitle("Đang thực hiện", for: .normal)
            self.bookButton.backgroundColor = .white
            self.bookButton.layer.borderColor = mainColor.cgColor
            self.bookButton.layer.borderWidth = 1
            self.bookButton.layer.cornerRadius = 5
            self.bookButton.isEnabled = false
        } else {
            self.bookButton.backgroundColor = mainColor
            self.bookButton.isEnabled = Global.doctor?.isInAppointment == 0
        }
//        GlobalService.shared.loadDoctorWithID(doctorID: Auth.auth().currentUser!.uid) { result in
//            switch result {
//            case .success(let doctor):
//                if doctor.isInAppointment == 1 {
//                    if appointment.status == "accepted" {
//                        self.bookButton.setTitle("Đang thực hiện", for: .normal)
//                        self.bookButton.backgroundColor = .white
//                        self.bookButton.layer.borderColor = mainColor.cgColor
//                        self.bookButton.layer.borderWidth = 1
//                        self.bookButton.layer.cornerRadius = 5
//                    } else {
//                        self.bookButton.backgroundColor = mainColor
//                        self.bookButton.isEnabled = false
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
    }
}
