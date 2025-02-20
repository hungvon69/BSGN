//
//  TabbarController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    
    private func setupTab() {
        
        let home = self.createNav(with: "Trang chủ", and: UIImage(systemName: "house"), vc: HomeViewController())
        let moreTab = self.createNav(with: "Tài khoản", and: UIImage(systemName: "person"), vc: MoreTabViewController())
        let historyVC = self.createNav(with: "Lịch sử", and: UIImage(systemName: "list.clipboard"), vc: PatientHistoryViewController())
        let myAppointmentVC = self.createNav(with: "Cuộc hẹn", and: UIImage(systemName: "calendar"), vc: PatientAppointmentViewController())
        self.setViewControllers([home, moreTab, historyVC, myAppointmentVC], animated: true)
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = mainColor
    }
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}
