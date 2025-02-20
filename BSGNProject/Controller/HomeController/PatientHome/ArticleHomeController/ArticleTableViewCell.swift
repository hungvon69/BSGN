//
//  ArticlesTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit

protocol ArticleTableViewCellDelegate: AnyObject {
    func collectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: ArticleTableViewCell)
}
class ArticleTableViewCell: UITableViewCell, SummaryMethod {
    
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var kindOfNameLabel: UILabel!
    @IBOutlet private var articleCollectionView: UICollectionView!
    
    var buttonAction: (() -> Void)?
    
    
    weak var delegate: ArticleTableViewCellDelegate?
    var customArticle : [Article] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()

    }
    func setUpUI() {
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.registerNib(cellType: ArticleCollectionViewCell.self)
        DispatchQueue.main.async {
            self.kindOfNameLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
            self.seeAllButton.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 13)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            self.articleCollectionView.collectionViewLayout = layout
        }
    }
    func configure(with article: [Article]) {
        customArticle = article
        updateUI()
    }
    func setKindLabel(with kind: String) {
        kindOfNameLabel.text = kind
    }
    func updateUI() {
        self.articleCollectionView.reloadData()
    }
    
    func biggestSizeOfTitle(with articles: [Article]) -> CGFloat {
        var size = [CGFloat]()
        for article in articles {
            size.append(heightForLabel(width: 234, font: UIFont.systemFont(ofSize: 15), text: article.title))
        }
        return size.max() ?? 0
    }
    @IBAction func didTapSeeAll(_ sender: Any) {
        buttonAction?()
    }
}
extension ArticleTableViewCell :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customArticle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articleCollectionView.dequeue(cellType: ArticleCollectionViewCell.self, for: indexPath)
        cell.configure(with: customArticle[indexPath.row])
        applyShadow(to: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 16, height: contentView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 258, height: (biggestSizeOfTitle(with: customArticle))  + 180)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewCellDidSelectItem(at: indexPath, in: self)
    }
}

