//
//  Builder.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 4/10/24.
//

import Foundation
import UIKit

extension UIStackView {
    static func build(axis: NSLayoutConstraint.Axis,
                      distribution: Distribution,
                      alignment: Alignment,
                      spacing: CGFloat,
                      subViews: [UIView]) -> UIStackView {
        let stv = UIStackView()
        stv.axis = axis
        stv.distribution = distribution
        stv.alignment = alignment
        stv.spacing = spacing
        subViews.forEach { stv.addArrangedSubview($0) }
        return stv
    }
}
