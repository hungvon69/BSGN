//
//  UITextView+.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 13/12/24.
//

import Foundation
import UIKit

extension UITextView {
    private struct AssociatedKeys {
        static var placeholderLabel = "placeholderLabel"
    }
    
    private var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Đặt placeholder cho UITextView
    var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                addPlaceholderLabel()
            }
            placeholderLabel?.text = newValue
        }
    }
    
    /// Đặt màu của placeholder
    var placeholderColor: UIColor? {
        get {
            return placeholderLabel?.textColor ?? .lightGray
        }
        set {
            placeholderLabel?.textColor = newValue
        }
    }
    
    private func addPlaceholderLabel() {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = self.font
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
        
        placeholderLabel = label
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    @objc private func textViewDidChange() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    // Cập nhật khi gán văn bản từ code
    func setText(_ text: String) {
        self.text = text
        textViewDidChange() // Gọi trực tiếp để cập nhật trạng thái placeholder
    }
}
