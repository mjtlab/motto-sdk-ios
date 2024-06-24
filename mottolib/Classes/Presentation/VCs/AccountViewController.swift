//
//  AccountViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit

class AccountViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    private var WebView: WKWebView!
    // 접근경로. app(PATH), lib(SELF)
    var dataFromVC: String = "PATH"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: "MJJS")
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        WebView = WKWebView(frame: self.view.safeAreaLayoutGuide.layoutFrame, configuration: config)
        WebView.translatesAutoresizingMaskIntoConstraints = false
        WebView.scrollView.contentInsetAdjustmentBehavior = .never
        WebView.allowsBackForwardNavigationGestures = true
        WebView.uiDelegate = self
        WebView.navigationDelegate = self
        WebView.scrollView.bounces = false
        WebView.scrollView.alwaysBounceVertical = false
        WebView.scrollView.alwaysBounceHorizontal = false
        
        view.backgroundColor = .baseWhite
        let backButton = UIButton().then {
            $0.isHidden = true
            $0.backgroundColor = .white
            $0.titleLabel?.font = .systemFont(ofSize: 17)
            $0.setTitle(" < \(Navigation.home)", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.black, for: .highlighted)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.view.addSubviews(WebView, backButton)
        if dataFromVC == "SELF" {
            backButton.isHidden = false
        }
        
        WebView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        backButton.addTarget(self, action: #selector(setBackAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< \(Navigation.home)", style: .plain, target: self, action: #selector(setBackAction))
        Utils.consoleLog("Domains.loginURL + Motto.pubkey", Domains.loginURL + Motto.pubkey, true)
        loadWebView(wv: WebView, url: Domains.loginURL + Motto.pubkey)
    }
    
    @objc func setBackAction() {
        if WebView.canGoBack {
            self.WebView.goBack()
        } else {
            if self.dataFromVC == "PATH" {  // app
                navigationController?.popViewController(animated: true)
            } else {                        // lib
                dismiss(animated: true)
            }
        }
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: webview delegates
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 로그인, 가입
        if message.name == "MJJS", let messageBody = message.body as? [String: Any] {
            print("[MJJS] Received message from Web: \(messageBody)")
            
            let messageString = String(describing: messageBody["message"] ?? "")
            let uid = String(describing: messageBody["uid"] ?? "")
            let res = String(describing: messageBody["res"] ?? "")
            let msg = String(describing: messageBody["msg"] ?? "")
            let title = String(describing: messageBody["title"] ?? "")
            
            // 로그인. msg = onLoginResult. dict 형태로
            switch messageString {
            case "onLoginResult", "onJoinSuccess":
                if res == "-1" { // 실패
                    let data = String(describing: messageBody["data"] ?? "")
                    let alert = UIAlertController(title: messageString == "onLoginResult" ? Description.failLogin: Description.failJoin, message: data, preferredStyle: .alert)
                    let yes = UIAlertAction(title: "확인", style: .default) {_ in
                        print(data)
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    UserDefaults.standard.set(uid, forKey: "uid")
                    Motto.uid = uid
                    
//                    let alert = UIAlertController(title: Navigation.userjoin, message: Description.successJoin, preferredStyle: .alert)
//                    let yes = UIAlertAction(title: "Yes", style: .default) {_ in
                        // 메인으로 이동
                        NotificationCenter.default.post(name: .refresh, object: nil)
                        if self.dataFromVC == "PATH" {  // app
                            self.navigationController?.popViewController(animated: true)
                        } else {                        // lib
                            self.dataFromVC = "PATH"
                            self.dismiss(animated: true)
                        }
//                    }
//                    alert.addAction(yes)
//                    self.present(alert, animated: true, completion: nil)
                }
            case "onAlert":
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) {_ in
                    print(msg)
                }
                alert.addAction(yes)

                self.present(alert, animated: true, completion: nil)
            default:
                print(messageString)
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else { return }
        
        if (urlString.contains("join")) {
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.title = "< \(Navigation.userjoin)"
        } else if (urlString.contains("pf.kakao.com")) {
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.title = "< \(Navigation.contact)"
        } else {
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.title = "< \(Navigation.mottoInfo)"
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
    // 문의하기 카톡이동에서 사용할 수도 있다.
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url, // Navigation Action을 딥링크로 설정
//        url.scheme != "http" && url.scheme != "https" {
//            UIApplication.shared.open(url, options: [:], completionHandler:{ (success) in
//                if !(success){
//                    /* 앱이 설치되어 있지 않을 때
//                       카드/은행 앱의 scheme과  앱토어 주소를 알고 있는 경우,
//                       직접 앱스토어로 안내한다. */
//                    if let scheme = url.scheme,
//                        let appStoreURLString = Constant.appStoreURL[scheme],
//                        let appStoreURL = URL(string: appStoreURLString) {
//                            UIApplication.shared.open(appStoreURL)
//                        } else {
//                            // 스킴을 실행에 실패했거나, 앱을 안내할 수 없습니다.
//                        }
//                }
//            })
//            decisionHandler(.cancel) // 웹뷰에서 링크로 이동하지 않음
//        } else {
//            decisionHandler(.allow) // 웹뷰에서 링크로 이동
//        }
//    }
    
}
