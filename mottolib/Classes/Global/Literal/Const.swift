//
//  Const.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

enum Dialog {
    static let ok = "확인"
    static let cancel = "취소"
    static let retry = "다시하기"
    static let retry_ = "재시도"
}

enum Words {
    static let basePlayOrder = "제0000회 모또 도전!"
    static let dDay = "남은시간"
    static let dDayValue = "0일 00시간 00분"
    static let loadCount = "남은횟수 읽는중.."
    static let issueNumber = "모또 번호가 발급되었습니다.\n발급번호는 다시 뽑기가 가능합니다."
    static let notGood = "발급번호가 마음에 안든다면,"
    static let thisNumber = "이 번호로 하기"
    static let againNumber = "다시 뽑기"
    static let noneTicket = "[이용권 0장]"
    static let confirmMission = "미션 참여 완료 확인"
    
    static let save = "저장하기"
    static let alarm_save = "알람&저장"
    static let part = "참여하기"
    static let close = "닫기"
    static let share = "공유하기"
    static let shareAndCheck = "공유하기 확인하기"
    static let naverLogin = "네이버 로그인"
    static let findStore = "매장 찾아가기"
    static let clickMore = "더보기 클릭하기"
    static let failMission = "미션실패"
    static let tourStore = "매장 구경하기"
    static let alarm = "알림받기"
}

enum Navigation {
    static let terms = "이용약관"
    static let privacy = "개인정보취급방침"
    static let mottoInfo = "모또정보"
    static let userManage = "계정관리"
    static let userjoin = "회원가입"
    static let contact = "문의하기"
    static let home = "홈"
}

enum Title {
    static let serviceInfo = "서비스 이용안내"
    static let serverWorking = "서버 작업중"
    static let notice = "알림"
    static let breakTime = "휴식시간"
    static let attend = "출석체크"
    static let unMission = "미션수행 미완료"
    static let wrongAnswer = "정답오류"
    static let wrongProcess = "처리오류"
    static let failTicket = "이용권 획득 실패"
    static let failMission = "이용권 획득 실패"
    static let ad_network_loading_fail_title = "미션 접속 지연"
}

enum Description {
    static let needLogin = "회원가입이 필요한 서비스입니다.로그인 하시겠습니까?"
    static let needLoginShort = "로그인이 필요합니다."
    static let notWorking = "현재 모또 서비스가 일시 중지된 상태입니다. 잠시 후 다시 접속 바랍니다."
    static let needUpdate = "새버전이 나왔습니다.\n앱을 최신버전으로 업데이트 해주세요."
    static let networkTrouble = "모또 접속에 장애가 발생하였습니다.\n현재 버전이 최신 버전인지 \n앱스토어에서 확인바랍니다."
    static let failLogin = "로그인 실패"
    static let failJoin = "회원가입 실패"
    static let successJoin = "회원가입이 완료되었습니다."
    static let breakCharge = "현재 모또 이용권 충전은\n휴식시간 이므로 이용하실 수 없습니다."
    static let breakMotto = "현재 모또 발급은\n휴식시간 이므로 이용하실 수 없습니다."
    static let ticketing = "이용권 캠페인 생성중입니다.\n잠시후에 다시 확인해주세요"
    static let loadCampaign = "이용권 캠페인을 불러오는 중입니다.\n잠시만 기다려 주세요"
    static let receiveCampaign = "캠페인이 도착하였습니다"
    static let choiceBlog = "공유 클릭 > 블로그를 선택해주세요!"
    static let unMissioning = "미션이 수행되지 않았습니다.\n다시 한번 확인해주세요."
    static let retryAnswer = "정답이 틀립니다.\n다시 한번 확인해주세요."
    static let needTicket = "모또를 이용하시려면\n이용권이 필요합니다."
    static let failedMission = "미션에 실패했습니다.\n해당 페이지로 돌아가 미션을\n다시 수행해주세요."
    
