//
//  DoctorsFormViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 8/10/24.
//

import UIKit
import FirebaseAuth
import Firebase

class DoctorsFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userInfo["major"] = majorData[row]
        userInfo["majorID"] = row + 1
    }
    
    @IBOutlet private weak var doctorFormTableView: UITableView!
    let majorPickerView = UIPickerView()
    private var selectedMajor: String = ""
    private let majorData: [String] = [
        "Tim mạch",
        "Da liễu",
        "Thần kinh",
        "Nhi khoa",
        "Chỉnh hình",
        "Nhãn khoa",
        "Tiêu hóa",
        "Hô hấp",
        "Sản khoa",
        "Nội tiết"
    ]
    
    var userInfo: [String: Any] = [
        "firstName": "",
        "lastName": "",
        "dateOfBirth": "",
        "gender": "",
        "phoneNumber": "",
        "education": "",
        "district": "",
        "city": "",
        "street": "",
        "address": "",
        "degree": "",
        "training_place": "",
        "major": "",
        "majorID": "",
        "avatar": "0",
        "balance": 0,
        "pricePerHour": 0,
        "typeOfAccount": 1,
        "isInAppointment": 0
    ]
    var selectedGenderIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorFormTableView.delegate = self
        doctorFormTableView.dataSource = self
        doctorFormTableView.registerNib(cellType: TextTableViewCell.self)
        doctorFormTableView.registerNib(cellType: ButtonTableViewCell.self)
        doctorFormTableView.registerNib(cellType: ChooseTableViewCell.self)
        
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newSection = indexPath.section + 1
        switch newSection {
        case 1, 2, 5, 6, 10:
            if newSection == 1 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Tên *"
                cell.inputTextField.placeholder = "Nhập tên của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.downButton.isHidden = true
                return cell
            } else if newSection == 2 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Họ *"
                cell.inputTextField.placeholder = "Nhập họ của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.downButton.isHidden = true
                return cell
            } else if indexPath.section + 1 == 5 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Số điện thoại"
                cell.inputTextField.placeholder = "Nhập số điện thoại của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.downButton.isHidden = true
                return cell
            } else if indexPath.section + 1 == 6 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Email"
                cell.inputTextField.placeholder = "Địa chỉ Email của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.downButton.isHidden = true
                return cell
            } else {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Địa chỉ nơi ở"
                cell.inputTextField.placeholder = "Nơi thường trú của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.downButton.isHidden = true
                return cell
            }
            
            
        case 3,7,8,9,11,12,13:

            if indexPath.section + 1 == 3 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Ngày sinh *"
                cell.inputTextField.placeholder = "DD/MM/YY"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else if indexPath.section + 1 == 7 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Tỉnh / Thành phố"
                cell.inputTextField.placeholder = "Nhập tỉnh/thành phố của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else if indexPath.section + 1 == 8 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Quận / Huyện"
                cell.inputTextField.placeholder = "Nhập quận/huyện của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else if indexPath.section + 1 == 9 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Phường / Xã"
                cell.inputTextField.placeholder = "Nhập phường/xã của bạn"
                cell.inputTextField.tag = indexPath.section // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else if indexPath.section + 1 == 11 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Bằng cấp"
                cell.inputTextField.placeholder = "Hãy nhập bằng cấp của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else if indexPath.section + 1 == 12 {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Nơi thực tập"
                cell.inputTextField.placeholder = "Hãy nhập nơi thực tập của bạn"
                cell.inputTextField.tag = indexPath.section  // Sử dụng tag để nhận diện textfield
                cell.inputTextField.delegate = self
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return cell
            } else {
                let cell = doctorFormTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
                cell.titleLabel.text = "Chuyên ngành"
                cell.inputTextField.placeholder = "Hãy nhập chuyên ngành của bạn"
//                cell.inputTextField.inputView = majorPickerView
                cell.inputTextField.placeholder = "Nhấp để chọn chuyên ngành"
                
                // Thêm nút Done cho PickerView
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([flexibleSpace, doneButton], animated: false)
                cell.inputTextField.inputAccessoryView = toolbar
                return cell
            }
            
            
        case 4:
            let cell = doctorFormTableView.dequeue(cellType: ChooseTableViewCell.self, for: indexPath)
            cell.chooseSegment.isEnabled = true
            cell.addSegmentedControlTarget(target: self, action: #selector(genderSegmentedControlChanged(_:)))
            return cell
        case 14:
            let cell = doctorFormTableView.dequeue(cellType: ButtonTableViewCell.self, for: indexPath)
            cell.addContinueButtonTarget(target: self, action: #selector(continueButtonTapped(_:)))
            return cell
        case 15:
            let cell = UITableViewCell()
            let view = UIView()
            view.backgroundColor = .clear
            cell.addSubview(view)
            return cell
        default:
            let cell = doctorFormTableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
            
            return cell
        }
        
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
            userInfo["degree"] = textField.text
        case 11:
            userInfo["training_place"] = textField.text
        case 12:
            userInfo["major"] = textField.text
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 3{
            return 70
        }
        else if indexPath.section == 13 {
            return 48
        }
        else if indexPath.section == 14 {
            return 400
        }
        else {
            return 70
        }
    }
    @objc func genderSegmentedControlChanged(_ sender: UISegmentedControl) {
        // Khi người dùng thay đổi giới tính, lưu giá trị vào userInfo
        let genderCell = doctorFormTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! ChooseTableViewCell
        userInfo["gender"] = genderCell.getSelectedGender()
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
        
        let ref = Database.database().reference().child("users").child("doctors").child(user.uid)
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
        let homeVC = LoginViewController()
        self.navigationController?.pushViewController(homeVC, animated: true)
        homeVC.navigationController?.navigationBar.isHidden = true
    }
    @objc func dismissPickerView() {
        view.endEditing(true) // Đóng PickerView
        if let indexPath = doctorFormTableView.indexPathForSelectedRow,
           indexPath.section == 12, // Chỉ cập nhật giá trị cho cell đầu tiên
           let cell = doctorFormTableView.cellForRow(at: indexPath) as? TextTableViewCell {
            cell.inputTextField.text = userInfo["major"] as? String
        }
    }
}
