//
//  DoctorProfileViewController.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit
import FirebaseAuth

class DoctorProfileViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let sections: [ProfileSection] = [.avatar, .info, .payment, .logout]
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }


    func setUpUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DoctorProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorProfileTableViewCell")
        tableView.register(UINib(nibName: "ProfileItemCell", bundle: nil), forCellReuseIdentifier: "ProfileItemCell")
    }

    private func signOut() {
        CommonAlertView.present(.init(title: "Đăng xuất", subtitle: "Bạn có chắc muốn đăng xuất!")) { [weak self] in
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
        }
    }
}

extension DoctorProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileTableViewCell", for: indexPath) as! DoctorProfileTableViewCell
//            cell.bind(Global.user)
            cell.parentVC = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell", for: indexPath) as! ProfileItemCell
            cell.bind(section.items[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section.items[indexPath.row] {
        case .signOut:
            signOut()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section {
        case .avatar:
            return UITableView.automaticDimension
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = sections[section]
        guard let headerTitle = sectionItem.headerTitle else {
            return nil
        }
        let headerView = CommonHeaderView(frame: .init(x: 0, y: 0, width: screenWidth, height: 30))
        headerView.bind(icon: nil, title: sectionItem.headerTitle, titleFont: .systemFont(ofSize:13, weight: .semibold), titleColor: .black.withAlphaComponent(0.7))
        headerView.layout(top: 0, leading: 0, trailing: 0, bottom: 0)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }
}

