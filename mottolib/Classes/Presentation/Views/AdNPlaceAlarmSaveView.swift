//
//  AdNPlaceAlarmSaveView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import WebKit
import SnapKit
import Then
import MottoFrameworks

class AdNPlaceAlarmSaveView: AdCrawlingView  {
    
    // MARK: - model
    enum NPlaceGuides: Int {
        case None = 0
        case Login = 1
        case PlaceMain = 2
        case PlaceShare = 3
        case BlogMain = 4
        case Stores = 5
        case Fail = 9
        case More = 11
        case Alarm = 13
        case Save = 15
    }
    
    // MARK: - property
    var enableSave = false
    var visitBookmark = false
    var isAlarm = false
    var isShowLastGuide = false
    var guideType = NPlaceGuides.None
    var prevGuideType = NPlaceGuides.None
    var endCheck = false
    var isSearchMoreButton: Bool = false
    var timer = Timer()
    
    // MARK: - View
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let topButtonView = UIImageView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdNPlaceAlarmSaveView.self, img: "btn_mission_info")
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomAlarmView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomAlarmImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdNPlaceAlarmSaveView.self, img: "naver_place_bottom_bar_alarm")
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomAlarmLabel = UILabel().then {
        $0.textColor = .black
        $0.text = Global.alarmMent
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomSaveView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomSaveImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdNPlaceAlarmSaveView.self, img: "naver_place_bottom_bar_save")
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomSaveLabel = UILabel().then {
        $0.textColor = .black
        $0.text = Global.alarmMent
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomBlogLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .black
        $0.text = Global.choiceBlog
        $0.font = .boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bottomOKLabel = UIButton().then {
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Global.confirmMission, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(bodyStackView)
//        bodyStackView.addSubviews(topButtonView, webView, bottomView)
        [topButtonView, webView, bottomView]
            .forEach(bodyStackView.addSubview(_:))
        bottomView.addSubviews(bottomAlarmView, bottomSaveView, bottomBlogLabel, bottomOKLabel)
        bottomAlarmView.addSubviews(bottomAlarmImageView, bottomAlarmLabel)
        bottomSaveView.addSubviews(bottomSaveImageView, bottomSaveLabel)
        
        bodyStackView.snp.makeConstraints { make in
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
            make.height.equalTo(50)
        }
//        bottomButtonView.snp.makeConstraints { make in
//            make.centerX.equalTo(bottomView.snp.centerX)
//            make.centerY.equalTo(bottomView.snp.centerY)
//            make.width.equalTo(240)
//        }
        bottomAlarmView.snp.makeConstraints { make in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.centerY.equalTo(bottomView.snp.centerY)
            make.width.equalTo(220)
            make.height.equalTo(25)
        }
        bottomAlarmImageView.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(22)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        bottomAlarmLabel.snp.makeConstraints { make in
            make.left.equalTo(bottomAlarmImageView.snp.right)
            make.width.equalTo(120)
            make.height.equalTo(25)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        bottomSaveView.snp.makeConstraints { make in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.centerY.equalTo(bottomView.snp.centerY)
            make.width.equalTo(210)
            make.height.equalTo(25)
        }
        bottomSaveImageView.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(22)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        bottomSaveLabel.snp.makeConstraints { make in
            make.left.equalTo(bottomSaveImageView.snp.right)
            make.width.equalTo(120)
            make.height.equalTo(25)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        bottomBlogLabel.snp.makeConstraints { make in
            make.centerX.equalTo(bottomView.snp.centerX)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
        bottomOKLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveClick))
        bottomView.addGestureRecognizer(tapGesture)
        bottomView.isUserInteractionEnabled = false
        bottomOKLabel.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(showGuide))
        topButtonView.addGestureRecognizer(tapGesture2)
        topButtonView.isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        isSearchMoreButton = false
    }
    
    func processOtherPages(pageType: MissionPageTypes, url: String) {
        switch pageType {
        case .GoogleSearch:
            if joinMethod == 1 || joinMethod == 2 {
                callScript(number: 1, delay: 500)
            }
        case .NaverLogin:
            guideType = NPlaceGuides.Login
            topButtonView.isHidden = false
            switchTopButtonView(isvisible: true)
            switchBottomView(isvisible: false)
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
            if productKey.count > 0, url.contains(productKey) {
                return
            }
            if url.contains(Global.NaverMapUrl) {
                return
            }
            
            guideType = NPlaceGuides.Fail;
        }
    }
    
    func searchMore() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self!.isSearchMoreButton {
                    self!.callScript(number: 3, delay: 1000)
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
        guideType = NPlaceGuides.None
        parentVC?.nhomeView.isHidden = true
        switchBottomView(isvisible: false)
        let pageType = getPageType(url: currentUrl)
        
        isSearchMoreButton = false
        
        if pageType == MissionPageTypes.DBUrl1 ||
            pageType == MissionPageTypes.DBUrl2 ||
            pageType == MissionPageTypes.DBUrl3 ||
            pageType == MissionPageTypes.PlaceBookmark {
            
            parentVC?.visibleTitleBar(visible: true)
            switchTopButtonView(isvisible: false)
            var delay = 500
            var scriptNumber = 0
            
            switch pageType {
            case .DBUrl1:
                delay = 700
                guideType = NPlaceGuides.Stores
                switch joinMethod {
                case 1:
                    scriptNumber = 2
                case 2:
//                    if prevGuideType == guideType {
//                        guideType = NPlaceGuides.None
//                    } else {
//                        scriptNumber = 1
//                    }
                    guideType = NPlaceGuides.More
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 3
                    isSearchMoreButton = true
                    searchMore()
                default:
                    break
                }
            case .DBUrl2:
                if joinMethod == 1 {
                    if !visitBookmark {
                        guideType = NPlaceGuides.Alarm
                        isShowLastGuide = true
                    }
                    delay = 700
                    scriptNumber = 5
                } else if joinMethod == 2 {
                    delay = 1700
                    guideType = NPlaceGuides.Stores
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 4
                    LoadingIndicator.showLoading()
                }
            case .DBUrl3:
                if joinMethod == 2 {
                    if !visitBookmark {
                        guideType = NPlaceGuides.Alarm
                        isShowLastGuide = true
                    }
                    delay = 700
                    scriptNumber = 5
                }
            
//                if !visitBookmark {
//                    guideType = NPlaceGuides.PlaceMain
//                }
//                
//                delay = 1400
//                scriptNumber = 5
//                switchBottomView(isvisible: true)
//                switchOkButton(step: 1)
            case .PlaceBookmark:
                visitBookmark = true
            default:
                break
            }
            
            if guideType != NPlaceGuides.None {
                switchTopButtonView(isvisible: true)
            }
            
            if scriptNumber != 0 {
                callScript(number: scriptNumber, delay: delay)
            }
        } else {
            parentVC?.visibleTitleBar(visible: true)
            switchTopButtonView(isvisible: false)
            processOtherPages(pageType: pageType, url: url);
        }
        
        if guideType != NPlaceGuides.Stores && !isShowLastGuide {
            showGuide()
        }
    }
    
    func showFinalGuide() {
        isShowLastGuide = false
        if isAlarm {
            guideType = NPlaceGuides.Alarm
        } else {
            guideType = NPlaceGuides.Save
        }
        showGuide()
    }
    
    func webPageScript(url: String, diff: Int) {
        currentUrl = url
        guideType = NPlaceGuides.None
        let pageType = getPageType(url: currentUrl);
        
        if pageType == MissionPageTypes.DBUrl1 ||
            pageType == MissionPageTypes.DBUrl2 ||
            pageType == MissionPageTypes.PlaceBookmark {

            let delay = 1400
            let scriptNumber = 5
            
            switch pageType {
            case .DBUrl2:
                if !(bottomOKLabel.isHidden) {
                    // 현재 미션완료 상태라면
                    if endCheck {
                        // objectFound code 값이 계속 11 이라면 여전히 완료상태임을 확인
                    } else {
                        switchOkButton(step: 1)
                    }
                    endCheck = false
                }
                callScript(number: scriptNumber, delay: delay)
            default:
                break
            }
        }
    }
    
    
    @objc func saveClick() {
        if enableSave && !requestSend {
            enableSave = false
            requestSend = true
            LoadingIndicator.showLoading()
            sendOkRequest();
            parentVC?.issueTimer?.invalidate()
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
        bodyStackView.layoutIfNeeded()
    }
    func switchOkButton(step: Int) {
        switchBottomView(isvisible: true)
        switch step {
        case 1:
            bottomAlarmView.isHidden = false
            bottomSaveView.isHidden = true
            bottomOKLabel.isHidden = true
            bottomView.backgroundColor = .colorGrayCD
            bottomView.isUserInteractionEnabled = false
        case 2:
            bottomAlarmView.isHidden = true
            bottomSaveView.isHidden = false
            bottomOKLabel.isHidden = true
            bottomView.backgroundColor = .colorGrayCD
            bottomView.isUserInteractionEnabled = false
        case 3:
            bottomAlarmView.isHidden = true
            bottomSaveView.isHidden = true
            bottomOKLabel.isHidden = false
            bottomView.backgroundColor = .colorMain1
            bottomView.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    override func objectFound(code: Int, args: String) {
        Utils.consoleLog("objectFound", code, true)
        if code == 21 {
            LoadingIndicator.hideLoading()
            guideType = NPlaceGuides.Stores
            showGuide()
        } else if code == 11 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.enableSave = true
                self.endCheck = true
                self.switchOkButton(step: 3)
            }
        } else if code == 501 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.enableSave = false
                self.switchOkButton(step: 2)
            }
        } else if code == 601 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.enableSave = false
                self.switchOkButton(step: 1)
            }
        } else if code == 1000 {
            self.isAlarm = true
            if self.isShowLastGuide {
                self.showFinalGuide()
            }
        }
    }
    override func objectNotFound(code: Int) {
        Utils.consoleLog("objectNotFound", code, true)
        if code == 21 {
            LoadingIndicator.hideLoading()
        } else if code == 11 || code == 501 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.enableSave = false
                self.switchOkButton(step: 1)
            }
        } else if code == 1000 {
            self.isAlarm = false
            if self.isShowLastGuide {
                self.showFinalGuide()
            }
        }
    }
    
    @objc func showGuide() {
        lazy var guideVC = GuideViewController()
        let guideIsShowing = (guideVC.isViewLoaded && guideVC.view.window != nil)
        lazy var guideCommVC = GuideCommViewController()
        let GuideIsShowing = (guideCommVC.isViewLoaded && guideCommVC.view.window != nil)
        
        if guideType != NPlaceGuides.None {
            if GuideIsShowing {
                if guideCommVC.getGuideType() == NPlaceGuides.Fail.rawValue {
                    return
                }
            }
            
            if(guideType == NPlaceGuides.PlaceMain ||
               guideType == NPlaceGuides.PlaceShare ||
               guideType == NPlaceGuides.Alarm ||
               guideType == NPlaceGuides.Save ||
               guideType == NPlaceGuides.BlogMain) {
                Utils.consoleLog("guideType", guideType)
                if guideType == NPlaceGuides.Save {
                    guideVC.popupView.placeView.isHidden = false
                } else if guideType == NPlaceGuides.Alarm {
                    guideVC.popupView.alarmView.isHidden = false
                } else if guideType == NPlaceGuides.PlaceShare {
                    guideVC.popupView.blogView.isHidden = false
                } else if(guideType == NPlaceGuides.BlogMain) {
                    guideVC.popupView.blog2View.isHidden = false
                }
                
                if guideIsShowing && guideVC.getGuideType() == guideType.rawValue {
                    return
                }
                
                if guideIsShowing {
                    guideVC.dismiss(animated: true)
                }
                if GuideIsShowing {
                    guideCommVC.dismiss(animated: true)
                }
                
                guideVC.setGuideType(type: guideType.rawValue)
                
                guideVC.modalPresentationStyle = .overFullScreen
                parentVC?.present(guideVC, animated: false, completion: nil)
            } else {
                if guideType == NPlaceGuides.Login {
                    guideCommVC.popupView.loginView.isHidden = false
                } else if guideType == NPlaceGuides.Stores {
                    guideCommVC.popupView.goodsView.isHidden = false
                } else if guideType == NPlaceGuides.More {
                    guideCommVC.popupView.shopView.isHidden = false} else if guideType == NPlaceGuides.More {
                    guideCommVC.popupView.shopView.isHidden = false
                } else if guideType == NPlaceGuides.Fail {
                    guideCommVC.popupView.failView.isHidden = false
                }
                
                if GuideIsShowing && guideCommVC.getGuideType() == guideType.rawValue {
                    return
                }
                
                if guideIsShowing {
                    guideVC.dismiss(animated: true)
                }
                if GuideIsShowing {
                    guideCommVC.dismiss(animated: true)
                }
                
                guideCommVC.setGuideType(type: guideType.rawValue)
                
                guideCommVC.modalPresentationStyle = .overFullScreen
                parentVC?.present(guideCommVC, animated: false, completion: nil)
            }
        }
        
        prevGuideType = guideType
    }
}

