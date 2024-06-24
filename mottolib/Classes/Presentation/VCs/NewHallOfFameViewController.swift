//
//  NewHallOfFameViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import WebKit

class NewHallOfFameViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    private var WebView: WKWebView!
    
    let contentsView = UIView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var titleTopView = UIView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let frameView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: NewHallOfFameViewController.self, img: "icon_close"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.text = "명예의 전당"
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseWhite
        view.addSubviews(contentsView)
        contentsView.addSubview(bodyStackView)
        bodyStackView.addSubviews(
            titleTopView,
            frameView
        )
        titleTopView.addSubviews(
            titleLabel,
            backButton
        )
        contentsView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        bodyStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.top.bottom.left.right.equalToSuperview()
        }
        titleTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        frameView.snp.makeConstraints { make in
            make.top.equalTo(titleTopView.snp.bottom)
            make.left.equalTo(contentsView.snp.left)
            make.right.equalTo(contentsView.snp.right)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            make.height.equalTo(40)
        }
        
        // back action
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: "MLJS")
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        WebView = WKWebView(frame: self.view.safeAreaLayoutGuide.layoutFrame, configuration: config)
        WebView.translatesAutoresizingMaskIntoConstraints = false
        WebView.scrollView.contentInsetAdjustmentBehavior = .never
        WebView.uiDelegate = self
        WebView.navigationDelegate = self
        
        frameView.addSubview(WebView)
        
        loadWebView(wv: WebView, url: Domains.hallURL)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "MLJS", let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            
            switch messageString {
            case "onOpenChat":
                if let url = URL(string: "https://pf.kakao.com/_ScyMG/chat") {
                    UIApplication.shared.open(url, options: [:])
                }

            default:
                break
            }
        }
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func dismissVC() {
        dismiss(animated: false)
    }
}
