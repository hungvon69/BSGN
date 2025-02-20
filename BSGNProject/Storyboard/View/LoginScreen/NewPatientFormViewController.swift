//
//  NewPatientFormViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 17/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewPatientFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewPatientFormCellDelegate {

    @IBOutlet private weak var newFormTableView: UITableView!
    
    var userData = GlobalService.shared.userData
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setup()
    }
    private func setup() {
        newFormTableView.delegate = self
        newFormTableView.dataSource = self
        newFormTableView.registerNib(cellType: NewPatientFormTableViewCell.self)
        userData["id"] = "\(Auth.auth().currentUser!.uid)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newFormTableView.dequeue(cellType: NewPatientFormTableViewCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
    
    func didTapDoneButton(with data: [String: Any]) {
        userData.merge(data) { _, new in new }
        print("Updated userInfo: \(userData)")
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users").child("patients").child(user.uid)
        ref.setValue(userData) { error, _ in
            if let error = error {
                print("Lỗi khi lưu thông tin: \(error.localizedDescription)")
                return
            }
        }
        let homeVC = TabbarController()
        self.navigationController?.pushViewController(homeVC, animated: true)
        homeVC.navigationController?.navigationBar.isHidden = true

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1300
    }

}
