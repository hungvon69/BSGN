//
//  PatientHistoryTableViewCell.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 5/1/25.
//

import UIKit

class PatientHistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var symboLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    private func setUpUI() {
        borderView.backgroundColor = UIColor(hex: "#D7E6DF")
    }
    
    func bind(_ item: Appointment) {
        majorLabel.text = "Khoa: " + item.specialty
        statusLabel.text = item.status
        symboLabel.text = "Triệu chứng: " + item.symtoms
        doctorLabel.text = "Bác sỹ: " + item.doctorName
        priceLabel.text = "Giá: \(item.price) VNĐ"
        
        doctorLabel.isHidden = item.doctorID == "00"
        priceLabel.isHidden = item.doctorID == "00"
        statusLabel.textColor = item.getStatusColor()
    }
}
