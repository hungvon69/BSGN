//
//  ButtonTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 23/08/2024.
//

import UIKit

class ButtonTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet var continueButton: UIButton!
    
    static let identifier = "ButtonTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ButtonTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func setupUI() {
        continueButton.isEnabled = true
        continueButton.alpha = 1
        continueButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
    }

    func updateButtonState(isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.alpha = isEnabled ? 1.0 : 0.5
    }
    func addContinueButtonTarget(target: Any, action: Selector) {
        continueButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
