//
//  UView+.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 23/9/24.
//

import Foundation
import UIKit

extension UIView {
    
    /// Adds a custom background blur effect with a specific radius
        /// - Parameters:
        ///   - blurRadius: The intensity of the blur (e.g., 4.0 for Figma-like blur).
    func addCustomBackgroundBlur(blurRadius: CGFloat = 4.0) {
        // Remove any existing blur effects
        self.subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        
        // Create a UIView to hold the blur effect
        let blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = self.layer.cornerRadius
        blurView.clipsToBounds = true
        self.insertSubview(blurView, at: 0)
        
        // Set up constraints for the blur view
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // Apply a blur filter using CIFilter
        let context = CIContext()

        let inputImage = CIImage(image: UIImage())
        
        if let inputImage = inputImage {
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            blurFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
            
            if let outputImage = blurFilter?.outputImage {
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let blurredImage = UIImage(cgImage: cgImage)
                    blurView.backgroundColor = UIColor(patternImage: blurredImage)
                }
            }
        }
    }
                
                                     
    
    func round() {
        layer.cornerRadius = frame.height / 2.0
    }
    
    func setCornerRadius(_ radius: CGFloat, corners: CACornerMask) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}

//MARK: - IBInspectable
extension UIView {
    @IBInspectable
    var _cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var _borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var _borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var _shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var _shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var _shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var _shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
