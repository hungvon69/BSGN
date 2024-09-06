//
//  HomeViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit

enum cellSeperate {
    case article
    case promotion
    case doctor
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleTableViewCellDelegate, PromotionTableViewCellDelegate {
    
    var homeCells: [cellSeperate] = [
        .article,
        .promotion,
        .doctor
    ]
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var nameAccLabel: UILabel!
    @IBOutlet private var avatarImageView: UIButton!
    @IBOutlet private var infoButton: UIButton!
    @IBOutlet private var personalImageView: UIImageView!
    @IBOutlet private var homeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerNib(cellType: ArticleTableViewCell.self)
        homeTableView.registerNib(cellType: PromotionTableViewCell.self)
        homeTableView.registerNib(cellType: DoctorTableViewCell.self)
        homeTableView.layer.cornerRadius = 16
        nameAccLabel.font = UIFont(name: "NunitoSans-Regular", size: 15)
        statusLabel.font = UIFont(name: "NunitoSans-Light", size: 12)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch homeCells[indexPath.row] {
            
        case .article:
            let cell = homeTableView.dequeue(cellType: ArticleTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationArticleList(with: cell.articles)
            }
            cell.delegate = self
            return cell
            
        case .promotion:
            let cell = homeTableView.dequeue(cellType: PromotionTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationPromotionList(with: cell.promotions)
                
            }
            cell.delegate = self
            return cell
        case .doctor:
            let cell = homeTableView.dequeue(cellType: DoctorTableViewCell.self, for: indexPath)
            cell.buttonAction = {
                [weak self] in
                self?.navigationDoctorList(with: cell.doctors)
                
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 243
        }
        else {
            return 268
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func navigationArticleList(with articles: [Article]) {
        let newVC = ArticleListViewController(nibName: "ArticleListViewController", bundle: nil)
        newVC.configure(with: articles)
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    func navigationPromotionList(with promotions: [Promotion]) {
        let newVC = PromotionListViewController(nibName: "PromotionListViewController", bundle: nil)
        newVC.configure(with: promotions)
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    func navigationDoctorList(with doctors: [Doctor]) {
        let newVC = DoctorListViewController(nibName: "DoctorListViewController", bundle: nil)
        newVC.configure(with: doctors)
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let newHeight = max(50, 150 - offsetY)
        personalImageView.frame.size.height = newHeight
        personalImageView.frame.origin.y = 0
    }
    
    
    @IBAction func didTapInfo(_ sender: Any) {
        let newVC = InformationViewController(nibName: "InformationViewController", bundle: nil)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    func upadteAvatar() {
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    func collectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: ArticleTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.articles[indexPath.row].link)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    func promotionCollectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: PromotionTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.promotions[indexPath.row].link)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}
