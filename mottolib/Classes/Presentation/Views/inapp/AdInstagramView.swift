//
//  AdInstagramView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/17.
//

import UIKit
import SnapKit
import Then
import Alamofire
import WebKit
import MottoFrameworks

enum InstagramCampaignType: Int {
    case FOLLOW = 120
    case LIKE = 121
    case SAVE = 122
    case TRAFFIC = 213
}
enum InstagramPageState: Int {
    case INIT
    case LOGIN      // instagram.com
    case HOME       // instagram.com
    case EXPLORE    // instagram.com/explore
    case SEARCHING     // instagram.com/explore/search
    case SEARCH_SUCCESS
    case TARGET_HOME // instagram.com/{accountId}
    case REELS_TAB
    case SEARCHING_POST // instagram.com/{accountId}
    case SEARCH_SUCCESS_POST // instagram.com/{accountId}
    case TARGET_POST // instagram.com/p/{targerID}
    case TARGET_REEL // instagram.com/reel/{targerID}

    case CHECKING_MISSION
    case FINDING_MISSION
    case COMPLETE
    case ALREADY_FAIL
    case FAIL

    case TRAFFIC_PROGRESS
    case TRAFFIC_COMPLETE

    case PROGRESS
    case END
}

enum InstagramUrlType: String {
    case HOME = "https://www.instagram.com/"
    case EXPLORE = "https://www.instagram.com/explore/"
    case SEARCH = "https://www.instagram.com/explore/search/"
    case TARGET_POST = "https://www.instagram.com/p/"
    case TARGET_REEL = "https://www.instagram.com/reel/"
    static func getTargetHomeUrl(accountId: String) -> String {
        return "\(InstagramUrlType.HOME.rawValue)\(accountId)/"
    }
    static func getTargetPostUrl(postId: String) -> String {
        return "\(InstagramUrlType.TARGET_POST.rawValue)\(postId)/"
    }
    static func getTargetReelUrl(postId: String) -> String {
        return "\(InstagramUrlType.TARGET_REEL.rawValue)\(postId)/"
    }
    static func getTargetReelsTabUrl(accountId: String) -> String {
        return "\(InstagramUrlType.HOME.rawValue)\(accountId)/reels/"
    }
}

enum ScriptResult: Int {
    case UNKNOWN_ERROR = 0

    case FOUND_LOGIN = 1
    case NOT_FOUND_LOGIN = 2

    case FOUND_SEARCH = 3
    case NOT_FOUND_SEARCH = 4

    case FOUND_INPUT = 5;
    case NOT_FOUND_INPUT = 6;

    case FOUND_ACCOUNT = 7
    case NOT_FOUND_ACCOUNT = 8

    case FOUND_REELS_TAB = 9
    case NOT_FOUND_REELS_TAB = 10

    case FOUND_POST = 20
    case NOT_FOUND_POST = 21
    case FAIL_FOUND_POST = 22

    case FOUND_FOLLOW = 100
    case FOUND_FOLLOWING = 101
    case NOT_FOUND_FOLLOW = 102

    case FOUND_LIKE = 200
    case FOUND_UNLIKE = 201
    case NOT_FOUND_LIKE = 202

    case FOUND_SAVE = 300
    case FOUND_DELETE = 301
    case NOT_FOUND_SAVE = 302
}

let JAVASCRIPT_INTERFACE_NAME = "AppInterfaceIos"
let HTTP_REQUEST_TYPE_REWARD = 1000

class AdInstagramView: AdBaseView {
    
    var timer: Timer?
    var operationType: String = ""  //ctype: inapp A, B, human C, D, E
    var campaignType: InstagramCampaignType = InstagramCampaignType.FOLLOW       //jtype: instagram follow: 120
    var methodType: Int = 1         //jmethod
    var pCode: String = ""          //pcode
    var name: String = ""           //name
    
    var guidePageUrl: String = ""
    var oldPageUrl: String = ""
    var currentPageUrl: String = ""
    var currentPageState: InstagramPageState = InstagramPageState.INIT
    
