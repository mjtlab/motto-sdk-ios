//
//  PrizeNumberViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit
import MottoFrameworks

class PrizeNumberViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

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
        Utils.consoleLog("ssss", Global.prizeNumberURL + Motto.pubkey + "&uid=\(Motto.uid)", true)
        loadWebView(wv: WebView, url: Motto.currentDomain + Global.prizeNumberURL + Motto.pubkey + "&uid=\(Motto.uid)")
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Utils.consoleLog(message.name, Global.prizeNumberURL + Motto.pubkey + "&uid=\(Motto.uid)", true)
        if message.name == "MLJS", let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            
            switch messageString {
            case "onAirLotto":
                if let url = URL(string: "https://m.imbc.com/vod/vodlist/1003945100000100000") {
                    UIApplication.shared.open(url, options: [:])
                }

            default:
                break
            }
        }
    }
}
