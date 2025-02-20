//
//  BookedPatientListViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 23/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BookedPatientListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var bookedPatientListTableView: UITableView!
    
    var appointmentList: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookedPatientListTableView.delegate = self
        bookedPatientListTableView.dataSource = self
        bookedPatientListTableView.registerNib(cellType: BookedPatientListTableViewCell.self)
        
//        view.bringSubviewToFront(self.navigationController?.navigationBar ?? UINavigationBar())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setup() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Lấy majorID từ Firebase
//        let majorRef = Database.database().reference().child("users").child("doctors").child(uid).child("majorID")
//        
//        majorRef.observeSingleEvent(of: .value) { snapshot in
//            if let majorID = snapshot.value as? Int {
//                // Gọi fetchAppointments với majorID lấy được
//                GlobalService.shared.fetchAppointments(completion: { appointments in
//                    // Xử lý danh sách các cuộc hẹn nhận được
//                    for appointment in appointments {
//                        if appointment.doctorID == uid || appointment.doctorID == "00" {
//                            self.appointmentList.append(appointment)
//                        }
//                    }
//                    print(appointments)
//                    self.bookedPatientListTableView.reloadData()
//                }, majorID: majorID)
//                print(majorID)
//                self.bookedPatientListTableView.reloadData()
//                print(self.appointmentList)
//                print(self.appointmentList.count)
//            } else {
//                print("Failed to fetch majorID")
//                print("uid: \(uid)")
//                print(majorRef)
//            }
//        }
        self.appointmentList = []
        let majorID = Global.doctor?.majorID ?? 0
        GlobalService.shared.fetchAppointments(completion: { appointments in
            // Xử lý danh sách các cuộc hẹn nhận được
            for appointment in appointments {
                if (appointment.doctorID == uid && (appointment.status != "cancelled" && appointment.status != "completed") ) || appointment.doctorID == "00" {
                    self.appointmentList.append(appointment)
                }
            }
            print(appointments)
            self.bookedPatientListTableView.reloadData()
        }, majorID: majorID)
        print(majorID)
        self.bookedPatientListTableView.reloadData()
        print(self.appointmentList)
        print(self.appointmentList.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: BookedPatientListTableViewCell.self, for: indexPath)
        cell.configureCell(appointment: appointmentList[indexPath.row])
        cell.appointment = appointmentList[indexPath.row]
        cell.parentVC = self

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyAppointmentsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Thông tin bệnh nhân", with: false)
        vc.configure(with: appointmentList[indexPath.row].id)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func acceptAppointment(_ sender: UIButton) {
        
    }
    
}
