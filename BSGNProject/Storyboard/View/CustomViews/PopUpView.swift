import UIKit
class PopUpView: UIView {

    // Callback closure để xử lý khi bấm nút Confirm
    var onConfirm: (() -> Void)?

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Thành công!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .systemGreen
        return imageView
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Xác nhận", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 10

        // Add subviews
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        self.addSubview(confirmButton)

        // Auto Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),

            confirmButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Button Action
    @objc private func didTapConfirm() {
        // Gọi callback khi bấm nút Confirm
        onConfirm?()
    }
}
