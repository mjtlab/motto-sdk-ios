//
//  AdCpcViewController.swift
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import WebKit

class AdCpcViewController: BaseCampaignViewController {
    
    var additionalRewardList: [Int] = []
    var isRewardEarned = false
    
    let contentsView = UIView().then {
        $0.backgroundColor = .white
    }
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    var titleTopView = UIView().then {
        $0.backgroundColor = .white
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: AdCpcViewController.self, img: "ic_arrow_left"), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.text = "미션"
        $0.sizeToFit()
    }
    let frameView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    // tip popup 추가
    let tipView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .purple
        $0.makeRounded(cornerRadius: 20)
    }
    let tipIconImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdCpcViewController.self, img: "icon_traffic_guide")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = false
    }
    let tipLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.text = Description.ad_cpc_guide_warning
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    let bottomView = UIView().then {
        $0.isHidden = false
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // popup view 1
    let bottomPopupView_1 = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    let infoLabel_1 = UILabel().then {
        $0.text = "광고"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel_2 = UILabel().then {
        $0.text = ""
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel_3 = UILabel().then {
        $0.text = "를 눌러 페이지를 방문하세요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let adImageView = UIImageView().then {
        $0.isHidden = true
        $0.backgroundColor = .colorGrayF3
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = false
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
        [titleTopView, frameView, bottomView, tipView]
            .forEach(bodyStackView.addSubview(_:))
        titleTopView.addSubviews(
            backButton,
            titleLabel
        )
        bottomView.addSubviews(bottomPopupView_1)
        [infoLabel_1, infoLabel_2, infoLabel_3]
            .forEach(bottomPopupView_1.addArrangedSubview(_:))
        tipView.addSubviews(tipIconImageView, tipLabel)
        frameView.addSubviews(webView, adImageView)
        
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
        }
        bottomPopupView_1.snp.makeConstraints { make in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        infoLabel_1.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        infoLabel_2.snp.makeConstraints { make in
            make.left.equalTo(infoLabel_1.snp.right).offset(3)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        infoLabel_3.snp.makeConstraints { make in
            make.left.equalTo(infoLabel_2.snp.right)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        tipView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        tipIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(tipIconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        adImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = Motto.store
        // back action
        backButton.addTarget(self, action: #selector(baseBackAction), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveClick))
        adImageView.addGestureRecognizer(tapGesture)
        adImageView.isUserInteractionEnabled = true
        
        let urlString = Domains.campaignURL + "main_ad_cpx.php?pk=" + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&campaignType=\(String(describing: Motto.adrole))&executionType=\(String(describing: Motto.jmethod))"
        Utils.consoleLog("urlString", urlString, true)
        loadWebView(wv: webView, url: urlString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @objc func saveClick() {
        if (adUrl.count > 0) {
            openDefaultBrowser(startUrl: adUrl)
            sendOkRequest()
        }
    }
    
    func showAd() {
        DispatchQueue.main.async {
            self.webView.isHidden = true
            self.adImageView.isHidden = false
            guard let url = URL(string: self.adImage) else { return }
            self.adImageView.load(url: url)
            
            self.tipView.isHidden = false
            self.bottomPopupView_1.isHidden = false
            self.bottomView.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50)
            }
        }
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
            let trafficTime = String(describing: messageBody["trafficTime"] ?? "0")
            
            switch messageString {
            case "onSetCampaignData":
                Utils.consoleLog("onSetCampaignData adTitle", adTitle, true)
                Utils.consoleLog("onSetCampaignData url", url, true)
                Utils.consoleLog("onSetCampaignData image", image, true)
                Utils.consoleLog("onSetCampaignData time", trafficTime, true)
                // 배열화 하는 것이 일반적이겠지만, 이미지가 여러개 안올 수도 있을 것 같아서.
                let imageUrl = image.replacingOccurrences(of: ",", with: "")

                adUrl = url
                adImage = imageUrl
            case "onStart":
                showAd()
            default:          
                break
            }
        }
    }
}
