//
//  ExtensionForCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 06/09/2024.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadable {
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
   

typealias SummaryMethod = Reusable & NibLoadable


extension UITableView {

    func registerClass<Cell: UITableViewCell & SummaryMethod>(cellType: Cell.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerNib<Cell: UITableViewCell & SummaryMethod>(cellType: Cell.Type) {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<Cell: UITableViewCell & Reusable>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Error: Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
}
extension UICollectionView {
    
    func registerNib<Cell: UICollectionViewCell & SummaryMethod>(cellType: Cell.Type) {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerClass<Cell: UICollectionViewCell & Reusable>(cellType: Cell.Type) {
        self.register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<Cell: UICollectionViewCell & Reusable>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Error: Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
}

