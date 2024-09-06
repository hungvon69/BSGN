//
//  LoginViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private var hotlineButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var translateButton: UIButton!
    @IBOutlet private var continueLoginButton: UIButton!
    @IBOutlet private var phoneBoxImageView: UIImageView!
    @IBOutlet private var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        phoneBoxImageView.layer.borderWidth = 1
        phoneBoxImageView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        phoneBoxImageView.layer.cornerRadius = 28
        
        addShadow()
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        
        continueLoginButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        continueLoginButton.layer.opacity = 0.3
        continueLoginButton.setTitleColor(.white, for: .disabled)
        continueLoginButton.isEnabled = false
        
        navigationController?.isNavigationBarHidden = true
        let text = "Hotline 1900 6036 893"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 7))

        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1), range: NSRange(location: 8, length: 11))
        
        if let font = UIFont(name: "NunitoSans-SemiBold", size: 17) {
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        }
        
        hotlineButton.setAttributedTitle(attributedString, for: .normal)
        hotlineButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        addShadow()
        createDoneButton()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneBoxImageView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        phoneBoxImageView.layer.borderWidth = 1.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneBoxImageView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        phoneBoxImageView.layer.borderWidth = 1
    }
    //Hàm xử lý textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = phoneNumberTextField.text as NSString? {
                let updatedText = currentText.replacingCharacters(in: range, with: string)
                if (updatedText.count == 9 && updatedText.first != "0" && updatedText.allSatisfy({$0.isNumber})) || (updatedText.count == 10 && updatedText.first == "0" && updatedText.allSatisfy({$0.isNumber})) {
                    continueLoginButton.layer.opacity = 1
                    continueLoginButton.isEnabled = true
                } else {
                    continueLoginButton.layer.opacity = 0.3
                    continueLoginButton.isEnabled = false
                    continueLoginButton.setTitleColor(.white, for: .disabled)
                }
            }
            return true
        }
    
    @IBAction func didTapCustomButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let loginVC = OTPViewController(nibName: "OTPViewController", bundle: nil)
        loginVC.phoneNumber = phoneNumberTextField.text
//        loginVC.configure(with: phoneNumberTextField.text!)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    func addShadow() {
        phoneBoxImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        phoneBoxImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        phoneBoxImageView.layer.shadowOpacity = 1
        phoneBoxImageView.layer.shadowRadius = 20
        phoneBoxImageView.layer.masksToBounds = false
    }
 
    @IBAction func buttonTapped() {
            phoneNumberTextField.text = ""
        continueLoginButton.layer.opacity = 0.3
        continueLoginButton.isEnabled = false
        continueLoginButton.setTitleColor(.white, for: .disabled)
    }
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        toolbar.items = [flexibleSpace, doneButton]
            
        phoneNumberTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
}
