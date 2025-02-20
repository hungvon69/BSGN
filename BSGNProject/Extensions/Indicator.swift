//
//  Indicator.swift
//  BSGNProject
//
//  Created by Khanh Vu on 30/12/24.
//

import Foundation
import ProgressHUD

final class Indicator {
    static func show() {
        mainAsync {
            ProgressHUD.colorAnimation = .darkGray
            ProgressHUD.animate(nil, .circleDotSpinFade)
        }
    }
    
    static func hide() {
        mainAsync {
            ProgressHUD.dismiss()
        }
    }
}
