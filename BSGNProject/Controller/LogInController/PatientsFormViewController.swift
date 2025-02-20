//
//  PatientsFormViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 8/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class PatientsFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var patientFormTableView: UITableView!
    var userInfo: [String: Any] = [
        "firstName": "",
        "lastName": "",
        "dateOfBirth": "",
        "gender": "Nam",
        "phoneNumber": "",
        "email": "",
        "district": "",
        "city": "",
        "street": "",
        "address": "",
        "bloodName": "",
        "typeOfAccount": 1]
    var selectedGenderIndex: Int = 0  // Giới tính được chọn mặc định là 0 (Nam)
    override func viewDidLoad() {
        super.viewDidLoad()
        patientFormTableView.delegate = self
        patientFormTableView.dataSource = self
        patientFormTableView.registerNib(cellType: TextTableViewCell.self)
        patientFormTableView.registerNib(cellType: ChooseTableViewCell.self)
        patientFormTableView.registerNib(cellType: ButtonTableViewCell.self)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section + 1 {
        case 1, 2, 5, 6, 10:
            let cell = patientFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
            if indexPath.section + 1 == 1 {
                cell.titleLabel.text = "Tên *"
                cell.inputTextField.placeholder = "Nhập tên của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 2 {
                cell.titleLabel.text = "Họ *"
                cell.inputTextField.placeholder = "Nhập họ của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 5 {
                cell.titleLabel.text = "Số điện thoại"
                cell.inputTextField.placeholder = "Nhập số điện thoại của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 6 {
                cell.titleLabel.text = "Email"
                cell.inputTextField.placeholder = "Địa chỉ Email của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else {
                cell.titleLabel.text = "Địa chỉ nơi ở"
                cell.inputTextField.placeholder = "Nơi thường trú của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
            cell.downButton.isHidden = true
            return cell
            
        case 3,7,8,9,11:
            let cell = patientFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
            if indexPath.section + 1 == 3 {
                cell.titleLabel.text = "Ngày sinh *"
                cell.inputTextField.placeholder = "DD/MM/YY"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 7 {
                cell.titleLabel.text = "Tỉnh / Thành phố"
                cell.inputTextField.placeholder = "Nhập tỉnh/thành phố của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 8 {
                cell.titleLabel.text = "Quận / Huyện"
                cell.inputTextField.placeholder = "Nhập quận/huyện của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else if indexPath.section + 1 == 9 {
                cell.titleLabel.text = "Phường / Xã"
                cell.inputTextField.placeholder = "Nhập phường/xã của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            } else {
                cell.titleLabel.text = "Nhóm máu"
                cell.inputTextField.placeholder = "A+/B+/AB/O"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
            return cell
            
        case 4:
            let cell = patientFormTableView.dequeue(cellType: ChooseTableViewCell.self, for: indexPath)
            cell.chooseSegment.isEnabled = true
            cell.addSegmentedControlTarget(target: self, action: #selector(genderSegmentedControlChanged(_:)))
            return cell
        case 12:
            let cell = patientFormTableView.dequeue(cellType: ButtonTableViewCell.self, for: indexPath)
            cell.addContinueButtonTarget(target: self, action: #selector(continueButtonTapped(_:)))
            return cell
        case 13:
            let cell = UITableViewCell()
            let view = UIView()
            view.backgroundColor = .clear
            cell.addSubview(view)
            return cell
        default:
            let cell = patientFormTableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
            
            return cell
        }
        
    }
    @objc func genderSegmentedControlChanged(_ sender: UISegmentedControl) {
        // Khi người dùng thay đổi giới tính, lưu giá trị vào userInfo
        let genderCell = patientFormTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! ChooseTableViewCell
        userInfo["gender"] = genderCell.getSelectedGender()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userInfo["firstName"] = textField.text
        case 1:
            userInfo["lastName"] = textField.text
        case 2:
            userInfo["dateOfBirth"] = textField.text
        case 3:
            userInfo["gender"] = textField.text
        case 4:
            userInfo["phoneNumber"] = textField.text
        case 5:
            userInfo["email"] = textField.text
        case 6:
            userInfo["district"] = textField.text
        case 7:
            userInfo["city"] = textField.text
        case 8:
            userInfo["street"] = textField.text
        case 9:
            userInfo["address"] = textField.text
        case 10:
            userInfo["bloodName"] = textField.text
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 3{
            return 70
        }
        if indexPath.section == 11 {
            return 48
        }
        if indexPath.section == 12 {
            return 400
        }
        
        return 70
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    @objc func continueButtonTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference().child("users").child("patients").child(user.uid)
        ref.setValue(userInfo) { error, _ in
            if let error = error {
                print("Lỗi khi lưu thông tin: \(error.localizedDescription)")
                return
            }
//            else {
//                let homeVC = TabbarController()
//                self.navigationController?.pushViewController(homeVC, animated: true)
//            }
        }
        let homeVC = TabbarController()
        self.navigationController?.pushViewController(homeVC, animated: true)
        homeVC.navigationController?.navigationBar.isHidden = true
    }
}
