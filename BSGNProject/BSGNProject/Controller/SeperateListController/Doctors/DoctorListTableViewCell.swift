//
//  DoctorListTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 22/08/2024.
//

import UIKit
import Nuke

class DoctorListTableViewCell: UITableViewCell, SummaryMethod {
    
    @IBOutlet private var majorLabel: UILabel!
    @IBOutlet private var reviewersLabel: UILabel!
    @IBOutlet private var starLabel: UILabel!

    @IBOutlet var doctorNameLabel: UILabel!
    @IBOutlet var doctorImageView: UIImageView!
    static let identifier = "DoctorListTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DoctorListTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        doctorNameLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 15)
        majorLabel.font = UIFont(name: "NunitoSans-Regular", size: 13)
        starLabel.font = UIFont(name: "NunitoSans-Light", size: 14)
        reviewersLabel.font = UIFont(name: "NunitoSans-Light", size: 14)
        doctorImageView.layer.cornerRadius = 6
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
    }
    public func configure(with doctor: ListDoctor) {
        if let imageUrl = URL(string: doctor.avatar) {
            Nuke.loadImage(with: imageUrl, into: doctorImageView) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.doctorImageView.image = UIImage(named: "default_doctor")
                            }
            }
        }
        
        doctorNameLabel.text = doctor.name
        majorLabel.text = "Chuyên ngành: \(doctor.majorsName)"
        starLabel.text = String(doctor.ratioStar)
        reviewersLabel.text = "(" + String(doctor.numberOfReviews) + ")"
    }
}
