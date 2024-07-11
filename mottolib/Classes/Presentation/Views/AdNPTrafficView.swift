//
//  AdNPTrafficView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then
import WebKit

class AdNPTrafficView: AdCrawlingView {
    
    enum NPTrafficGuides: Int {
        case None = 0
        case Stores = 1
        case More = 2
        case Traffic = 8
        case Fail = 9
    }
    enum TrafficPopupState {
        case HIDE
        case PROGRESS
        case COMPLETE
    }
    
    var guideType: NPTrafficGuides = NPTrafficGuides.None
    var prevGuideType: NPTrafficGuides = NPTrafficGuides.None
    var countDownStarted: Bool = false
    var isSearchMoreButton: Bool = false
    var isTipAnimation: Bool = false
    private var timer = Timer()
    private var cdTimer = Timer()
    private var trafficUrl: String = ""
    
    // MARK: - View
    let contentsView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let topButtonView = UIImageView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdNPTrafficView.self, img: "btn_mission_info")
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomContentsView = UIStackView().then {
        $0.isHidden = false
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
        $0.image = Utils.podImage(context: AdNPTrafficView.self, img: "traffic")
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
    // tip popup 추가
    let tipView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .purple
        $0.makeRounded(cornerRadius: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let tipIconImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdNPTrafficView.self, img: "icon_traffic_guide")
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
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(contentsView)
        contentsView.addSubviews(topButtonView, webView, tipView, bottomView)
//        bottomView.addSubviews(bottomDescLabel, bottomTimerView)
        bottomView.addSubviews(bottomContentsView)
        [leftView, completeButton]
            .forEach(bottomContentsView.addArrangedSubview(_:))
        leftView.addSubviews(trafficImageView, infoLabel30, infoLabel31)
//        bottomTimerView.addSubviews(bottomClockView, bottomTimeLabel)
        tipView.addSubviews(tipIconImageView, tipLabel)
        
        contentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(65)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
//        bottomDescLabel.snp.makeConstraints { make in
//            make.top.equalTo(bottomView.snp.top)
//            make.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.7)
//        }
//        bottomTimerView.snp.makeConstraints { make in
//            make.top.equalTo(bottomView.snp.top)
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.3)
//        }
//        bottomClockView.snp.makeConstraints { make in
//            make.top.equalTo(bottomTimerView.snp.top).inset(5)
//            make.left.equalToSuperview().inset(5)
//            make.bottom.equalToSuperview().inset(5)
//            make.width.height.equalTo(25)
//        }
//        bottomTimeLabel.snp.makeConstraints { make in
//            make.top.equalTo(bottomTimerView.snp.top)
//            make.left.equalTo(bottomClockView.snp.right).offset(5)
//            make.bottom.equalToSuperview()
//        }
        // UI 변경
        bottomContentsView.snp.makeConstraints { make in
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
        
        completeButton.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveClick))
