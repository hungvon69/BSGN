//
//  HomeViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

enum cellSeperate {
    case book
    case article
    case article2
    case article3
}

class HomeViewController: UIViewController {
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var nameAccLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var avatarButton: UIButton!
    @IBOutlet private var personalImageView: UIImageView!
    @IBOutlet private var homeTableView: UITableView!
    

    private var ids: [String] = GlobalService.shared.idArticle
    private var currentUser: Patient?
    private lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self.navigationController, delegate: self)
        return picker
    }()
    private var HomeCells: [cellSeperate] = [
        .book,
        .article,
        .article2,
        .article3
    ]

    var customArticle : [Article] = []
    private var articles1: [Article] = []
    private var articles2: [Article] = []
    private var articles3: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        for id in ids {
            GlobalService.shared.fetchArticlesFromFirebase(articleID: id) { result in
                switch result {
                case .success(let fetchedArticles):
                    if fetchedArticles.category == "Y tế Dự phòng" {
                        self.articles1.append(fetchedArticles)
                    } else if fetchedArticles.category == "Y tế Điều trị" {
                        self.articles2.append(fetchedArticles)
                    } else {
                        self.articles3.append(fetchedArticles)
                    }
                    self.homeTableView.reloadData() // Reload table view khi dữ liệu đã có
                case .failure(let error):
                    print("Error fetching articles: \(error.localizedDescription)") // Xử lý lỗi
                }
            }
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
    
    private func setupUI() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerNib(cellType: ArticleTableViewCell.self)
        homeTableView.registerNib(cellType: PromotionTableViewCell.self)
        homeTableView.registerNib(cellType: DoctorTableViewCell.self)
        homeTableView.registerNib(cellType: BookTableViewCell.self)
        homeTableView.layer.cornerRadius = 16
        nameAccLabel.build(font: .boldSystemFont(ofSize: 20), color: .white)
        upadteAvatar()
        fetchData()
    }
    
    private func fetchData() {
        if let userID = Auth.auth().currentUser?.uid {
            GlobalService.shared.fetchUserData(uid: userID, isDoctor: false) { [weak self] Result in
                guard let self else { return }
                switch Result {
                case .success(let user):
                    Global.patient = (user as! Patient)
                    self.currentUser = (user as! Patient)
                    self.nameAccLabel.text = "Xin chào, " + (self.currentUser?.getFullName() ?? "Bệnh nhân")
                    self.avatarImageView.load(url: self.currentUser?.avatar, placeholderImage: UIImage(systemName: "person"))
                    mainAsync {
                        self.homeTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    print("============================")
                }
            }
        }
    }
    
    

    func navigationArticleList(with articles: [Article]) {
        let newVC = ArticleListViewController(nibName: "ArticleListViewController", bundle: nil)
        newVC.configure(with: articles)
        self.navigationController?.pushViewController(newVC, animated: true)
        self.navigationController?.hidesBottomBarWhenPushed = true
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Tin tức", with: false)
    }
    func navigationPromotionList(with promotions: [Promotion]) {
        let newVC = PromotionListViewController(nibName: "PromotionListViewController", bundle: nil)
        newVC.configure(with: promotions)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Khuyến mãi", with: false)
    }
    func navigationDoctorList(with doctors: [Doctor]) {
        let newVC = DoctorListViewController(nibName: "DoctorListViewController", bundle: nil)
        newVC.configure(with: doctors)
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Bác sỹ", with: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let newHeight = max(50, 150 - offsetY)
        personalImageView.frame.size.height = newHeight
        personalImageView.frame.origin.y = 0
    }
    
    
    @IBAction func didTapInfo(_ sender: Any) {
        imagePicker.present(for: .photoLibrary, title: "Photos")
    }
    func upadteAvatar() {
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    func collectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: ArticleTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.customArticle[indexPath.row].link ?? "")
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Chi tiết Tin tức", with: true)
    }
    func promotionCollectionViewCellDidSelectItem(at indexPath: IndexPath, in cell: PromotionTableViewCell) {
        let newVC = DetailWebViewController(nibName: "DetailWebViewController", bundle: nil)
        newVC.configure(with: cell.homeData?.promotionList[indexPath.row].link ?? "")
        self.navigationController?.pushViewController(newVC, animated: true)
        newVC.tabBarController?.tabBar.isHidden = true
        newVC.setupNavigationBar(with: "Chi tiết Khuyến mãi", with: true)
    }
    @objc func didTapBook() {
        guard Global.patient?.isInAppointment == 0 else {
            ToastApp.show("Bạn đang trong cuộc hẹn, không thể đặt thêm!")
            return
        }
        let bookVC = PatientBookViewController(nibName: "PatientBookViewController", bundle: nil)
        self.navigationController?.pushViewController(bookVC, animated: true)
        bookVC.setupNavigationBar(with: "", with: false)
        bookVC.navigationController?.navigationBar.backgroundColor = .clear
        GlobalService.appointmentData["patientID"] = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference()
            .child("users")
            .child("patients")
            .child(Auth.auth().currentUser?.uid ?? "")
            .child("name")

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let firstName = snapshot.value as? String {
                GlobalService.appointmentData["patientName"] = firstName
                print("Patient name updated: \(firstName)")
            } else {
                print("Failed to retrieve patient's first name")
            }
        }
        
    }
}


extension HomeViewController: ImagePickerDelegate, UITableViewDelegate, UITableViewDataSource, ArticleTableViewCellDelegate {
    func didSelectFile(fileURL: URL, fileName: String) {
        
    }
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        avatarImageView.image = image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        Indicator.show()
        GlobalService.shared.uploadAvatar(imageData: imageData, typeOfAccount: Global.role.name) { [weak self] error in
            Indicator.hide()
            self?.fetchData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeCells[indexPath.row] {
            
        case .book:
            let cell = homeTableView.dequeue(cellType: BookTableViewCell.self, for: indexPath)
            cell.addTargetToBookingButton(target: self, action: #selector (didTapBook))
            return cell
            
        case .article:
            let cell = homeTableView.dequeue(cellType: ArticleTableViewCell.self, for: indexPath)
            cell.configure(with: articles1)
            cell.buttonAction = {
                [weak self] in
                let articles = self!.articles1
                self?.navigationArticleList(with: articles)
            }
            cell.setKindLabel(with: "Y tế Dự phòng")
            cell.delegate = self
            return cell
            
        case .article2:
            let cell = homeTableView.dequeue(cellType: ArticleTableViewCell.self, for: indexPath)
            cell.configure(with: articles2)
            cell.buttonAction = {
                [weak self] in
                let articles = self!.articles2
                self?.navigationArticleList(with: articles)
            }
            cell.setKindLabel(with: "Y tế Điều trị")
            cell.delegate = self
            return cell
        case .article3:
            let cell = homeTableView.dequeue(cellType: ArticleTableViewCell.self, for: indexPath)
            cell.configure(with: articles3)
            cell.buttonAction = {
                [weak self] in
                let articles = self!.articles3
                self?.navigationArticleList(with: articles)
            }
            cell.setKindLabel(with: "Y tế Hồi phục")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 243
        }
        else if indexPath.row == 1 || indexPath.row == 2 {
            return 268
        }
        else {
            return 155
        }
    }
}

