//
//  DoctorHomeActionTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import UIKit

class DoctorHomeActionTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet private weak var hotlineButton: UIButton!
    @IBOutlet private weak var balanceButton: UIButton!
    @IBOutlet private weak var boodedHistoryButton: UIButton!
    @IBOutlet private weak var boodkedButton: UIButton!
    @IBOutlet private weak var accountButton: UIButton!
    let backview: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(backview)
        backview.frame.size = CGSize(width: contentView.frame.width - 30, height: contentView.frame.height)
        backview.center = contentView.center
        contentView.backgroundColor = .clear
        contentView.sendSubviewToBack(backview)
    }
    func addBookedButtonTarget(target: Any, action: Selector) {
        boodkedButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addBoodedHistoryButtonTarget(target: Any, action: Selector) {
        boodedHistoryButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addAccountButtonTarget(target: Any, action: Selector) {
        accountButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addBalanceButtonTarget(target: Any, action: Selector) {
        balanceButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addHotlineButtonTarget(target: Any, action: Selector) {
        hotlineButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
