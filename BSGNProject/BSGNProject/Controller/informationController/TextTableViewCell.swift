//
//  TextTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 23/08/2024.
//

import UIKit

class TextTableViewCell: UITableViewCell, UITextFieldDelegate, SummaryMethod {

    @IBOutlet var seperatorView: UIView!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!

    static let identifier = "TextTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "TextTableViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        inputTextField.delegate = self
        inputTextField.font = UIFont(name: "NunitoSans-Regular", size: 15)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        seperatorView.backgroundColor = UIColor(red: 150/255, green: 155/255, blue: 171/255, alpha: 1)
        createDoneButton()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1)
        seperatorView.backgroundColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        titleLabel.textColor = UIColor(red: 150/255, green: 155/255, blue: 171/255, alpha: 1)
        seperatorView.backgroundColor = UIColor(red: 150/255, green: 155/255, blue: 171/255, alpha: 1)
    }

        
    @objc func textFieldDidChange() {
        NotificationCenter.default.post(name: NSNotification.Name("TextFieldDidChangeNotification"), object: nil)
    }
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        toolbar.items = [flexibleSpace, doneButton]
            
        inputTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
        contentView.endEditing(true)
    }
    
}
