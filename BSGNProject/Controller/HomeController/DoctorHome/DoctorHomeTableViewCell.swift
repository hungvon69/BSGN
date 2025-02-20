//
//  DoctorHomeTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 22/10/24.
//

import UIKit

class DoctorHomeTableViewCell: UITableViewCell, SummaryMethod {

    @IBOutlet private weak var todayLabel: UILabel!
    @IBOutlet private weak var greetingDoctorLabel: UILabel!
    @IBOutlet weak var doctorAvatarImageView: UIImageView!
    
    var parentViewController: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        showCurrentDate()
    }
    func showCurrentDate() {
        // Lấy ngày hiện tại
        let currentDate = Date()
        
        // Định dạng ngày
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN") // Thiết lập ngôn ngữ tiếng Việt
        dateFormatter.dateFormat = "EEEE, dd/MM/yyyy" // Định dạng: Thứ, ngày/tháng/năm
        
        // Hiển thị ngày trên label
        let formattedDate = dateFormatter.string(from: currentDate)
        todayLabel.text = formattedDate.capitalized // Viết hoa chữ cái đầu
    }
    private func setupUI() {
        doctorAvatarImageView.layer.cornerRadius = 60
        doctorAvatarImageView.layer.borderColor = UIColor.black.cgColor
        doctorAvatarImageView.layer.borderWidth = 1
        doctorAvatarImageView.image = UIImage(named: "default_doctor")
    }


    func configureCell(avatarURL: String?, name: String?) {
        greetingDoctorLabel.text = name
        doctorAvatarImageView.load(url: avatarURL, placeholderImage: UIImage(named: "default_doctor"))
    }
    
    private func loadAvatarImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.doctorAvatarImageView.image = image
            }
        }.resume()
    }
    
}
