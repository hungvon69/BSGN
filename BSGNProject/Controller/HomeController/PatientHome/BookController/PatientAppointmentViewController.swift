//
//  PatientAppointmentViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 18/12/24.
//

import UIKit
import FirebaseAuth

class PatientAppointmentViewController: UIViewController {

    @IBOutlet private weak var doctorLb: UILabel!
    @IBOutlet private weak var waitingLabel: UILabel!
    @IBOutlet private weak var waitingImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var workLabel: UILabel!
    @IBOutlet private weak var graduatedLabel: UILabel!
    @IBOutlet private weak var majorLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var symtomsLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitingLabel.isHidden = true
        waitingImageView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup() {
        GlobalService.shared.fetchAppointmentsWithPatientID(completion: { [weak self] appointments in
            guard let self = self else { return }
            self.appointments = []
            for appointment in appointments {
                if appointment.status == "accepted" || appointment.status == "Pending" {
                    self.appointments.append(appointment)
                    print("xxxxx")
                }
            }
            
            DispatchQueue.main.async {
                if !(self.appointments.isEmpty) {
                    guard let appointment = self.appointments.last else { return }
                    if appointment.doctorID == "00" {
                        self.allHidden()
                        print("1=========1")
                    } else {
                        self.allVisible()
                        print("1=========2")
                        print(appointment)
                        self.nameLabel.text = appointment.doctorName
                        self.majorLabel.text = "Chuyên ngành: " + appointment.specialty
                        self.priceLabel.text = "Giá khám: "+String(appointment.price)
                        self.symtomsLabel.text = "Triệu chứng của bạn: " + appointment.symtoms
                        GlobalService.shared.loadDoctorWithID(doctorID: appointment.doctorID) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let doctor):
                                self.workLabel.text = "Nơi làm việc: " + doctor.training_place
                                self.graduatedLabel.text = "Tốt Nghiệp: " + doctor.education
                                self.phoneNumberLabel.text = "Số điện thoại: " + doctor.phoneNumber
                                self.avatarImageView.load(url: doctor.avatar, placeholderImage: UIImage(named: "default_doctor"))
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                } else {
                    self.allHidden()
                    self.waitingLabel.text = "Bạn chưa đặt lịch hẹn"
                    print("2=========1")
                    print(self.appointments)
                }
            }
        }, patient: Auth.auth().currentUser!.uid)
    }

    func allHidden() {
        DispatchQueue.main.async {
            self.symtomsLabel.isHidden = true
            self.cancelButton.isHidden = true
            self.nameLabel.isHidden = true
            self.majorLabel.isHidden = true
            self.priceLabel.isHidden = true
            self.workLabel.isHidden = true
            self.graduatedLabel.isHidden = true
            self.avatarImageView.isHidden = true
            self.waitingLabel.isHidden = false
            self.waitingImageView.isHidden = false
            self.phoneNumberLabel.isHidden = true
            self.doctorLb.isHidden = true
        }
    }
    func allVisible() {
        DispatchQueue.main.async {
            self.symtomsLabel.isHidden = false
            self.cancelButton.isHidden = false
            self.nameLabel.isHidden = false
            self.majorLabel.isHidden = false
            self.priceLabel.isHidden = false
            self.workLabel.isHidden = false
            self.graduatedLabel.isHidden = false
            self.phoneNumberLabel.isHidden = false
            self.avatarImageView.isHidden = false
            self.doctorLb.isHidden = false
            self.waitingLabel.isHidden = true
            self.waitingImageView.isHidden = true
        }
        
    }
}
