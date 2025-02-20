//
//  ImagesPickerFormTableViewCell.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 8/10/24.
//

import UIKit
import Photos

class ImagesPickerFormTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet private weak var seperateView: UIView!
    @IBOutlet private weak var image2ImageView: UIImageView!
    @IBOutlet private weak var image1ImageView: UIImageView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!

    // Tạo một biến để lưu trữ UIViewController sẽ present UIImagePickerController
    var parentViewController: UIViewController?
    var selectedImageView: UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    private func setupUI() {
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(didTapOpen1(_:)))
        image1ImageView.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapOpen2(_:)))
        image2ImageView.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        parentViewController?.present(imagePicker, animated: true, completion: nil)
    }

    @objc func didTapOpen1(_ sender: Any) {
        self.selectedImageView = image1ImageView
        self.openGallery()
    }
    @objc func didTapOpen2(_ sender: Any) {
        self.selectedImageView = image2ImageView
        self.openGallery()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImageView?.image = image
        }
        parentViewController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parentViewController?.dismiss(animated: true, completion: nil)
    }
}
