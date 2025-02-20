//
//  TableViewAdvancedLayout.swift
//  BSGNProject
//
//  Created by Linh Thai on 20/08/2024.
//

import Foundation
import UIKit
extension UITableView {
    func setCornerRadiusForCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