    static let clickSave = "그림과 같이 저장하기를 눌러주세요!"
    static let clickAlarm = "알림받기를 먼저 진행 후\n저장하기를 눌러주세요"
    static let clickShare = "그림과 같이 공유 클릭 후 블로그를 선택해주세요."
    static let clickShareAndCheck = "그림과 같이 공유하기 확인 버튼을 눌러주세요."
    static let loginNaver = "네이버 앱 로그인이 아닌\n네이버 아이디와 비밀번호 입력으로\n로그인을 실행해주세요!"
    static let requestAlarm = "그림과 같이 '알림받기'를 눌러주세요"
    static let alarmMent = "를 먼저 눌러주세요!"
    static let trafficTip = "소식, 메뉴, 리뷰 등 탭 메뉴를 클릭하면 시간을 빠르게 줄일 수 있어요!"
    static let missionComplete = "미션을 완료하셨습니다"
    static let waitMission = "초 후 받을 수 있어요"
    static let finishMission = "미션에 실패했습니다.\n다른 미션을 우선 참여 부탁드립니다."
    static let networkError = "접속이 지연되고 있습니다.\n인터넷환경을 다시 확인 후 시도해보세요."
    static let ad_network_loading_fail_desc = "현재 해당 미션의 접속량이 많아 접속이 원활하지 않습니다.\n다른 미션에 먼저 참여해보세요."
    
    static let ad_cpc_guide_string1 = "광고"
    static let ad_cpc_guide_string2 = "를 눌러 페이지를 방문하세요"
    static let ad_cpc_guide_warning = "원하지 않을 시 ‘<’ 를 눌러주세요."
    
    static let autoKeyword = "검색어는 자동으로 입력됩니다"
    static let autoKeyword1 = "검색창"
    static let autoKeyword2 = "을 눌러 검색 하세요"
    
    static let more = "빨간박스"
    static let more1 = "더보기"
    static let more2 = "를 클릭 하세요"
    
    static let target = "빨간박스"
    static let target1 = "사이트"
    static let target2 = "를 클릭 하세요"
}

enum Domains {
    static let debugURL = "http://106.248.241.115/motto"
    static let releaseURL = "https://motto.kr"
    static let accountURL = Motto.currentDomain + "/pages/account/controller/account_main.php"
    static let loginURL = Motto.currentDomain + "/pages/account/view/login.html?pk="
    static let bannerURL = Motto.currentDomain + "/pages/main/view/top_banner.html?pk="
    static let infoURL = Motto.currentDomain + "/pages/main/view/bottom_area.html?pk="
    static let myMottoURL = Motto.currentDomain + "/pages/main/view/my_motto_v.html?pk="
    static let prizeNumberURL = Motto.currentDomain + "/pages/main/view/win_num_v.html?pk="
//    static let hallURL = Motto.currentDomain + "/pages/main/view/hall_of_fame_v.html?pk="
    static let hallURL = "https://m.blog.naver.com/mjt8333"
    static let missionURL = Motto.currentDomain + "/pages/ms/controller/ms_entry_v100.php?pk="
    static let instaURL = Motto.currentDomain + "/pages/campaign/controller/main_instagram.php?pk="
    static let campaignURL = Motto.currentDomain + "/pages/campaign/controller/"
    static let mainPath = "/pages/main/controller/"
    static let msPath = "/pages/ms/controller/"
}

enum MLDefine {
    static let MT_NPlace = 100                // 위치저장
    static let MT_NBlog = 110                 // 블로그공유
    static let MT_NFavorStore = 200           // 스토어찜
    static let MT_NFavorProduct = 201         // 상품찜
    static let MT_NSTraffic = 210             // NS 트래픽 유정수동
    static let MT_NPTraffic = 211;            // N 플레이스 트래픽
    static let MT_EndTraffic = 240            // 트래픽 종류 끝
    
    static let MT_InstaFollow = 120           // 인스타그램 팔로우
    static let MT_InstaLike = 121             // 인스타그램 좋아요
    static let MT_InstaSave = 122             // 인스타그램 저장
    static let MT_InstaTraffic = 213          // 인스타그램 트래픽
    
    static let CAMPAIGN_TYPE_SITE_TRAFFIC_NAVER = 220   // 사이트트래픽
    static let CAMPAIGN_TYPE_AUTO_KEYWORD_NAVER = 230   // 검색어자동완성
    
    static let CAMPAIGN_TYPE_AD_CPC = 410
    static let CAMPAIGN_TYPE_AD_CPV = 411
    static let CAMPAIGN_TYPE_AD_NETWORK = 420
    
    static let GoogleHomeUrl = "https://www.google.co.kr"
    static let NaverHomeUrl = "https://m.naver.com/"
    static let NaverMapUrl = "https://m.map.naver.com/"
    static let NaverMapUrl2 = "https://m.map.naver.com/#/search"
    static let NaverShoppingUrl = "https://m.shopping.naver.com/"
    static let NaverShoppingUrl2 = "https://shopping.naver.com/"
    static let NaverNidUrl = "https://nid.naver.com"
    static let TestServer = "http://106.248.241.115"
    
    static let pub_key = "motto"
}
