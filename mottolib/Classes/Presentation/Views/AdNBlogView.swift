//
//  AdNBlogView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then

class AdNBlogView: AdNPlaceView {
    var lastUrl = ""
    var entryLastPage = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        bottomBlogLabel.isHidden = false
        bottomSaveView.isHidden = true
        bottomAlarmView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        isSearchMoreButton = false
    }
    
    override func webPageFinished(url: String, diff: Int) {
        if detailUrls.count == 0 {
            return
        }
        
        lastUrl = currentUrl
        currentUrl = url
        guideType = NPlaceGuides.None
        
        parentVC?.nhomeView.isHidden = true
        bottomView.isHidden = true
        let pageType = getPageType(url: currentUrl)
        
        isSearchMoreButton = false
        
        if (pageType == MissionPageTypes.DBUrl1 ||
            pageType == MissionPageTypes.DBUrl2 ||
            pageType == MissionPageTypes.DBUrl3 ||
            pageType == MissionPageTypes.PlaceBlog) {
            
            parentVC?.visibleTitleBar(visible: true)
            topButtonView.isHidden = true
            
            var delay = 700
            var scriptNumber = 0
            
            switch pageType {
            case .DBUrl1:
                guideType = NPlaceGuides.Stores
                switch joinMethod {
                case 1:
                    scriptNumber = 2
                case 2:
                    guideType = NPlaceGuides.More
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 2
                    isSearchMoreButton = true
                    searchMore()
//                    if prevGuideType == guideType {
//                        guideType = NPlaceGuides.None
//                    } else {
//                        scriptNumber = 2
//                    }
                default:
                    break
                }
            case .DBUrl2:
                if joinMethod == 1 {
                    entryLastPage = true
                    guideType = NPlaceGuides.PlaceShare
                } else if joinMethod == 2 {
                    delay = 3000
                    guideType = NPlaceGuides.Stores
                    switchTopButtonView(isvisible: true)
                    scriptNumber = 4
                    LoadingIndicator.showLoading()
                }
            case .DBUrl3:
                if joinMethod == 2 {
                    entryLastPage = true
                    guideType = NPlaceGuides.PlaceShare
                }
            case .PlaceBlog:
                if !entryLastPage {
                    guideType = NPlaceGuides.Fail
                } else {
                    bottomView.isHidden = false
                    guideType = NPlaceGuides.BlogMain
                    delay = 1400
                    scriptNumber = 5
                }
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
            if pageType == .NaverLogin {
                guideType = NPlaceGuides.Login
                switchTopButtonView(isvisible: true)
                showGuide()
                return
            }
            switchTopButtonView(isvisible: false)
            
            if url.contains("m.blog.naver.com/PostList.nhn?blogId=") {
                // 이전 페이지가 스크랩페이지일 경우
                if lastUrl.contains("m.blog.naver.com/ScrapForm.naver") ||
                   lastUrl.contains("m.blog.naver.com/PostList.nhn?blogId=") {
                    // 블로그 스크랩 완료 페이지 진입
                    bottomView.isHidden = false
                    enableSave = true
                    switchOkButton(step: 2)
                    return
                }
            } else if url.contains("m.blog.naver.com/OpenScrapSuccess") {
                // 로그인하고 바로 스크랩시 진입하는 페이지이다.
                bottomView.isHidden = false
                enableSave = true
                switchOkButton(step: 2)
                return
            } else if url.contains("m.blog.naver.com") {
                return
            }
            
            bottomView.isHidden = true
            processOtherPages(pageType: pageType, url: url)
        }
        
        if guideType != NPlaceGuides.Stores {
            showGuide()
        }
    }
    
    override func objectFound(code: Int, args: String) {
        Utils.consoleLog("objectFound", code, true)
        if code == 21 {
            LoadingIndicator.hideLoading()
            guideType = NPlaceGuides.Stores
//            LoadingIndicator.showLoading()
        }
    }
    override func objectNotFound(code: Int) {
        Utils.consoleLog("objectNotFound", code, true)
        if code == 21 {
            LoadingIndicator.hideLoading()
        }
    }
    
    override func switchOkButton(step: Int) {
        switch step {
        case 1:
            bottomBlogLabel.isHidden = false
            bottomOKLabel.isHidden = true
            bottomView.backgroundColor = .gray
        case 2:
            bottomBlogLabel.isHidden = true
            bottomOKLabel.isHidden = false
            bottomView.backgroundColor = .red
            
            bottomView.isUserInteractionEnabled = true
            bottomOKLabel.isUserInteractionEnabled = true
        default:
            break
        }
    }
}
