//
//  DoctorArticleTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 5/11/24.
//

import UIKit

class DoctorArticleTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, SummaryMethod {

    @IBOutlet private weak var doctorArticleTableView: UITableView!
    
    let customArticle : [Article] = [
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    private func setupUI() {
        contentView.backgroundColor = .clear
        doctorArticleTableView.dataSource = self
        doctorArticleTableView.delegate = self
        doctorArticleTableView.registerNib(cellType: ReuseArticleTableViewCell.self)
        doctorArticleTableView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return customArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorArticleTableView.dequeue(cellType: ReuseArticleTableViewCell.self, for: indexPath)
        cell.configure(with: customArticle[indexPath.section])
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
