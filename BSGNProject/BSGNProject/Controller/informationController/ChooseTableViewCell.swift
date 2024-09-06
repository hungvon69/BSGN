//
//  ChooseTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 23/08/2024.
//

import UIKit

class ChooseTableViewCell: UITableViewCell, SummaryMethod {
    
    static let identifier = "ChooseTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ChooseTableViewCell", bundle: nil)
    }

    @IBOutlet var chooseSegment: UISegmentedControl!
    @IBOutlet var chooseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chooseLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named: "male-UI")
        let attributedString1 = NSMutableAttributedString(attachment: imageAttachment1)
        attributedString1.append(NSAttributedString(string: " Nam"))
        let imageAttachment2 = NSTextAttachment()
        imageAttachment2.image = UIImage(named: "Female-UI")
        let attributedString2 = NSMutableAttributedString(attachment: imageAttachment2)
        attributedString2.append(NSAttributedString(string: " Nữ"))
        chooseSegment.setImage(imageFromLabel(label: createLabel(with: attributedString2)), forSegmentAt: 1)
        chooseSegment.setImage(imageFromLabel(label: createLabel(with: attributedString1)), forSegmentAt: 0)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        chooseSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1)]
        chooseSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
       
    }
    

    func createLabel(with attributedText: NSAttributedString) -> UILabel {
        let label = UILabel()
        label.attributedText = attributedText
        label.sizeToFit()
        return label
    }
    func imageFromLabel(label: UILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            label.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != 0 {
            sender.selectedSegmentIndex = 0
        }
    }
    
}