//        bottomView.addGestureRecognizer(tapGesture)
//        bottomView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(showGuide))
        topButtonView.addGestureRecognizer(tapGesture2)
        topButtonView.isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        timer.invalidate()
        cdTimer.invalidate()
        
        NotificationCenter.default.removeObserver(self)
        isSearchMoreButton = false
    }
    
    @objc func saveClick() {
        if !requestSend {
            requestSend = true
            LoadingIndicator.showLoading()
            sendOkRequest()
        }
    }
    
    func processOtherPages(pageType: MissionPageTypes, url: String) {
        switch pageType {
        case .GoogleSearch:
            if joinMethod == 1 || joinMethod == 2 {
                callScript(number: 1, delay: 500)
            }
        case .NaverHome, .NaverMap:
            if joinMethod == 1 || joinMethod == 2 {
                var searchKeyword: String = extractKeywordFromUrl(url: detailUrls[0])
                searchKeyword = searchKeyword.replacingOccurrences(of: "+", with: " ")
                if searchKeyword.count > 0 {
                    parentVC?.nhomeView.isHidden = false
                    parentVC?.nhomeView.keywordTextView.text = searchKeyword
                    parentVC?.nhomeView.keywordTextView.alignVerticallyCenter()
                    
                    callScript(number: 1, delay: 100)
                }
            }
        case .OurServer:
            break
        default:
            if productKey.count > 0 && url.contains(productKey) {
                return
            }
            if url.contains(MLDefine.NaverMapUrl) {
                return
            }
            
            guideType = NPTrafficGuides.Fail
        }
    }
    
    func searchMore() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self!.isSearchMoreButton {
                    self!.callScript(number: 2, delay: 1000)
                } else {
                    timer.invalidate()
                }
            }

        })
    }
    
    override func webPageFinished(url: String, diff: Int) {
        if detailUrls.count == 0 || diff < 300 {
            return
        }
        
        currentUrl = url
        guideType = NPTrafficGuides.None
        
        parentVC?.nhomeView.isHidden = true
//        switchBottomView(isvisible: false)
        processTrafficPopup(state: TrafficPopupState.HIDE);
        
        let pageType = getPageType(url: currentUrl)
        var isStopCountdown: Bool = true
        isSearchMoreButton = false
        var isShowTrafficTip: Bool = false
        
        if  pageType == MissionPageTypes.DBUrl1 ||
            pageType == MissionPageTypes.DBUrl2 ||
            pageType == MissionPageTypes.DBUrl3 {
            parentVC?.visibleTitleBar(visible: true)
            
            var delay = 700
            var scriptNumber = 0
            
            switch pageType {
            case .DBUrl1:
                switch joinMethod {
                case 1:
                    guideType = NPTrafficGuides.Stores
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 3
                case 2:
                    guideType = NPTrafficGuides.More
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 3
                    isSearchMoreButton = true
                    searchMore()
                default:
                    break
                }
            case .DBUrl2:
                if joinMethod == 1 {
                    switchTopButtonView(isvisible: false)
                    processTrafficPopup(state: TrafficPopupState.PROGRESS)
                    isShowTrafficTip = true
                    switchBottomView(isvisible: true)
                    if countDownStarted  {
                        startCountDown()
                    } else if !isComplete {
                        processTrafficPopup(state: TrafficPopupState.HIDE)
                        isShowTrafficTip = false
//                        switchOkButton(step: 1)
                        showTimerGuide()
                    }
                    isStopCountdown = false
                } else if joinMethod == 2 {
                    delay = 1700
                    guideType = NPTrafficGuides.Stores
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 4
                    LoadingIndicator.showLoading()
                }
            case .DBUrl3:
                if joinMethod == 2 {
                    switchTopButtonView(isvisible: false)
                    processTrafficPopup(state: TrafficPopupState.PROGRESS);
                    isShowTrafficTip = true
                    if countDownStarted {
                        startCountDown()
                    } else if !isComplete {
                        processTrafficPopup(state: TrafficPopupState.HIDE);
                        isShowTrafficTip = false
//                        switchOkButton(step: 1)
                        showTimerGuide()
                    }
                    isStopCountdown = false;
                }
            default:
                break
            }
            
            if scriptNumber != 0 {
                callScript(number: scriptNumber-1, delay: delay)
            }
        } else {
            parentVC?.visibleTitleBar(visible: true)
            switchTopButtonView(isvisible: false)
            processOtherPages(pageType: pageType, url: url)
        }
        
        if isStopCountdown {
            if countDownStarted {
                cdTimer.invalidate()
                countDownStarted = false
            }
            isComplete = false
        }
        
        if guideType != NPTrafficGuides.Stores {
            showGuide()
        }
        
        if isShowTrafficTip {
            showTrafficTip()
        } else {
            hideTrafficTip()
        }
    }
    
    func showTrafficTip() {
        tipView.isHidden = false
        if isTipAnimation {
            tipView.fadeIn()
            isTipAnimation = false
        }
    }
    func hideTrafficTip() {
        tipView.isHidden = true
    }
    
    override func objectFound(code: Int, args: String) {
        if code == 21 {
            LoadingIndicator.hideLoading()
            guideType = NPTrafficGuides.Stores
//            LoadingIndicator.showLoading()
        }
    }
    override func objectNotFound(code: Int) {
        if code == 21 {
            LoadingIndicator.hideLoading()
        }
    }
    
    func switchTopButtonView(isvisible: Bool) {
        topButtonView.isHidden = !isvisible
        if isvisible {
            webView.snp.remakeConstraints { make in
                make.top.equalTo(topButtonView.snp.bottom)
                make.left.right.equalToSuperview()
                if bottomView.isHidden {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalTo(bottomView.snp.top)
                }
            }
        } else {
            webView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                if bottomView.isHidden {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalTo(bottomView.snp.top)
                }
            }
        }
        
        webView.layoutIfNeeded()
    }
    func switchBottomView(isvisible: Bool) {
        bottomView.isHidden = !isvisible
        if isvisible {
            webView.snp.remakeConstraints { make in
                if topButtonView.isHidden {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topButtonView.snp.bottom)
                }
                make.left.right.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top)
            }
        } else {
            webView.snp.remakeConstraints { make in
                if topButtonView.isHidden {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topButtonView.snp.bottom)
                }
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        webView.layoutIfNeeded()
    }
    
