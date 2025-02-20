//
//  SplashViewController.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 26/12/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SceneDelegate.shared.rootApp()
        }
    }

    
}
