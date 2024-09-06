//
//  ArticleCollectionViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit
import SDWebImage
import Nuke

class ArticleCollectionViewCell: UICollectionViewCell, SummaryMethod {
    
    @IBOutlet private var noticeLabel: UILabel!
    @IBOutlet private var createdLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var articleImageView: UIImageView!
    static let identifier = "ArticleCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        createdLabel.font = UIFont(name: "NunitoSans-Regular", size: 13)
        titleLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 15)
        noticeLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        articleImageView.layer.cornerRadius = 8
        createdLabel.textColor = UIColor(red: 150/255, green: 155/255, blue: 171/255, alpha: 1)
    }
    func addShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1
    }



    public func configure(with article: Article) {
        if let imageUrl = URL(string: article.picture) {
            Nuke.loadImage(with: imageUrl, into: articleImageView) {
                result in
                    switch result {
                        case .success(let response):
                            print("Image loaded successfully: \(response.image)")
                        case .failure(let error):
                               print("Error loading image: \(error.localizedDescription)")
                            self.articleImageView.image = UIImage(named: "default")
                    }
            }
        }
        titleLabel.text = article.title
        createdLabel.text = article.created_at
    }
    public func configurePromotion(with promotion: Promotion) {
        if let imageUrl = URL(string: promotion.picture) {
            Nuke.loadImage(with: imageUrl, into: articleImageView) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.articleImageView.image = UIImage(named: "default")
                            }
            }
        }
        titleLabel.text = promotion.name
        createdLabel.text = promotion.created_at
    }


}
