//
//  UILabel+.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 24/9/24.
//

import Foundation
import UIKit

//MARK: - Builder
extension UILabel {
    static func build(font: UIFont, color: UIColor? = .black, lines: Int = 1, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.numberOfLines = lines
        label.textAlignment = alignment
        return label
    }
    
    func build(font: UIFont, color: UIColor? = .black, lines: Int = 1, alignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = color
        self.numberOfLines = lines
        self.textAlignment = alignment
    }
}
