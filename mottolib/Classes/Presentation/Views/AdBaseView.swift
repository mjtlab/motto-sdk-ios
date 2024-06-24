//
//  AdBaseView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit
import SnapKit
import Then
import Alamofire

class AdBaseView: UIView, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    // MARK: - property
    enum MissionPageTypes {
        case None
        case OurServer
        case GoogleSearch
        case NaverHome
        case NaverMap
        case NaverShopping
        case NaverLogin
        case PlaceBookmark
        case PlaceBlog
        case DBUrl1
        case DBUrl2
        case DBUrl3
        case DBUrl4
    }
    
    var parentVC: AdMissionViewController?
    var webView: WKWebView!
    var oldUrl: String = ""
    var adrole: Int = 0
    var pageFinishedTime: Double = 0
    var detailUrls: [String] = []
    var productKey: String = "";
    var extraArgs: [String] = []
    var joinMethod: Int = 0;
    var requestSend: Bool = false
    var currentUrl: String = ""
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: "MMJS")   // base
        contentController.add(self, name: "MMCWJS") // crawling
        contentController.add(self, name: "MMHTJS") // human
        contentController.add(self, name: "AppInterfaceIos") // Instagram
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        
        webView = WKWebView(frame: self.safeAreaLayoutGuide.layoutFrame, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // noti로 결과 호출
    func sendOkRequest() {
        let pcode = Motto.pcode
        
        let parameters = ["what": "ms_done", "pk": Motto.pubkey, "uid": Motto.uid, "pcode": pcode, "jmethod": String(joinMethod), "adid": Motto.adid, "ticket": Motto.ticket] as [String : Any]
        AF.request(
            Motto.currentDomain + Domains.msPath + "ms_done.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            self.requestSend = false
            LoadingIndicator.hideLoading()
            
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(ms_done.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(ms_done.php)")
                    
                    let alert = UIAlertController(title: Title.failTicket, message: afModel.message, preferredStyle: .alert)
                    let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                        self.parentVC?.dismiss(animated: true)
                    }
                    alert.addAction(yes)
                    self.parentVC?.present(alert, animated: true)
                } else {
                    guard let responseData = afModel.data else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.parentVC?.dismiss(animated: true)
                        NotificationCenter.default.post(name: .successfinish, object: responseData)
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(ms_done.php)", error)
                // 실패
                let alert = UIAlertController(title: Title.failTicket, message: afModel.message, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                    self.parentVC?.dismiss(animated: true)
                }
                alert.addAction(yes)
                self.parentVC?.present(alert, animated: true)
            }
        }
    }
    
    func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func extractKeywordFromUrl(url: String) -> String {
        let targetWord = "query="
        guard let subRange = url.range(of: targetWord) else { return "" }
        let endIdx = url[subRange].endIndex
        var searchKeyword: String = String(url[endIdx ..< url.endIndex])
        
        if searchKeyword.count > 0 {
            if searchKeyword.contains("&")  {
                searchKeyword = String(searchKeyword.prefix(upTo: searchKeyword.firstIndex(of: "&")!))
            }
            let frontWordDecode = searchKeyword.removingPercentEncoding
            let frontWordLower = frontWordDecode?.lowercased()

            return frontWordLower ?? ""
        }

        return ""
    }
    
    func getPageType(url: String) -> MissionPageTypes {
        if url.contains("bookmark") || url.contains("alarm") {
            let lastUrl: String = detailUrls[detailUrls.count - 1]
            if let pos = lastUrl.lastIndex(of: "/"), lastUrl.contains("/") {
                let placeId: String = String(lastUrl[pos..<lastUrl.endIndex])
                if (url.contains(placeId)) {
                    return MissionPageTypes.PlaceBookmark
                }
            }
        } else if url.contains(MLDefine.GoogleHomeUrl) {
            return MissionPageTypes.GoogleSearch
        } else if url == MLDefine.NaverHomeUrl {
            return MissionPageTypes.NaverHome
        } else if url == MLDefine.NaverMapUrl || url == MLDefine.NaverMapUrl2 {
            return MissionPageTypes.NaverMap
        } else if url.contains(MLDefine.NaverShoppingUrl) || url.contains(MLDefine.NaverShoppingUrl2) {
            return MissionPageTypes.NaverShopping
        } else if url.contains("OpenScrapForm") || url.contains("m.blog.naver.com/ScrapForm") {
            return MissionPageTypes.PlaceBlog
        } else if url.contains(MLDefine.NaverNidUrl) {
            return MissionPageTypes.NaverLogin
        } else if url.contains(Motto.currentDomain) {
            return MissionPageTypes.OurServer
        } else {
            for i in 0..<detailUrls.count {
                if url.contains(detailUrls[i]) || detailUrls[i].contains(url) {
                    switch i {
                    case 0:
                        return MissionPageTypes.DBUrl1
                    case 1:
                        return MissionPageTypes.DBUrl2
                    case 2:
                        return MissionPageTypes.DBUrl3
                    case 3:
                        return MissionPageTypes.DBUrl4
                    default:
                        return MissionPageTypes.DBUrl1
                    }
                }
            }
            
            if url.contains("query=") {
                let keyword1: String = searchKeywordWithoutSpace(url: url)
                if keyword1.count > 0 {
                    if url.contains("m.search.naver.com") {
                        let keyword2: String = searchKeywordWithoutSpace(url: detailUrls[0])
                        if keyword1 == keyword2 {
                            return MissionPageTypes.DBUrl1
                        }
                    } else {
                        if detailUrls.count >= 2 {
                            let keyword2: String = searchKeywordWithoutSpace(url: detailUrls[1])
                            if keyword1 == keyword2 {
                                return MissionPageTypes.DBUrl2
                            }
                        }
                    }
                }
            }
        }
        return MissionPageTypes.None
    }
    
    func searchKeywordWithoutSpace(url: String) -> String {
        var keyword: String = extractKeywordFromUrl(url: url)
        if keyword.count > 0 {
            keyword = keyword.replacingOccurrences(of: " ", with: "")
        }
        return keyword
    }
    
    func loadUrlWithDelay(url: String, delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if url.hasPrefix("javascript") {
                guard let urlDecode = url.removingPercentEncoding else { return }
                self.webView.evaluateJavaScript(urlDecode)
            } else {
                guard let urlDecode = url.removingPercentEncoding else { return }
                Utils.consoleLog("instagram ", urlDecode, true)
                guard let goUrl = URL(string: urlDecode) else { return }
                let request = URLRequest(url: goUrl)
                self.webView.load(request)
            }
        }
    }
    
    func goBack() -> Bool {
        if webView.canGoBack {
            self.webView.goBack()
            return true
        }
        return false
    }
    
    func setClipboardData(text: String) {
        let searchKeyword: String = extractKeywordFromUrl(url: text)
        if searchKeyword.count > 0 {
            UIPasteboard.general.string = searchKeyword
        }
    }
    
    func delayByPerformance() -> Int {
        let delay: Int = 3800
        
        return delay
    }
    
    func startMission(startUrl: String) {
        let url: String = startUrl.count > 0 ? startUrl : detailUrls[0]
        loadUrlWithDelay(url: url, delay: 30)
    }
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "MMJS", let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            let startUrl = String(describing: messageBody["startUrl"] ?? "")
            let args = String(describing: messageBody["args"] ?? "")
            let urls = String(describing: messageBody["urls"] ?? "")
            
            switch messageString {
            case "onParams":
                if urls.count > 0 {
                    detailUrls = urls.components(separatedBy: ",")
                }
                if args.count > 0 {
                    let arrArg: [String] = args.components(separatedBy: ",")
                    joinMethod = Int(arrArg[0]) ?? 0
                    productKey = arrArg[1]
                    extraArgs.removeAll()
                    if arrArg.count > 2 {
                        extraArgs.append(contentsOf: arrArg[2...])
                    }
                }
                
            case "onStartMission":
                startMission(startUrl: startUrl)
                
            case "onMoveInstagram":
                loadWebView(wv: webView, url: "https://www.instagram.com")
                
            default:
                break
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url: String = webView.url?.absoluteString else { return }
        if oldUrl == url {
            return
        }
        
        oldUrl = url
        // 현재 시간을 밀리세컨드로 받기
        let currentTime = Double(NSDate().timeIntervalSince1970 * 1000)
        let diff = currentTime - pageFinishedTime
        pageFinishedTime = currentTime
        
        let newUrl = url.replacingOccurrences(of: "%20", with: "")
        webPageFinished(url: newUrl, diff: Int(diff));
    }
    func webPageFinished(url: String, diff: Int) {}
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Dialog.cancel, style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: Dialog.ok, style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.parentVC?.present(alertController, animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        Utils.consoleLog("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        Utils.consoleLog("didStartProvisionalNavigation")
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
//        Utils.consoleLog("didFail")
    }
    
}
