//
//  IntroCollectionViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell, SummaryMethod {

    @IBOutlet private var backView: UIView!
    @IBOutlet private var introImageView: UIImageView!
    @IBOutlet private var introLabel: UILabel!
    @IBOutlet private var quoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.backgroundColor = .clear
        introLabel.font = UIFont(name: "NunitoSans-Light", size: 14)
        quoteLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 24)
    }
    
    public func configure(with introPage: IntroPage) {
        introImageView.image = UIImage(named: introPage.image)
        introLabel.text = introPage.title
        quoteLabel.text = introPage.qoute
    }
}

