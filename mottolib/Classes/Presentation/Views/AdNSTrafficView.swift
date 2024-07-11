//
//  AdNSTrafficView.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import SnapKit
import Then
import WebKit

class AdNSTrafficView: AdCrawlingView {
    
    enum NSTrafficGuides: Int {
        case None = 0
        case Stores = 1
        case More = 2
        case Fail = 9
    }
    enum TrafficPopupState {
        case HIDE
        case PROGRESS
        case COMPLETE
    }
    
    var guideType: NSTrafficGuides = NSTrafficGuides.None
    var countDownStarted: Bool = false
    var passFail: Bool = false
    private var timer = Timer()
    private var cdTimer = Timer()
    var trafficCategory: Int = 0
    var foundNextUrl: String = ""
    
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
        $0.backgroundColor = .black
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
        $0.backgroundColor = .colorGrayCD
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle("미션완료", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(contentsView)
        contentsView.addSubviews(topButtonView, webView, bottomView)
//        bottomView.addSubviews(bottomDescLabel, bottomTimerView)
        bottomView.addSubviews(bottomContentsView)
        [leftView, completeButton]
            .forEach(bottomContentsView.addArrangedSubview(_:))
        leftView.addSubviews(trafficImageView, infoLabel30, infoLabel31)
//        bottomTimerView.addSubviews(bottomClockView, bottomTimeLabel)
        
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
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saveClick() {
        if requestSend { return }
        
        var canRequest: Bool = true
        if trafficCategory > 1 {
            if foundNextUrl == "" {
                canRequest = false
            } else {
                loadUrlWithDelay(url: foundNextUrl, delay: 50)
            }
        }
        
        if canRequest {
            requestSend = true
            passFail = true
            LoadingIndicator.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                self.sendOkRequest()
            }
        }
    }
    
    func processOtherPages(pageType: MissionPageTypes, url: String) {
        switch pageType {
        case .NaverHome, .NaverShopping:
            if joinMethod == 1 || joinMethod == 2 {
                var searchKeyword: String = extractKeywordFromUrl(url: detailUrls[0])
                searchKeyword = searchKeyword.replacingOccurrences(of: "+", with: " ")
                if searchKeyword.count > 0 {
                    if joinMethod == 1 {
                        parentVC?.nhomeView.isHidden = false
                        parentVC?.nhomeView.keywordTextView.text = searchKeyword
                        parentVC?.nhomeView.keywordTextView.alignVerticallyCenter()
                    }

                    callScript(number: 1, delay: 100)
                }
            }
        case .OurServer:
            break
        default:
            if passFail { return }
            if productKey.count > 0 && url.contains(productKey) {
                return
            }
            if url.contains(MLDefine.NaverMapUrl) {
                return
            }
            
            guideType = NSTrafficGuides.Fail
        }
    }
    
