//
//  BalanceTableViewCell.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class BalanceTableViewCell: BaseTableViewCell {

    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
    }

}
