//
//  NewDoctorFormTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/12/24.
//

import UIKit
import FirebaseAuth

class NewDoctorFormTableViewCell: UITableViewCell, SummaryMethod, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var dobTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var studyTextField: UITextField!
    @IBOutlet private weak var degreeTextField: UITextField!
    @IBOutlet private weak var trainingPlaceTextField: UITextField!
    @IBOutlet private weak var majorTextField: UITextField!
    @IBOutlet private weak var priceForOneHourTextField: UITextField!
    @IBOutlet private weak var genderSegment: UISegmentedControl!
    @IBOutlet private weak var doneButton: UIButton!
    
    private var majorID: Int?
    weak var delegate: NewDoctorFormCellDelegate?
    private let pickerView = UIPickerView()
    private let majorData: [String] = GlobalService.shared.majorData
    let uid = Auth.auth().currentUser?.uid
    private let degree: [String] = ["Đại học", "Cao đẳng", "Không có"]
    private let degreePicker = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        [nameTextField, lastNameTextField, dobTextField, phoneNumberTextField,
         addressTextField, studyTextField, degreeTextField,
         majorTextField, priceForOneHourTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        validateFields()
        setupDegreePicker()
        setupDatePicker()
        setupPickerView()
    }
    
    func validateFields() {
        let isFirstNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isLastNameValid = !(lastNameTextField.text?.isEmpty ?? true)
        let isDobValid = !(dobTextField.text?.isEmpty ?? true)
        let isPhoneNumberValid = !(phoneNumberTextField.text?.isEmpty ?? true)
        let isAddressValid = !(addressTextField.text?.isEmpty ?? true)
        let isStudyValid = !(studyTextField.text?.isEmpty ?? true)
        let isDegreeValid = !(degreeTextField.text?.isEmpty ?? true)
        let isMajorValid = !(majorTextField.text?.isEmpty ?? true)
        let isPriceValid = !(priceForOneHourTextField.text?.isEmpty ?? true)
        
        let allFieldsValid = isFirstNameValid && isLastNameValid && isDobValid &&
            isPhoneNumberValid && isAddressValid && isStudyValid &&
            isDegreeValid && isMajorValid && isPriceValid
        
        doneButton.isEnabled = allFieldsValid
        doneButton.alpha = allFieldsValid ? 1.0 : 0.5
    }

    func addTargettoDoneButton(selector: Selector) {
        doneButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let data: [String: Any] = [
            "firstName": nameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "dateOfBirth": dobTextField.text ?? "",
            "gender": genderSegment.selectedSegmentIndex == 0 ? "Male" : "Female",
            "phoneNumber": phoneNumberTextField.text ?? "",
            "address": addressTextField.text ?? "",
            "education": studyTextField.text ?? "",
            "degree": degreeTextField.text ?? "",
            "training_place": trainingPlaceTextField.text ?? "",
            "majorID": majorID ?? 0,
            "major": majorTextField.text ?? "",
            "price": Int(priceForOneHourTextField.text ?? "0") ?? 0
        ]
//        
        delegate?.didTapDoneButton(with: data)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateFields()
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Gán pickerView làm inputView cho majorTextField
        majorTextField.inputView = pickerView
        
        // Tạo thanh công cụ (Toolbar) với nút "Done" để đóng pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        majorTextField.inputAccessoryView = toolbar
    }
    
    private func setupDegreePicker() {
        // Cấu hình picker cho bloodTextField
        degreePicker.delegate = self
        degreePicker.dataSource = self
        degreeTextField.inputView = degreePicker
        degreeTextField.inputAccessoryView = createToolbar(action: #selector(didSelectDegree))
    }
    
    @objc private func dismissPicker() {
        majorTextField.resignFirstResponder()
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
    
    @objc private func didSelectDegree() {
        let selectedRow = degreePicker.selectedRow(inComponent: 0)
        degreeTextField.text = degree[selectedRow]
        degreeTextField.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        dobTextField.resignFirstResponder()
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // PickerView chỉ có 1 cột
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return majorData.count // Số hàng = số phần tử trong majorData
        }
        
        if pickerView == self.degreePicker {
            return degree.count
        }
        return 1
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return majorData[row] // Hiển thị tên chuyên ngành
        }
        
        if pickerView == self.degreePicker {
            return degree[row]
        }
        return "No data!"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            majorTextField.text = majorData[row] // Cập nhật text của majorTextField
            majorID = row + 1
        }
    }
    
}
protocol NewDoctorFormCellDelegate: AnyObject {
    func didTapDoneButton(with data: [String: Any])
}

