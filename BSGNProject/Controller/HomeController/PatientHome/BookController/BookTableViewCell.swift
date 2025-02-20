//
//  BookTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit

class BookTableViewCell: UITableViewCell, SummaryMethod {
    

    @IBOutlet private weak var bookingButton: UIButton!
    
    private var homeData: HomeData?
    let home = HomeService()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        home.fetchData(success: { data in
            self.homeData = data
            self.updateUI()
        }
                           , failure: { code, message in
            print("Có lỗi xảy ra: \(code) - \(message)")
        }, path: .homePath)
    }
    private func updateUI() {
        
    }
    private func setupShadow() {

        bookingButton.layer.shadowColor = UIColor.black.cgColor
        bookingButton.layer.shadowRadius = 10
        bookingButton.layer.shadowOpacity = 0.3
        bookingButton.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    func addTargetToBookingButton(target: Any, action: Selector) {
        bookingButton.addTarget(target, action: action, for: .touchUpInside)
    }

}
