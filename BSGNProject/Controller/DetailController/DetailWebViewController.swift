import UIKit
import WebKit

class DetailWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    private var urlPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Thiết lập delegate cho WebView
        webView.navigationDelegate = self
        self.navigationController?.navigationBar.isHidden = true
        // Thiết lập URL để tải trong WebView
        if let url = URL(string: urlPage ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    func configure(with url: String) {
        self.urlPage = url
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
