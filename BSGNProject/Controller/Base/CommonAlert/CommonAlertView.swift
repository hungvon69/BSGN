//
//  CommonAlertView.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 26/12/24.
//

import UIKit

class CommonAlertView: BaseAlertView {
    
    static func present(_ model: Model,
                        _ confirm: EmptyClosure?,
                        cancel: EmptyClosure? = nil) {
        let vc = CommonAlertView(model: model)
        let topVC = UIApplication.getTopViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.confirm = confirm
        vc.cancel = cancel
        if let nav = topVC?.navigationController {
            nav.present(vc, animated: true)
        } else {
            topVC?.present(vc, animated: true)
        }
    }
    
    //MARK: - Components
    private lazy var stackView: UIStackView = {
        return UIStackView.build(axis: .vertical,
                                 distribution: .fill,
                                 alignment: .fill,
                                 spacing: 0,
                                 subViews: [subtitleLabel, noteLabel])
    }()
    
    private lazy var subtitleLabel: UILabel = {
        return UILabel.build(font: .systemFont(ofSize: 15, weight: .regular),
                             color: .white,
                             lines: 0,
                             alignment: .center)
    }()
    
    private lazy var noteLabel: UILabel = {
        return UILabel.build(font: .systemFont(ofSize: 15, weight: .regular),
                             color: .yellow,
                             lines: 0,
                             alignment: .center)
    }()
    
    //MARK: - Properties
    private var model: Model
    
    //MARK: - Init
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(stackView)
        setData()
    }
    
    private func setData() {
        subtitleLabel.text = model.subtitle
        noteLabel.text = model.note
        if model.note == nil || model.note == "" {
            noteLabel.isHidden = true
        }
        config(title: model.title,
               titleColor: .black,
               cancelTitle: model.cancelTitle,
               cancelColor: .black,
               canCancel: true,
               confirmTitle: model.doneTitle,
               confirmColor: .black,
               canConfirm: true,
               backgroundColor: mainColor.withAlphaComponent(0.7),
               cornerRadius: 24)
    }
}

extension CommonAlertView {
    struct Model {
        let title: String?
        let subtitle: String?
        let note: String?
        let cancelTitle: String?
        let doneTitle: String?
        init(title: String?,
             subtitle: String?,
             note: String? = nil,
             cancelTitle: String? = "Huỷ bỏ",
             doneTitle: String? = "Oke") {
            
            self.title = title
            self.subtitle = subtitle
            self.note = note
            self.cancelTitle = cancelTitle
            self.doneTitle = doneTitle
        }
    }
}
