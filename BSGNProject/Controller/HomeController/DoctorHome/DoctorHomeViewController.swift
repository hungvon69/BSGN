//
//  DoctorHomeViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import UIKit
import FirebaseAuth

enum DoctorHomeCellType: CaseIterable {

    case doctorHome
    case doctorHomeAction
    case doctorArticle

    static func returnValueFromInt(value: Int) -> DoctorHomeCellType {
        return DoctorHomeCellType.allCases[value]
    }
}

class DoctorHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var doctorHomeTableView: UITableView!
//    var doctorHomeCellType: [DoctorHomeCellType] = [
//        .doctorHome,
//        .doctorHomeAction
//    ]
//    private var avatarImageView: UIImageView?
    private var selectedImage: UIImage? = UIImage(named: "default_doctor")
    private lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self.navigationController, delegate: self)
        return picker
    }()

    private var customArticle : [Article] = []
    private var idArticle: [String] = GlobalService.shared.idArticle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        doctorHomeTableView.delegate = self
        doctorHomeTableView.dataSource = self
        doctorHomeTableView.registerNib(cellType: DoctorHomeTableViewCell.self)
        doctorHomeTableView.registerNib(cellType: DoctorHomeActionTableViewCell.self)
        doctorHomeTableView.registerNib(cellType: ReuseArticleTableViewCell.self)
        doctorHomeTableView.backgroundColor = .clear
       
//        fetchDoctorProfile()
        for id in idArticle {
            GlobalService.shared.fetchArticlesFromFirebase(articleID: id) { result in
                switch result {
                case .success(let fetchedArticles):
                    self.customArticle.append(fetchedArticles)
                    self.doctorHomeTableView.reloadData() // Reload table view khi dữ liệu đã có
                case .failure(let error):
                    print("Error fetching articles: \(error.localizedDescription)") // Xử lý lỗi
                }
            }
        }
        if let backgroundImage = UIImage(named: "docback")?.cgImage {
            self.view.layer.contents = backgroundImage
            self.view.layer.contentsGravity = .resizeAspectFill
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func fetchDoctorProfile() {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }
        FirebaseDatabaseService.fetchDoctor(by: currentUser) { [weak self] result in
            switch result {
            case .success(let doctor):
                print("Doctor fetched successfully: \(doctor)")
                // Xử lý dữ liệu doctor, ví dụ hiển thị giao diện
                Global.doctor = doctor
                Global.role = .doctor
                self?.doctorHomeTableView.reloadData()
            case .failure(let error):
                print("Failed to fetch doctor: \(error.localizedDescription)")
                
            }
        }
    }
    func setting() {
        view.backgroundColor = .clear
        print("setting")
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        DoctorHomeCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch DoctorHomeCellType.allCases[section] {
        case .doctorHome, .doctorHomeAction: 1
        default: customArticle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DoctorHomeCellType.returnValueFromInt(value: indexPath.section) {
        case .doctorHome:
            let cell = doctorHomeTableView.dequeue(cellType: DoctorHomeTableViewCell.self, for: indexPath)
            cell.parentViewController = self
            cell.doctorAvatarImageView.image = selectedImage
            cell.doctorAvatarImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
            cell.doctorAvatarImageView.addGestureRecognizer(tapGesture)
            cell.configureCell(avatarURL: Global.doctor?.avatar, name: "Dr. \(Global.doctor?.firstName ?? "") \(Global.doctor?.lastName ?? "") ")
            cell.backgroundColor = .clear
            return cell
            
        case .doctorHomeAction:
            let cell = doctorHomeTableView.dequeue(cellType: DoctorHomeActionTableViewCell.self, for: indexPath)
            cell.addBookedButtonTarget(target: self, action: #selector(bookedButtonTapped))
            cell.addAccountButtonTarget(target: self, action: #selector(accountButtonTapped))
            cell.addBoodedHistoryButtonTarget(target: self, action: #selector(hisotryTapped))
            cell.addBalanceButtonTarget(target: self, action: #selector(balanceButtonTapped))
            cell.clipsToBounds = true
            return cell
        case .doctorArticle:
            let cell = doctorHomeTableView.dequeue(cellType: ReuseArticleTableViewCell.self, for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(with: customArticle[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch DoctorHomeCellType.returnValueFromInt(value: indexPath.row) {
//        case .doctorHome:
//            return 250
//        case .doctorHomeAction:
//            return view.bounds.height / 5
//        case .doctorArticle:
//            return 700
//        }
        UITableView.automaticDimension
    }
    
    @objc private func accountButtonTapped() {
        GlobalService.shared.loadDoctorWithID(doctorID: Auth.auth().currentUser!.uid) { Result in
            let vc = DoctorProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.setupNavigationBar(with: "Tài khoản", with: false)
            
        }
        
    }
    @objc func didTapImageView() {

        // Sử dụng ImagePickerHelper
        imagePicker.present(for: .photoLibrary, title: "Photos")
    }
    @objc private func bookedButtonTapped() {
        let vc = BookedPatientListViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Các ca khám hiện có", with: false)
    }
    
    @objc private func hisotryTapped() {
        
        let vc = DoctorHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Lịch sử", with: false)
    }
    
    @objc private func balanceButtonTapped() {
        let vc = BalanceViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.setupNavigationBar(with: "Số dư", with: false)
    }
}


extension DoctorHomeViewController: ImagePickerDelegate {
    func didSelectFile(fileURL: URL, fileName: String) {
        
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.selectedImage = image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        Indicator.show()
        GlobalService.shared.uploadAvatar(imageData: imageData, typeOfAccount: Global.role.name) { [weak self] error in
            Indicator.hide()
            self?.fetchDoctorProfile()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let article = self.customArticle[indexPath.row]
            let vc = DetailWebViewController()
            vc.configure(with: article.link)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            print("ngu")
        }
    }
}
