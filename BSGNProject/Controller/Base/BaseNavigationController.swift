//
//  BaseNavigationController.swift
//  AdmicroHybridEvent
//
//  Created by Khánh Vũ on 22/9/24.
//

import Foundation
import UIKit

final class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var shouldAutorotate: Bool { false }
}

extension BaseNavigationController {
    private func config() {
        view.backgroundColor = UIColor.clear
        let appearance = self.navigationBar
        
        appearance.setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        appearance.shadowImage = UIImage()
        // Sets the translucent background color
        appearance.backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        appearance.isTranslucent = true
        // Change back icon
        interactivePopGestureRecognizer?.delegate = self
        
        
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
