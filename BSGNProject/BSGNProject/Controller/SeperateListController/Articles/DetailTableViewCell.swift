//
//  DetailTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 22/08/2024.
//

import UIKit
import Nuke
class DetailTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet private var markButton: UIButton!
    @IBOutlet private var detailCreatedLabel: UILabel!
    @IBOutlet private var detailTitleLabel: UILabel!
    @IBOutlet private var detailImageView: UIImageView!
    
    var isGreen = false
    
    static let identifier = "DetailTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DetailTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailImageView.layer.cornerRadius = 8
        markButton.setImage(UIImage(named: "bookmark2"), for: .normal)
        markButton.tintColor = UIColor(red: 150/255, green: 155/255, blue: 171/255, alpha: 1)
        detailTitleLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        detailCreatedLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 12)
    }
    public func articleConfigure(with article: ListArticle) {
        detailTitleLabel.text = article.title
        detailCreatedLabel.text = article.created_at
        if let imageUrl = URL(string: article.picture) {
            Nuke.loadImage(with: imageUrl, into: detailImageView) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.detailImageView.image = UIImage(named: "default")
                            }
            }
        }

    }
    public func promotionConfigure(with promotion: ListPromotion) {
        detailTitleLabel.text = promotion.name
        detailCreatedLabel.text = promotion.createdAt
        if let imageUrl = URL(string: promotion.picture) {
            Nuke.loadImage(with: imageUrl, into: detailImageView) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.detailImageView.image = UIImage(named: "default")
                            }
            }
        }

    }
    
    @IBAction func didTapMarked(_ sender: Any) {
        if isGreen == false {
            markButton.setImage(UIImage(named: "bookmark3"), for: .normal)
        }
        else {
            markButton.setImage(UIImage(named: "bookmark2"), for: .normal)
        }
        isGreen.toggle()
    }
}
