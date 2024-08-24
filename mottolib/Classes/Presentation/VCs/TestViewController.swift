//
//  TestViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit
import MottoFrameworks

class TestViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    private var missionData: MissionData?
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
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: TestViewController.self, img: "ic_arrow_left"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.text = "미션"
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseWhite
        view.addSubview(contentsView)
        contentsView.addSubview(bodyStackView)
        [titleTopView, frameView]
            .forEach(bodyStackView.addArrangedSubview(_:))
//        bodyStackView.addSubviews(
//            titleTopView,
//            frameView
//        )
        titleTopView.addSubviews(
            backButton,
            titleLabel
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
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            make.height.equalTo(40)
        }

        let contentController = WKUserContentController()
        contentController.add(self, name: "CampaignInterfaceIos")
        contentController.add(self, name: "AppInterfaceIos")
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.userContentController = contentController
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        WebView = WKWebView(frame: self.view.safeAreaLayoutGuide.layoutFrame, configuration: config)
        WebView.translatesAutoresizingMaskIntoConstraints = false
        frameView.addSubview(WebView)
        
        WebView.scrollView.contentInsetAdjustmentBehavior = .never
        WebView.allowsBackForwardNavigationGestures = true
        WebView.uiDelegate = self
        WebView.navigationDelegate = self
        
        WebView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        // back action
        backButton.addTarget(self, action: #selector(setBackAction), for: .touchUpInside)
        
        loadWebView(wv: WebView, url: Global.debugURL + Global.TestViewController + "?pk=" + Motto.pubkey + "&uid=\(Motto.uid)")
        Utils.consoleLog(Global.debugURL + "/pages/campaign/view/campaign_list_for_test.html?pk=" + Motto.pubkey + "&uid=\(Motto.uid)")
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(sendResult), name: .sendResult, object: nil)
    }
    
//    @objc func sendResult(_ notification: Notification) {
//        // 미션 홈 화면으로 다시 데이터 전달
//        Utils.consoleLog("notification.object", notification.object ?? "", true)
//        NotificationCenter.default.post(name: .successfinish, object: notification.object)
//        
//        self.dismiss(animated: false) {
//            NotificationCenter.default.removeObserver(self)
//        }
//    }
    
    @objc func setBackAction() {
        self.dismiss(animated: false) {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Utils.consoleLog("message.name", message.name)
        Utils.consoleLog("message.body", message.body)
        if (message.name == "AppInterfaceIos" || message.name == "CampaignInterfaceIos"), let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            let data = String(describing: messageBody["data"] ?? "")
            
            switch messageString {
            case "onStart":
                let missiondata = data.components(separatedBy: ",")
                self.missionData = MissionData(ticket: Int(missiondata[0])!, pcode: missiondata[1], store: missiondata[2], adrole: Int(missiondata[3])!, jmethod: Int(missiondata[4])!)
                
                self.goMission()
            default:
                break
            }
        }
    }
    
    func goMission() {
        let viewcontroller = AdMissionViewController()
        viewcontroller.ms_data = missionData
        viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: false) {
            NotificationCenter.default.removeObserver(self)
            pvc.present(viewcontroller, animated: false, completion: nil)
        }
    }
}
