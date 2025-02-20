//
//  RegisterPatientViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 7/10/24.
//

import UIKit
import FirebaseAuth

class RegisterPatientViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var phoneView: UIView!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    
    private var kindOfAccount: KindOfAccount?
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
    }
    private func setupUI() {
        passwordView.layer.cornerRadius = 24
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        phoneView.layer.cornerRadius = 24
        phoneView.layer.borderWidth = 1
        phoneView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        continueButton.layer.opacity = 0.3
        continueButton.setTitleColor(.white, for: .disabled)
        continueButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        phoneView.layer.borderWidth = 1.5
        passwordView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        passwordView.layer.borderWidth = 1.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        phoneView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        passwordView.layer.borderWidth = 1
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = phoneTextField.text {
            if (currentText.count > 2
//                && updatedText.first != "0" && updatedText.allSatisfy({$0.isNumber})) || (updatedText.count == 10 && updatedText.first == "0" && updatedText.allSatisfy({$0.isNumber})
                ) {
                continueButton.layer.opacity = 1
                continueButton.isEnabled = true
            } else {
                continueButton.layer.opacity = 0.3
                continueButton.isEnabled = false
                continueButton.setTitleColor(.white, for: .disabled)
            }
        }
        return true
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
    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    func setKindOfAccountToPatientRegister() {
        kindOfAccount = .patientRegister
    }
    func setKindOfAccountToPatientLogin() {
        kindOfAccount = .patientLogin
    }
    func setKindOfAccountToDoctorRegister() {
        kindOfAccount = .doctorRegister
    }
    func setKindOfAccountToDoctorLogin() {
        kindOfAccount = .doctorLogin
    }
    
    @IBAction func eyeTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.setImage(UIImage(systemName: passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        if kindOfAccount == .patientRegister {
            guard let email = phoneTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                print("Email or Password is empty")
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                    // Nếu tài khoản không tồn tại thì mới cho phép tạo user mới
                    self.registerPatient(email: email, password: password)
                } else
                if let authResult = authResult {
                    // Nếu đã có tài khoản thì thông báo
                    print("Account already exists for email \(authResult.user.email ?? "")")
                } else if AuthErrorCode.wrongPassword.hashValue == error?._code.hashValue {
                    print("Account already exists for email \(email)")
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
            
        } else if kindOfAccount == .doctorRegister {
            guard let email = phoneTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                print("Email or Password is empty")
                return
            }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                    // Nếu tài khoản không tồn tại thì mới cho phép tạo user mới
                    self.registerDoctor(email: email, password: password)
                } else
                if let authResult = authResult {
                    // Nếu đã có tài khoản thì thông báo
                    print("Account already exists for email \(authResult.user.email ?? "")")
                } else if AuthErrorCode.wrongPassword.hashValue == error?._code.hashValue {
                    print("Account already exists for email \(email)")
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        } else {
            let newVC = OTPViewController(nibName: "OTPViewController", bundle: nil)
            newVC.setKindOfAccountToPatientRegister()
            newVC.setPhoneNumber(with: phoneTextField.text ?? "")
            navigationController?.pushViewController(newVC, animated: true)
            newVC.setupNavigationBar(with: "Xác nhận số điện thoại", with: false)
            
        }
    }
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            print("Đăng xuất thành công!")
            // Điều hướng về màn hình đăng nhập hoặc các bước khác
        } catch let signOutError as NSError {
            print("Lỗi khi đăng xuất: \(signOutError.localizedDescription)")
        }
    }

    func registerPatient(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error)")
                return
            }
            // Khi tạo user thành công, chuyển sang màn hình nhập thông tin cá nhân
            print("User created successfully")
            let personalInfoVC = NewPatientFormViewController() // Đảm bảo đã set up storyboard hoặc tạo VC
            self.navigationController?.pushViewController(personalInfoVC, animated: true)
        }
    }
    func registerDoctor(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error)")
                return
            }
            print("User created successfully")
            let personalInfoVC = NewDoctorFormViewController    ()
            self.navigationController?.pushViewController(personalInfoVC, animated: true)
            
        }
    }
}