    var removeAnimationScript = """
    javascript: (function removeAnimation() {
        var elementList = document.querySelectorAll('*');
        for(var i = 0; i < elementList.length; i++) {
            var animations = elementList[i].getAnimations();
            if (animations != null && animations.length > 0) {
                if (animations[0].id == \"highlight-ani\") {
                    animations[0].cancel();
                    return;
                }
            }
        }
    }) ();
    """
    
    var isLoginPageScript: String = ""
    var findMagnifyingScript: String = ""
    var findInputScript: String = ""
    var findAccountScript: String = ""
    var findReelsTabScript: String = ""
    var findPostScript: String = ""
    var findMissionScript: String = ""
    var checkMissionScript: String = ""
    
    var searchKeyword: String = ""
    var accountId: String = ""
    var postId: String = ""
    var targetUrl: String = ""
    var isReelsTarget: Bool = false
    var additionalRewardList: [Int] = []
    
    var trafficDurations:Int = 0
    var currentTrafficTime: Int = 0
    
    // MARK: - View
    let contentsView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let topView = UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // account ============================================
    let accountView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel2 = UILabel().then {
        $0.text = "계정"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel3 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // account ============================================
    // past ===============================================
    let pastView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel4 = UILabel().then {
        $0.text = "이미 수행한 미션입니다."
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "FF4356")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // past ============================================
    // complete ============================================
    let completeView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    let flagImageView = UIImageView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.clipsToBounds = false
    }
    let infoLabel5 = UILabel().then {
        $0.text = "미션을 완료하셨습니다"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .left
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
    // complete ============================================
    // copy ============================================
    let copyView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    let labelView = UIView().then {
        $0.backgroundColor = .clear
    }
    let infoLabel6 = UILabel().then {
        $0.text = "복사"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel7 = UILabel().then {
        $0.text = " 후 검색란에 붙여넣기"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let copyButton = UIButton().then {
        $0.backgroundColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle("복사", for: .normal)
        $0.setTitleColor(UIColor(hexCode: "005BE3"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "005BE3"), for: .highlighted)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
    }
    // copy ============================================
    // input ==========================================
    let searchView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel8 = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel9 = UILabel().then {
        $0.text = "검색"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel10 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // input ============================================
    // login ============================================
    let loginView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    let infoLabel11 = UILabel().then {
        $0.text = "로그인"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel12 = UILabel().then {
        $0.text = "을 해주세요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    // login ============================================
    // mission ============================================
    let missionView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel13 = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel14 = UILabel().then {
        $0.text = "팔로우"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel15 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // mission ============================================
    // post ============================================
    let postView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel16 = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel17 = UILabel().then {
        $0.text = "게시물"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel18 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // post ============================================
    // progress ============================================
    let progressView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel19 = UILabel().then {
        $0.text = "처리중..."
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // progress ============================================
    // reels ============================================
    let reelsView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel20 = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel21 = UILabel().then {
        $0.text = "릴스탭"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let infoLabel22 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // reels ============================================
    // lens ============================================
    let lensView = UIStackView().then {
        $0.isHidden = true
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    let lensImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = Utils.podImage(context: AdInstagramView.self, img: "lens")
        $0.clipsToBounds = false
    }
    let infoLabel23 = UILabel().then {
        $0.text = "빨간박스 "
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel24 = UILabel().then {
        $0.text = "돋보기"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel25 = UILabel().then {
        $0.text = " 클릭"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    // lens ============================================
    // traffic ============================================
    let trafficView = UIStackView().then {
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
        $0.image = Utils.podImage(context: AdInstagramView.self, img: "traffic")
        $0.clipsToBounds = false
    }
    let infoLabel26 = UILabel().then {
        $0.text = "30"
        $0.backgroundColor = .clear
        $0.textColor = UIColor(hexCode: "48B6FF")
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let infoLabel27 = UILabel().then {
        $0.text = "초 후 받을 수 있어요"
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let trafficButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.setTitle("미션완료", for: .normal)
        $0.setTitleColor(.baseWhite, for: .normal)
        $0.setTitleColor(.baseWhite, for: .highlighted)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
    }
    // traffic ============================================
        
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(retryMission), name: .retrymission, object: nil)
        
        self.addSubview(contentsView)
        contentsView.addSubviews(topView, webView)
        topView.addSubviews(accountView, pastView, completeView, copyView, searchView, loginView, missionView,
                             postView, progressView, reelsView, lensView, trafficView)
        [infoLabel, infoLabel2, infoLabel3]
            .forEach(accountView.addArrangedSubview(_:))
        [infoLabel4]
            .forEach(pastView.addArrangedSubview(_:))
        [flagImageView, infoLabel5, completeButton]
            .forEach(completeView.addArrangedSubview(_:))
        [labelView, copyButton]
            .forEach(copyView.addArrangedSubview(_:))
        labelView.addSubviews(infoLabel6, infoLabel7)
        [infoLabel8, infoLabel9, infoLabel10]
            .forEach(searchView.addArrangedSubview(_:))
        [infoLabel11, infoLabel12]
            .forEach(loginView.addArrangedSubview(_:))
        [infoLabel13, infoLabel14, infoLabel15]
            .forEach(missionView.addArrangedSubview(_:))
        [infoLabel16, infoLabel17, infoLabel18]
            .forEach(postView.addArrangedSubview(_:))
        [infoLabel19]
            .forEach(progressView.addArrangedSubview(_:))
        [infoLabel20, infoLabel21, infoLabel22]
            .forEach(reelsView.addArrangedSubview(_:))
        [lensImageView, infoLabel23, infoLabel24, infoLabel25]
            .forEach(lensView.addArrangedSubview(_:))
        [leftView, trafficButton]
            .forEach(trafficView.addArrangedSubview(_:))
        leftView.addSubviews(trafficImageView, infoLabel26, infoLabel27)
        
        contentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        accountView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel2.snp.makeConstraints { make in
            make.left.equalTo(infoLabel.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel3.snp.makeConstraints { make in
            make.left.equalTo(infoLabel2.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        pastView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel4.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        completeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        flagImageView.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).inset(15)
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
        infoLabel5.snp.makeConstraints { make in
            make.left.equalTo(flagImageView.snp.right).offset(3)
            make.centerY.equalTo(topView.snp.centerY)
        }
        completeButton.snp.makeConstraints { make in
            make.right.equalTo(topView.snp.right).inset(15)
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(30)
        }
        
        copyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        labelView.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).inset(15)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel6.snp.makeConstraints { make in
            make.left.equalTo(labelView.snp.left)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel7.snp.makeConstraints { make in
            make.left.equalTo(infoLabel6.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        copyButton.snp.makeConstraints { make in
            make.right.equalTo(topView.snp.right).inset(15)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        searchView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel8.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel9.snp.makeConstraints { make in
            make.left.equalTo(infoLabel8.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel10.snp.makeConstraints { make in
            make.left.equalTo(infoLabel9.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        loginView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel11.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel12.snp.makeConstraints { make in
            make.left.equalTo(infoLabel11.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        missionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel13.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel14.snp.makeConstraints { make in
            make.left.equalTo(infoLabel13.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel15.snp.makeConstraints { make in
            make.left.equalTo(infoLabel14.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        postView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel16.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel17.snp.makeConstraints { make in
            make.left.equalTo(infoLabel16.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel18.snp.makeConstraints { make in
            make.left.equalTo(infoLabel17.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel18.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        reelsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        infoLabel20.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel21.snp.makeConstraints { make in
            make.left.equalTo(infoLabel20.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel22.snp.makeConstraints { make in
            make.left.equalTo(infoLabel21.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        lensView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        lensImageView.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
        infoLabel23.snp.makeConstraints { make in
            make.left.equalTo(lensImageView.snp.right).offset(3)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel24.snp.makeConstraints { make in
            make.left.equalTo(infoLabel23.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel25.snp.makeConstraints { make in
            make.left.equalTo(infoLabel24.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        trafficView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftView.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).inset(15)
            make.centerY.equalTo(topView.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        trafficImageView.snp.makeConstraints { make in
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(leftView.snp.left)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
        infoLabel26.snp.makeConstraints { make in
            make.left.equalTo(trafficImageView.snp.right).offset(3)
            make.centerY.equalTo(topView.snp.centerY)
        }
        infoLabel27.snp.makeConstraints { make in
            make.left.equalTo(infoLabel26.snp.right)
            make.centerY.equalTo(topView.snp.centerY)
        }
        trafficButton.snp.makeConstraints { make in
            make.right.equalTo(topView.snp.right).inset(15)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        
        completeButton.addTarget(self, action: #selector(requestReward), for: .touchUpInside)
        trafficButton.addTarget(self, action: #selector(requestReward), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        
        let campaignTypeValue = Motto.adrole
        switch campaignTypeValue {
        case 120:
            campaignType = InstagramCampaignType.FOLLOW
        case 121:
            campaignType = InstagramCampaignType.LIKE
        case 122:
            campaignType = InstagramCampaignType.SAVE
        case 213:
            campaignType = InstagramCampaignType.SAVE
        default:
            campaignType = InstagramCampaignType.TRAFFIC
        }
        
        let jmethod = Motto.jmethod
        methodType = jmethod > 0 ? jmethod : 1
        pCode = Motto.pcode
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        setState(state:InstagramPageState.END)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func retryMission() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = searchKeyword
        showToast("클립보드에 복사되었어요.", withDuration: 1.0, delay: 1.0)
    }
    
    func setState(state: InstagramPageState) {
        if currentPageState != state {
            currentPageState = state
            showGuidePopup()
        }
    }
    
    // 웹뷰 로딩상태에 따라 호출.
    func checkCurrentPageState() {
        let newPageUrl = webView.url?.absoluteString ?? ""
        if currentPageUrl != newPageUrl {
            currentPageUrl = newPageUrl
            
            switch currentPageUrl {
            case guidePageUrl:
                setState(state: InstagramPageState.INIT)
            case InstagramUrlType.HOME.rawValue:
                switch currentPageState {
                case InstagramPageState.INIT:
                    executeScript(script: isLoginPageScript)
                case InstagramPageState.LOGIN:
                    executeScript(script: findMagnifyingScript)
                default:
                    setState(state: InstagramPageState.INIT)
                    executeScript(script: isLoginPageScript)
                }
            case InstagramUrlType.EXPLORE.rawValue:
                setState(state: InstagramPageState.EXPLORE)
                executeScript(script: findInputScript, delay: 500)
            case InstagramUrlType.SEARCH.rawValue:
                setState(state: InstagramPageState.SEARCHING)
                executeScript(script: removeAnimationScript, delay: 90) //animation 제거용
                executeScript(script: findAccountScript, delay: 500)
            case InstagramUrlType.getTargetHomeUrl(accountId: accountId):
                if (isReelsTarget) {
                    setState(state: InstagramPageState.PROGRESS)
                    executeScript(script: findReelsTabScript, delay: 500)
                } else {
                    setState(state: InstagramPageState.SEARCHING_POST)
                    executeScript(script: findPostScript, delay: 500)
                }
            case InstagramUrlType.getTargetReelsTabUrl(accountId: accountId):
                executeScript(script: removeAnimationScript, delay: 90) //animation 제거용
                setState(state: InstagramPageState.SEARCHING_POST)
                executeScript(script: findPostScript, delay: 500)
            case InstagramUrlType.getTargetReelUrl(postId: postId):
                    if campaignType == InstagramCampaignType.TRAFFIC {
                        setState(state: InstagramPageState.TRAFFIC_PROGRESS)
                    } else {
                        setState(state: InstagramPageState.FINDING_MISSION)
                        executeScript(script: findMissionScript, delay: 500)
                    }
            default:
                if currentPageUrl.hasPrefix(InstagramUrlType.getTargetPostUrl(postId: postId)) {
                    if campaignType == InstagramCampaignType.TRAFFIC {
                        setState(state: InstagramPageState.TRAFFIC_PROGRESS)
                    } else {
                        if currentPageState != InstagramPageState.FINDING_MISSION
                            && currentPageState != InstagramPageState.CHECKING_MISSION {
                            setState(state: InstagramPageState.FINDING_MISSION)
                            executeScript(script: findMissionScript, delay: 500)
                        }
                    }
                }
                if currentPageUrl.contains("main_instagram.php") {
                    setState(state: InstagramPageState.INIT)
                }
                if currentPageState != InstagramPageState.INIT
                    && currentPageState != InstagramPageState.LOGIN {
                    setState(state: InstagramPageState.FAIL)
                }
            }
        }
    }
    
    func showTopView(isvisible: Bool) {
        topView.isHidden = !isvisible
        if isvisible {
            webView.snp.remakeConstraints { make in
                make.top.equalTo(topView.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        } else {
            webView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        webView.layoutIfNeeded()
    }
        
    func switchTopView(addview: UIView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            for subview in self.topView.subviews {
                subview.isHidden = true
            }
            addview.isHidden = false
            
            self.showTopView(isvisible: true)
        }
    }

    func showGuidePopup() {
        switch currentPageState {
        case InstagramPageState.LOGIN:
            switchTopView(addview: loginView)
        case InstagramPageState.HOME:
            switchTopView(addview: lensView)
        case InstagramPageState.EXPLORE:
            switchTopView(addview: searchView)
        case InstagramPageState.SEARCHING:
            switchTopView(addview: copyView)
        case InstagramPageState.SEARCH_SUCCESS:
            switchTopView(addview: accountView)
        case InstagramPageState.REELS_TAB:
            switchTopView(addview: reelsView)
        case InstagramPageState.SEARCH_SUCCESS_POST:
            switchTopView(addview: postView)
        case InstagramPageState.FINDING_MISSION, InstagramPageState.CHECKING_MISSION:
            switch campaignType {
            case InstagramCampaignType.FOLLOW :
                infoLabel14.text = "팔로우"
            case InstagramCampaignType.LIKE:
                infoLabel14.text = "좋아요"
            case InstagramCampaignType.SAVE:
                infoLabel14.text = "저장"
            default:
                infoLabel14.text = ""
            }
            switchTopView(addview: missionView)
        case InstagramPageState.TRAFFIC_PROGRESS:
            startTrafficTimer()
        case InstagramPageState.COMPLETE:
            if (campaignType == InstagramCampaignType.TRAFFIC) {
                return
            }
            switch campaignType {
            case InstagramCampaignType.LIKE:
                flagImageView.isHidden = false
                flagImageView.image = Utils.podImage(context: AdInstagramView.self, img: "like")
            case InstagramCampaignType.SAVE:
                flagImageView.isHidden = false
                flagImageView.image = Utils.podImage(context: AdInstagramView.self, img: "save")
            default:
                break
            }
            switchTopView(addview: completeView)
        case InstagramPageState.ALREADY_FAIL:
            switchTopView(addview: pastView)
        case InstagramPageState.INIT:
            showTopView(isvisible: false)
        case InstagramPageState.FAIL:
            showFailPopup()
        default:
            switchTopView(addview: progressView)
        }
    }
    
    func showFailPopup() {
        let viewcontroller = MissionFailViewController()
        viewcontroller.modalPresentationStyle = .overFullScreen
        parentVC?.present(viewcontroller, animated: false, completion: nil)
    }

    func executeScript(script: String, delay: Int = 400) {
        if script.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                guard let urlDecode = script.removingPercentEncoding else { return }
                self.webView.evaluateJavaScript(urlDecode) { result, error in
                    if let error {
                        Utils.consoleLog("evaluateJavaScript error", error)
                    }
                    Utils.consoleLog("evaluateJavaScript Received Data", result ?? "")
                }

            }
        }
    }
    
    func checkScriptResult(result: Int) {
        if (currentPageState == InstagramPageState.END) {
            return
        }
        
        switch result {
        case ScriptResult.UNKNOWN_ERROR.rawValue:
            showFailPopup()
        case ScriptResult.FOUND_LOGIN.rawValue:
            setState(state: InstagramPageState.LOGIN)
        case ScriptResult.NOT_FOUND_LOGIN.rawValue:
            executeScript(script: findMagnifyingScript)
        case ScriptResult.FOUND_SEARCH.rawValue:
            setState(state: InstagramPageState.HOME)
        case ScriptResult.NOT_FOUND_SEARCH.rawValue:
            executeScript(script: isLoginPageScript)
        case ScriptResult.FOUND_INPUT.rawValue:
            break
        case ScriptResult.NOT_FOUND_INPUT.rawValue:
            if (currentPageState == InstagramPageState.EXPLORE) {
                executeScript(script: findInputScript)
            }
        case ScriptResult.FOUND_ACCOUNT.rawValue:
                setState(state: InstagramPageState.SEARCH_SUCCESS)
        case ScriptResult.NOT_FOUND_ACCOUNT.rawValue:
            if (currentPageState == InstagramPageState.SEARCHING) {
                executeScript(script: findAccountScript, delay: 500)
            }
        case ScriptResult.FOUND_REELS_TAB.rawValue:
            setState(state: InstagramPageState.REELS_TAB)
        case ScriptResult.NOT_FOUND_REELS_TAB.rawValue:
            if (currentPageState == InstagramPageState.PROGRESS) {
                executeScript(script: findReelsTabScript, delay: 500)
            }
        case ScriptResult.FOUND_POST.rawValue:
            setState(state: InstagramPageState.SEARCH_SUCCESS_POST)
        case ScriptResult.NOT_FOUND_POST.rawValue:
            if (currentPageState == InstagramPageState.SEARCHING_POST) {
                executeScript(script: findPostScript, delay: 500)
            }
        case ScriptResult.FAIL_FOUND_POST.rawValue:
            if (currentPageState == InstagramPageState.SEARCHING_POST) {
                executeScript(script: findPostScript, delay: 500)
            }
        case ScriptResult.FOUND_FOLLOW.rawValue,
            ScriptResult.FOUND_LIKE.rawValue,
            ScriptResult.FOUND_SAVE.rawValue:
                if (currentPageState == InstagramPageState.SEARCH_SUCCESS_POST
                    || currentPageState == InstagramPageState.CHECKING_MISSION
                    || currentPageState == InstagramPageState.FINDING_MISSION
                    || currentPageState == InstagramPageState.COMPLETE) {
                    setState(state: InstagramPageState.CHECKING_MISSION)
                    executeScript(script: checkMissionScript, delay: 500)
                }
        case ScriptResult.FOUND_FOLLOWING.rawValue,
            ScriptResult.FOUND_UNLIKE.rawValue,
            ScriptResult.FOUND_DELETE.rawValue:
            if currentPageState.rawValue > InstagramPageState.SEARCH_SUCCESS_POST.rawValue {
                setState(state: InstagramPageState.COMPLETE)
                executeScript(script: removeAnimationScript, delay: 90)
                executeScript(script: checkMissionScript, delay: 500)
            }
        case ScriptResult.NOT_FOUND_FOLLOW.rawValue,
            ScriptResult.NOT_FOUND_LIKE.rawValue,
            ScriptResult.NOT_FOUND_SAVE.rawValue:
            if currentPageState.rawValue > InstagramPageState.SEARCH_SUCCESS_POST.rawValue {
                switch currentPageState {
                case InstagramPageState.COMPLETE:
                    executeScript(script: findMissionScript, delay: 500)
                case InstagramPageState.CHECKING_MISSION:
                    setState(state: InstagramPageState.FINDING_MISSION)
                    executeScript(script: findMissionScript, delay: 500)
                case InstagramPageState.FINDING_MISSION:
                    setState(state: InstagramPageState.CHECKING_MISSION)
                    executeScript(script: checkMissionScript, delay: 500)
                default:
                    break
                }
            }
        default:
            break
        }
    }

    func startTrafficTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleTrafficTimerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func handleTrafficTimerTick() {
        if (currentPageState != InstagramPageState.TRAFFIC_PROGRESS) {
            return
        }
        
        switchTopView(addview: trafficView)
        infoLabel26.text = "\(trafficDurations - currentTrafficTime)"
        
        if (currentTrafficTime < trafficDurations) {
            trafficButton.isEnabled = false
            infoLabel27.text = "초 후 받을 수 있어요"
        } else {
            trafficButton.isEnabled = true
            infoLabel26.isHidden = true
            infoLabel27.text = "미션을 완료하셨습니다"
            setState(state: InstagramPageState.COMPLETE)
        }
        
        currentTrafficTime += 1
    }
    
    @objc func requestReward() {
        let parameters = ["what": Global.MissionComplete, "pk": Motto.pubkey, "uid": Motto.uid, "pcode": pCode, "jmethod": String(joinMethod), "adid": Motto.adid, "ticket": Motto.ticket] as [String : Any]
        AF.request(
            Motto.currentDomain + Global.msPath + Global.MissionCompleteController,
            method: .post,
            parameters: parameters)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DefaultResponseModel.self) { response in
            guard let afModel = response.value else { return }
            self.requestSend = false
            LoadingIndicator.hideLoading()
            
            switch response.result {
            case .success(let value):
                Utils.consoleLog("Network Response SUCCESS(ms_done.php)", value)
                
                if afModel.result == -1 {
                    Utils.consoleLog("Network Response data FAIL(ms_done.php)")
                    self.showFailPopup()
                } else {
                    guard let responseData = afModel.data else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        NotificationCenter.default.post(name: .successfinish, object: responseData)
                        self.parentVC?.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                Utils.consoleLog("Network Response FAIL(ms_done.php)", error)
                self.showFailPopup()
            }
        }
    }
    


    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkCurrentPageState()
    }
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "MMJS" {
            super.userContentController(userContentController, didReceive: message)
            return
        }
        if message.name == "AppInterfaceIos", let messageBody = message.body as? [String: Any] {
            print("[AppInterfaceIos] Received message from Web: \(messageBody)")
            
            let messageString = String(describing: messageBody["message"] ?? "")
            let script1 = String(describing: messageBody["script1"] ?? "")
            let script2 = String(describing: messageBody["script2"] ?? "")
            let script3 = String(describing: messageBody["script3"] ?? "")
            let script4 = String(describing: messageBody["script4"] ?? "")
            let script5 = String(describing: messageBody["script5"] ?? "")
            let script6 = String(describing: messageBody["script6"] ?? "")
            let keyword = String(describing: messageBody["keyword"] ?? "")
            let account = String(describing: messageBody["account"] ?? "")
            let post = String(describing: messageBody["post"] ?? "")
            let target = String(describing: messageBody["target"] ?? "")
            let trafficTime = String(describing: messageBody["trafficTime"] ?? "")
            let param = String(describing: messageBody["param"] ?? "")
            
            switch messageString {
            case "onSetCommonScripts":
                isLoginPageScript = script1
                findMagnifyingScript = script2
                findInputScript = script3
                findAccountScript = script4
                findReelsTabScript = script5
                findPostScript = script6
                
            case "onSetMissionScripts":
                findMissionScript = script1
                checkMissionScript = script2
                
            case "onSetCampaignData":
                searchKeyword = keyword
                accountId = account
                postId = post
                targetUrl = target.removingPercentEncoding ?? ""
                isReelsTarget = targetUrl.contains("/reel/\(postId)")
                trafficDurations = trafficTime.count > 0 ? Int(trafficTime)! : 0
                
            case "onScriptResult":
                checkScriptResult(result: Int(param) ?? 0)
                
            case "onMoveInstagram":
                loadWebView(wv: webView, url: "https://www.instagram.com")
                
            default:
                break
            }
        }
    }
}
