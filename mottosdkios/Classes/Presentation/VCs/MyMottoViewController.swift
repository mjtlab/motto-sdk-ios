//
//  MyMottoViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit

class MyMottoViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate {

    private var WebView: WKWebView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 모든 옵저버 제거
//        NotificationCenter.default.removeObserver(self)
        // 특정 옵저버 제거
        //NotificationCenter.default.removeObserver(self, name: ClickNumberNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // noti observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(mainRefresh), name: .mymotto, object: nil)

        view.backgroundColor = .baseWhite

        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        WebView = WKWebView(frame: self.view.safeAreaLayoutGuide.layoutFrame, configuration: config)
        WebView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(WebView)
        
        WebView.scrollView.contentInsetAdjustmentBehavior = .never
        WebView.allowsBackForwardNavigationGestures = true
        WebView.uiDelegate = self
        WebView.navigationDelegate = self
        
        WebView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        loadWebView(wv: WebView, url: Domains.myMottoURL + Motto.pubkey + "&uid=\(Motto.uid)")
    }
    
    @objc func mainRefresh() {
        WebView.reload()
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
