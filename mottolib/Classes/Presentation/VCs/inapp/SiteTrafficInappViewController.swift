//
//  SiteTrafficInappViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit

class SiteTrafficInappViewController: BaseCampaignViewController {
    
    enum GuideType {
        case SEARCH
        case MORE_BUTTON
        case TARGET
        case TRAFFIC
    }
    enum WebPageType {
        case GOOGLE_SEARCH
        case NAVER_HOME
        case MJT_SERVER
        case TARGET_URL

        case CAMPAIGN_URL1
        case CAMPAIGN_URL2
        case CAMPAIGN_URL3
        case CAMPAIGN_URL4
        case CAMPAIGN_URL5

        case UNKNOWN
    }
    
    var timer: Timer?
    var isComplete = false
    
    let GOOGLE_HOME_URL = "https://www.google.co.kr"
    let NAVER_HOME_URL = "https://m.naver.com/"
    
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
    let frameView = UIView().then {
        $0.backgroundColor = .clear
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: SiteTrafficInappViewController.self, img: "ic_arrow_left"), for: .normal)
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
    let bottomView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // popup view 1
    let bottomPopupView_1 = UIStackView().then {
        $0.isHidden = false
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    let infoLabel_1 = UILabel().then {
        $0.text = "30"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel_2 = UILabel().then {
        $0.text = "초 후 받을 수 있어요"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel_3 = UILabel().then {
        $0.text = "초 후 받을 수 있어요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 18)
    }
    // popup view 2
    let bottomPopupView_2 = UIStackView().then {
        $0.isHidden = true
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
        $0.image = Utils.podImage(context: SiteTrafficInappViewController.self, img: "traffic")
        $0.clipsToBounds = false
    }
    let infoLabel30 = UILabel().then {
        $0.text = "5"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel31 = UILabel().then {
        $0.text = "초 후 받을 수 있어요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.sizeToFit()
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
    // tip popup 추가
    let tipView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .purpleTip
        $0.makeRounded(cornerRadius: 25)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let tipIconImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: SiteTrafficInappViewController.self, img: "icon_traffic_guide")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let tipLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.text = Description.trafficTip
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    deinit {
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
        bottomView.addSubviews(bottomPopupView_1, bottomPopupView_2)
        [infoLabel_1, infoLabel_2, infoLabel_3]
            .forEach(bottomPopupView_1.addArrangedSubview(_:))
        [leftView, completeButton]
            .forEach(bottomPopupView_2.addArrangedSubview(_:))
        leftView.addSubviews(trafficImageView, infoLabel30, infoLabel31)
        tipView.addSubviews(tipIconImageView, tipLabel)
        frameView.addSubview(webView)
        
        contentsView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
//            make.left.equalTo(contentsView.snp.left)
//            make.right.equalTo(contentsView.snp.right)
//            make.bottom.equalTo(contentsView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
            make.height.equalTo(60)
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
        bottomPopupView_2.snp.makeConstraints { make in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.centerY.equalTo(bottomView.snp.centerY)
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
        tipView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
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
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = Motto.store
        // back action.
        backButton.addTarget(self, action: #selector(baseBackAction), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(sendOkRequest), for: .touchUpInside)
        
        let urlString = Domains.campaignURL + "main_site_traffic_inapp.php?pk=" + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&campaignType=\(String(describing: Motto.adrole))&executionType=\(String(describing: Motto.jmethod))"
        Utils.consoleLog("urlString", urlString, true)
        loadWebView(wv: webView, url: urlString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func onPageStarted(url: String) {
        Utils.consoleLog("onPageStarted", url, true)
        LoadingIndicator.showLoading()
        hideGuidePopup()
    }
    override func onPageFinished(url: String) {
        Utils.consoleLog("onPageFinished", url, true)
        let pageType = getWebPageType(url: url)
        Utils.consoleLog("pageType", pageType, true)
        isComplete = false
        switch pageType {
        case WebPageType.GOOGLE_SEARCH:
            runCampaignScript(index: 0)
        case WebPageType.NAVER_HOME:
            runCampaignScript(index: 1)
            showGuidePopup(type: GuideType.SEARCH)
        case WebPageType.CAMPAIGN_URL1:
            runCampaignScript(index: 2)
            showGuidePopup(type: GuideType.MORE_BUTTON)
        case WebPageType.CAMPAIGN_URL2:
            runCampaignScript(index: 3)
            showGuidePopup(type: GuideType.TARGET)
        case WebPageType.TARGET_URL:
            isComplete = true
            showGuidePopup(type: GuideType.TRAFFIC)
        case WebPageType.UNKNOWN:
            LoadingIndicator.hideLoading()
            showFailGoPreviousPopup()
        default:
            LoadingIndicator.hideLoading()
        }
    }
    
    func showGuidePopup(type: GuideType) {
        LoadingIndicator.hideLoading()
        
        switch type {
        case GuideType.SEARCH:
            tipView.isHidden = false
            tipLabel.text = Description.autoKeyword
            infoLabel_1.text = ""
            infoLabel_2.text = Description.autoKeyword1
            infoLabel_3.text = Description.autoKeyword2
            addGuidePopup(type: 1)
        case GuideType.MORE_BUTTON:
            tipView.isHidden = true
            infoLabel_1.text = Description.more
            infoLabel_2.text = Description.more1
            infoLabel_3.text = Description.more2
            addGuidePopup(type: 1)
        case GuideType.TARGET:
            tipView.isHidden = true
            infoLabel_1.text = Description.target
            infoLabel_2.text = Description.target1
            infoLabel_3.text = Description.target2
            addGuidePopup(type: 1)
        case GuideType.TRAFFIC:
            startTrafficTimer()
            addGuidePopup(type: 2)
        default:
            break
        }
    }
    func addGuidePopup(type: Int) {
        if type == 1 {
            bottomPopupView_1.isHidden = false
            bottomPopupView_2.isHidden = true
        } else {
            bottomPopupView_1.isHidden = true
            bottomPopupView_2.isHidden = false
        }
        bottomView.isHidden = false
    }
    func hideGuidePopup() {
        bottomView.isHidden = true
    }
    
    func getWebPageType(url: String) -> WebPageType {
        if targetUrl == url {
            return WebPageType.TARGET_URL
        }
        
        for i in 0..<urlList.count {
            if compareCampaignPage(url1: url, url2: urlList[i]) {
                switch i {
                case 0:
                    return WebPageType.CAMPAIGN_URL1
                case 1:
                    return WebPageType.CAMPAIGN_URL2
                case 2:
                    return WebPageType.CAMPAIGN_URL3
                case 3:
                    return WebPageType.CAMPAIGN_URL4
                case 4:
                    return WebPageType.CAMPAIGN_URL5
                default:
                    break
                }
            }
        }
        
        if url.hasPrefix(GOOGLE_HOME_URL) {
            return WebPageType.GOOGLE_SEARCH
        }
        if url.hasPrefix(NAVER_HOME_URL) {
            return WebPageType.NAVER_HOME
        }
        if url.hasPrefix(Motto.currentDomain) {
            return WebPageType.MJT_SERVER
        }
        
        return WebPageType.UNKNOWN
    }
    
    func compareCampaignPage(url1: String, url2: String) -> Bool {
        if url1 == url2 {
            return true
        }
        // paging 처리를 위해 검색 결과 페이지 검사
        if (url1.hasPrefix("https://m.search.naver.com/search.naver")
            && url1.contains("query=")
            && url1.contains("page=")
            && url2.hasPrefix("https://m.search.naver.com/search.naver")
            && url2.contains("query=")
            && url2.contains("page=")) {
            if (Utils.extractKeywordFromUrl(url: url1) == Utils.extractKeywordFromUrl(url: url2)) {
                return true
            }   
        }
        return false
    }
    
    func runCampaignScript(index: Int) {
        if index < scriptList.count {
            let script = scriptList[index]
            LoadingIndicator.showLoading()
            var addtime = 0.25
            if script.contains("검색결과 더보기") {
                addtime = 0.8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + addtime) {
                Utils.consoleLog("script", script, true)
                self.executeScript(script: script)
            }
        }
    }
    func executeScript(script: String) {
        guard let urlDecode = script.removingPercentEncoding else { return }
        self.webView.evaluateJavaScript(urlDecode) { result, error in
            if let error {
                Utils.consoleLog("evaluateJavaScript error", error)
            }
            Utils.consoleLog("evaluateJavaScript Received Data", result ?? "")
            
            LoadingIndicator.hideLoading()
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
    }
}
