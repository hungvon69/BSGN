//
//  DoctorTableViewCell.swift
//  BSGNProject
//
//  Created by Linh Thai on 21/08/2024.
//

import UIKit

class DoctorTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SummaryMethod {

    @IBOutlet var seeAllButton: UIButton!
    @IBOutlet var kindOfNameLabel: UILabel!
    @IBOutlet var doctorCollectionView: UICollectionView!
    var doctors = [Doctor]()
    var homeData: HomeData?
    var doctorViewModel: DoctorViewModel?
    let home = HomeService()
    var numberOfDoctor = 0
    var buttonAction: (() -> Void)?
    static let identifier = "DoctorTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DoctorTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorCollectionView.delegate = self
        doctorCollectionView.dataSource = self
        doctorCollectionView.registerNib(cellType: DoctorCollectionViewCell.self)
        kindOfNameLabel.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        seeAllButton.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 13)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        doctorCollectionView.collectionViewLayout = layout
        NewsService.fetchNews{ result in
            switch result {
            case .success(let data):
                self.doctors = data.doctorList
                if self.doctorViewModel == nil {
                    self.doctorViewModel = DoctorViewModel()
                }
                self.homeData = data
                self.doctorViewModel?.doctors = data.doctorList
                print(data.doctorList)
                self.numberOfDoctor = data.doctorList.count
                print(self.doctors)
                self.updateUI()
            case .failure(let error):
                print("000000000000000000000000\(error)")
            }
        }
    }

    func updateUI() {
        // Kiểm tra nếu mảng articles có dữ liệu
        if !self.doctors.isEmpty {
            print(self.doctors[0])
        }
        self.doctorCollectionView.reloadData()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDoctor
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 16, height: contentView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = doctorCollectionView.dequeue(cellType: DoctorCollectionViewCell.self, for: indexPath)
        if let doctor = doctorViewModel?.doctors[indexPath.row] {
            cell.configure(with: doctor)
        }
        
       applyShadow(to: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 121, height: 185)
    }

    @IBAction func didTapSeeAll(_ sender: Any) {
        buttonAction?()
    }
    
}
