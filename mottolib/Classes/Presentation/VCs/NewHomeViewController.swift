//
//  NewHomeViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import WebKit
import Alamofire
import SnapKit

final class NewHomeViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UICollectionViewDelegate, WKScriptMessageHandler {

    var sloting = false
    var missionData: MissionData?
    let numbers = Array(1...46)
    var slotCount = 0
//    var isViewDid = true
    var selectedNumber: [Int] = [0,0,0,0,0,0]
    private var timer = Timer()
    private var noticeTimer = Timer()
    var notiDataSource: [String] = ["이용권 획득에 참여해보세요"]
    var timerExcute = DispatchWorkItem(block: {} )
    
    private var infoWebView: WKWebView!
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let contentsView = UIView().then {
        $0.backgroundColor = .backgroundLight
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let middleView = UIView().then {
        $0.backgroundColor = .baseWhite
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let topNoticeView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let leftMicImageView = UIImageView().then {
        $0.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_notice_light")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let topNoticeTableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.estimatedRowHeight = 54
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let mainTopImageView = UIImageView().then {
        $0.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_home_title_light2")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midBackgroundView = UIView().then {
        $0.backgroundColor = .clear
//        $0.layer.cornerRadius = 20
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor.clear.cgColor
//        $0.layer.shadowOpacity = 1
//        $0.layer.shadowColor = UIColor.lightGray.cgColor
//        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
//        $0.layer.shadowRadius = 2
//        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midMottoOrderLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = Words.basePlayOrder
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midInnerBackgroundView = UIView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midInnerTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = Words.dDay
        $0.font = UIFont.boldSystemFont(ofSize: 12.5)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midInnerTimeLabel = UILabel().then {
        $0.textColor = .blue
        $0.textAlignment = .center
        $0.text = Words.dDayValue
        $0.font = UIFont.boldSystemFont(ofSize: 12.5)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // charactor Ani
    let midAniView = UIImageView().then {
        guard let mImg_0 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_1 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_3 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_5 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_6 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_7 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_9 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_10 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_12 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_13 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_15 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_16 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_18 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_19 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_21 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_23 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_24 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_26 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_27 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_29 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_30 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_32 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_33 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_36 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_37 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_39 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_43 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_45 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_46 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_49 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_50 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_53 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_55 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_57 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        guard let mImg_60 = Utils.podImage(context: NewHomeViewController.self, img: "move_0000") else { return }
        $0.animationImages = [mImg_0, mImg_1, mImg_3, mImg_5, mImg_6, mImg_7, mImg_9, mImg_10, mImg_12, mImg_13, mImg_15, mImg_16, mImg_18, mImg_19, mImg_21, mImg_23, mImg_24, mImg_26, mImg_27, mImg_29, mImg_30, mImg_32, mImg_33, mImg_36, mImg_37, mImg_39, mImg_43, mImg_45, mImg_46, mImg_49, mImg_50, mImg_53, mImg_55, mImg_57, mImg_60]
        $0.animationDuration = 3
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midSlotBackgroundView = UIImageView().then {
        $0.image = Utils.podImage(context: NewHomeViewController.self, img: "bg_slot_machine")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var midSlotView_1 = UIPickerView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midInnerButtonBackgroundView = UIView().then {
        $0.isHidden = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor.clear.cgColor
//        $0.layer.shadowOpacity = 1
//        $0.layer.shadowColor = UIColor.lightGray.cgColor
//        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
//        $0.layer.shadowRadius = 2
        $0.layer.masksToBounds = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midInnerButtonBackgroundViewBack = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midBalloonView = UIButton().then {
        $0.isHidden = true
        $0.setBackgroundImage(Utils.podImage(context: NewHomeViewController.self, img: "motto_balloon_yellow"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midBalloonLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = Words.loadCount
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midStartButton = UIButton().then {
        $0.alignMainButton(context: NewHomeViewController.self, imageName: "icon_motto_draw", textValue: "모또 발급하기")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midTicketButton = UIButton().then {
        $0.alignMainButton(context: NewHomeViewController.self, imageName: "icon_ticket", textValue: "이용권 충전하기")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midMottoCompleteLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = Words.issueNumber
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.sizeToFit()
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midMottoNotGoodLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = Words.notGood
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.sizeToFit()
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midRetryButton = UIButton().then {
//        $0.backgroundColor = .baseRed
//        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        $0.setTitle(Words.againNumber, for: .normal)
//        $0.setTitleColor(.baseWhite, for: .normal)
//        $0.setTitleColor(.baseWhite, for: .highlighted)
//        $0.layer.cornerRadius = 15
//        $0.layer.masksToBounds = false
//        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.makeRetryButton(context:NewHomeViewController.self, imageName: "icon_retry", textValue: "다시 뽑기")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let midConfirmButton = UIButton().then {
//        $0.backgroundColor = .baseBlack
//        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        $0.setTitle(Words.thisNumber, for: .normal)
//        $0.setTitleColor(.baseWhite, for: .normal)
//        $0.setTitleColor(.baseWhite, for: .highlighted)
//        $0.layer.cornerRadius = 15
//        $0.layer.masksToBounds = false
//        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.makeConfirmButton(context:NewHomeViewController.self, imageName: "icon_check_circle", textValue: "이 번호로 하기")
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - View Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if sloting {
            // slot이 돌아가고 있을 때는 정지 초기화.
            timer.invalidate()
            timerExcute.cancel()
            
            initRouletteView()
            slotCount = 0
            
            DispatchQueue.main.async() {
                self.midInnerButtonBackgroundView.isHidden = false
                self.midInnerButtonBackgroundViewBack.isHidden = true
                
                self.midStartButton.isEnabled = true
                self.midTicketButton.isEnabled = true
            }
            
            sloting = false
        }
        
        super.viewWillDisappear(true)
        
        // 모든 옵저버 제거
//        NotificationCenter.default.removeObserver(self)
        // 특정 옵저버 제거
        //NotificationCenter.default.removeObserver(self, name: ClickNumberNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNoticeTableView.dataSource = self
        
        setDelegate()
        checkAttend()
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainRefresh), name: .refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goMission), name: .gomission, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(successFinish), name: .successfinish, object: nil)
        
        let config = WKWebViewConfiguration()
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        
        
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "CampaignInterfaceIos")
        contentController.add(self, name: "AppInterfaceIos")
        config.preferences = WKPreferences()
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = contentController
        infoWebView = WKWebView(frame: .zero, configuration: config)
        infoWebView.translatesAutoresizingMaskIntoConstraints = false
        infoWebView.scrollView.contentInsetAdjustmentBehavior = .never
        infoWebView.scrollView.isScrollEnabled = false
        infoWebView.allowsBackForwardNavigationGestures = true
        infoWebView.uiDelegate = self
        infoWebView.navigationDelegate = self
        
        
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
                
        scrollView.addSubview(
            contentsView
        )
        contentsView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        contentsView.addSubviews(
            topNoticeView,
            mainTopImageView,
            midBackgroundView,
            midInnerButtonBackgroundView,
            midInnerButtonBackgroundViewBack,
            infoWebView
        )
        topNoticeView.addSubviews(
            leftMicImageView,
            topNoticeTableView
        )
        midBackgroundView.addSubviews(
            midAniView,
            midSlotBackgroundView,
            midMottoOrderLabel,
            midInnerBackgroundView
        )
        midInnerBackgroundView.addSubviews(
            midInnerTitleLabel,
            midInnerTimeLabel
        )
        midSlotBackgroundView.addSubview(
            midSlotView_1
        )
        midInnerButtonBackgroundView.addSubviews(
            midTicketButton,
            midStartButton,
            midBalloonView
        )
        midInnerButtonBackgroundViewBack.addSubviews(
            midMottoCompleteLabel,
            midMottoNotGoodLabel,
            midRetryButton,
            midConfirmButton
        )
        midBalloonView.addSubview(midBalloonLabel)
        
        infoWebView.scrollView.contentInsetAdjustmentBehavior = .never
        
        topNoticeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(54)
        }
        leftMicImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        topNoticeTableView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(3)
            make.left.equalTo(leftMicImageView.snp.right)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(54)
        }
        mainTopImageView.snp.makeConstraints { make in
            make.top.equalTo(topNoticeView.snp.bottom).offset(28)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(42)
        }
        midBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(mainTopImageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
        midAniView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(170)
        }
        midSlotBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(midAniView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(70)
        }
        midSlotView_1.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.width.height.equalTo(60)
        }
        midMottoOrderLabel.snp.makeConstraints { make in
            make.top.equalTo(midSlotBackgroundView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(26)
        }
        midInnerBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(midMottoOrderLabel.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(142)
            make.height.equalTo(22)
        }
        midInnerTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(20)
        }
        midInnerTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(midInnerTitleLabel.snp.right).offset(8)
            make.height.equalTo(20)
        }
        midInnerButtonBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(midInnerBackgroundView.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
            make.height.equalTo(170)
        }
        midTicketButton.snp.makeConstraints { make in
            make.top.equalTo(midInnerButtonBackgroundView.snp.top).offset(35)
            make.left.equalTo(midInnerButtonBackgroundView.snp.left).offset(20)
            make.height.equalTo(120)
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        midStartButton.snp.makeConstraints { make in
            make.top.equalTo(midInnerButtonBackgroundView.snp.top).offset(35)
            make.right.equalTo(midInnerButtonBackgroundView.snp.right).inset(20)
            make.height.equalTo(120)
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        midBalloonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        midBalloonLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview()
        }
        midInnerButtonBackgroundViewBack.snp.makeConstraints { make in
            make.top.equalTo(midInnerBackgroundView.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
            make.height.equalTo(170)
        }
        midMottoCompleteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
//            make.height.equalTo(30)
        }
        midMottoNotGoodLabel.snp.makeConstraints { make in
            make.top.equalTo(midMottoCompleteLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        midRetryButton.snp.makeConstraints { make in
            make.top.equalTo(midInnerButtonBackgroundView.snp.top).offset(79)
            make.left.equalTo(midInnerButtonBackgroundView.snp.left).offset(20)
            make.height.equalTo(76)
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        midConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(midInnerButtonBackgroundView.snp.top).offset(79)
            make.right.equalTo(midInnerButtonBackgroundView.snp.right).inset(20)
            make.height.equalTo(76)
            make.width.equalToSuperview().multipliedBy(0.43)
        }
        infoWebView.snp.makeConstraints { make in
            make.top.equalTo(midInnerButtonBackgroundView.snp.bottom).offset(26)
            make.left.right.equalToSuperview()
        }
        
        infoWebView.topAnchor.constraint(equalTo: midInnerButtonBackgroundView.bottomAnchor, constant: 26).isActive = true
        infoWebView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: 0).isActive = true
        
        midAniView.startAnimating()

        infoWebView.uiDelegate = self
        infoWebView.navigationDelegate = self
        
        loadWebView(wv: infoWebView, url: Domains.infoURL + Motto.pubkey + "&uid=\(Motto.uid)")
        
        midSlotView_1.delegate = self
        midSlotView_1.dataSource = self
        midSlotView_1.isUserInteractionEnabled = false

        initRouletteView()
        
        // 모또 start
        midStartButton.addTarget(self, action: #selector(rouletteStart), for: .touchUpInside)
        // 충전하기
        midTicketButton.addTarget(self, action: #selector(getTicket), for: .touchUpInside)
        // 이번호로 하기
        midConfirmButton.addTarget(self, action: #selector(confirmRoulette), for: .touchUpInside)
        // 다시뽑기
        midRetryButton.addTarget(self, action: #selector(retryRoulette), for: .touchUpInside)
        
        let parameters: Parameters = ["what": "info"]
        AF.request(
            Motto.currentDomain + Domains.mainPath + "ord_times.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(ord_times.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(ord_times.php)")
                    
                    guard let responseMsg = afModel.message else { return }
                    let alert = UIAlertController(title: Title.notice, message: responseMsg, preferredStyle: .alert)
                    let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            exit(0)
                        }
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let responseData = afModel.data else { return }
                    // 이 값의 형태를 봐야한다. 안드로이드는 ","로 구분된 "회차,다음추첨일"의 형태로 온다.
                    // 우선 안드로이드와 동일하게 처리
                    if responseData.contains(",") {
                        let arr = responseData.components(separatedBy: ",")
                        Motto.currentRound = arr[0]
                        let thisPrizeDay = arr[1]
                        let arr2 = thisPrizeDay.components(separatedBy: "-")
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        guard let targetDate = formatter.date(from: "\(arr2[0])-\(arr2[1])-\(arr2[2]) 20:00:00") else {return}
                        
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                            let remainSeconds = Int(Date().distance(to:targetDate))
                            guard remainSeconds >= 0 else {
                                timer.invalidate()
                                return
                            }
                            
                            let s = remainSeconds % 60
                            var m = (remainSeconds - s) / 60
                            var h = m / 60
                            let d = h / 24
                            m -= (h * 60)
                            h -= (d * 24)
                            
//                            self?.midInnerTimeLabel.text = "\(d)일 \(String(format: "%02d", h))시 \(String(format: "%02d", m))분"
                            self?.midInnerTimeLabel.text = "\(d)일 \(h)시 \(m)분"
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.midMottoOrderLabel.text = "제 \(Motto.currentRound)회 모또 도전!"
                        }
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(ord_times.php)", error)
                
                let alert = UIAlertController(title: Title.notice, message: Description.networkTrouble, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        exit(0)
                    }
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        initTheme()
        
        initNotice()
    }
    
    func initNotice() {
        topNoticeTableView.rowHeight = 54
        let parameters: Parameters = ["what": "notice"]
        AF.request(
            Motto.currentDomain + Domains.mainPath + "notice_list.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(notice_list.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(notice_list.php)")
                    
                    guard let responseMsg = afModel.message else { return }
                    let alert = UIAlertController(title: Title.notice, message: responseMsg, preferredStyle: .alert)
                    let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            exit(0)
                        }
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let responseData = afModel.data else { return }
                    
                    if responseData.count > 0 {
                        let arr = responseData.components(separatedBy: "\n")
                        self.notiDataSource.removeAll()
                        for i in 0...arr.count-1 {
                            self.notiDataSource.append(arr[i])
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.notiTimerStart(duration: 1.0)
                        }
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(notice_list.php)", error)
                
                let alert = UIAlertController(title: Title.notice, message: Description.networkTrouble, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        exit(0)
                    }
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func notiTimerStart(duration: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            if self.notiDataSource.count > 1 {
                self.topNoticeTableView.scrollToBottom(completion: {
                    self.notiDataSource.append(self.notiDataSource[0])
                    self.notiDataSource.remove(at: 0)
                    
                    DispatchQueue.main.async { self.topNoticeTableView.reloadData() }
                    self.topNoticeTableView.scrollToTops(completion: {self.notiTimerStart(duration: 0)})
                })
            }
        }
    }
    
    func initTheme() {
        var currentBackgroudColor: UIColor = .clear
        if (Motto.getBackgroundColor() != .clear) {
            currentBackgroudColor = Motto.getBackgroundColor()
        } else {
            if (Motto.IsDarkMode()) {
                currentBackgroudColor = .backgroundDark
            } else {
                currentBackgroudColor = .backgroundLight
            }
        }
        
        view.backgroundColor = .clear
        contentsView.backgroundColor = currentBackgroudColor
        infoWebView.backgroundColor = currentBackgroudColor
        
        if (Motto.IsDarkMode()) {
            topNoticeView.backgroundColor = .colorWhite44
            leftMicImageView.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_notice_dark")
            topNoticeTableView.dequeueReusableCell(withIdentifier: "cell")?.textLabel?.textColor = .textColorDark
            mainTopImageView.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_home_title_dark2")
            midMottoOrderLabel.textColor = .textColorDark
            midInnerTitleLabel.textColor = .textColorDark
            midInnerTimeLabel.textColor = .textColorDark
        } else {
            topNoticeView.backgroundColor = .colorBlack0A
            leftMicImageView.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_notice_light")
            topNoticeTableView.dequeueReusableCell(withIdentifier: "cell")?.textLabel?.textColor = .textColorLight
            mainTopImageView.image = Utils.podImage(context: NewHomeViewController.self, img: "icon_home_title_light2")
            midMottoOrderLabel.textColor = .textColorLight
            midInnerTitleLabel.textColor = .textColorLight
            midInnerTimeLabel.textColor = .textColorLight
        }
        
        if (Motto.getMainColor() != .clear) {
            midConfirmButton.backgroundColor = Motto.getMainColor()
            if (!Motto.IsDarkMode()) {
                midInnerTimeLabel.textColor = Motto.getMainColor()
            }
        } else {
            midConfirmButton.backgroundColor = .red
            if (!Motto.IsDarkMode()) {
                midInnerTimeLabel.textColor = .homePrimary
            }
        }
    }
    
    @objc func mainRefresh() {
        loadMyTicket(isStartRoulette: true)
    }
    
    @objc func rouletteStart() {
//        if !isViewDid { return }
//        isViewDid = false
        
        if Motto.uid == "" {
            let alert = UIAlertController(title: Title.serviceInfo, message: Description.needLoginShort, preferredStyle: .alert)
            let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                // 로그인
//                self.isViewDid = true
//                self.midStartButton.isEnabled = true
//                self.midTicketButton.isEnabled = true
                let viewcontroller = AccountViewController()
                viewcontroller.dataFromVC = "SELF"
                viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(viewcontroller, animated: true, completion: nil)
            }
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
        } else {
            if isBreakMottoTime() {
                let alert = UIAlertController(title: Title.breakTime, message: Description.breakMotto, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
//                    self.isViewDid = true
                    self.dismiss(animated: false)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            } else {
                scrollView.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
                
                if Motto.myTicket <= 0 {
                    let alert = UIAlertController(title: Title.serviceInfo, message: Description.needTicket, preferredStyle: .alert)
                    let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
//                        self.isViewDid = true
                        self.dismiss(animated: false)
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                midStartButton.isEnabled = false
                midTicketButton.isEnabled = false
                
//                Motto.myTicket = Motto.myTicket - 1
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.midBalloonLabel.text = "남은횟수 \(Motto.myTicket)번"
//                }
                
                selectedNumber = Motto.startSlotNumber()
                trigger()
            }
        }
    }
    @objc func getTicket() {
//        if !isViewDid { return }
//        isViewDid = false
//        self.midTicketButton.isEnabled = false
//        self.midStartButton.isEnabled = false
//        self.midInnerButtonBackgroundViewBack.isHidden = true
//        self.midRetryButton.isEnabled = true
//        self.midConfirmButton.isEnabled = true
        
        if Motto.routeString.contains("DEBUG") {
            goMission()
            return
        }
        
        if Motto.uid == "" {
            let alert = UIAlertController(title: Title.serviceInfo, message: Description.needLoginShort, preferredStyle: .alert)
            let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                // 로그인
                let viewcontroller = AccountViewController()
                viewcontroller.dataFromVC = "SELF"
                viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(viewcontroller, animated: true, completion: nil)
            }
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
        } else {
            if isBreakTime() {
                let alert = UIAlertController(title: Title.breakTime, message: Description.breakCharge, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                    self.dismiss(animated: false)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            } else {
                requestMission()

                let viewcontroller = DialogViewController()
                viewcontroller.modalPresentationStyle = .overFullScreen
                self.present(viewcontroller, animated: false, completion: nil)
            }
        }
    }
    
    func isBreakMottoTime() -> Bool {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        let currentFrontString = formatter.string(from: date)
        formatter.dateFormat = "EEEE"
        let currentFrontString3 = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentFrontString2 = formatter.string(from: date)
        

        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        guard let todayDate = formatter.date(from: currentFrontString2) else {return true}
        
        guard let saturStartDate = formatter.date(from: "\(currentFrontString) 19:55:00") else {return true}
        guard let saturEndDate = formatter.date(from: "\(currentFrontString) 20:05:00") else {return true}
        
        if currentFrontString3 == "Saturday" {
            if todayDate.dateCompare(fromDate: saturEndDate) && !(todayDate.dateCompare(fromDate: saturStartDate)) {
                return true
            }
        }
        
        return false
    }
    func isBreakTime() -> Bool {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        let currentFrontString = formatter.string(from: date)
        formatter.dateFormat = "EEEE"
        let currentFrontString3 = formatter.string(from: date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentFrontString2 = formatter.string(from: date)
        

        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        guard let todayDate = formatter.date(from: currentFrontString2) else {return true}
        
        guard let startDate = formatter.date(from: "\(currentFrontString) 23:55:00") else {return true}
        guard let endDate = formatter.date(from: "\(currentFrontString) 00:05:00") else {return true}
        
        guard let saturStartDate = formatter.date(from: "\(currentFrontString) 19:50:00") else {return true}
        guard let saturEndDate = formatter.date(from: "\(currentFrontString) 20:00:00") else {return true}
        
        if todayDate.dateCompare(fromDate: endDate) {
            return true
        }
        if !(todayDate.dateCompare(fromDate: startDate)) {
            return true
        }
        if currentFrontString3 == "Saturday" {
            if todayDate.dateCompare(fromDate: saturEndDate) && !(todayDate.dateCompare(fromDate: saturStartDate)) {
                return true
            }
        }
        
        return false
    }
    
    @objc func retryRoulette() {
        midRetryButton.isEnabled = false
        midConfirmButton.isEnabled = false
//        if !isViewDid { return }
        
        initRouletteView()
//        midSlotView_1.reloadAllComponents()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.isViewDid = false
            self.selectedNumber = Motto.startSlotNumber()
            self.trigger()
        }
    }
    
    func initRouletteView() {
        DispatchQueue.main.async {
            self.midSlotView_1.selectRow(45, inComponent: 0, animated: false)
            self.midSlotView_1.selectRow(45, inComponent: 1, animated: false)
            self.midSlotView_1.selectRow(45, inComponent: 2, animated: false)
            self.midSlotView_1.selectRow(45, inComponent: 3, animated: false)
            self.midSlotView_1.selectRow(45, inComponent: 4, animated: false)
            self.midSlotView_1.selectRow(45, inComponent: 5, animated: false)
        }
    }
                         
    @objc func goMission() {
        if Motto.routeString.contains("DEBUG") {
            let viewcontroller = TestViewController()
            viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(viewcontroller, animated: false, completion: nil)
        } else {
            let viewcontroller = AdMissionViewController()
            viewcontroller.ms_data = missionData
            viewcontroller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(viewcontroller, animated: true, completion: nil)
        }
    }
                         
    @objc func successFinish(_ notification: Notification) {
        Utils.consoleLog("notification.object", notification.object, true)
        
        var getValue: Int = 0
        let getString = notification.object as! String
        var datas: [String] = []
        
        if getString.contains(",") {
            datas = getString.components(separatedBy: ",")
        } else {
            getValue = Int(getString) ?? 0
        }
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {     
            if datas.count == 3 {
                let alert = UIAlertController(title: "", message: "[이용권 \(datas[0])장]", preferredStyle: .alert)
//                let alert = UIAlertController(title: "", message: "[이용권 \(datas[0])장]\n\(datas[1])\(datas[2]) 적립", preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .default) {_ in
                    self.dismiss(animated: false)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            } else {
                if getValue > 0 {
                    let alert = UIAlertController(title: "", message: "[이용권 \(getValue)장]", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "확인", style: .default) {_ in
                        self.dismiss(animated: false)
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "", message: "이미 참여완료한 미션입니다!", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "확인", style: .default) {_ in
                        self.dismiss(animated: false)
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            self.loadMyTicket(isStartRoulette: true)
        }
    }
    
    func loadMyTicket(isStartRoulette: Bool) {
        if Motto.uid != "" {
            let parameters: Parameters = ["what": "my_ticket", "pk": Motto.pubkey, "uid": Motto.uid]
            AF.request(
                Motto.currentDomain + Domains.mainPath + "my_ticket_v2.php",
                method: .post,
                parameters: parameters)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: DefaultResponseModel.self) { response in
//                print(response)
                guard let afModel = response.value else { return }
                switch response.result {
                case .success(let value):
                    Utils.consoleLog("Network Response SUCCESS(my_ticket_v2.php)", value)
                    
                    if afModel.result == -1 {
                        Utils.consoleLog("Network Response data FAIL(my_ticket_v2.php)")
                    } else {
                        guard let responseData = afModel.data else { return }
                        var responseDataInt = Int(responseData) ?? 0
                        if responseDataInt < 0 {
                            responseDataInt = 0
                        }
                        Motto.myTicket = responseDataInt
                        // 숫자 리턴
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.midBalloonLabel.text = "남은횟수 \(responseDataInt)번"
                        }
                    }
                case .failure(let error):
                    Utils.consoleLog("Network Response FAIL(my_ticket_v2.php)", error)
                }
            }
            
            midBalloonView.isHidden = false
            midBalloonLabel.isHidden = false
        }
    }
    func checkAttend() {
        if Motto.uid != "" {
            let parameters: Parameters = ["what": "attend", "pk": Motto.pubkey, "uid": Motto.uid]
            AF.request(
                Motto.currentDomain + Domains.mainPath + "attends.php",
                method: .post,
                parameters: parameters)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: DefaultResponseModel.self) { response in
                guard let afModel = response.value else { return }
                switch response.result {
                case .success(let value):
                    Utils.consoleLog("Network Response SUCCESS(attends.php)", value)
                    
                    if afModel.result == -1 {
                        Utils.consoleLog("Network Response data FAIL(attends.php)")
                    } else {
                        guard let responseData = afModel.data else { return }
                        if responseData != "0" {
                            let alert = UIAlertController(title: Title.attend, message: "[이용권 \(responseData)장 \n지급되었습니다.]", preferredStyle: .alert)
                            let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                                self.dismiss(animated: false)
                            }
                            alert.addAction(yes)
                            self.present(alert, animated: true, completion: nil)
                        }

                        self.loadMyTicket(isStartRoulette: true)
                    }
                case .failure(let error):
                    Utils.consoleLog("Network Response FAIL(attends.php)", error)
                }
            }
        }
    }
    func requestJoin() {
        let parameters: Parameters = ["what": "join", "pk": Motto.pubkey, "uid": Motto.uid, "hp": "010-0000-0000"]
        AF.request(
            Motto.currentDomain + Domains.mainPath + "joinus.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(joinus.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(joinus.php)")
                } else {
                    guard let responseData = afModel.data else { return }
                    if responseData != "0" {
                        self.loadMyTicket(isStartRoulette: true)
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(joinus.php)", error)
            }
        }
    }
    func requestMission() {
        // 이 함수를 호출하는 조건을 명확히 하는 것이 우선이고.
        // 그 후에 해당 함수 호출
        let parameters: Parameters = ["what": "rand_camp", "pk": Motto.pubkey, "uid": Motto.uid]
        AF.request(
            Motto.currentDomain + Domains.mainPath + "ms_getone.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(ms_getone.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(ms_getone.php)")
                    
                    // 다이얼로그뷰 UI 변경처리. noti를 보낸다.
                    NotificationCenter.default.post(name: .mission, object: 0)
                    } else {
                    guard let responseData = afModel.data else { return }
                    if responseData.contains(",") {
                        let arr = responseData.components(separatedBy: ",")
                        guard let ticket = Int(arr[0]) else {return}
                        let pcode = arr[1]
                        let store = arr[2]
                        guard let adrole = Int(arr[3]) else {return}
                        guard let jmethod = Int(arr[4]) else {return}
                        
                        self.missionData = MissionData(ticket: ticket, pcode: pcode, store: store, adrole: adrole, jmethod: jmethod)
                        
                        // 다이얼로그뷰 UI 변경처리. noti를 보낸다.
                        NotificationCenter.default.post(name: .mission, object: ticket)
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(joinus.php)", error)
                
                let alert = UIAlertController(title: Title.notice, message: Description.networkError, preferredStyle: .alert)
                let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
                    self.dismiss(animated: false)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func confirmRoulette() {
        midRetryButton.isEnabled = false
        midConfirmButton.isEnabled = false
        
        let sortedSelectedNumbers = selectedNumber.sorted()
        let parameters: Parameters = ["what": "put_numbers", "pk": Motto.pubkey, "uid": Motto.uid, "num1": sortedSelectedNumbers[0], "num2": sortedSelectedNumbers[1], "num3": sortedSelectedNumbers[2], "num4": sortedSelectedNumbers[3], "num5": sortedSelectedNumbers[4], "num6": sortedSelectedNumbers[5]]
            
        AF.request(
            Motto.currentDomain + Domains.mainPath + "put_numbers_v2.php",
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            switch response.result {
            case .success(_):
                if afModel.result == -1 {
                    guard let responseMsg = afModel.message else { return }
                    let alert = UIAlertController(title: "알림", message: responseMsg, preferredStyle: .alert)
                    let yes = UIAlertAction(title: "확인", style: .default) {_ in
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // 남은횟수 재조회
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.loadMyTicket(isStartRoulette: true)
                    }
                    // 내모또 리프레쉬
                    NotificationCenter.default.post(name: .mymotto, object: nil)
                    
//                    self.midSlotView_1.reloadAllComponents()
                    self.initRouletteView()
                }
                
//                self.infoWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    if let wHeight: Int = height as? Int {
//                        self.infoWebView.snp.makeConstraints { make in
//                            make.height.equalTo(wHeight)
//                            make.top.equalTo(self.midInnerButtonBackgroundViewBack.snp.bottom).offset(26)
//                            make.left.right.equalToSuperview()
//                        }
//                    }
//                })
                
//                self.isViewDid = true
                self.midInnerButtonBackgroundView.isHidden = false
                self.midTicketButton.isEnabled = true
                self.midStartButton.isEnabled = true
                self.midInnerButtonBackgroundViewBack.isHidden = true
                self.midRetryButton.isEnabled = true
                self.midConfirmButton.isEnabled = true
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(put_numbers_v2.php)", error)
            }
        }
    }
    
    func trigger() {
        sloting = true
//        midInnerButtonBackgroundView.isHidden = true
//        midInnerButtonBackgroundViewBack.isHidden = true
        
//        infoWebView.snp.makeConstraints { make in
//            make.top.equalTo(self.midInnerButtonBackgroundView.snp.top)
//        }
//        infoWebView.layoutIfNeeded()
        
        timerExcute = DispatchWorkItem(block: {
            self.timer.invalidate()
            
            self.midSlotView_1.selectRow(self.selectedNumber[self.slotCount]-1, inComponent: self.slotCount, animated: false)
            if self.slotCount < 5 {
                self.slotCount = self.slotCount + 1
                
                self.trigger()
            } else {
                self.slotCount = 0
                
                self.midInnerButtonBackgroundView.isHidden = true
                self.midInnerButtonBackgroundViewBack.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.isViewDid = true
                    self.midInnerButtonBackgroundView.isHidden = true
                    self.midTicketButton.isEnabled = true
                    self.midStartButton.isEnabled = true
                    self.midInnerButtonBackgroundViewBack.isHidden = false
                    self.midRetryButton.isEnabled = true
                    self.midConfirmButton.isEnabled = true
                }
                
                self.sloting = false
            }
        } )
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(scrollRandomly), userInfo: nil, repeats: true);
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC), execute: timerExcute)
    }

    @objc func scrollRandomly() {
        let row:Int = Int.random(in: 0..<45)
        self.midSlotView_1.selectRow(row, inComponent: self.slotCount, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let wHeight: Int = height as? Int {
                        webView.snp.makeConstraints { make in
                            make.height.equalTo(wHeight)
                        }
                    }
                })
            }
        })
    }
    
    private func loadWebView(wv webView: WKWebView, url moveUrl: String) {
        guard let url = URL(string: moveUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setDelegate() {
        self.scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        midSlotView_1.subviews[1].isHidden = true
    }
    
    var pickerData = [String]()
    var selectedRow: Int {
        return midSlotView_1.selectedRow(inComponent: 0)
    }
    
    
    // MARK: - 2차 renewal 추가
    @objc func changeToTheme() {
        if Motto.IsDarkMode() {
            // set dark mode
            
        } else {
            // set light mode
            
        }
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "AppInterfaceIos" || message.name == "CampaignInterfaceIos"), let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            let data = String(describing: messageBody["data"] ?? "")
            
            switch messageString {
            case "onStart":
                let missiondata = data.components(separatedBy: ",")
                self.missionData = MissionData(ticket: Int(missiondata[0])!, pcode: missiondata[1], store: missiondata[2], adrole: Int(missiondata[3])!, jmethod: Int(missiondata[4])!)
                
                self.goMission()
            default:
                break
            }
        }
    }
}

extension NewHomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 46
    }
}
extension NewHomeViewController: UIPickerViewDelegate {
    // 피커 뷰의 높이 설정
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        pickLabel2.layer.masksToBounds = true
        pickLabel2.layer.cornerRadius = 20
        pickLabel2.textAlignment = .center
//        if isViewDid {
//            pickLabel2.backgroundColor = .white
//            pickLabel2.text = "?"
//            pickLabel2.textColor = .black
//            pickLabel2.font = .systemFont(ofSize: 14, weight: .bold)
//            pickLabel2.numberOfLines = 0
//            pickLabel2.layer.borderWidth = 6
//            
//            switch component {
//            case 0:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "2E16BC").cgColor
//            case 1:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "fbdf24").cgColor
//            case 2:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "248efb").cgColor
//            case 3:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "f42837").cgColor
//            case 4:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "7b7b7b").cgColor
//            case 5:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "8ec146").cgColor
//            default:
//                pickLabel2.layer.borderColor = UIColor(hexCode: "2E16BC").cgColor
//            }
//            
//            pickLabel2.layoutIfNeeded()
//        } else {
            pickLabel2.backgroundColor = .white
        if row == 45 {
            pickLabel2.text = "?"
        } else {
            pickLabel2.text = String(numbers[row])
        }
            pickLabel2.textColor = .black
            pickLabel2.font = .systemFont(ofSize: 14, weight: .bold)
            pickLabel2.numberOfLines = 0
            pickLabel2.layer.borderWidth = 6
            
