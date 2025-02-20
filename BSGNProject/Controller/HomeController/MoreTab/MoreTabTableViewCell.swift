//
//  MoreTabTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 2/10/24.
//

import UIKit
import FirebaseAuth

class MoreTabTableViewCell: BaseTableViewCell, SummaryMethod {

//    @IBOutlet weak var changeInfoBtn: UIButton!
    @IBOutlet private weak var bloodLbl: UILabel!
    @IBOutlet private weak var phoneLbl: UILabel!
    @IBOutlet private weak var addressLbl: UILabel!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var nameAccountLabel: UILabel!
    
    weak var delegate: LogoutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    func configure(with patient: Patient){
        nameLbl.text = "Họ và tên: \(patient.name) \(patient.lastName)"
        addressLbl.text = "Địa chỉ: \(patient.address)"
        phoneLbl.text = "Số điện thoại: \(patient.phoneNumber)"
        bloodLbl.text = "Nhóm máu: \(patient.blood)"
    }
    private func setupShadow() {
        logOutButton.layer.shadowColor = UIColor.black.cgColor
        logOutButton.layer.shadowOpacity = 0.3
        logOutButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        logOutButton.layer.shadowRadius = 10
    }
    @IBAction func changeTapped(_ sender: Any) {
        delegate?.changeTap()
    }
    @IBAction func signOutTapped(_ sender: Any) {
        delegate?.didTapLogout()
    }
}
protocol LogoutCellDelegate: AnyObject {
    func didTapLogout()
    func changeTap()
}
