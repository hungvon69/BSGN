//
//  PatientHistoryViewController.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 5/1/25.
//

import UIKit

class PatientHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var data: [Appointment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PatientHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientHistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Lịch sử"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        guard let patientId = Global.patient?.id else {
            return
        }
        data = []
        Indicator.show()
        FirebaseDatabaseService.fetchPatientHistory(for: patientId) {  [weak self] appointment, error in
            self?.data = (appointment ?? []).filter { $0.status == "completed" || $0.status == "cancelled"}
            self?.tableView.reloadData()
            Indicator.hide()
        }
    }
}

extension PatientHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientHistoryTableViewCell", for: indexPath) as! PatientHistoryTableViewCell
        cell.bind(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
