//
//  CancellableAlertView.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 26/12/24.
//

import UIKit

class CancellableAlertView: BaseAlertView {
    static func present(_ model: Model,
                        _ cancel: (() -> Void)? = nil) {
        let vc = CancellableAlertView(model: model)
        let topVC = UIApplication.getTopViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.cancel = cancel
        if let nav = topVC?.navigationController {
            nav.present(vc, animated: true)
        } else {
            topVC?.present(vc, animated: true)
        }
    }
    private var model: Model
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(model.content)
        setData()
    }
    
    private func setData() {
        config(title: model.title,
               titleColor: .black,
               cancelTitle: model.cancelTitle,
               cancelColor: model.cancelColor,
               canCancel: true,
               confirmTitle: nil,
               confirmColor: nil,
               canConfirm: false,
               backgroundColor: mainColor.withAlphaComponent(0.7),
               cornerRadius: 24)
    }
    
    struct Model {
        let title: String?
        let content: UIView
        let cancelTitle: String?
        let cancelColor: UIColor?
    }
}
