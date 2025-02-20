//
//  PatientBookViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 30/10/24.
//

import UIKit

class PatientBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var findButton: UIButton!
    @IBOutlet weak var borderTextView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet private weak var majorTextField: UITextField!
    @IBOutlet private weak var backgroundImageVIew: UIImageView!
    private let majorPickerView = UIPickerView()

   
    private var keyboardTextFields: UITextField!
    let majorData: [String] = GlobalService.shared.majorData
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpTextView()
    }
    private func setupUI() {
        GlobalService.appointmentData["specialtyID"] = 1 // dèfault = 1
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        majorTextField.inputView = majorPickerView
        majorTextField.inputAccessoryView = createToolbar(action: #selector(dismissPickerView))
        
        keyboardTextFields = UITextField()
        keyboardTextFields.placeholder = "Mô tả"
        keyboardTextFields.frame = CGRect(x: 0, y: view.bounds.height + 50, width: view.bounds.width + 10, height: 34)
        keyboardTextFields.layer.cornerRadius = 5
        keyboardTextFields.layer.shadowColor = UIColor.black.cgColor
        keyboardTextFields.layer.shadowOffset = CGSize(width: 0, height: 1)
        keyboardTextFields.layer.shadowRadius = 1
        keyboardTextFields.layer.shadowOpacity = 0.5
        
        view.addSubview(keyboardTextFields)
        keyboardTextFields.delegate = self
        keyboardTextFields.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        

        findButton.layer.shadowColor = UIColor.black.cgColor
        findButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        findButton.layer.shadowRadius = 4
        findButton.layer.shadowOpacity = 0.5
    }
    
    func setUpTextView() {
        borderTextView._cornerRadius = 20
        borderTextView.layer.masksToBounds = true
        borderTextView.backgroundColor = UIColor(hex: "#D7E6DF", alpha: 1)

        detailTextView.font = .systemFont(ofSize: 16, weight: .medium)
        detailTextView.textColor = .black
        
        detailTextView.placeholder = "Mô tả chi tiết ở đây"
        detailTextView.placeholderColor = .darkGray
    }
    
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    @objc private func dismissPickerView() {
        let selectedRow = majorPickerView.selectedRow(inComponent: 0)
        majorTextField.text = majorData[selectedRow]
        majorTextField.resignFirstResponder()
    }

    private func createToolbar(action: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: action)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        detailMedicalLabel.text = keyboardTextFields.text
    }
    
    @IBAction func didTapFind(_ sender: Any) {
//        let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn tìm kiếm?", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
        if let navController = self.navigationController {
            let mapVC = PositionViewController()
            navController.pushViewController(mapVC, animated: true)
            mapVC.setupNavigationBar(with: "Xác nhận vị trí của bạn", with: false)
            GlobalService.appointmentData["specialty"] = majorTextField.text

            GlobalService.appointmentData["symtoms"] =  detailTextView.text
        } else {
            print("Navigation controller is nil")
        }

        
    }
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        majorTextField.text = majorData[row]
        GlobalService.appointmentData["specialtyID"] = row + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorData[row]
    }
    

}
