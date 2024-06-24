//
//  AdNetworkViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import WebKit
//import GoogleMobileAds


class AdNetworkViewController: BaseCampaignViewController {
    
    var additionalRewardList: [Int] = []
    var isAdLoaded = false
    var isRewardEarned = false
    var adUnit: AdUnitBase?
    var selfVC: AdNetworkViewController?
    var adType: AdUnitType?
    
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
        $0.setImage(Utils.podImage(context: AdNetworkViewController.self, img: "ic_arrow_left"), for: .normal)
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
        
        selfVC = self
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
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
        
        let urlString = Domains.campaignURL + "main_ad_network.php?pk=" + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&campaignType=\(String(describing: Motto.adrole))&executionType=\(String(describing: Motto.jmethod))"
        Utils.consoleLog("urlString", urlString, true)
        loadWebView(wv: webView, url: urlString)
        
        AdUnitBase.initAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.consoleLog("isRewardEarned", isRewardEarned, true)
        
        if (isRewardEarned) {
            sendOkRequest()
            isRewardEarned = false
        }
    }
    
    func loadAd(typeString: String) {
        // 현재 VC 에서 광고가 보여야 한다.
        DispatchQueue.main.async {
            LoadingIndicator.showLoading()
            
            Utils.consoleLog("ad type string:", typeString, true)
            
            switch typeString {
//            case "admob":
//                self.adType = AdUnitType.ADMOB
//                self.adUnit = AdUnitAdmob.shared
            case "unity":
                self.adType = AdUnitType.UNITY
                self.adUnit = AdUnitUnity.shared
            case "vungle":
                self.adType = AdUnitType.VULGLE
                self.adUnit = AdUnitVungle.shared
            case "pangle":
                self.adType = AdUnitType.PANGLE
                self.adUnit = AdUnitPangle.shared
            case "adpopcorn":
                self.adType = AdUnitType.ADPOPCORN
                self.adUnit = AdUnitAdpopcorn.shared
            default:
                break
            }
            self.adUnit?.callVC = self
            
//            switch adType {
//            case AdUnitType.ADMOB:
//                self.adUnit = AdUnitAdmob.shared
//            case AdUnitType.UNITY:
//                self.adUnit = AdUnitUnity.shared
//            case AdUnitType.VULGLE:
//                self.adUnit = AdUnitVungle.shared
//            case AdUnitType.PANGLE:
//                self.adUnit = AdUnitPangle.shared
//            case AdUnitType.ADPOPCORN:
//                self.adUnit = AdUnitAdpopcorn.shared
//            }
            
            self.adUnit?.loadAd { result in
                LoadingIndicator.hideLoading()
                switch result {
                case AdUnitResult.LOAD_SUCCESS:
                    Utils.consoleLog("Successed to load interstitial ad")
                    self.isAdLoaded = true
                default:
                    Utils.consoleLog("Failed to load interstitial ad")
                    // alert 띄울 것
                }
            }
        }
    }
    
    func callbackAd(result: AdUnitResult) {
        switch result {
        case AdUnitResult.LOAD_SUCCESS:
            Utils.consoleLog("Successed to load interstitial ad")
            self.isAdLoaded = true
        case AdUnitResult.LOAD_FAIL:
            Utils.consoleLog("Failed to load interstitial ad")
            // alert 띄울 것
        case AdUnitResult.REWARD_SUCCESS:
            Utils.consoleLog("Successed to reward ad")
            if let adtype = self.adType {
                if (adtype == AdUnitType.UNITY) {
                    self.sendOkRequest()
                } else {
                    self.isRewardEarned = true
                }
            }
        default:
            break
        }
    }
    
    func showAd() {
        DispatchQueue.main.async {
            if self.isAdLoaded {
                self.adUnit?.showAd(viewController: self) { result in
                    switch result {
                    case AdUnitResult.REWARD_SUCCESS:
                        Utils.consoleLog("Successed to reward ad")
                        if let adtype = self.adType {
                            if (adtype == AdUnitType.UNITY) {
                                self.sendOkRequest()
                            } else {
                                self.isRewardEarned = true
                            }
                        }
                    default:
                        Utils.consoleLog("Failed to reward ad")
                        // alert 띄울 것
                    }
                }
            }
        }
//        runOnUiThread {
//            if (isAdLoaded) {
//                adUnit?.let { adUnit ->
//                    adUnit.showAd(this) { result ->
//                        when (result) {
//                            AdUnitResult.REWARD_SUCCESS -> {
//                                LibLog.i(TAG, "show result: $result")
//                                if (adUnit.type == AdUnitType.UNITY) {
//                                    requestReward()
//                                } else {
//                                    isRewardEarned = true
//                                }
//                            }
//                            else -> {
//                                LibLog.i(TAG, "show result: $result")
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func test() {
        Utils.consoleLog("dagian")
    }
    
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Utils.consoleLog("message.name", message.name, true)
        Utils.consoleLog("message.body", message.body, true)
        if (message.name == "AppInterfaceIos" || message.name == "CampaignInterfaceIos"), let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            // AdCpc
            let adTitle = String(describing: messageBody["adTitle"] ?? "0")
            let adType = String(describing: messageBody["adType"] ?? "0")
            
            switch messageString {
            case "onSetCampaignData":
                Utils.consoleLog("onSetCampaignData adTitle", adTitle, true)
                Utils.consoleLog("onSetCampaignData adType", adType, true)

                loadAd(typeString: adType)
            case "onStart":
                showAd()
            default:
                break
            }
        }
    }
}
