//
//  ProfileItemCell.swift
//  Snapheal
//
//  Created by Khánh Vũ on 3/11/24.
//

import UIKit

class ProfileItemCell: BaseTableViewCell {

    @IBOutlet weak var borderIconView: UIView!
    @IBOutlet weak var thumbIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func bind(_ item: DoctorProfileViewController.ProfileRow) {
        titleLabel.text = item.title
    }
}

private extension ProfileItemCell {
    func setUpUI() {
        borderIconView._cornerRadius = 15
        thumbIcon.tintColor = .black
        thumbIcon.isHidden = true
        borderIconView.backgroundColor = .black.withAlphaComponent(0.2)
        backgroundColor = UIColor(hex: "#D7E6DF")
        titleLabel.build(font: .systemFont(ofSize: 14, weight: .medium), color: .black, lines: 1, alignment: .left)
    }
}
