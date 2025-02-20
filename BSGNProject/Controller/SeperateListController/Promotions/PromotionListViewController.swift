//
//  PromotionListViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 22/08/2024.
//

import UIKit

class PromotionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var promotionListTableView: UITableView!
    
    var promotions = [Promotion]()
    var promotionVM: PromotionViewModel?
    var numberOfPromotions = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionListTableView.dataSource = self
        promotionListTableView.delegate = self
        promotionListTableView.registerNib(cellType: DetailTableViewCell.self)

    }
    
    func updateUI() {
        self.promotionListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPromotions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = promotionListTableView.dequeue(cellType: DetailTableViewCell.self, for: indexPath)
        
        if let promotion = promotionVM?.listPromotion[indexPath.row] {
            cell.promotionConfigure(with: promotion)
        }
        
        return cell
    }
//    func setupNavigationBar() {
//        let navItem = UINavigationItem(title: "Danh sách khuyến mãi")
//
//        let backButton = UIButton(type: .custom)
//        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
//        backButton.tintColor = .black
//        backButton.backgroundColor = .white
//        backButton.layer.cornerRadius = 15
//        backButton.clipsToBounds = true
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        backButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
//
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
//        navItem.leftBarButtonItem = backBarButtonItem
//
//        promotionListNavigationbar.setItems([navItem], animated: false)
//    }
//    @objc func backButtonTapped() {
//        if let navigationController = self.navigationController {
//                navigationController.popViewController(animated: true)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    public func configure(with promotions: [Promotion]) {
        self.promotions = promotions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: promotions[indexPath.row].link)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
