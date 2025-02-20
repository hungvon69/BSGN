//
//  MyAppointmentsViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 14/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyAppointmentsViewController: UIViewController {
    
    @IBOutlet weak var detailLocattionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var symtomsLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var infoBorderView: UIView!
    @IBOutlet weak var timeBorderView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var isBooked: String?
    var appointmentID: String?
    var appointment: Appointment?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        backView.backgroundColor = .clear
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "") // Thay "backgroundImageName" bằng tên ảnh
        backgroundImageView.contentMode = .scaleToFill // Cách hiển thị ảnh
        backgroundImageView.clipsToBounds = true // Cắt các phần ảnh vượt ra ngoài bounds
        
        // Thêm UIImageView vào ViewController
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    private func setup() {
        infoBorderView.backgroundColor = UIColor(hex: "#D7E6DF")
        timeBorderView.backgroundColor = UIColor(hex: "#D7E6DF")
        locationLabel.layer.cornerRadius = 5
        locationLabel.layer.masksToBounds = true
        detailLocattionLabel.layer.cornerRadius = 5
        detailLocattionLabel.layer.masksToBounds = true
    }
    
    func updateUI() {
        self.acceptButton.layer.borderColor = mainColor.cgColor
        self.acceptButton.layer.borderWidth = 1
        self.acceptButton.layer.cornerRadius = 5
        cancelButton.isHidden = appointment?.status != "accepted"
        doneButton.isHidden = appointment?.status != "accepted"
        if appointment?.status == "accepted" {
            self.acceptButton.isEnabled = false
            self.acceptButton.setTitle("Đang thực hiện", for: .normal)
            self.acceptButton.backgroundColor = .white
            self.acceptButton.layer.borderColor = mainColor.cgColor
            self.acceptButton.layer.borderWidth = 1
            self.acceptButton.layer.cornerRadius = 5
        } else {
            self.acceptButton.setTitle("Nhận ngay", for: .normal)
            self.acceptButton.backgroundColor = mainColor
            self.acceptButton.isEnabled = true
        }
    }
    
    public func configure(with appointmentID: String) {
        self.appointmentID = appointmentID
        configureAppointmentPatient(with: appointmentID)
    }
    func configureAppointmentPatient(with ID: String) {
        self.appointmentID = ID
        GlobalService.shared.loadAppointmentWithID(appointmentID: ID) { result in
            switch result {
            case .success(let appointment):
                print(appointment)
                self.locationLabel.text = "Địa chỉ khám: \(appointment.position)"
                self.detailLocattionLabel.text = "Chi tiết: \(appointment.positionNote)"
                self.majorLabel.text = appointment.specialty
                self.symtomsLabel.text = appointment.symtoms
                self.isBooked = appointment.status
                print("=========\(self.isBooked ?? "No status")")
                self.configurePatient(with: appointment.patientID)
                self.appointment = appointment
                
                // Xử lý liên quan đến `accepted` sau khi isBooked đã được cập nhật
                self.updateUI()
                
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
                self.addressLabel.text = "Địa chỉ: "+patient.address
                self.phoneLabel.text = "Số điện thoại: "+patient.phoneNumber
                self.ageLabel.text = "Ngày sinh: "+patient.dateOfBirth
                self.avatarImageView.loadAvatar(url: patient.avatar)
            case .failure(let error):
                print(error)
            }
        }
    }

    func showAlertCompleted() {
        // Tạo và hiển thị SuccessPopupView
        let popupView = PopUpView(frame: CGRect(x: 40, y: (self.view.frame.height) / 2 - 100, width: (self.view.frame.width) - 80, height: 250))
        
        // Đặt closure onConfirm để xử lý khi bấm nút "Xác nhận"
        popupView.onConfirm = {
            // Ẩn popup khi bấm nút xác nhận
            popupView.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        
        // Thêm popup vào view chính
        self.view.addSubview(popupView)
    }
    
    func showAlertCancelled() {
        let subtitle = UILabel.build(font: .systemFont(ofSize: 15, weight: .medium), color: .darkGray, lines: 2, alignment: .center)
        subtitle.text = "Cancel Appointment"
        CancellableAlertView.present(.init(title: "Alert!", content: subtitle, cancelTitle: "Oke", cancelColor: .red)) { [weak self] in
            mainAsync {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        // Hoan thanh
        guard var appointment = self.appointment else { return }
        appointment.status = "completed" // Cập nhật trạng thái cuộc hẹn
        
        guard var doctor = Global.doctor else { return }
        doctor.isInAppointment = 0
        
        // Load thông tin patient từ appointment
        GlobalService.shared.loadPatientWithID(patientID: appointment.patientID) { [weak self] patientResult in
            switch patientResult {
            case .success(let patient):
                // Tạo patient mới với trạng thái đã trong cuộc hẹn
                var updatedPatient = patient
                updatedPatient.isInAppointment = 0 // Đánh dấu patient đang trong cuộc hẹn
                
                // Cập nhật trạng thái của doctor và patient lên Firebase
                let dispatchGroup = DispatchGroup()
                
                // Cập nhật doctor
                dispatchGroup.enter()
                GlobalService.shared.updateDoctorInfo(doctor: doctor) { doctorUpdateResult in
                    Global.doctor = doctor
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
                    let ref = Database.database().reference().child("appointments").child(appointment.id)
                    ref.setValue(appointment.toDictionary())
                    print("Appointment status updated successfully.")
                    mainAsyncAfter(0.5) {
                        self?.showAlertCompleted()
                    }
                }
            case .failure(let error):
                print("Failed to load patient: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        // Bsi huy
        
        guard var appointment = self.appointment else { return }
        appointment.status = "cancelled" // Cập nhật trạng thái cuộc hẹn
        
        guard var doctor = Global.doctor else { return }
        doctor.isInAppointment = 0
        
        // Load thông tin patient từ appointment
        GlobalService.shared.loadPatientWithID(patientID: appointment.patientID) { [weak self] patientResult in
            switch patientResult {
            case .success(let patient):
                // Tạo patient mới với trạng thái đã trong cuộc hẹn
                var updatedPatient = patient
                updatedPatient.isInAppointment = 0 // Đánh dấu patient đang trong cuộc hẹn
                
                // Cập nhật trạng thái của doctor và patient lên Firebase
                let dispatchGroup = DispatchGroup()
                
                // Cập nhật doctor
                dispatchGroup.enter()
                GlobalService.shared.updateDoctorInfo(doctor: doctor) { doctorUpdateResult in
                    Global.doctor = doctor
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
                    // Cập nhật trạng thái cuộc hẹn trong Firebase
                    let ref = Database.database().reference().child("appointments").child(appointment.id)
                    ref.setValue(appointment.toDictionary())
                    print("Appointment status updated successfully.")
                    mainAsyncAfter(0.5) {
                        self?.showAlertCancelled()
                    }
                }
            case .failure(let error):
                print("Failed to load patient: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
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
                    GlobalService.shared.loadPatientWithID(patientID: appointment.patientID) { [weak self] patientResult in
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
                                self?.appointment = appointment
                                GlobalService.shared.updateAppointmentStatus(appointment: appointment, doctorID: doctor.id, doctorName: "\(doctor.firstName) \(doctor.lastName)")
                                ToastApp.show("Appointment status updated successfully.")
                                self?.updateUI()
                            }
                        case .failure(let error):
                            print("Failed to load patient: \(error.localizedDescription)")
                        }
                    }
                            
                } else {
                    print("You are in another appointment")
                    ToastApp.show("You are in another appointment")
                }
               
                   
                
            case .failure(let error):
                print("Failed to load doctor: \(error.localizedDescription)")
            }
        }
    }

}
