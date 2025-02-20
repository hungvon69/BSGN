//
//  BalanceViewController.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        tableView.register(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTableViewCell")
    }
}

extension BalanceViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTableViewCell", for: indexPath) as! BalanceTableViewCell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNonzeroMagnitude : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let header = CommonHeaderView(frame: .init(x: 0, y: 0, width: screenWidth, height: 30))
        header.bind(title: "Lịch sử giao dịch: ",
                    titleFont: .systemFont(ofSize: 16, weight: .semibold),
                    titleColor: .black)
        header.layout(top: 0, padding: 20)
        return header
    }
}
