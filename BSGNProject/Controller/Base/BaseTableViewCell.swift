//
//  BaseTableViewCell.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 4/10/24.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpStyle()
    }
    
    private func setUpStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
