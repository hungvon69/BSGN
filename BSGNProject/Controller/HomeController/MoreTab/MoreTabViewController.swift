//
//  MoreTabViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit
import FirebaseAuth

class MoreTabViewController: UIViewController {

    @IBOutlet private weak var moreTabTableView: UITableView!
    
    private var patient: Patient?
    override func viewDidLoad() {
        super.viewDidLoad()
        moreTabTableView.delegate = self
        moreTabTableView.dataSource = self
        moreTabTableView.registerNib(cellType: MoreTabTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
}
extension MoreTabViewController : UITableViewDelegate, UITableViewDataSource, LogoutCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTabTableView.dequeue(cellType: MoreTabTableViewCell.self, for: indexPath)
        GlobalService.shared.fetchUserData(uid: Auth.auth().currentUser?.uid ?? "", isDoctor: false) { result in
            switch result {
            case .success(let patient):
                self.patient = patient as! Patient
                self.moreTabTableView.reloadData()
            case .failure(let error):
                print("Error fetching patient data: \(error)")
            }
        }
        guard let patientt = self.patient else { return cell }
        cell.configure(with: patientt)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func didTapLogout() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        
        // Nút Xác nhận
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive, handler: { _ in
            // Xử lý đăng xuất
            do {
                try Auth.auth().signOut()
                print("User logged out successfully.")
                
                // Điều hướng về màn hình đăng nhập
                let introViewController = IntroViewController()
                let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController

                nav?.viewControllers = [introViewController]
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }))
        
        // Nút Hủy bỏ
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
    func changeTap() {
        let newVC = NewPatientFormViewController()
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.setupNavigationBar(with: "Cập nhật thông tin", with: false)
    }
}
