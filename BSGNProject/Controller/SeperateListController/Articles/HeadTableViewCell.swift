//
//  HeadTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 23/08/2024.
//

import UIKit
import Nuke

class HeadTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet private var headCreateLabel: UILabel!
    @IBOutlet private var headTitleLabel: UILabel!
    @IBOutlet private var headImageView: UIImageView!
    
    static let identifier = "HeadTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HeadTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headTitleLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 20)
        headCreateLabel.font = UIFont(name: "NunitoSans-Regular", size: 12)
    }

    public func configure(with article: Article) {
        headTitleLabel.text = article.title
        headCreateLabel.text = article.time
        if let imageUrl = URL(string: article.image) {
            Nuke.loadImage(with: imageUrl, into: headImageView) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.headImageView.image = UIImage(named: "default")
                            }
            }
        }

    }
}
