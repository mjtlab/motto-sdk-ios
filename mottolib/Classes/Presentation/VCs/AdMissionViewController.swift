//
//  AdMissionViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//
// 결과값을 받는 방식이 다르다. 이 부분에서 정확히 받는지를 체크해야 한다.

import UIKit
import WebKit
import MottoFrameworks

class AdMissionViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - property
    var observer: NSObjectProtocol?
    
    var AdMissionVC: AdMissionViewController?
    var ms_data: MissionData?
    var moveView: AdBaseView?
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
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let frameView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let backButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setImage(Utils.podImage(context: AdMissionViewController.self, img: "ic_arrow_left"), for: .normal)
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
    let nhomeView = GuideNplaceHomeView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        
        AdMissionVC = self
    }
    required init?(coder: NSCoder) { fatalError() }
    deinit {
        trafficTimer?.invalidate()
        issueTimer?.invalidate()
        
        // 모든 옵저버 제거
        NotificationCenter.default.removeObserver(self)
        
        Utils.consoleLog("VC deinit", "AdMissionViewController")
    }

    // MARK: - view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 모든 옵저버 제거
//        NotificationCenter.default.removeObserver(self)
        // 특정 옵저버 제거
        //NotificationCenter.default.removeObserver(self, name: ClickNumberNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
                                                                                               
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Motto.campaignInfoClear()
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                          object: nil,
                                                          queue: .main) {
            [unowned self] notification in
            // background --> foreground
            Motto.currentSharedUrl = UIPasteboard.general.string ?? ""
            if Motto.currentSharedUrl.starts(with: "http") {
                Utils.consoleLog("Motto.currentSharedUrl", Motto.currentSharedUrl, true)
                if Motto.currentSharedUrl != "" {
                    if Motto.pathWay == "VW" {
                        // 서브뷰가 있다는 판단. 그곳에서 다음을 수행.
                        moveView!.webView.evaluateJavaScript("javascript:popupAnswerWithSharedText('\(String(describing: Motto.currentSharedUrl.removingPercentEncoding ?? ""))');")
                        
                        Motto.currentSharedUrl = ""
                    }
                }
            }
        }
        
        view.backgroundColor = .baseWhite
        view.addSubviews(contentsView, nhomeView)
        contentsView.addSubview(bodyStackView)
        [titleTopView, frameView]
            .forEach(bodyStackView.addArrangedSubview(_:))
//        bodyStackView.addSubviews(
//            titleTopView,
//            frameView
//        )
        titleTopView.addSubviews(
            backButton,
            titleLabel
        )
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
        nhomeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
        }
        view.keyboardLayoutGuide.topAnchor.constraint(equalTo: nhomeView.bottomAnchor).isActive = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(sendResult), name: .sendResult, object: nil)
        
        // back action
        backButton.addTarget(self, action: #selector(setBackAction), for: .touchUpInside)
        
        Motto.ticket = ms_data?.ticket ?? 0
        Motto.pcode = ms_data?.pcode ?? ""
        Motto.store = ms_data?.store ?? ""
        Motto.adrole = ms_data?.adrole ?? 0
        Motto.jmethod = ms_data?.jmethod ?? 0
        
        Utils.consoleLog("Motto Info","\(Motto.ticket),\(Motto.pcode),\(Motto.store),\(Motto.adrole),\(Motto.jmethod)", true)
        
        titleLabel.text = Motto.store
        
        DispatchQueue.main.async {
            self.startCampaign()
        }
    }
    
