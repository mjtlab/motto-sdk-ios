//
//  BaseCampaignViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/14.
//

import UIKit
import WebKit
import Alamofire
import MottoFrameworks

class BaseCampaignViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    // MARK: - property
    
    // executionType = jmethod, campaignType = jtype
    var operationType: String = ""      //ctype: inapp A, B, human C, D, E
    var campaignAnswer: String = ""
    var browserOpenType: Int = 1
    var isOpenAnswerPage: Bool = false
    
    var adUrl = ""
    var adImage = ""
    
    var urlList: [String] = []
    var targetUrl = ""
    var scriptList: [String] = []
    var trafficDurations = 0
    var currentTrafficTime = 0
    
    var observer: NSObjectProtocol?
    
    let RESULT_UNKNOWN_ERROR = 0
    let RESULT_SITE_MORE_BUTTON_FOUND = 10
    let RESULT_SITE_MORE_BUTTON_NOT_FOUND = 11
    let RESULT_TARGET_SITE_FOUND = 20
    let RESULT_TARGET_SITE_NOT_FOUND = 21
    
    var webView: WKWebView!
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let source = """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
        """

        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: "CampaignInterfaceIos")
        contentController.add(self, name: "AppInterfaceIos")
        contentController.addUserScript(script)
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func sendOkRequest() {
        let parameters = ["what": Global.MissionComplete, "pk": Motto.pubkey, "uid": Motto.uid, "pcode": Motto.pcode, "jmethod": Motto.jmethod, "adid": Motto.adid, "ticket": Motto.ticket] as [String : Any]
        let path = Motto.currentDomain + Global.msPath + Global.MissionCompleteController
        AF.request(
            path,
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { [weak self] response in
            guard let self else { return }
            guard let afModel = response.value else { return }
            
            LoadingIndicator.hideLoading()
            
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(ms_done.php)", value, true)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(ms_done.php)")
                    
                    let alert = UIAlertController(title: Global.wrongProcess, message: afModel.message, preferredStyle: .alert)
                    let retryActon = UIAlertAction(title: Global.retry_, style: .default) {_ in
                        self.dismiss(animated: false) {
                            NotificationCenter.default.removeObserver(self)
                        }
                    }
                    let cancelAction = UIAlertAction(title: Global.cancel, style: .cancel) {_ in
                        self.dismiss(animated: false) {
                            NotificationCenter.default.removeObserver(self)
                        }
                    }
                    alert.addAction(retryActon)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false)
                } else {
                    guard let responseData = afModel.data else { return }
                    self.successfinish(responseData: responseData)
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(ms_done.php)", error)
                // 실패
                let alert = UIAlertController(title: Global.wrongProcess, message: afModel.message, preferredStyle: .alert)
                let retryActon = UIAlertAction(title: Global.retry_, style: .default) {_ in
                    self.dismiss(animated: false) {
                        NotificationCenter.default.removeObserver(self)
                    }
                }
                let cancelAction = UIAlertAction(title: Global.cancel, style: .cancel) {_ in
                    self.dismiss(animated: false) {
                        NotificationCenter.default.removeObserver(self)
                    }
                }
                alert.addAction(retryActon)
                alert.addAction(cancelAction)
                self.present(alert, animated: false)
            }
        }
    }
    
    
    func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func startMission(startUrl: String) {
        switch browserOpenType {
        case 2:
            openNaverApp(startUrl: startUrl)
        default:
            openDefaultBrowser(startUrl: startUrl)
        }
    }
    func openDefaultBrowser(startUrl: String) {
        if let url = URL(string: startUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            Utils.consoleLog("startUrl", url, true)
            UIApplication.shared.open(url, options: [:])
        }
    }
    func openNaverApp(startUrl: String) {
        var encUrl = startUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        encUrl = encUrl.replacingOccurrences(of: "&", with: "%26")
        encUrl = encUrl.replacingOccurrences(of: "/", with: "%2F")
        encUrl = encUrl.replacingOccurrences(of: ":", with: "%3A")
        encUrl = encUrl.replacingOccurrences(of: "?", with: "%3F")
        encUrl = encUrl.replacingOccurrences(of: "=", with: "%3D")
        encUrl = encUrl.replacingOccurrences(of: "#", with: "%23")
        
        let url = "naversearchapp://inappbrowser?url=" + encUrl + "&target=new&version=6"
//        Utils.consoleLog("ddd", url, true)
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
        } else {
            if let openStore = URL(string: "http://itunes.apple.com/kr/app/id393499958?mt=8"), UIApplication.shared.canOpenURL(openStore) {
                UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
            }
        }
    }
    func openAnswerPage(answerUrl: String) {
        if isOpenAnswerPage && answerUrl.count == 0 {
            DispatchQueue.main.async {
                self.openDefaultBrowser(startUrl: answerUrl)
            }
        }
    }
    func showWrongAnswerPopup() {
        let alert = UIAlertController(title: Global.wrongAnswer, message: Global.retryAnswer, preferredStyle: .alert)
        let yes = UIAlertAction(title: Global.retry, style: .default) {_ in
            self.dismiss(animated: false) {
                NotificationCenter.default.removeObserver(self)
            }
        }
        alert.addAction(yes)
        self.present(alert, animated: false)
    }
    func showFailFinishPopup() {
        let alert = UIAlertController(title: Global.failMission, message: Global.finishMission, preferredStyle: .alert)
        let yes = UIAlertAction(title: Global.ok, style: .destructive) {_ in
            self.dismiss(animated: false) {
                NotificationCenter.default.removeObserver(self)
            }
        }
        alert.addAction(yes)
        
        self.present(alert, animated: true, completion: nil)
    }
    func showFailGoPreviousPopup() {
        let alert = UIAlertController(title: Global.failMission, message: Global.failedMission, preferredStyle: .alert)
        let yes = UIAlertAction(title: Global.retry_, style: .destructive) {_ in
            self.dismiss(animated: false) {
                NotificationCenter.default.removeObserver(self)
            }
        }
        let no = UIAlertAction(title: Global.cancel, style: .cancel) {_ in
            self.baseBackAction()
        }
        alert.addAction(no)
        alert.addAction(yes)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func baseBackAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: false) {
                NotificationCenter.default.removeObserver(self)
            }
