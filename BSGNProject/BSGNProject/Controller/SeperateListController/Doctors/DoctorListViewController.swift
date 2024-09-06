//
//  DoctorListViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 22/08/2024.
//

import UIKit

class DoctorListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var doctorListTableView: UITableView!
    @IBOutlet private var doctorListNavigationBar: UINavigationBar!
    
    var doctors = [Doctor]()
    var doctorVM: DoctorViewModel?
    var numberOfDoctors = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorListTableView.delegate = self
        doctorListTableView.dataSource = self
        doctorListTableView.registerNib(cellType: DoctorListTableViewCell.self)
        setupNavigationBar()
        DoctorService.fetchNews{ result in
            switch result {
            case .success(let data):
                if self.doctorVM == nil {
                    self.doctorVM = DoctorViewModel()
                }
                self.doctorVM?.listDoctor = data.items
                print(self.doctorVM?.listDoctor as Any)
                self.numberOfDoctors = data.items.count
                self.updateUI()
            case .failure(let error):
                print("000000000000000000000000\(error)")
            }
        }
    }
    func updateUI() {
        self.doctorListTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfDoctors
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doctorListTableView.dequeue(cellType: DoctorListTableViewCell.self, for: indexPath)
        if let doctor = doctorVM?.listDoctor[indexPath.section] {
            cell.configure(with: doctor)
        }
        return cell
    }
    func setupNavigationBar() {
        let navItem = UINavigationItem(title: "Danh sách bác sỹ")

        let backButton = UIButton(type: .custom)
        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 5, weight: .thin)), for: .normal)
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

        doctorListNavigationBar.setItems([navItem], animated: false)
    }
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func configure(with doctors: [Doctor]) {
        self.doctors = doctors
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}
