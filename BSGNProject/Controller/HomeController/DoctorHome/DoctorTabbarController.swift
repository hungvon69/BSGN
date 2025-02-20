//
//  DoctorTabbarController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import Foundation
import UIKit
class DoctorTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    private func setupTab() {
        let home = self.createNav(with: "Trang chủ", and: UIImage(systemName: "house"), vc: DoctorHomeViewController())
        let moreTab = self.createNav(with: "Tài khoản", and: UIImage(systemName: "person"), vc: MoreTabViewController())
        self.setViewControllers([home, moreTab], animated: true)
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
