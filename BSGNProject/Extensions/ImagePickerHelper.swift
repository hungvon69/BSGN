import UIKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imageView: UIImageView?
    private weak var viewController: UIViewController?
    private var completion: ((UIImage) -> Void)?
    
    init(for imageView: UIImageView, in viewController: UIViewController, completion: @escaping (UIImage) -> Void) {
        self.imageView = imageView
        self.viewController = viewController
        self.completion = completion
    }
    
    func pickImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        viewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            completion?(selectedImage)
        } else if let selectedImage = info[.originalImage] as? UIImage {
            completion?(selectedImage)
        }
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
