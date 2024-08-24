//
//  AutoKeywordViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import MottoFrameworks

class AutoKeywordViewController: BaseCampaignViewController {
    
    let contentsView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var titleTopView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let frameView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: AutoKeywordViewController.self, img: "ic_arrow_left"), for: .normal)
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
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        
//        AdMissionVC = self
    }
    required init?(coder: NSCoder) { fatalError() }
    deinit {
//        trafficTimer?.invalidate()
//        issueTimer?.invalidate()
    }

    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(contentsView)
        contentsView.addSubview(bodyStackView)
        [titleTopView, frameView]
            .forEach(bodyStackView.addSubview(_:))
        titleTopView.addSubviews(
            backButton,
            titleLabel
        )
        frameView.addSubview(webView)
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
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = Motto.store
        // back action
        backButton.addTarget(self, action: #selector(baseBackAction), for: .touchUpInside)
        
        let urlString = Motto.currentDomain + Global.campaignURL + Global.AutoKeywordController + "?pk=" + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&campaignType=\(String(describing: Motto.adrole))&executionType=\(String(describing: Motto.jmethod))"
        Utils.consoleLog("urlString", urlString, true)
        loadWebView(wv: webView, url: urlString)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                          object: nil,
                                                          queue: .main) {
            [unowned self] notification in
            // background --> foreground
            Motto.currentSharedUrl = UIPasteboard.general.string ?? ""
            if Motto.currentSharedUrl.starts(with: "http") {
                Utils.consoleLog("Motto.currentSharedUrl", Motto.currentSharedUrl, true)
                if Motto.currentSharedUrl != "" {
                    webView.evaluateJavaScript("javascript:popupAnswerWithSharedText('\(String(describing: Motto.currentSharedUrl.removingPercentEncoding ?? ""))');")
                    
                    Motto.currentSharedUrl = ""
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 모든 옵저버 제거
//        NotificationCenter.default.removeObserver(self)
        // 특정 옵저버 제거
        //NotificationCenter.default.removeObserver(self, name: ClickNumberNotification, object: nil)
    }
}