//    @objc func sendResult(_ notification: Notification) {
//        // 미션 홈 화면으로 다시 데이터 전달
//        Utils.consoleLog("notification.object", notification.object ?? "", true)
//        
//        self.dismiss(animated: false) {
//            NotificationCenter.default.post(name: .successfinish, object: notification.object)
//            NotificationCenter.default.removeObserver(self)
//        }
//    }
    
    func startCampaign() {
        var urlString = Motto.currentDomain + Global.missionURL
        Motto.pathWay = "VC"
        
        // 캠페인 화면 변경
        switch Motto.adrole {
        case Global.CAMPAIGN_TYPE_AUTO_KEYWORD_NAVER:
            let viewcontroller = AutoKeywordViewController()
            viewcontroller.modalPresentationStyle = .overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
            
            return
        case Global.CAMPAIGN_TYPE_SITE_TRAFFIC_NAVER:
            let viewcontroller = if Motto.jmethod < 3 {
                SiteTrafficInappViewController()
            } else {
                SiteTrafficViewController()
            }
            viewcontroller.modalPresentationStyle = .overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
            
            return
        case Global.CAMPAIGN_TYPE_AD_NETWORK:
//            let viewcontroller = AdUnitAdmob()
            let viewcontroller = AdNetworkViewController()
            viewcontroller.modalPresentationStyle = .overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
            
            return
        case Global.CAMPAIGN_TYPE_AD_CPC:
            let viewcontroller = AdCpcViewController()
            viewcontroller.modalPresentationStyle = .overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
            
            return
        case Global.CAMPAIGN_TYPE_AD_CPV:
            let viewcontroller = AdCpvViewController()
            viewcontroller.modalPresentationStyle = .overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
//            
            return
        case Global.MT_InstaFollow,Global.MT_InstaLike,Global.MT_InstaSave,Global.MT_InstaTraffic:
            break
        default:
            break
        }
        
        if Motto.jmethod > 2 {
            let viewcontroller = HumanNaverViewController()
            viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//            self.present(viewcontroller, animated: false, completion: nil)
            guard let pvc = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                pvc.present(viewcontroller, animated: false, completion: nil)
                NotificationCenter.default.removeObserver(self)
            }
            
            return
        } else {
            switch Motto.adrole {
            case Global.MT_NPlace:
                moveView = AdNPlaceAlarmSaveView()
//                moveView = AdNPlaceView()
                startIssueCheckTimer()
            case Global.MT_NBlog:
                moveView = AdNBlogView()
            case Global.MT_NPTraffic:
                moveView = AdNPTrafficView()
                startPageCheckTimer()
            case Global.MT_NFavorProduct, Global.MT_NFavorStore:
                moveView = AdNFavorView()
            case Global.MT_NSTraffic:
                moveView = AdNSTrafficView()
            case Global.MT_InstaFollow,Global.MT_InstaLike,Global.MT_InstaSave,Global.MT_InstaTraffic:
                moveView = AdInstagramView()
                urlString = Motto.currentDomain + Global.instaURL
                
                startPageCheckTimer()
            default:
                moveView = AdHumanView()
            }
        }
        
        Utils.consoleLog("moveView", moveView?.description ?? "", true)
        
        urlString = urlString + Motto.pubkey + "&uid=\(Motto.uid)&pcode=\(String(describing: Motto.pcode))&adrole=\(String(describing: Motto.adrole))&jmethod=\(String(describing: Motto.jmethod))"
//        urlString = "https://www.instagram.com"
        Utils.consoleLog("urlString", urlString, true)
        
        frameView.addSubview(moveView!)
        moveView!.parentVC = AdMissionVC
        moveView!.snp.makeConstraints { make in
            make.top.equalTo(titleTopView.snp.bottom)
            make.left.equalTo(contentsView.snp.left)
            make.right.equalTo(contentsView.snp.right)
            make.bottom.equalTo(contentsView.snp.bottom)
        }
        // webview load
        moveView!.loadWebView(wv: moveView!.webView, url: urlString)
        Motto.pathWay = "VW"
    }
    
    @objc func setBackAction() {
        if Motto.pathWay == "VW" {
            if moveView!.webView.canGoBack {
                moveView!.webView.goBack()
            } else {
                nhomeView.isHidden = true
                moveView?.removeFromSuperview()
                trafficTimer?.invalidate()
                issueTimer?.invalidate()
                self.dismiss(animated: true) {
                    NotificationCenter.default.removeObserver(self)
                }
            }
        } else {
            self.dismiss(animated: false) {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    func goBack() {
        setBackAction()
    }
    
    func visibleTitleBar(visible: Bool) {
        titleTopView.isHidden = !visible
    }
    
    
    
    // MARK: - Page move Check
    weak var trafficTimer: Timer?
    func startPageCheckTimer() {
        trafficTimer?.invalidate()
        
        self.trafficTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkWebViewURL), userInfo: nil, repeats: true)
    }
    @objc func checkWebViewURL() {
        if let url = moveView?.webView.url {
            let tempUrl = url.absoluteString.replacingOccurrences(of: "%20", with: "")
            let cuUrl = moveView?.currentUrl
            
            if moveView is AdInstagramView {
                (moveView as! AdInstagramView).checkCurrentPageState()
            } else if moveView is AdNPTrafficView {
                if cuUrl != tempUrl {
                    moveView?.oldUrl = url.absoluteString
                    let currentTime = Double(NSDate().timeIntervalSince1970 * 1000)
                    let diff = currentTime - (moveView?.pageFinishedTime ?? 0)
                    moveView?.pageFinishedTime = currentTime
                    
                    (moveView as! AdNPTrafficView).webPageFinished(url: tempUrl, diff: Int(diff));
                }
            }
        }
    }
    // MARK: - Page issue Check
    weak var issueTimer: Timer?
    func startIssueCheckTimer() {
        issueTimer?.invalidate()
        
        self.issueTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkIssue), userInfo: nil, repeats: true)
    }
    @objc func checkIssue() {
        if let url = moveView?.webView.url {
            let tempUrl = url.absoluteString.replacingOccurrences(of: "%20", with: "")
            let cuUrl = moveView?.currentUrl
            let currentTime = Double(NSDate().timeIntervalSince1970 * 1000)
            let diff = currentTime - (moveView?.pageFinishedTime ?? 0)
            
            if moveView is AdNPlaceView {
                (moveView as! AdNPlaceView).webPageScript(url: cuUrl!, diff: Int(diff))
            }
            if moveView is AdNPlaceAlarmSaveView {
                (moveView as! AdNPlaceAlarmSaveView).webPageScript(url: cuUrl!, diff: Int(diff))
            }
        }
    }
}
