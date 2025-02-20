//
//  BaseAlertViewController.swift
//  AdmicroHybridEvent
//
//  Created by Khanh Vu on 26/12/24.
//

import UIKit

protocol CommonAlertable {
    func bind(_ content: UIView)
    var cancel: (() -> ())? { get set }
    var confirm: (() -> ())? { get set }
}

class BaseAlertView: UIViewController, CommonAlertable {
    // MARK: - Components
    private var blurView: UIVisualEffectView!
    private var borderView: UIView!
    private var containerView: UIView!
    private var containerStackView: UIStackView!
    private var contentView: UIView!
    private var subContentStackView: UIStackView!
    private var subContentView: UIView!
    private var bottomStackView: UIStackView!
    private var actionStackView: UIStackView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    private var titleLabel: UILabel!
    private var hLineView: UIView!
    private var vLineView: UIView!
    
    //MARK: - Properties
    private var cornerRadius: CGFloat = 24
    private var backgroundColor: UIColor? = .black.withAlphaComponent(0.7)
    private var lineColor: UIColor? = .white.withAlphaComponent(0.2)
    private var titleColor: UIColor? = .white
    private var cancelColor: UIColor? = .lightGray
    private var confirmColor: UIColor? = .white
    
    private var alertTitle: String?
    private var cancelTitle: String? = "Hủy bỏ"
    private var confirmTitle: String? = "Xác nhận"
    private var canCancel: Bool = true
    private var canConfirm: Bool = true
    
    var cancel: (() -> ())?
    var confirm: (() -> ())?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        configUI()
    }
    
    deinit {
        log("Deinit Alert!")
    }
    
    //MARK: - Public
    func bind(_ content: UIView) {
        subContentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func config(title: String?,
                titleColor: UIColor? = .white,
                cancelTitle: String? = "Hủy bỏ",
                cancelColor: UIColor? = .lightGray,
                canCancel: Bool = true,
                confirmTitle: String? = "Xác nhận",
                confirmColor: UIColor? = .white,
                canConfirm: Bool = true,
                backgroundColor: UIColor? = .black.withAlphaComponent(0.7),
                cornerRadius: CGFloat = 24) {
        
        self.titleColor = titleColor
        self.cancelTitle = cancelTitle
        self.cancelColor = cancelColor
        self.canCancel = canCancel
        self.confirmTitle = confirmTitle
        self.confirmColor = confirmColor
        self.canConfirm = canConfirm
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.alertTitle = title
        configUI()
    }
}

//MARK: - Private Method
private extension BaseAlertView {
    private func setUpUI() {
        let blurEffect = UIBlurEffect(style: .regular)

        blurView = UIVisualEffectView(effect: blurEffect)

        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel = UILabel()
        subContentView = UIView()
        
        subContentStackView = UIStackView.build(axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 20,
                                                subViews: [titleLabel, subContentView])
        
        contentView = UIView()
        contentView.addSubview(subContentStackView)
        
        
        /// Bottom Action
        hLineView = UIView()
        
        cancelButton = UIButton()
        confirmButton = UIButton()
        
        actionStackView = UIStackView.build(axis: .horizontal,
                                            distribution: .fill,
                                            alignment: .fill,
                                            spacing: 0,
                                            subViews: [cancelButton, hLineView, confirmButton])
        vLineView = UIView()
        bottomStackView = UIStackView.build(axis: .vertical,
                                            distribution: .fill,
                                            alignment: .fill,
                                            spacing: 0,
                                            subViews: [contentView, vLineView, actionStackView])
        
        
        /// container
        containerStackView = UIStackView.build(axis: .vertical,
                                               distribution: .fill,
                                               alignment: .fill,
                                               spacing: 0, subViews: [contentView, bottomStackView])
        
        containerView = UIView()
        containerView.addSubview(containerStackView)
        
        borderView = UIView()
        borderView.addSubview(containerView)
        view.addSubview(borderView)
        
        /// Layout
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subContentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        vLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(confirmButton.snp.width)
        }
        
        actionStackView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }

        hLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
//        titleLabel.snp.contentHuggingVerticalPriority = .greatestFiniteMagnitude
//        titleLabel.snp.contentCompressionResistanceVerticalPriority = .greatestFiniteMagnitude
    }
    
    private func configUI() {
        view.backgroundColor = .clear
        borderView.backgroundColor = .clear
        containerView.backgroundColor = backgroundColor
        contentView.backgroundColor = .clear
        subContentView.backgroundColor = .clear
        [vLineView, hLineView].forEach { sub in
            sub?.backgroundColor = lineColor
        }
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        titleLabel.build(font: .systemFont(ofSize: 21, weight: .bold), color: titleColor, lines: 1, alignment: .center)
        titleLabel.text = alertTitle
        
        cancelButton.build(font: .systemFont(ofSize: 16, weight: .semibold), title: cancelTitle, color: cancelColor)
        confirmButton.build(font: .systemFont(ofSize: 16, weight: .semibold), title: confirmTitle, color: confirmColor)
        cancelButton.isHidden = !canCancel
        confirmButton.isHidden = !canConfirm
        hLineView.isHidden = !canCancel || !canConfirm
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    @objc
    func cancelTapped() {
        dismiss(animated: true) { [weak self] in
            self?.cancel?()
        }
    }
    
    @objc
    func confirmTapped() {
        dismiss(animated: true) { [weak self] in
            self?.confirm?()
        }
    }
}
