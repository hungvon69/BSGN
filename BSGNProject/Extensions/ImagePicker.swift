//
//  ImagePicker.swift
//  CAMELOT
//
//  Created by Ankush on 07/04/20.
//  Copyright © 2020 CAMELOT. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelectFile(fileURL: URL, fileName: String)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController?, delegate: ImagePickerDelegate, allowEdit:Bool = true) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowEdit
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(for type: UIImagePickerController.SourceType, title: String) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            ToastApp.show("Device no support type: \(type.rawValue)")
            return
        }
        self.pickerController.sourceType = type
        
        if type == .camera {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.presentationController?.present(self.pickerController, animated: true)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            self.presentationController?.present(self.pickerController, animated: true)
                        } else {
                            self.handleAccessDenied()
                        }
                    }
                })
            }
        } else {
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIButton) {
        DispatchQueue.main.async {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.openPopup(from: sourceView)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.openPopup(from: sourceView)
                    } else {
                        self.handleAccessDenied()
                    }
                })
            }
        }
    }
    
    private func handleAccessDenied() {
        DispatchQueue.main.async {
            CommonAlertView.present(.init(title: "Cảnh báo", subtitle: "Để chụp ảnh, bạn cần cấp quyền cho ứng dụng truy cập camera của thiết bị!", doneTitle: "Cài đặt")) {
                openSettings()
            }
        }
    }
    
    private func openPopup(from sourceView: UIButton) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if let action = self.action(for: .camera, title: "Camera") {
                action.setValue(UIColor.black, forKey: "titleTextColor")
                alertController.addAction(action)
            }
            if let action = self.action(for: .photoLibrary, title: "Photos") {
                action.setValue(UIColor.black, forKey: "titleTextColor")
                alertController.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
            }
            
            self.presentationController?.present(alertController, animated: true)
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.pickerController(picker, didSelect: image.resizeImage(targetSize: CGSize.init(width: 1000, height: 1000)))
        } else if let image = info[.editedImage] as? UIImage {
            self.pickerController(picker, didSelect: image)
        }
        
        if let imageURL = info[.imageURL] as? URL {
            let imageName = imageURL.lastPathComponent
            self.delegate?.didSelectFile(fileURL: imageURL, fileName: imageName)
        } else if let referenceURL = info[.mediaURL] as? URL {
            let imageName = referenceURL.lastPathComponent
            self.delegate?.didSelectFile(fileURL: referenceURL, fileName: imageName)
        }
        
        self.pickerController(picker, didSelect: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}


extension UIImage {

    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}


extension UIAlertController {

    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
