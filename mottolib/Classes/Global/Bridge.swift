//
//  Bridge.swift
//  mottolib
//
//  Created by MHD on 2024/08/22.
//

import Foundation


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
