//
//  DoctorHistoryViewController.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class DoctorHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var data: [Appointment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DoctorHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorHistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }

    func fetchData() {
        let doctorID = Global.doctor?.id
        let majorID = Global.doctor?.majorID ?? 0
        data = []
        GlobalService.shared.fetchAppointments(completion: { appointments in
            // Xử lý danh sách các cuộc hẹn nhận được
            for appointment in appointments {
                if appointment.doctorID == doctorID && (appointment.status == "completed" || appointment.status == "cancelled") {
                    self.data.append(appointment)
                }
            }
            self.tableView.reloadData()
        }, majorID: majorID)
    }
}

extension DoctorHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorHistoryTableViewCell", for: indexPath) as! DoctorHistoryTableViewCell
        cell.bind(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
