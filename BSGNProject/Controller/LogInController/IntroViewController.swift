//
//  IntroViewController.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var introCollectionView: UICollectionView!
    
    @IBOutlet private var signupbutton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var introPageControl: UIPageControl!
    
    var c = UIScreen.main.bounds.size.width + 40 + 156
    let introPages: [IntroPage] = [
         IntroPage(image: "Intro 1", qoute: "Bác sĩ sẵn lòng chăm sóc khi bạn cần", title: "Chọn chuyên khoa, bác sĩ phù hợp và được thăm khám trong không gian thoải mái tại nhà"),
         IntroPage(image: "Intro 2", qoute: "Bác sĩ sẵn lòng chăm sóc khi bạn cần", title: "Chọn chuyên khoa, bác sĩ phù hợp và được thăm khám trong không gian thoải mái tại nhà"),
         IntroPage(image: "Intro 3", qoute: "Bác sĩ sẵn lòng chăm sóc khi bạn cần", title: "Chọn chuyên khoa, bác sĩ phù hợp và được thăm khám trong không gian thoải mái tại nhà")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    private func setup() {
        loginButton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 14)
        signupbutton.titleLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 14)
        let backgroundImageView = UIImageView(image: UIImage(named: "introBackground"))
        backgroundImageView.contentMode = .scaleAspectFill
        introCollectionView.backgroundView = backgroundImageView
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
        introCollectionView.registerNib(cellType: IntroCollectionViewCell.self)
        introPageControl.numberOfPages = introPages.count
        introPageControl.currentPage = 0
        
        if let layout = introCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        introPageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            introPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introPageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.size.width + 156 + 20))
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }


    @IBAction func didTapLogin(_ sender: Any) {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    @IBAction func didTapRegister(_ sender: Any) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
}
extension IntroViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        introPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = introCollectionView.dequeue(cellType: IntroCollectionViewCell.self, for: indexPath)
        
        cell.configure(with: introPages[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = introCollectionView.frame.width
        let currentPage = scrollView.contentOffset.x / pageWidth
        var newPage = currentPage

        if velocity.x == 0 {
            newPage = round(currentPage)
        } else {
            newPage = velocity.x > 0 ? floor(currentPage + 1) : ceil(currentPage - 1)
        }

//        if newPage < 0 {
//            newPage = 0
//        }
//
//        if newPage >= CGFloat(introPages.count) {
//            newPage = CGFloat(introPages.count) - 1
//        }
        newPage = max(min(CGFloat(introPages.count - 1), newPage), 0)

        targetContentOffset.pointee.x = newPage * pageWidth
        introPageControl.currentPage = Int(newPage)
    }
}
/*
 
 dem Int
 5 100
 
 if dem < 5 dem =5
 ìf dem > 100 dem = 100
 //ạdsfkladjf
  dem = max(min(dem, 100),5)
 
 */
