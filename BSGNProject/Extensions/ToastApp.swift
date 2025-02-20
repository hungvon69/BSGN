//
//  Toast+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit
import ToastViewSwift

final class ToastApp {
    
    private init() {
    }
    
    static var toastDuration: TimeInterval = 3.0
    static var configBottom = ToastConfiguration(
        direction: .bottom,
        dismissBy: [.time(time: toastDuration), .swipe(direction: .natural), .longPress],
        animationTime: 0.2,
        enteringAnimation: .fade(alpha: 0.5),
        exitingAnimation: .default,
        allowToastOverlap: false
    )
    
    static var configTop = ToastConfiguration(
        direction: .top,
        dismissBy: [.time(time: toastDuration), .swipe(direction: .natural), .longPress],
        animationTime: 0.2,
        enteringAnimation: .fade(alpha: 0.5),
        exitingAnimation: .default,
        allowToastOverlap: false
    )

    static func show(_ message: String?,
                     title: String = "" ,
                     image: UIImage? = nil,
                     direction: Toast.Direction = .top) {
        guard message != "", message != nil else {
            return
        }
        let config = direction == .bottom ? configBottom : configTop
        var bgrNoti = UIColor.black
        var viewConfig = ToastViewConfiguration(darkBackgroundColor: bgrNoti,
                                                       lightBackgroundColor: bgrNoti,
                                                       titleNumberOfLines: 0,
                                                       subtitleNumberOfLines: 0)
        
        if let image = image {
            let toast = Toast.default(image: image,
                                      title: title,
                                      subtitle: message,
                                      viewConfig: viewConfig,
                                      config: config)
            toast.show()
            return
        }
        
        guard let message = message else {
            return
        }
        
        // Tạo style để căn giữa
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center // Căn giữa text
        
        // Thuộc tính của chuỗi
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle // Áp dụng style
        ]
        
        let attributedString = NSMutableAttributedString(string: message, attributes: attributes)
        
        
        let toast = Toast.text(attributedString,
                               viewConfig: viewConfig,
                               config: config)
        toast.show()
    }
}
