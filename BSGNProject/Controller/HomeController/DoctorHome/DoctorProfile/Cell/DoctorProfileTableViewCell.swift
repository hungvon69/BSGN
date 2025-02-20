//
//  DoctorProfileTableViewCell.swift
//  BSGNProject
//
//  Created by Khánh Vũ on 24/12/24.
//

import UIKit

class DoctorProfileTableViewCell: BaseTableViewCell {

    @IBOutlet weak var bgrView: UIView!
    
    var parentVC: DoctorProfileViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgrView.backgroundColor = UIColor(hex: "#D7E6DF")
        bgrView.setCornerRadius(30, corners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeTapped(_ sender: Any) {
        let vc = NewDoctorFormViewController()
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Chỉnh sửa thông tin", with: false)
    }
}
