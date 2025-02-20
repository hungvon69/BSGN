//
//  LoginViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {

    @IBOutlet private weak var passWordTextField: UITextField!
    @IBOutlet private weak var passWordView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var introImageView: UIImageView!
    @IBOutlet private weak var hotlineButton: UIButton!
    @IBOutlet private weak var translateButton: UIButton!
    @IBOutlet private weak var continueLoginButton: UIButton!
    @IBOutlet private weak var eyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        setupNavigationBar(with: "", with: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.sendSubviewToBack(introImageView)
        
        
        emailTextField.delegate = self
        
        emailView.layer.cornerRadius = 10
        passWordView.layer.cornerRadius = 10
        
        continueLoginButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        continueLoginButton.layer.opacity = 0.3
        continueLoginButton.setTitleColor(.white, for: .disabled)
        continueLoginButton.isEnabled = false
        
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
        createDoneButton()
    }
  
    @IBAction func didTapCustomButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        loginAndFetchUserAttributes(email: emailTextField.text ?? "", password: passWordTextField.text ?? "")
    }

 
    @IBAction func eyeTapped(_ sender: Any) {
        passWordTextField.isSecureTextEntry.toggle()
        eyeButton.setImage(UIImage(systemName: passWordTextField.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
    }
    
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        toolbar.items = [flexibleSpace, doneButton]
            
        emailTextField.inputAccessoryView = toolbar
        passWordTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    func loginAndFetchUserAttributes(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                return
            }
            
            guard let userId = authResult?.user.uid else { return }
            let ref = Database.database().reference()
            
            ref.child("users").child("doctors").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {

                    self.fetchDoctorAttributes(userId: userId)
                    let Vc = DoctorHomeViewController()
                    Vc.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.viewControllers = [Vc]
                } else {
                    ref.child("users").child("patients").child(userId).observeSingleEvent(of: .value) { (snapshot) in
                        if snapshot.exists() {
                            self.fetchPatientAttributes(userId: userId)
                            let VC = TabbarController()
                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                            self.navigationController?.viewControllers = [VC]
                        } else {
                            print("User data not found in either doctors or patients.")
                        }
                    }
                }
            }
        }
    }

    func fetchDoctorAttributes(userId: String) {
        let ref = Database.database().reference()
        FirebaseDatabaseService.fetchDoctor(by: userId) { result in
            switch result {
            case .success(let doctor):
                Global.doctor = doctor
                Global.role = .doctor
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func fetchPatientAttributes(userId: String) {
        let ref = Database.database().reference()
        FirebaseDatabaseService.fetchPatient(by: userId) { result in
            switch result {
            case .success(let patient):
                Global.patient = patient
                Global.role = .patient
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        emailView.layer.borderWidth = 1.5
        passWordView.layer.borderColor = UIColor(red: 44/255, green: 134/255, blue: 103/255, alpha: 1).cgColor
        passWordView.layer.borderWidth = 1.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        emailView.layer.borderWidth = 1
        passWordView.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        passWordView.layer.borderWidth = 1
    }
    //Hàm xử lý textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = emailTextField.text {
            if (currentText.count > 2
//                && updatedText.first != "0" && updatedText.allSatisfy({$0.isNumber})) || (updatedText.count == 10 && updatedText.first == "0" && updatedText.allSatisfy({$0.isNumber})
                ) {
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
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

  
}
