//
//  ArticlesTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit

class PromotionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SummaryMethod {
    
    @IBOutlet private var kindOfLabel: UILabel!
    @IBOutlet private var seeAllButton: UIButton!
    @IBOutlet private var promoTionCollectionView: UICollectionView!
    
    weak var delegate: PromotionTableViewCellDelegate?
    
    var promotions = [Promotion]()
    var homeData: HomeData?
    var promotionViewModel: PromotionViewModel?
    let home = HomeService()
    var numberOfPromotion = 0
    var buttonAction: (() -> Void)?
    static let identifier = "PromotionTableViewCell"
    static func nib() -> UINib {
        
        return UINib(nibName: "PromotionTableViewCell", bundle: nil)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        promoTionCollectionView.delegate = self
        promoTionCollectionView.dataSource = self
        promoTionCollectionView.registerNib(cellType: ArticleCollectionViewCell.self)
        kindOfLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        seeAllButton.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 13)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        promoTionCollectionView.collectionViewLayout = layout
        home.fetchData(success: { data in
            self.homeData = data
            self.updateUI()
        }
                           , failure: { code, message in
            print("Có lỗi xảy ra: \(code) - \(message)")
        }, path: .homePath)
    }
    
    func updateUI() {
        if !self.promotions.isEmpty {
            print(self.promotions[0])
        }
        self.promoTionCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData?.promotionList.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 16, height: contentView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = promoTionCollectionView.dequeue(cellType: ArticleCollectionViewCell.self, for: indexPath)
        cell.configurePromotion(with: homeData!.promotionList[indexPath.row])
        applyShadow(to: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 248, height: 205)
    }
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        buttonAction?()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.promotionCollectionViewCellDidSelectItem(at: indexPath, in: self)
    }
    
}
protocol PromotionTableViewCellDelegate: AnyObject {
    func promotionCollectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: PromotionTableViewCell)
}
