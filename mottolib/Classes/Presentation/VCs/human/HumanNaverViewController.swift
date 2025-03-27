//
//  HumanNaverViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
//import MottoFrameworks

class HumanNaverViewController: BaseCampaignViewController {
    
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
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: HumanNaverViewController.self, img: "ic_arrow_left"), for: .normal)
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
        Utils.consoleLog("VC deinit", "HumanNaverViewController")
    }

    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(contentsView)
        contentsView.addSubview(bodyStackView)
        [titleTopView, frameView]
            .forEach(bodyStackView.addSubview(_:))
        frameView.addSubview(webView)
        titleTopView.addSubviews(
            backButton,
            titleLabel
        )
        contentsView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        bodyStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        frameView.snp.makeConstraints { make in
            make.top.equalTo(titleTopView.snp.bottom)
            make.left.equalTo(bodyStackView.snp.left)
            make.right.equalTo(bodyStackView.snp.right)
            make.bottom.equalTo(bodyStackView.snp.bottom)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        webView.backgroundColor = .clear
        titleLabel.text = Motto.store
        // back action
        backButton.addTarget(self, action: #selector(baseBackAction), for: .touchUpInside)

        let urlString = Motto.humanCampaignUrl + "?pub_key=" + Motto.pubkey + "&user_id=" + Motto.uid + "&campaign_code=" + Motto.pcode + "&campaign_type=" + "\(Motto.adrole)"
        Utils.consoleLog("휴먼 캠페인 URL", urlString, true)
        
        loadWebView(wv: webView, url: urlString)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                          object: nil,
                                                          queue: .main) {
            [unowned self] notification in
            // background --> foreground
            Motto.currentSharedUrl = UIPasteboard.general.string ?? ""
//            if Motto.currentSharedUrl.starts(with: "http") {
                Utils.consoleLog("Motto.currentSharedUrl", Motto.currentSharedUrl, true)
                if Motto.currentSharedUrl != "" {
                    webView.evaluateJavaScript("javascript:popupAnswerWithSharedText('\(String(describing: Motto.currentSharedUrl.removingPercentEncoding ?? ""))');")
                    
                    Motto.currentSharedUrl = ""
                }
//            }
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
