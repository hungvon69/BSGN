//
//  ListViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 22/08/2024.
//

import UIKit

class ArticleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var articleListTableView: UITableView!
    
    var articles = [Article]()
    var articleVM: ArticleViewModel?
    var numberOfArticles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleListTableView.delegate = self
        articleListTableView.dataSource = self
        articleListTableView.registerNib(cellType: HeadTableViewCell.self)
        articleListTableView.registerNib(cellType: DetailTableViewCell.self)
        
    }
    func updateUI() {
        self.articleListTableView.reloadData()
    }
//    func setupNavigationBar() {
//        let navItem = UINavigationItem(title: "Tin tức")
//
//        let backButton = UIButton(type: .custom)
//        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
//        backButton.tintColor = .black
//        backButton.backgroundColor = .white
//        backButton.layer.cornerRadius = 15
//        backButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
//        backButton.layer.borderWidth = 1
//        backButton.clipsToBounds = true
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        backButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
//
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
//        navItem.leftBarButtonItem = backBarButtonItem
//
//        articleListNavigationBar.setItems([navItem], animated: false)
//    }
//    @objc func backButtonTapped() {
//        if let navigationController = self.navigationController {
//                navigationController.popViewController(animated: true)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    public func configure(with articles: [Article]) {
        self.articles = articles
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = articleListTableView.dequeue(cellType: HeadTableViewCell.self, for: indexPath)
            let article = articles[indexPath.row]
            cell.configure(with: article)
            
            return cell
        }
       
        let cell = articleListTableView.dequeue(cellType: DetailTableViewCell.self, for: indexPath)
            
            cell.articleConfigure(with: articles[indexPath.row])
            return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: articles[indexPath.row].link)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.setupNavigationBar(with: "Tin tức", with: true)
    }
}
