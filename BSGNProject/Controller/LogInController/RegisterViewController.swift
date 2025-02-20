//
//  RegisterViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 7/10/24.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var roleSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        setupNavigationBar(with: "", with: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        roleSegmentControl.frame.size.height = 50
    }
    
    @IBAction func didTapContinue(_ sender: Any) {
        if roleSegmentControl.selectedSegmentIndex == 0 {
            let registerPatientVC = RegisterPatientViewController(nibName: "RegisterPatientViewController", bundle: nil)
            self.navigationController?.pushViewController(registerPatientVC, animated: true)
            registerPatientVC.setupNavigationBar(with: "Đăng ký bệnh nhân", with: false)
            registerPatientVC.setKindOfAccountToPatientRegister()
        } else {
            let registerDoctorVC = RegisterPatientViewController(nibName: "RegisterPatientViewController", bundle: nil)
            self.navigationController?.pushViewController(registerDoctorVC, animated: true)
            registerDoctorVC.setupNavigationBar(with: "Đăng ký bác sĩ", with: false)
            registerDoctorVC.setKindOfAccountToDoctorRegister()
        }
    }
}
