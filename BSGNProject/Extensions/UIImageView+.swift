//
//  UIImageView+.swift
//  BSGNProject
//
//  Created by Khanh Vu on 30/12/24.
//

import Foundation
import Nuke

extension UIImageView {
    func loadAvatar(url: String?, placeholderImage: UIImage? = UIImage(systemName: "person")?.withTintColor(.black)) {
        load(url: url, placeholderImage: placeholderImage)
    }
    
    func load(url: String?, placeholderImage: UIImage? = nil) {
        // Load image
        if let placeholderImage { image = placeholderImage }
        guard let url, let url = URL(string: url) else { return }
        ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            if case .success(let response) = result {
                self?.image = response.image
            }
        }
    }
    
    func load(url: String?, placeholderImage: String? = nil, completion: ((UIImage?) -> Void)?) {
        if let placeholderImage = UIImage(named: placeholderImage ?? "") {
            self.image = placeholderImage
        }
        guard let url, let url = URL(string: url) else { return }
        ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            if case .success(let response) = result {
                self?.image = response.image
                completion?(response.image)
            }
        }
    }
    
    func setTintColor(_ color: UIColor) {
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func resetTintColor() {
        self.image = image?.withRenderingMode(.alwaysOriginal)
    }
}
