//
//  DoctorAccountViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 19/12/24.
//

import UIKit
import FirebaseAuth

class DoctorAccountViewController: UIViewController {

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var workLabel: UILabel!
    @IBOutlet private weak var dobLabel: UILabel!
    @IBOutlet private weak var graduatedLabel: UILabel!
    @IBOutlet private weak var phoneNumLabel: UIButton!
    @IBOutlet private weak var majorLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var doctorAvatarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    func configure() {
        guard let user = Auth.auth().currentUser?.uid else { return }
        GlobalService.shared.loadDoctorWithID(doctorID: user) { userprofile in
            switch userprofile {
            case .success(let userprofile):
                print(userprofile)
                self.nameLabel.text = "\(userprofile.firstName) \(userprofile.lastName)"
                self.majorLabel.text = userprofile.major
                self.phoneNumLabel.setTitle(userprofile.phoneNumber, for: .normal)
                self.workLabel.text = userprofile.education
                self.dobLabel.text = userprofile.dateOfBirth
            case .failure(let error):
                print(error)
            }
            
        }
    }

    @IBAction func logOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        
        // Nút Xác nhận
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive, handler: { _ in
            // Xử lý đăng xuất
            do {
                try Auth.auth().signOut()
                print("User logged out successfully.")
                
                // Điều hướng về màn hình đăng nhập
                let introViewController = IntroViewController()
                self.navigationController?.pushViewController(introViewController, animated: true)
                introViewController.navigationController?.setNavigationBarHidden(true, animated: false)
                introViewController.tabBarController?.tabBar.isHidden = true
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }))
        
        // Nút Hủy bỏ
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: nil))
        
        // Hiển thị alert
        self.present(alert, animated: true, completion: nil)
    }
}