//    func switchOkButton(step: Int) {
//        switch step {
//        case 1:
//            bottomView.isUserInteractionEnabled = false
//            bottomView.backgroundColor = .gray
//        case 2:
//            bottomView.isUserInteractionEnabled = true
//            bottomView.backgroundColor = .red
//            
//            bottomDescLabel.snp.remakeConstraints { make in
//                make.top.equalTo(bottomView.snp.top)
//                make.left.equalToSuperview()
//                make.bottom.equalToSuperview()
//                make.width.equalToSuperview()
//            }
//            bottomDescLabel.layoutIfNeeded()
//        default:
//            break
//        }
//    }
    
    @objc func showGuide() {
        lazy var guideCommVC = GuideCommViewController()
        let GuideIsShowing = (guideCommVC.isViewLoaded && guideCommVC.view.window != nil)
        if guideType != NPTrafficGuides.None && guideType != NPTrafficGuides.Traffic {
            if GuideIsShowing {
                if guideCommVC.getGuideType() == NPTrafficGuides.Fail.rawValue {
                    return
                }
                guideCommVC.dismiss(animated: true)
            }
            
            if guideType == NPTrafficGuides.Stores  {
                guideCommVC.popupView.goodsView.isHidden = false
            } else if guideType == NPTrafficGuides.More {
                guideCommVC.popupView.placeView.isHidden = false
	        } else if guideType == NPTrafficGuides.Fail {
                guideCommVC.popupView.failView.isHidden = false
            }
            
            guideCommVC.setGuideType(type: guideType.rawValue)
            guideCommVC.modalPresentationStyle = .overFullScreen
            guideCommVC.viewFromVC = parentVC!
            parentVC?.present(guideCommVC, animated: false, completion: nil)
        }
        
        prevGuideType = guideType
    }
    
    func showTimerGuide() {
        lazy var guideCommVC = GuideCommViewController()
        let GuideIsShowing = guideCommVC.viewIfLoaded != nil
        
        if prevGuideType == NPTrafficGuides.Traffic {
            return
        }
        prevGuideType = NPTrafficGuides.Traffic
        guideType = NPTrafficGuides.Traffic
        if GuideIsShowing {
            guideCommVC.dismiss(animated: true)
        }
        
        guideCommVC.popupView.trafficView.isHidden = false
        guideCommVC.setGuideType(type: guideType.rawValue)
        
        guideCommVC.modalPresentationStyle = .overFullScreen
        guideCommVC.viewFromVC = parentVC!
        self.parentVC?.present(guideCommVC, animated: false, completion: nil)
    }
    
    var trafficUriList: [String] = []
    var currentDuration: Int = 0
    var isComplete: Bool = false
    
    func startCountDown() {
        if isComplete {
            return
        }
        
        if (!countDownStarted) {
            countDownStarted = true;
//            bottomTimerView.isHidden = false
            
            trafficUriList.append(currentUrl)
            
            currentDuration = extraArgs.count > 0 ? Int(extraArgs[0])! * 1000 : 5000
            currentDuration += 300
            startTimer(duration: currentDuration)
        } else if (!trafficUriList.contains(currentUrl) && !trafficUriList.contains("/home?")) {
            trafficUriList.append(currentUrl)
            if currentDuration > 10000 {
                let newDuration: Int = currentDuration - 9900
                if newDuration < 10000 {
                    currentDuration = 9900
                } else {
                    currentDuration = newDuration
                }
                startTimer(duration: currentDuration)
            }
        }
    }
    
    func startTimer(duration: Int) {
        currentDuration = duration
        cdTimer.invalidate()
        
        if currentDuration > 0 {
            onTimerTick(millisUntilFinished: self.currentDuration)
            cdTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                self.onTimerTick(millisUntilFinished: self.currentDuration)
                self.currentDuration -= 1000
            })
            
            RunLoop.current.add(cdTimer, forMode: .common)
        } else {
            onTimerFinish()
        }
    }
    
    func onTimerTick(millisUntilFinished: Int) {
        currentDuration = millisUntilFinished
        let sec: Int = millisUntilFinished / 1000
        let cntString: String  = "\(sec)"
//        bottomTimeLabel.text = cntString
        
        if sec < 60 {
            showTrafficTip()
        }
        infoLabel30.text = cntString
        
        if millisUntilFinished < 1000 {
            onTimerFinish()
        }
    }
    
    func onTimerFinish() {
//        bottomTimerView.isHidden = true
//        switchOkButton(step: 2)
        processTrafficPopup(state: TrafficPopupState.COMPLETE)
        hideTrafficTip()
        countDownStarted = false
        isComplete = true
        
        cdTimer.invalidate()
    }
    
    // 캠페인 변경
    func processTrafficPopup(state: TrafficPopupState) {
        switch state {
        case TrafficPopupState.HIDE:
            switchBottomView(isvisible: false)
        case TrafficPopupState.COMPLETE:
            switchBottomView(isvisible: true)
            infoLabel30.isHidden = true
            infoLabel31.text = Description.missionComplete
            completeButton.isEnabled = true
        case TrafficPopupState.PROGRESS:
            switchBottomView(isvisible: true)
            infoLabel30.isHidden = false
            infoLabel31.text = Description.waitMission
            completeButton.isEnabled = false
        }
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        if countDownStarted {
            // 이 경우에만 webpagefinished 역할을 대신
            webPageFinished(url: webView.url!.absoluteString, diff: 500)
        }
    }
    override func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
