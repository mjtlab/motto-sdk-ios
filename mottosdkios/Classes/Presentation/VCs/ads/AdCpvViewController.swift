//
//  AdCpvViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import WebKit

class AdCpvViewController: BaseCampaignViewController {
    
    var timer: Timer?
    var isComplete = false
    
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
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: AdCpvViewController.self, img: "ic_arrow_left"), for: .normal)
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
    let frameView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // popup view 2
    let bottomPopupView_2 = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let leftView = UIView().then {
        $0.backgroundColor = .clear
    }
    let trafficImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdCpvViewController.self, img: "traffic")
        $0.clipsToBounds = false
    }
    let infoLabel30 = UILabel().then {
        $0.text = "30"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel31 = UILabel().then {
        $0.text = "초 후 받을 수 있어요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let completeButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle("미션완료", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
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
        [titleTopView, frameView, bottomView]
            .forEach(bodyStackView.addSubview(_:))
        titleTopView.addSubviews(
            backButton,
            titleLabel
        )
        bottomView.addSubview(bottomPopupView_2)
        [leftView, completeButton]
            .forEach(bottomPopupView_2.addArrangedSubview(_:))
        leftView.addSubviews(trafficImageView, infoLabel30, infoLabel31)
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
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        bottomPopupView_2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftView.snp.makeConstraints { make in
            make.left.equalTo(bottomView.snp.left).inset(15)
            make.centerY.equalTo(bottomView.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        trafficImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
            make.left.equalTo(leftView.snp.left)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
        infoLabel30.snp.makeConstraints { make in
            make.left.equalTo(trafficImageView.snp.right).offset(3)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        infoLabel31.snp.makeConstraints { make in
            make.left.equalTo(infoLabel30.snp.right)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        completeButton.snp.makeConstraints { make in
            make.right.equalTo(bottomView.snp.right).inset(15)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = Motto.store
        // back action
        backButton.addTarget(self, action: #selector(sendBackAction), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(sendOkRequest), for: .touchUpInside)
        
        let urlString = Domains.campaignURL + "main_ad_cpx.php?pk=" + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&campaignType=\(String(describing: Motto.adrole))&executionType=\(String(describing: Motto.jmethod))"
        Utils.consoleLog("urlString", urlString, true)
        loadWebView(wv: webView, url: urlString)
    }
    
    @objc func sendBackAction() {
//        if webView.canGoBack {
//            webView.goBack()
//        } else {
        bottomView.isHidden = true
        dismiss(animated: false)
        presentingViewController!.dismiss(animated: false)
//        }
        timer?.invalidate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    func showVideo() {
        DispatchQueue.main.async {
            LoadingIndicator.showLoading()
            self.loadWebView(wv: self.webView, url: self.adUrl)
        }
    }
    
    override func onPageFinished(url: String) {
        if (adUrl == url) {
            isComplete = true
            startTrafficTimer()
            LoadingIndicator.hideLoading()
        } else {
            isComplete = false
        }
    }
    func startTrafficTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleTrafficTimerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func handleTrafficTimerTick() {
        if !isComplete {
            return
        }
        
        infoLabel30.text = "\(trafficDurations - currentTrafficTime)"
        
        if (currentTrafficTime < trafficDurations) {
            completeButton.isEnabled = false
            infoLabel31.text = "초 후 받을 수 있어요"
        } else {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .color_instagram_blue2
            infoLabel30.isHidden = true
            infoLabel31.text = "미션을 완료하셨습니다"
            timer?.invalidate()
        }
        
        currentTrafficTime += 1
        bottomView.isHidden = false
    }

    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Utils.consoleLog("message.name", message.name, true)
        Utils.consoleLog("message.body", message.body, true)
        if (message.name == "AppInterfaceIos" || message.name == "CampaignInterfaceIos"), let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            // AdCpc
            let adTitle = String(describing: messageBody["adTitle"] ?? "0")
            let url = String(describing: messageBody["adUrl"] ?? "0")
            let image = String(describing: messageBody["adImage"] ?? "0")
            // Test 시에 이미지가 빈값으로 넘어와서 강제 고정
//            let image = "http://106.248.241.115/bfnew/images/C/yj170naof2mggatkzhyo.jpg"
            let trafficTime = String(describing: messageBody["trafficTime"] ?? "0")
            
            switch messageString {
            case "onSetCampaignData":
                Utils.consoleLog("onSetCampaignData adTitle", adTitle, true)
                Utils.consoleLog("onSetCampaignData url", url, true)
                Utils.consoleLog("onSetCampaignData image", image, true)
                Utils.consoleLog("onSetCampaignData time", trafficTime, true)

                adUrl = url
                trafficDurations = Int(trafficTime) ?? 0
            case "onStart":
                
                showVideo()
            default:
                break
            }
        }
    }
}

