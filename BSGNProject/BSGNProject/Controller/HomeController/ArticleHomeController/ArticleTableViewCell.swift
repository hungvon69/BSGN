//
//  ArticlesTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit

class ArticleTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SummaryMethod {
    
    @IBOutlet var seeAllButton: UIButton!
    @IBOutlet var kindOfNameLabel: UILabel!
    @IBOutlet var articleCollectionView: UICollectionView!
    var buttonAction: (() -> Void)?

    weak var delegate: ArticleTableViewCellDelegate?
    var articles = [Article]()
    var homeData: HomeData?
    var articleViewModel: ArticleViewModel?
    let home = HomeService()
    var numberOfArticles = 0

    static let identifier = "ArticleTableViewCell"
    static func nib() -> UINib {
        
        return UINib(nibName: "ArticleTableViewCell", bundle: nil)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.registerNib(cellType: ArticleCollectionViewCell.self)
        kindOfNameLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        seeAllButton.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 13)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        articleCollectionView.collectionViewLayout = layout
        NewsService.fetchNews{ result in
            switch result {
            case .success(let data):
                self.articles = data.articleList
                if self.articleViewModel == nil {
                    self.articleViewModel = ArticleViewModel()
                }
                self.homeData = data
                self.articleViewModel?.articles = data.articleList
                print(data.articleList)
                self.numberOfArticles = data.articleList.count
                print(self.articles)
                self.updateUI()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfArticles
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articleCollectionView.dequeue(cellType: ArticleCollectionViewCell.self, for: indexPath)
        if let article = articleViewModel?.articles[indexPath.row] {
            cell.configure(with: article)
        }
        applyShadow(to: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 16, height: contentView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 258, height: (biggestSizeOfTitle(with: articleViewModel!.articles))  + 160)
    }
    
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        buttonAction?()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewCellDidSelectItem(at: indexPath, in: self)
    }
}
protocol ArticleTableViewCellDelegate: AnyObject {
    func collectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: ArticleTableViewCell)
}
