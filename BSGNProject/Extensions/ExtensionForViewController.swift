//
//  ExtensionForViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 16/9/24.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBar(with title: String, with share: Bool) {
        if self.navigationController != nil {
            self.navigationItem.title = title
            let backBarButtonItem = createCustomBackButton()
            self.navigationItem.leftBarButtonItem = backBarButtonItem
            if share {
                let shareButtonItem = createCustomShareButton()
                self.navigationItem.rightBarButtonItem = shareButtonItem
            }
        } else {
            let navBar = UINavigationBar()
            navBar.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(navBar)
            NSLayoutConstraint.activate([
                navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            
            let navItem = UINavigationItem(title: title)
            let backBarButtonItem = createCustomBackButton()
            navItem.leftBarButtonItem = backBarButtonItem
            if share {
                let shareButtonItem = createCustomShareButton()
                navItem.rightBarButtonItem = shareButtonItem
            }
            navBar.setItems([navItem], animated: false)
        }
    }
    private func createCustomBackButton() -> UIBarButtonItem {
        let backButton = UIButton(type: .custom)
        if let backImage = UIImage(named: "backleftButton")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)) {
            backButton.setBackgroundImage(backImage, for: .normal)
        }
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 15
        backButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        backButton.layer.borderWidth = 1
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        return UIBarButtonItem(customView: backButton)
    }
    private func createCustomShareButton() -> UIBarButtonItem {
        let shareButton = UIButton(type: .custom)
        shareButton.setBackgroundImage(UIImage(named: "shareButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
        shareButton.tintColor = .black
        shareButton.backgroundColor = .white
        shareButton.layer.cornerRadius = 15
        shareButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        shareButton.layer.borderWidth = 1
        shareButton.clipsToBounds = true
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
        return UIBarButtonItem(customView: shareButton)
    }
    @objc private func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func shareButtonTapped() {
        let notificationWidth = self.view.frame.width / 2
        let notificationX = (self.view.frame.width - notificationWidth) / 2
        let notificationView = UIView(frame: CGRect(x: notificationX, y: -20, width: self.view.frame.width/2, height: 40))
            notificationView.backgroundColor = UIColor.white
//        notificationView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        notificationView.layer.shadowRadius = 20
//        notificationView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        notificationView.layer.shadowOpacity = 1
        notificationView.layer.cornerRadius = 20
        notificationView.layer.borderWidth = 0.5
        notificationView.layer.borderColor = UIColor.gray.cgColor
        let label = UILabel(frame: notificationView.bounds)
        label.text = "Đã sao chép URL"
        label.textAlignment = .center
        label.textColor = .black
        notificationView.addSubview(label)
        self.view.addSubview(notificationView)
        UIView.animate(withDuration: 0.5, animations: {
            notificationView.frame.origin.y = 40
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: [], animations: {
                notificationView.frame.origin.y = -20
            }) { _ in
                notificationView.removeFromSuperview()
            }
        }
        let stringToCopy = "00"
        UIPasteboard.general.string = stringToCopy
    }
}


