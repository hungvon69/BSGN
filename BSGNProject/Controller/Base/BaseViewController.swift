//
//  BaseViewController.swift
//  Snapheal
//
//  Created by Khanh Vu on 5/10/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        print("===> DEINIT \(String(describing: self))")
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addBackButton() {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "backleftButton"), for: .normal)
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backBtn.imageEdgeInsets = .init(top: 0, left: -16, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    func addRightBarButton(_ customView: UIView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    @objc func backTapped() {
        if isBeingPresented {
            dismiss(animated: true)
            return
        }
        
        if navigationController?.viewControllers.first is Self {
            dismiss(animated: true)
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
}
