import UIKit
import WebKit

class DetailWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet private var detailNavigationBar: UINavigationBar!
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Thiết lập delegate cho WebView
        webView.navigationDelegate = self
        
        // Thiết lập URL để tải trong WebView
        if let url = URL(string: "https://viblo.asia/p/swiftui-huong-dan-su-dung-custom-font-trong-ung-dung-cua-ban-XL6lAQbglek") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Thiết lập Navigation Bar
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let navItem = UINavigationItem(title: "Chi tiết tin tức")
        
        let backButton = UIButton(type: .custom)
        backButton.setBackgroundImage(UIImage(named: "backleftButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 15
        backButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        backButton.layer.borderWidth = 1
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
        let shareButton = UIButton(type: .custom)
        shareButton.setBackgroundImage(UIImage(named: "shareButton")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .thin)), for: .normal)
        shareButton.tintColor = .black
        shareButton.backgroundColor = .white
        shareButton.layer.cornerRadius = 15
        shareButton.layer.borderColor = UIColor(red: 238/255, green: 239/255, blue: 244/255, alpha: 1).cgColor
        shareButton.layer.borderWidth = 1
        shareButton.clipsToBounds = true
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        shareButton.frame = CGRect(x: 0, y: 0, width: 32 , height: 32 )
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.leftBarButtonItem = backBarButtonItem
        let shareBarButtonItem = UIBarButtonItem(customView: shareButton)
        navItem.rightBarButtonItem = shareBarButtonItem
        detailNavigationBar.setItems([navItem], animated: false)
    }
    
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func shareButtonTapped() {
        let notificationWidth = self.view.frame.width / 2
        let notificationX = (self.view.frame.width - notificationWidth) / 2
        let notificationView = UIView(frame: CGRect(x: notificationX, y: -20, width: self.view.frame.width/2, height: 40))
            notificationView.backgroundColor = UIColor.white
//        notificationView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        notificationView.layer.shadowRadius = 20
//        notificationView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        notificationView.layer.shadowOpacity = 1
        notificationView.layer.cornerRadius = 20
        notificationView.layer.borderWidth = 0.5
        notificationView.layer.borderColor = UIColor.gray.cgColor
        let label = UILabel(frame: notificationView.bounds)
        label.text = "Đã sao chép URL"
        label.textAlignment = .center
        label.textColor = .black
        notificationView.addSubview(label)
        self.view.addSubview(notificationView)
        UIView.animate(withDuration: 0.5, animations: {
            notificationView.frame.origin.y = 40
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: [], animations: {
                notificationView.frame.origin.y = -20
            }) { _ in
                notificationView.removeFromSuperview()
            }
        }
    }
    func configure(with url: String) {
        self.url = url
    }
    // Delegate methods of WKWebView
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        print("Error loading page: \(error.localizedDescription)")
    }
}
