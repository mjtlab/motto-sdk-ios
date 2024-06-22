//
//  HallOfFameViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit

class HallOfFameViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    private var WebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseWhite
        
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
        self.view.addSubview(WebView)
        
        WebView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        loadWebView(wv: WebView, url: Domains.hallURL + Motto.pubkey + "&uid=\(Motto.uid)")
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
}
