//
//  AdNFavorView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then
import WebKit
import MottoFrameworks

class AdNFavorView: AdCrawlingView {
    
    enum NFavorGuides: Int {
        case None = 0
        case ZzimMain = 1
        case AlarmMain = 2
        case Stores = 3
        case More = 4
        case Login = 8
        case Fail = 9
    }
    
    // MARK: - property
    var enableSave = false
    var visitBookmark = false
    var guideType = NFavorGuides.None
    
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
        $0.image = Utils.podImage(context: AdNFavorView.self, img: "btn_mission_info")
        $0.clipsToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let finishButton = UIButton().then {
        $0.isHidden = true
        $0.backgroundColor = .red
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle(Global.confirmMission, for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(bodyStackView)
        bodyStackView.addSubviews(topButtonView, webView, finishButton)
        
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
        finishButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        finishButton.addTarget(self, action: #selector(firstCallScript), for: .touchUpInside)
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
    
    
    @objc func firstCallScript() {
        callScript(number: 5, delay: 100)
    }
    
    func getPageTypeForException(url: String) -> MissionPageTypes {
        if joinMethod == 2 && url.contains(detailUrls[0]) {
            return MissionPageTypes.DBUrl1
        }
        return getPageType(url: url)
    }
    override func webPageFinished(url: String, diff: Int) {
        if detailUrls.count == 0 || diff < 500 {
            return
        }
        
        currentUrl = url
        guideType = NFavorGuides.None
        adrole = Motto.adrole
        
        parentVC?.nhomeView.isHidden = true
        switchTopButtonView(isvisible: false)
        switchFinishButton(isvisible: false)
        
        let pageType = getPageTypeForException(url: currentUrl)
        
        if pageType == MissionPageTypes.DBUrl1 ||
            pageType == MissionPageTypes.DBUrl2 ||
            pageType == MissionPageTypes.DBUrl3 ||
            pageType == MissionPageTypes.DBUrl4 {
            
            parentVC?.visibleTitleBar(visible: true)
            if adrole == Global.MT_NFavorProduct {
                zzimProcess(pageType: pageType)
            } else {
                alarmProcess(pageType: pageType)
            }
        } else {
            parentVC?.visibleTitleBar(visible: true)
            Utils.consoleLog("pageType", pageType)
            switch pageType {
            case .NaverLogin:
                guideType = NFavorGuides.Login
                switchTopButtonView(isvisible: true)
            case .OurServer:
                break
            case .NaverHome, .NaverShopping:
                Utils.consoleLog("joinMethod", joinMethod)
                Utils.consoleLog("adrole", adrole)
                Utils.consoleLog("adrole == MLDefine.MT_NFavorStore", adrole == Global.MT_NFavorStore)
                if joinMethod == 1 || joinMethod == 2 {
                    let skipLogic: Bool = (joinMethod == 2 && adrole == Global.MT_NFavorStore)
                    Utils.consoleLog("skipLogic", skipLogic)
                    if !skipLogic {
                        var searchKeyword: String = extractKeywordFromUrl(url: detailUrls[0])
                        searchKeyword = searchKeyword.replacingOccurrences(of: "+", with: " ")
                        if searchKeyword.count > 0 {
                            parentVC?.nhomeView.isHidden = false
                            parentVC?.nhomeView.keywordTextView.text = searchKeyword
                            parentVC?.nhomeView.keywordTextView.alignVerticallyCenter()
                            
                            if joinMethod == 1 || joinMethod == 2 {
                                callScript(number: 1, delay: 100)
                            } else {
                                setClipboardData(text: detailUrls[0])
                            }
                        }
                    }
                } else {
                    guideType = NFavorGuides.Fail
                }
            default:
                if(productKey.count > 0 && url.contains(productKey)) {
                    return
                }
                if url.contains(Global.NaverMapUrl) {
                    return
                }
                
                guideType = NFavorGuides.Fail
            }
        }
        
        if guideType != NFavorGuides.Stores {
            showGuide()
        }
    }
    
    @objc func showGuide() {
        lazy var favorVC = FavorViewController()
        let favorIsShowing = (favorVC.isViewLoaded && favorVC.view.window != nil)
        lazy var guideCommVC = GuideCommViewController()
        let GuideIsShowing = (guideCommVC.isViewLoaded && guideCommVC.view.window != nil)
        
        if guideType != NFavorGuides.None {
            if GuideIsShowing {
                if guideCommVC.getGuideType() == NFavorGuides.Fail.rawValue {
                    return
                }
                
                guideCommVC.dismiss(animated: false)
            }
            
            if favorIsShowing {
                favorVC.dismiss(animated: false)
            }
            
            if guideType == NFavorGuides.ZzimMain || guideType == NFavorGuides.AlarmMain {
                if(guideType == NFavorGuides.ZzimMain) {
                    if detailUrls.count == 3 && joinMethod == 2 {
                        favorVC.popupView.bodyImageZzimView.image = Utils.podImage(context: AdNFavorView.self, img: "btn_mission_info")
                    }
                    favorVC.popupView.alarmView.isHidden = true
                    favorVC.popupView.zzimView.isHidden = false
                } else if guideType == NFavorGuides.AlarmMain {
                    favorVC.popupView.alarmView.isHidden = false
                    favorVC.popupView.zzimView.isHidden = true
                }
                
                favorVC.setGuideType(type: guideType.rawValue)
                favorVC.modalPresentationStyle = .overFullScreen
                parentVC?.present(favorVC, animated: false, completion: nil)
            } else {
                if  guideType == NFavorGuides.Login {
                    guideCommVC.popupView.loginView.isHidden = false
                } else if guideType == NFavorGuides.Stores {
                    guideCommVC.popupView.goodsView.isHidden = false
                } else if guideType == NFavorGuides.More {
                    guideCommVC.popupView.shopView.isHidden = false
                } else if guideType == NFavorGuides.Fail {
                    guideCommVC.popupView.failView.isHidden = false
                }
                
                guideCommVC.setGuideType(type: guideType.rawValue)
                
                guideCommVC.modalPresentationStyle = .overFullScreen
                guideCommVC.viewFromVC = parentVC!
                parentVC?.present(guideCommVC, animated: false, completion: nil)
            }
        }
    }
    
    func zzimProcess(pageType: MissionPageTypes) {
        var scriptNumber: Int = 0
        let delay: Int = 1500
        
        switch pageType {
        case .DBUrl1:
            guideType = NFavorGuides.More
            scriptNumber = 2
        case .DBUrl2:
            guideType = NFavorGuides.Stores
            scriptNumber = 3
            LoadingIndicator.showLoading()
        case .DBUrl3, .DBUrl4:
            if detailUrls.count < 4 || pageType == MissionPageTypes.DBUrl4 {
                finishButton.isEnabled = true
                finishButton.isHidden = false
                guideType = NFavorGuides.ZzimMain
            } else {
                loadUrlWithDelay(url: detailUrls[3], delay: 300);
            }
        default:
            break
        }
        
        if guideType != NFavorGuides.None {
            switchTopButtonView(isvisible: true)
        }
        if scriptNumber != 0 {
            callScript(number: scriptNumber, delay: delay)
        }
    }

    func alarmProcess(pageType: MissionPageTypes) {
        var scriptNumber: Int = 0
        let delay: Int = 1500
        
        switch pageType {
        case .DBUrl1:
            switch joinMethod {
            case 1:
                guideType = NFavorGuides.More
                scriptNumber = 2
            case 2:
                finishButton.isEnabled = true
                switchFinishButton(isvisible: true)
                guideType = NFavorGuides.AlarmMain
            default:
                break
            }
        case .DBUrl2:
            if joinMethod == 1 {
                guideType = NFavorGuides.Stores
                scriptNumber = 3
                LoadingIndicator.showLoading()
            }
        case .DBUrl3:
            if joinMethod == 1 {
                finishButton.isEnabled = true
                switchFinishButton(isvisible: true)
                guideType = NFavorGuides.AlarmMain;
            }
        default:
            break
        }
        
        if guideType != NFavorGuides.None {
            switchTopButtonView(isvisible: true)
        }
        if scriptNumber != 0 {
            callScript(number: scriptNumber, delay: delay)
        }
    }
    
    override func objectFound(code: Int, args: String) {
        LoadingIndicator.hideLoading()
        if guideType == NFavorGuides.Stores {
            showGuide()
        }
        if code == 11 {
            if requestSend { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.requestSend = true
                LoadingIndicator.showLoading()
                self.sendOkRequest()
            }
        }
    }

    override func objectNotFound(code: Int) {
        LoadingIndicator.hideLoading()
        if guideType == NFavorGuides.Stores {
            guideType = NFavorGuides.Fail
            showGuide()
        }
        if(code == 11) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let alert = UIAlertController(title: Global.unMission, message: Global.unMissioning, preferredStyle: .alert)
                let yes = UIAlertAction(title: Global.ok, style: .default) {_ in
                    self.parentVC?.dismiss(animated: false)
                }
                alert.addAction(yes)
                self.parentVC?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func switchTopButtonView(isvisible: Bool) {
        topButtonView.isHidden = !isvisible
        if isvisible {
            webView.snp.remakeConstraints { make in
                make.top.equalTo(topButtonView.snp.bottom)
                make.left.right.equalToSuperview()
                if finishButton.isHidden {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalTo(finishButton.snp.top)
                }
            }
        } else {
            webView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                if finishButton.isHidden {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalTo(finishButton.snp.top)
                }
            }
        }
        
        webView.layoutIfNeeded()
    }
    func switchFinishButton(isvisible: Bool) {
        Utils.consoleLog("isvisible", isvisible)
        finishButton.isHidden = !isvisible
        if isvisible {
            webView.snp.remakeConstraints { make in
                if topButtonView.isHidden {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(topButtonView.snp.bottom)
                }
                make.left.right.equalToSuperview()
                make.bottom.equalTo(finishButton.snp.top)
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
}