            switch row {
            case 0...9:
                pickLabel2.layer.borderColor = UIColor(hexCode: "fbdf24").cgColor
            case 10...19:
                pickLabel2.layer.borderColor = UIColor(hexCode: "248efb").cgColor
            case 20...29:
                pickLabel2.layer.borderColor = UIColor(hexCode: "f42837").cgColor
            case 30...39:
                pickLabel2.layer.borderColor = UIColor(hexCode: "7b7b7b").cgColor
            case 40...44:
                pickLabel2.layer.borderColor = UIColor(hexCode: "8ec146").cgColor
            case 45:
                switch component {
                case 0:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "2E16BC").cgColor
                case 1:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "fbdf24").cgColor
                case 2:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "248efb").cgColor
                case 3:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "f42837").cgColor
                case 4:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "7b7b7b").cgColor
                case 5:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "8ec146").cgColor
                default:
                    pickLabel2.layer.borderColor = UIColor(hexCode: "2E16BC").cgColor
                }
            default:
                pickLabel2.layer.borderColor = UIColor(hexCode: "fbdf24").cgColor
            }
//        }
        
        return pickLabel2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 45 {
            return "?"
        } else {
            return String(numbers[row])
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component, numbers[row])
    }
}




extension NewHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notiDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        DispatchQueue.main.async {
            cell.textLabel?.text = self.notiDataSource[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .clear
        }
        return cell
    }
}
extension UIScrollView {
    func scrollToBottom(completion: (() -> ())? = nil) {
        setValue(1.5, forKeyPath: "contentOffsetAnimationDuration")
        let bottomOffset = CGPoint(x: 0, y: 54.0)
//        Utils.consoleLog("cbottomOffset", bottomOffset)
        if(bottomOffset.y > 0) {
            setContentOffsets(offset: bottomOffset, animated: true, completion: completion)
        }
    }
    func scrollToTops(completion: (() -> ())? = nil) {
        setValue(0.3, forKeyPath: "contentOffsetAnimationDuration")
        setContentOffsets(offset: CGPoint(x: 0, y: 0), animated: false, completion: completion)
    }
    
    func setContentOffsets(offset: CGPoint, animated: Bool, completion: (() -> ())? = nil) {
        let keypath = "contentOffsetAnimationDuration"
        guard let duration = value(forKey: keypath) as? Double else { return }
        setContentOffset(offset, animated: animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
}
