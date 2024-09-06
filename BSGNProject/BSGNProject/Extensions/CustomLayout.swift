//
//  Shadow.swift
//  BSGNProject
//
//  Created by Linh Thai on 20/08/2024.
//

import Foundation
import UIKit
func applyShadow(to cell: UICollectionViewCell) {
    cell.layer.cornerRadius = 10
    cell.backgroundColor = .white
    cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    cell.layer.shadowRadius = 20
    cell.layer.shadowOffset = CGSize(width: 0, height: 4)
    cell.layer.shadowOpacity = 1
    cell.layer.masksToBounds = true
    cell.clipsToBounds = false
}
func heightForLabel(width: CGFloat, font: UIFont, text: String) -> CGFloat{
    let sizing = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boxText = text.boundingRect(with: sizing, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    return ceil(boxText.height)
}

