//
//  InformationViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 23/08/2024.
//

import UIKit

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var infoTableView: UITableView!
    
    var user: User?
    var sum: Int = 0
    var textFieldsData: [String] = ["", "","", "1","", "","", "","", "","", "1",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.registerNib(cellType: TextTableViewCell.self)
        infoTableView.registerNib(cellType: ChooseTableViewCell.self)
        infoTableView.registerNib(cellType: ButtonTableViewCell.self)
      
        
    }
    func updateUI(){
        self.infoTableView.reloadData()
    }
    
//    func setupNavigationBar() {
//        let navItem = UINavigationItem(title: "Thông tin cá nhân")
//
//        let backButton = UIButton(type: .custom)
//        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
//        backButton.tintColor = .black
//        backButton.backgroundColor = .white
//        backButton.layer.cornerRadius = 15
//        backButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
//        backButton.layer.borderWidth = 1
//        backButton.clipsToBounds = true
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        backButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
//
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
//        navItem.leftBarButtonItem = backBarButtonItem
//
//        infoNavigationBar.setItems([navItem], animated: false)
//        
//    }
//    @objc func backButtonTapped() {
//        if let navigationController = self.navigationController {
//                navigationController.popViewController(animated: true)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section + 1 {
        case 1, 2, 5, 6, 10:
            let cell = infoTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
            if indexPath.section + 1 == 1 {
                cell.titleLabel.text = "Tên *"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.isUserInteractionEnabled = true
                cell.inputTextField.placeholder = "Nhập tên của bạn"
            } else if indexPath.section + 1 == 2 {
                cell.titleLabel.text = "Họ *"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.isUserInteractionEnabled = true
                cell.inputTextField.placeholder = "Nhập họ của bạn"
            } else if indexPath.section + 1 == 5 {
                cell.titleLabel.text = "Số điện thoại"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.placeholder = "Nhập số điện thoại của bạn"
                cell.inputTextField.isUserInteractionEnabled = false
            } else if indexPath.section + 1 == 6 {
                cell.titleLabel.text = "Email"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.placeholder = "Địa chỉ Email của bạn"
            } else {
                cell.titleLabel.text = "Địa chỉ nơi ở"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.placeholder = "Nơi thường trú của bạn"
            }
            cell.downButton.isHidden = true
            return cell
            
        case 3,7,8,9,11:
            let cell = infoTableView.dequeue(cellType: TextTableViewCell.self, for: indexPath)
            if indexPath.section + 1 == 3 {
                cell.titleLabel.text = "Ngày sinh *"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.placeholder = "DD/MM/YY"
                cell.inputTextField.isUserInteractionEnabled = false
            } else if indexPath.section + 1 == 7 {
                cell.titleLabel.text = "Tỉnh / Thành phố"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.placeholder = "Chưa cập nhật"
                cell.inputTextField.isUserInteractionEnabled = false
            } else if indexPath.section + 1 == 8 {
                cell.titleLabel.text = "Quận / Huyện"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.isUserInteractionEnabled = false
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.placeholder = "Chưa cập nhật"
            } else if indexPath.section + 1 == 9 {
                cell.titleLabel.text = "Phường / Xã"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.isUserInteractionEnabled = false
                cell.inputTextField.placeholder = "Chưa cập nhật"
            } else {
                cell.titleLabel.text = "Nhóm máu"
                cell.inputTextField.text = textFieldsData[indexPath.section]
                cell.inputTextField.tag = indexPath.section
                cell.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.inputTextField.isUserInteractionEnabled = false
                cell.inputTextField.placeholder = "A+/B+/AB/O"
            }
            return cell
            
        case 4:
            let cell = infoTableView.dequeue(cellType: ChooseTableViewCell.self, for: indexPath)
            if let gender = user?.sex {
                cell.chooseSegment.selectedSegmentIndex = gender
            }
            
            cell.chooseSegment.isEnabled = true
            return cell
        case 12:
            let cell = infoTableView.dequeue(cellType: ButtonTableViewCell.self, for: indexPath)
            return cell
        case 13:
            let cell = UITableViewCell()
            let view = UIView()
            view.backgroundColor = .clear
            cell.addSubview(view)
            return cell
        default:
            let cell = infoTableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 3{
            return 70
        }
        else if indexPath.section == 11 {
            return 48
        }
        else if indexPath.section == 12 {
            return 400
        }
        else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let row = textField.tag
        textFieldsData[row] = textField.text ?? ""
    }
}
