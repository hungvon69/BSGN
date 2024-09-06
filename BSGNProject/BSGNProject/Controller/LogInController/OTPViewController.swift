//
//  OTPViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private var otpCodeStackView: UIStackView!
    @IBOutlet private var resendOtpButton: UIButton!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var otpNavigationBar: UINavigationBar!
    @IBOutlet private var otpTextField1: UITextField!
    @IBOutlet private var otpTextField2: UITextField!
    @IBOutlet private var otpTextField3: UITextField!
    @IBOutlet private var otpTextField4: UITextField!
    @IBOutlet private var otpTextField5: UITextField!
    @IBOutlet private var otpTextField6: UITextField!
    @IBOutlet private var notifiedLabel: UILabel!
    
    
    var countdownTimer: Timer?
    var remainingTime = 60
    var phoneNumber: String?
    var unmatchedOtpLabel: UILabel?
    var otpTextFields: [UITextField] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        otpTextField5.delegate = self
        otpTextField6.delegate = self
        otpTextField1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField4.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField5.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField6.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextFields = [otpTextField1, otpTextField2, otpTextField3, otpTextField4, otpTextField5, otpTextField6]
        for field in otpTextFields {
            field.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
            field.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            field.layer.shadowOffset = CGSize(width: 0, height: 4)
            field.layer.shadowOpacity = 0.5
            field.layer.shadowRadius = 8
            field.layer.masksToBounds = false
        }
        
        resendOtpButton.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        resendOtpButton.layer.borderWidth = 1
        resendOtpButton.setTitle("Gửi lại mã", for: .normal)
        resendOtpButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        resendOtpButton.layer.cornerRadius = 18
        
                
        notifiedLabel.text = "Vui lòng nhập mã gồm 6 chữ số đã được gửi đến bạn vào số điện thoại +84 " + phoneNumber!
        setNotifiedLabel()
        
        continueButton.isEnabled = false
        continueButton.setTitleColor(.white, for: .disabled)
        continueButton.layer.opacity = 0.3
        continueButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        setupNavigationBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        countdownTimer?.invalidate()
        remainingTime = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
        createDoneButton()
        
    }
    func setNotifiedLabel() {
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber!)
        let attributedText = NSMutableAttributedString(string: "Vui lòng nhập mã gồm 6 chữ số đã được gửi đến bạn vào số điện thoại ")
        if let font = UIFont(name: "NunitoSans-Regular", size: 14) {
            attributedText.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedText.length))
        }
        if let boldFont = UIFont(name: "NunitoSans-Bold", size: 14){
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
            let boldPhoneNumber = NSAttributedString(string: "+84 \(formattedPhoneNumber)", attributes: boldAttributes)
            attributedText.append(boldPhoneNumber)
        }
        notifiedLabel.attributedText = attributedText
    }
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        let digitsOnly = phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        var formattedNumber = ""
        for (index, digit) in digitsOnly.enumerated() {
            if index != 0 && index % 3 == 0 {
                formattedNumber += " "
            }
            formattedNumber.append(digit)
           }
        return formattedNumber
    }
    //NAVIGATION BAR
    func setupNavigationBar() {
        let navItem = UINavigationItem(title: "Xác minh số điện thoại")

        let backButton = UIButton(type: .custom)
        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 5, weight: .thin)), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 15
        backButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        backButton.layer.borderWidth = 1
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )

        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.leftBarButtonItem = backBarButtonItem

        otpNavigationBar.setItems([navItem], animated: false)
    }
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //SHADOW
    func addShadow(to textField: UITextField) {
        textField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 4)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 8
        textField.layer.masksToBounds = false
        let spread: CGFloat = 2
        let bounds = textField.bounds
        let shadowPath = UIBezierPath(rect: CGRect(x: bounds.origin.x - spread, y: bounds.origin.y - spread, width: bounds.size.width + (2 * spread), height: bounds.size.height + (2 * spread)))
            textField.layer.shadowPath = shadowPath.cgPath
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // Nếu UITextField đã có một ký tự và người dùng nhập thêm
        if text.count == 2 {
            textField.text = String(text.prefix(1))  // Giữ lại ký tự đầu tiên trong textField hiện tại
            let nextText = String(text.suffix(1))  // Lấy ký tự thứ hai
            moveToPreviousTextField(from: textField, withText: nextText)  // Chuyển ký tự thứ hai sang textField trước đó
        } else if text.isEmpty {
            moveToNextTextField(from: textField)  // Di chuyển về textField sau nếu hiện tại đang trống
        }

        updateContinueButtonState()  // Cập nhật trạng thái của nút continue
    }

    func moveToNextTextField(from textField: UITextField, withText text: String? = nil) {
        if let currentIndex = otpTextFields.firstIndex(of: textField), currentIndex < otpTextFields.count - 1 {
            let nextTextField = otpTextFields[currentIndex + 1]
            if let nextText = text {
                nextTextField.text = nextText  // Điền ký tự vào textField tiếp theo
            }
            nextTextField.becomeFirstResponder()  // Chuyển focus đến textField tiếp theo
        }
    }

    func moveToPreviousTextField(from textField: UITextField, withText text: String? = nil) {
        if let currentIndex = otpTextFields.firstIndex(of: textField), currentIndex > 0 {
            let previousTextField = otpTextFields[currentIndex - 1]
            if let previousText = text {
                previousTextField.text = previousText  // Điền ký tự vào textField trước đó
            }
            previousTextField.becomeFirstResponder()  // Chuyển focus về textField trước đó
        }
    }



    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    func updateContinueButtonState() {
        let allTextFields = [otpTextField1, otpTextField2, otpTextField3, otpTextField4, otpTextField5, otpTextField6]
        let allFilled = allTextFields.allSatisfy { $0?.text?.count == 1 }
        continueButton.isEnabled = allFilled
        if allFilled {
            continueButton.layer.opacity = 1
            continueButton.isEnabled = true
        }
        else {
            continueButton.layer.opacity = 0.3
            continueButton.setTitleColor(.white, for: .disabled)
            continueButton.isEnabled = false
        }
    }
    @IBAction func didTapContinueButton(_ sender: Any) {
        
        let allTextFields = [otpTextField1, otpTextField2, otpTextField3, otpTextField4, otpTextField5, otpTextField6]
        let allTrue = allTextFields.allSatisfy { $0?.text == "1" }
        if allTrue {
            let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
       else if unmatchedOtpLabel == nil {
            let newLabel = UILabel()
            newLabel.translatesAutoresizingMaskIntoConstraints = false
            newLabel.text = "Nhập sai mã xác thực"
            newLabel.textAlignment = .center
            newLabel.backgroundColor = UIColor(red: 243/255, green: 245/255, blue: 251/255, alpha: 1)
            newLabel.textColor = .red
            newLabel.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(newLabel)
            self.unmatchedOtpLabel = newLabel

            NSLayoutConstraint.activate([
                newLabel.topAnchor.constraint(equalTo: otpCodeStackView.bottomAnchor, constant: 16),
                resendOtpButton.topAnchor.constraint(equalTo: newLabel.bottomAnchor, constant: 30),
                newLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                newLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                newLabel.heightAnchor.constraint(equalToConstant: 21)
            ])
            view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
            UIView.animate(withDuration: 0.3) {
                self.continueButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
        }
    }
        
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.continueButton.transform = .identity
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func startCountdown(_ sender: UIButton) {
        countdownTimer?.invalidate()
        
        remainingTime = 60
            

        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
        
    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            resendOtpButton.setTitle("Gửi lại mã sau \(remainingTime)s", for: .normal)
            resendOtpButton.isEnabled = false
            resendOtpButton.titleLabel?.textColor = UIColor(red: 217/255, green: 219/255, blue: 225/255, alpha: 1)
            resendOtpButton.layer.borderColor = UIColor(red: 217/255, green: 219/255, blue: 225/255, alpha: 1).cgColor
            resendOtpButton.layer.borderWidth = 1
            resendOtpButton.layer.cornerRadius = 15
            resendOtpButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        } else {
            countdownTimer?.invalidate()
            resendOtpButton.setTitle("Gửi lại mã", for: .normal)
            resendOtpButton.isEnabled = true
            resendOtpButton.titleLabel?.textColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1)
            resendOtpButton.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        }
    }
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        toolbar.items = [flexibleSpace, doneButton]
        
        for field in otpTextFields {
            field.inputAccessoryView = toolbar
        }
        
    }

    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
}
