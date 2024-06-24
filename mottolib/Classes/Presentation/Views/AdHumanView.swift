//
//  AdHumanView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/17.
//

import UIKit
import SnapKit
import Then
import WebKit

class AdHumanView: AdBaseView {
    var launchHuman: Bool = false
    var browserType: Int = 1   
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startMission(startUrl: String) {
        launchHuman = true
        if joinMethod != 5 && detailUrls.count > 0 {
            let searchKeyword = detailUrls[0].replacingOccurrences(of: "+", with: " ")
            setClipboardData(text: searchKeyword)
        }
        
        let tmpUrl: String = startUrl.count > 0 ? startUrl : detailUrls[0]
        if browserType == 2 {
            openNaverApp(startUrl: tmpUrl)
        } else {
            openDefaultBrowser(startUrl: tmpUrl)
        }
    }
    
    func openDefaultBrowser(startUrl: String) {
        if let url = URL(string: startUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func openNaverApp(startUrl: String) {
        var encUrl = startUrl.replacingOccurrences(of: "&", with: "%26")
        encUrl = encUrl.replacingOccurrences(of: "/", with: "%2F")
        encUrl = encUrl.replacingOccurrences(of: ":", with: "%3A")
        encUrl = encUrl.replacingOccurrences(of: "\\?", with: "%3F")
        encUrl = encUrl.replacingOccurrences(of: "=", with: "%3D")
        encUrl = encUrl.replacingOccurrences(of: "#", with: "%23")
        
        let url = "naversearchapp://inappbrowser?url=" + encUrl + "&target=replace&version=6"
        
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
        } else {
            if let openStore = URL(string: "http://itunes.apple.com/kr/app/id393499958?mt=8"), UIApplication.shared.canOpenURL(openStore) {
                UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("/////////////////////////////////////////////////////////////////////")
        print("Human userContentController", message)
        print("??????????????????//")
        print("userContentController", message.body)
        print("userContentController", message.name)
        print("/////////////////////////////////////////////////////////////////////")
        // base. MMJS
        // crawling.MMCWJS
        // human. MMHTJS
        if message.name == "MMJS" {
            super.userContentController(userContentController, didReceive: message)
            return
        }
        if message.name == "MMHTJS", let messageBody = message.body as? [String: Any] {
            
            let messageString = String(describing: messageBody["message"] ?? "")
            let rBrowserType = String(describing: messageBody["browserType"] ?? "")
            let userAnswer = String(describing: messageBody["userAnswer"] ?? "")
            
            switch messageString {
            case "onGetClipboardData":
                if launchHuman {
//                    return UIPasteboard.general.string
                    guard let clipText = UIPasteboard.general.string else { return }
                    webView.evaluateJavaScript("javascript:showAnswerDialog('\(String(describing: clipText))');")
                }
                
            case "onAnswer":
                if  extraArgs.count > 0 {
                    // 공유를 통해 클립보드로 복사한 url을 입력하게 된다. 곧 현재 클립보드에 있는 값과 동일할 것.
                    var ans1: String = userAnswer.trimmingCharacters(in: .whitespaces)
                    var ans2: String = extraArgs[0].trimmingCharacters(in: .whitespaces)
                    if ans2.contains("http") {
                        ans2 = ans2.replacingOccurrences(of: "WWW.", with: "")
                    }
                    
                    ans1 = ans1.lowercased()
                    ans2 = ans2.lowercased()
                    
                    if ans1.contains(ans2) {
                        sendOkRequest()
                        return
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    let alert = UIAlertController(title: Title.wrongAnswer, message: Description.retryAnswer, preferredStyle: .alert)
                    let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                        self.parentVC?.dismiss(animated: false)
                    }
                    alert.addAction(yes)
                    self.parentVC?.present(alert, animated: true, completion: nil)
                }
                
            case "onSetBrowser":
                browserType = Int(rBrowserType) ?? 1
                
            default:
                break
            }
        }
    }
}

