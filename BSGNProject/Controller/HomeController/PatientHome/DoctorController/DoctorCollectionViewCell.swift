//
//  DoctorCollectionViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 21/08/2024.
//

import UIKit
import Nuke
class DoctorCollectionViewCell: UICollectionViewCell, SummaryMethod {
    
    
    @IBOutlet private var reviewerCountLabel: UILabel!
    @IBOutlet private var starLabel: UILabel!
    @IBOutlet private var majorNameLabel: UILabel!
    @IBOutlet private var doctorNameLabel: UILabel!
    @IBOutlet private var doctorImageVIew: UIImageView!
    
    static let identifier = "DoctorCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DoctorCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.gray.cgColor
        doctorImageVIew.layer.cornerRadius = 10
        doctorImageVIew.clipsToBounds = true
        doctorImageVIew.contentMode = .scaleAspectFill
        doctorNameLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        majorNameLabel.font = UIFont(name: "NunitoSans-Regular", size: 12)
        starLabel.font = UIFont(name: "NunitoSans-Light", size: 11)
        reviewerCountLabel.font = UIFont(name: "NunitoSans-Light", size: 11)
    }
    private func setupShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        self.layer.masksToBounds = false
    }

    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    public func configure(with doctor: Doctor) {
        if let imageUrl = URL(string: doctor.avatar) {
            Nuke.loadImage(with: imageUrl, into: doctorImageVIew) {
                result in
                            switch result {
                            case .success(let response):
                                print("Image loaded successfully: \(response.image)")
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                                self.doctorImageVIew.image = UIImage(named: "default_doctor")
                            }
            }
        }
        starLabel.text = ""
        reviewerCountLabel.text = ""
        majorNameLabel.text = doctor.major
        doctorNameLabel.text = doctor.firstName + " " + doctor.lastName
    }


}
