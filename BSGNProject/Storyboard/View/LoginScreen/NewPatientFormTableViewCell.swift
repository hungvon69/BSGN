//
//  NewPatientFormTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 17/12/24.
//

import UIKit

class NewPatientFormTableViewCell: BaseTableViewCell, SummaryMethod {

    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var bloodTextField: UITextField!
    @IBOutlet private weak var idenTextField: UITextField!
    @IBOutlet private weak var xaTextField: UITextField!
    @IBOutlet private weak var districtTextField: UITextField!
    @IBOutlet private weak var provinceTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var sexSegment: UISegmentedControl!
    @IBOutlet private weak var dobTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    
    weak var delegate: NewPatientFormCellDelegate?
    
    let bloodTypes: [String] = GlobalService.shared.bloodTypes
    private let bloodTypePicker = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    private func setup() {
        setupDatePicker()
        setupBloodTypePicker()

        
        [lastNameTextField, firstNameTextField, dobTextField, phoneNumberTextField, addressTextField, provinceTextField, districtTextField, xaTextField, idenTextField, bloodTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        validateFields()
    }
    
    func fillData(_ userData: [String: Any]) {
        firstNameTextField.text = userData["name"] as? String
        lastNameTextField.text = userData["lastName"] as? String
        phoneNumberTextField.text = userData["phoneNumber"] as? String
        addressTextField.text = userData["address"] as? String
        provinceTextField.text = userData["province"] as? String
        districtTextField.text = userData["district"] as? String
        xaTextField.text = userData["xa"] as? String
        dobTextField.text = userData["dateOfBirth"] as? String
        idenTextField.text = userData["identifyNumber"] as? String

    }
    
    func validateFields() {
        let isFirstNameValid = firstNameTextField.text?.isEmpty ?? true
        let isLastNameValid = lastNameTextField.text?.isEmpty ?? true
        let isDobValid = dobTextField.text?.isEmpty ?? true
        let isPhoneNumberValid = phoneNumberTextField.text?.isEmpty ?? true
        let isAddressValid = addressTextField.text?.isEmpty ?? true
        let isProvinceValid = provinceTextField.text?.isEmpty ?? true
        let isDistrictValid = districtTextField.text?.isEmpty ?? true
        let isXaValid = xaTextField.text?.isEmpty ?? true
        let isIdenValid = idenTextField.text?.isEmpty ?? true
        let isBloodValid = bloodTextField.text?.isEmpty ?? true
        
        let allFieldsValid = !isFirstNameValid && !isLastNameValid && !isDobValid &&
        !isPhoneNumberValid && !isAddressValid && !isProvinceValid && !isDistrictValid && !isXaValid && !isIdenValid && !isBloodValid
        doneButton.isEnabled = true
        doneButton.alpha = 1
    }
    
    private func setupBloodTypePicker() {
        // Cấu hình picker cho bloodTextField
        bloodTypePicker.delegate = self
        bloodTypePicker.dataSource = self
        bloodTextField.inputView = bloodTypePicker
        bloodTextField.inputAccessoryView = createToolbar(action: #selector(didSelectBloodType))
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() // Ngày tối đa là ngày hiện tại
        datePicker.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        
        dobTextField.inputView = datePicker // Gắn datePicker làm input view
        dobTextField.inputAccessoryView = createToolbar(action: #selector(dismissKeyboard)) // Thêm thanh toolbar để đóng Date Picker
    }

    @objc private func didChangeDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Định dạng ngày tháng năm
        dobTextField.text = dateFormatter.string(from: sender.date)
        validateFields()
    }
    
    private func createToolbar(action: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: action)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: true)
        
        return toolbar
    }
    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    @objc private func didSelectBloodType() {
        let selectedRow = bloodTypePicker.selectedRow(inComponent: 0)
        bloodTextField.text = bloodTypes[selectedRow]
        bloodTextField.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        dobTextField.resignFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let data: [String: Any] = [
            "name": firstNameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "dateOfBirth": dobTextField.text ?? "",
            "sex": sexSegment.selectedSegmentIndex == 0 ? "Male" : "Female",
            "phoneNumber": phoneNumberTextField.text ?? "",
            "address": addressTextField.text ?? "",
            "province": provinceTextField.text ?? "",
            "district": districtTextField.text ?? "",
            "xa": xaTextField.text ?? "",
            "identifyNumber": idenTextField.text ?? "",
            "blood": bloodTextField.text ?? ""
        ]
        delegate?.didTapDoneButton(with: data)
    }
    
}
protocol NewPatientFormCellDelegate: AnyObject {
    func didTapDoneButton(with data: [String: Any])
}

extension NewPatientFormTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == bloodTypePicker {
            return bloodTypes.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == bloodTypePicker {
            return bloodTypes[row]
        }
        return nil
    }
}