    override func webPageFinished(url: String, diff: Int) {
        if detailUrls.count == 0 || diff < 300 {
            return
        }
        
        currentUrl = url
        guideType = NSTrafficGuides.None
        // nplacehomeview 를 히든
        parentVC?.nhomeView.isHidden = true
        // 저장하기 버튼(하단 영역) 히든.
//        switchBottomView(isvisible: false)
        processTrafficPopup(state: TrafficPopupState.HIDE)
        
        var pageType = getPageType(url: currentUrl)
        if countDownStarted {
            cdTimer.invalidate()
            countDownStarted = false
        }
        
        if  pageType == MissionPageTypes.DBUrl1 ||
             pageType == MissionPageTypes.DBUrl2 ||
             pageType == MissionPageTypes.DBUrl3 ||
             pageType == MissionPageTypes.DBUrl4 {
            
            parentVC?.visibleTitleBar(visible: true)
            
            var delay = 700
            var scriptNumber = 0
            var lastPage: Bool = false
            
            if trafficCategory == 1 {
                switch pageType {
                case .DBUrl1:
                    switch joinMethod {
                    case 1:
                        guideType = NSTrafficGuides.More
                        scriptNumber = 2
                        delay = 500
                    default:
                        guideType = NSTrafficGuides.Stores
                        scriptNumber = 3
                        LoadingIndicator.showLoading()
                    }
                case .DBUrl2:
                    if joinMethod == 1 {
                        guideType = NSTrafficGuides.Stores
                        scriptNumber = 3
                        LoadingIndicator.showLoading()
                    } else {
                        lastPage = true
                    }
                case .DBUrl3:
                    lastPage = true
                default:
                    break
                }
            } else {
                switch pageType {
                case .DBUrl1:
                    if joinMethod == 1 {
                        guideType = NSTrafficGuides.More
                        scriptNumber = 2
                        delay = 500
                    } else {
                        guideType = NSTrafficGuides.Stores
                        scriptNumber = 3
                        LoadingIndicator.showLoading()
                    }
                case .DBUrl2:
                        if joinMethod == 1 {
                            guideType = NSTrafficGuides.Stores
                            scriptNumber = 3
                            LoadingIndicator.showLoading()
                        } else {
                            lastPage = true
                            scriptNumber = 4
                        }
                case .DBUrl3:
                        if joinMethod == 1 {
                            lastPage = true
                            scriptNumber = 4
                        } else {
                            scriptNumber = 5
                        }
                case .DBUrl4:
                    if joinMethod == 1 {
                        scriptNumber = 5
                    }
                default:
                    break
                }
            }
            
            if lastPage {
                switchTopButtonView(isvisible: false)
//                switchBottomView(isvisible: true)
//                switchOkButton(step: 1)
                processTrafficPopup(state: TrafficPopupState.PROGRESS)
                startCountDown()
            }
            
            if scriptNumber != 0 {
                callScript(number: scriptNumber, delay: delay)
            }
        } else {
            parentVC?.visibleTitleBar(visible: true)
            processOtherPages(pageType: pageType, url: url)
        }
        
        if guideType != NSTrafficGuides.None {
            switchTopButtonView(isvisible: true)
        } else {
            switchTopButtonView(isvisible: false)
        }
        
        if guideType != NSTrafficGuides.Stores {
            showGuide()
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
    
    override func startMission(startUrl: String) {
        if extraArgs.count > 0 {
            trafficCategory = Int(extraArgs[1])!
        }
        
        crawlingClear()
        super.startMission(startUrl: startUrl)
    }
    
    override func objectFound(code: Int, args: String) {
        LoadingIndicator.hideLoading()
        if guideType == NSTrafficGuides.Stores {
            showGuide()
        }
        
        if trafficCategory == 2 || trafficCategory == 3 {
            if code == 40 || code == 41 {
                foundNextUrl = args
            }
        }
    }
    
    override func objectNotFound(code: Int) {
        LoadingIndicator.hideLoading()
        if guideType == NSTrafficGuides.Stores {
            showGuideFailExit()
            return
        }
        
        if trafficCategory == 2 || trafficCategory == 3 {
            if code == 40 {
                if detailUrls.count >= 3 {
                    let row: Int = Int.random(in: 0...1000)
                    let delay: Int = row + 500
                    loadUrlWithDelay(url: detailUrls[2], delay: delay)
                }
            }
        }
    }
    
    func showGuideFailExit() {
        lazy var guideCommVC = GuideCommViewController()
        guideCommVC.popupView.failView.isHidden = false
        guideCommVC.popupView.centerFailButton.addTarget(self, action: #selector(dismissGuideAndDismiss), for: .touchUpInside)
        guideCommVC.setGuideType(type: guideType.rawValue)
        guideCommVC.modalPresentationStyle = .overFullScreen
        guideCommVC.viewFromVC = parentVC!
        parentVC?.present(guideCommVC, animated: false, completion: nil)
    }
    @objc func dismissGuideAndDismiss() {
        timer.invalidate()
        cdTimer.invalidate()
        NotificationCenter.default.removeObserver(self)
        parentVC?.dismiss(animated: true)
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
        
        if guideType != NSTrafficGuides.None {
            if GuideIsShowing {
                if guideCommVC.getGuideType() == NSTrafficGuides.Fail.rawValue {
                    return
                }
                guideCommVC.dismiss(animated: true)
            }
            
            if guideType == NSTrafficGuides.Stores  {
                guideCommVC.popupView.goodsView.isHidden = false
            }
            else if (guideType == NSTrafficGuides.More) {
                guideCommVC.popupView.shopView.isHidden = false
            }
            else if(guideType == NSTrafficGuides.Fail) {
                guideCommVC.popupView.failView.isHidden = false
            }
            
            guideCommVC.setGuideType(type: guideType.rawValue)
            
            guideCommVC.modalPresentationStyle = .overFullScreen
            guideCommVC.viewFromVC = parentVC!
            parentVC?.present(guideCommVC, animated: false, completion: nil)
        }
    }
    
    func startCountDown() {
        if countDownStarted {
            return
        }
        
        countDownStarted = true
//        bottomTimerView.isHidden = false
        
        var duration: Int = extraArgs.count > 0 ? Int(extraArgs[0])! * 1000 : 5000
        
        cdTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            duration -= 1000
            let sec: Int = duration / 1000
            var cntString: String  = "\(sec)"
//            self.bottomTimeLabel.text = cntString
            self.infoLabel30.text = cntString

            if duration <= 0 {
//                self.bottomTimerView.isHidden = true
//                self.switchOkButton(step: 2)
                self.processTrafficPopup(state: TrafficPopupState.COMPLETE)
                self.countDownStarted = false
                
                self.cdTimer.invalidate()
            }
        })
        
        RunLoop.current.add(cdTimer, forMode: .common)
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
            completeButton.backgroundColor = .color_instagram_blue2
        case TrafficPopupState.PROGRESS:
            switchBottomView(isvisible: true)
            infoLabel30.isHidden = false
            infoLabel31.text = Description.waitMission
            completeButton.isEnabled = false
        }
    }
}
