//
//  UIButton+.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 30/9/24.
//

import Foundation
import UIKit

extension UIButton {
    
    func build(font: UIFont?,
               title: String?,
               image: UIImage? = nil,
               color: UIColor?,
               cornerRadius: CGFloat = 0,
               borderWidth: CGFloat = 0,
               borderColor: UIColor? = .clear,
               spacing: CGFloat = 8) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        if let image = image {
            setImage(image, for: .normal)
            imageEdgeInsets = .init(top: 0, left: -spacing, bottom: 0, right: spacing)
            contentEdgeInsets = .init(top: 0, left: spacing, bottom: 0, right: 0)
            tintColor = color
        }
        titleLabel?.font = font
        _cornerRadius = cornerRadius
        layer.masksToBounds = true
        _borderWidth = borderWidth
        _borderColor = borderColor
    }
}