//            presentingViewController!.dismiss(animated: false)
        }
    }
    
    func onPageStarted(url: String) { }
    func onPageFinished(url: String) { }
    

    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if (message.name == "AppInterfaceIos" || message.name == "CampaignInterfaceIos"),
           let messageBody = message.body as? [String: Any]
        {
            let messageString = String(describing: messageBody["message"] ?? "")
            let startUrl = String(describing: messageBody["startUrl"] ?? "")
//            let args = String(describing: messageBody["args"] ?? "")
//            let urls = String(describing: messageBody["urls"] ?? "")
            let answer = String(describing: messageBody["answer"] ?? "")
            let browserType = String(describing: messageBody["browserType"] ?? "")
            let openAnswerPage = String(describing: messageBody["openAnswerPage"] ?? "0")
            let userAnswer = String(describing: messageBody["userAnswer"] ?? "")
            
            // sitetrafficinapp
            let urlListString = String(describing: messageBody["urlListString"] ?? "")
            let targetUrlString = String(describing: messageBody["extraTargetUrl"] ?? "")
            let trafficTime = String(describing: messageBody["trafficTime"] ?? "")
            let script1 = String(describing: messageBody["script1"] ?? "")
            let script2 = String(describing: messageBody["script2"] ?? "")
            let script3 = String(describing: messageBody["script3"] ?? "")
            let script4 = String(describing: messageBody["script4"] ?? "")
            let script5 = String(describing: messageBody["script5"] ?? "")
            let script6 = String(describing: messageBody["script6"] ?? "")
            let param = String(describing: messageBody["param"] ?? "0")
            
            // AdCpc
            let adTitle = String(describing: messageBody["adTitle"] ?? "0")
            let url = String(describing: messageBody["url"] ?? "0")
            let image = String(describing: messageBody["image"] ?? "0")
            let time = String(describing: messageBody["time"] ?? "0")
            
            
            // NEW
            let data = String(describing: messageBody["data"] ?? "")
            
            switch messageString {
            case "onMissionSuccess":
                self.successfinish(responseData: data)
            case "onSetCampaignData":
//                Utils.consoleLog("onSetCampaignData answer", answer, true)
//                Utils.consoleLog("onSetCampaignData browserType", browserType, true)
//                Utils.consoleLog("onSetCampaignData openAnswerPage", openAnswerPage, true)
//                Utils.consoleLog("onSetCampaignData urlListString", urlListString, true)
//                Utils.consoleLog("onSetCampaignData targetUrlString", targetUrlString, true)
//                Utils.consoleLog("onSetCampaignData trafficTime", trafficTime, true)
                
                self.campaignAnswer = answer.removingPercentEncoding ?? "" // 한글
                self.browserOpenType = Int(browserType) ?? 1
                self.isOpenAnswerPage = Int(openAnswerPage)! > 0
                
                //=== case: SiteTrafficInapp
                if urlListString.count > 0 {
                    self.urlList = urlListString.components(separatedBy: ",")
                    targetUrl = targetUrlString
                    Utils.consoleLog("targetUrl", targetUrl, true)
                    trafficDurations = Int(trafficTime) ?? 10
                    Utils.consoleLog("trafficDurations", trafficDurations, true)
                }
                //=== case: SiteTrafficInapp
                //=== case: AdCpc
                adUrl = url
                adImage = image
                //=== case: AdCpc
            case "onGetClipboardData":
                guard let clipText = UIPasteboard.general.string else { return }
                Utils.consoleLog("onGetClipboardData clipText", clipText, true)
                webView.evaluateJavaScript("javascript:showAnswerDialog('\(String(describing: clipText))');")
            case "onAnswer":
                Utils.consoleLog("answer 1 decoding", userAnswer.removingPercentEncoding!, true)
                Utils.consoleLog("answer 2 decoding", campaignAnswer, true)
                
                if self.campaignAnswer.count > 0 && userAnswer.count > 0 {
                    // 사용자 대답은 새로 넘어온 값이기 때문에 먼저 decoding.
                    var answer1 = userAnswer.removingPercentEncoding!.trimmingCharacters(in: .whitespaces).lowercased()
                    var answer2 = campaignAnswer.trimmingCharacters(in: .whitespaces).lowercased()
                    var answer3 = answer1.replacingOccurrences(of: "http", with: "https")
                    if answer2.hasSuffix("/") && !answer3.hasSuffix("/") {
                        answer3 = answer3 + "/"
                    }

                    if answer1.contains("http") {
                        answer1 = answer1.replacingOccurrences(of: "www.", with: "")
                    }
                    if answer2.contains("http") {
                        answer2 = answer2.replacingOccurrences(of: "www.", with: "")
                    }
                    if answer3.contains("http") {
                        answer3 = answer3.replacingOccurrences(of: "www.", with: "")
                    }

                    if answer1.contains(answer2) {
                        self.openAnswerPage(answerUrl: campaignAnswer)
                        sendOkRequest()
                    } else {
                        if answer3.contains(answer2) {
                            self.openAnswerPage(answerUrl: campaignAnswer)
                            sendOkRequest()
                        } else {
                            showWrongAnswerPopup()
                        }
                    }
                }
            case "onStartMission":
                Utils.consoleLog("onStartMission", true)
                let url = startUrl.contains("https") ? startUrl : "https://\(startUrl)"
                startMission(startUrl: url.removingPercentEncoding ?? "")
            case "onSetScripts":
                Utils.consoleLog("onSetScripts script1", script1, true)
                Utils.consoleLog("onSetScripts script2", script2, true)
                Utils.consoleLog("onSetScripts script3", script3, true)
                Utils.consoleLog("onSetScripts script4", script4, true)
                Utils.consoleLog("onSetScripts script5", script5, true)
                Utils.consoleLog("onSetScripts script6", script6, true)
                if script1.count > 0 {
                    scriptList.append(script1)
                }
                if script2.count > 0 {
                    scriptList.append(script2)
                }
                if script3.count > 0 {
                    scriptList.append(script3)
                }
                if script4.count > 0 {
                    scriptList.append(script4)
                }
                if script5.count > 0 {
                    scriptList.append(script5)
                }
                if script6.count > 0 {
                    scriptList.append(script6)
                }
            case "onScriptResult":
                Utils.consoleLog("onScriptResult param", param, true)
                switch Int(param) {
                case RESULT_TARGET_SITE_FOUND, RESULT_SITE_MORE_BUTTON_FOUND:
                    break
                case RESULT_SITE_MORE_BUTTON_NOT_FOUND, RESULT_TARGET_SITE_NOT_FOUND:
                    showFailFinishPopup()
                default:
                    showFailGoPreviousPopup()
                }
                
                LoadingIndicator.hideLoading()
            case "onStart":
                Utils.consoleLog("onStart adTitle", adTitle, true)
                Utils.consoleLog("onStart url", url, true)
                Utils.consoleLog("onStart image", image, true)
                Utils.consoleLog("onStart time", time, true)
                
                adUrl = url
                adImage = image
            default:
                break
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let _: String = webView.url?.absoluteString else { return }

    }
    func webPageFinished(url: String, diff: Int) {
        guard let _: String = webView.url?.absoluteString else { return }
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Global.cancel, style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: Global.ok, style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        Utils.consoleLog("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        Utils.consoleLog("didStartProvisionalNavigation")
        guard let url: String = webView.url?.absoluteString else { return }
        onPageStarted(url: url)
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        Utils.consoleLog("didCommit")
        guard let url: String = webView.url?.absoluteString else { return }
        onPageFinished(url: url)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        Utils.consoleLog("decidePolicyFor navigationAction")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        Utils.consoleLog("decidePolicyFor navigationResponse")
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        Utils.consoleLog("createWebViewWith")
        let request = URLRequest(url: navigationAction.request.url!)
        webView.load(request)
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url: String = webView.url?.absoluteString else { return }
        Utils.consoleLog("didFail", url, true)
    }
}

extension BaseCampaignViewController {
    private func successfinish(responseData: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 이전 VC로 결과 전달. 결과 데이터가 변경된듯.
            Utils.consoleLog("Network responseData", responseData)
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: .successfinish, object: responseData)
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
}
