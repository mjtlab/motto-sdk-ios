//
//  AdUnitAdmob.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import Foundation
//import GoogleMobileAds
import AppTrackingTransparency

class AdUnitAdmob: AdUnitBase {

//    static let shared = AdUnitAdmob()
//    
//    var interstitial: GADInterstitialAd?    // 전면광고
//    var rewardedAd: GADRewardedAd?          // 리워드
//
//    func initAdmob() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if #available(iOS 14, *) {
//                ATTrackingManager.requestTrackingAuthorization { (status) in
//                    switch status {
//                    case .notDetermined, .restricted, .denied:
//                        // 광고 진행 못함. alert
//                        print("no ad")
//                    case .authorized:
//                        print("Admob authorized") // 허용됨
//                        GADMobileAds.sharedInstance().start(completionHandler: nil)
//                    @unknown default:
//                        // 광고 진행 못함. alert
//                        print("error") // 알려지지 않음
//                    }
//                }
//            }
//        }
//    }
//    
//    override func loadAd(completion: @escaping(AdUnitResult) -> Void) {
//        let request = GADRequest()
//        
////        GADRewardedAd.load(withAdUnitID: "ca-app-pub-7193526914088525/7586098869",   // 리워드 실 ID(IOS)
//        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",   // 리워드 testID
//                               request: request) { [self] ad, error in
//            if let error = error {
//                Utils.consoleLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                completion(AdUnitResult.LOAD_FAIL)
//                return
//            }
//            rewardedAd = ad
//            rewardedAd?.fullScreenContentDelegate = self
//            
//            completion(AdUnitResult.LOAD_SUCCESS)
//            Utils.consoleLog("Successed to load interstitial ad")
//        }
//    }
//    override func showAd(viewController: UIViewController, completion: @escaping(AdUnitResult) -> Void) {
//        guard let rewardedAd = self.rewardedAd else {
//            Utils.consoleLog("Failed to load interstitial ad")
//            completion(AdUnitResult.SHOW_FAIL)
//            return
//        }
//        
//        rewardedAd.present(fromRootViewController: viewController, userDidEarnRewardHandler: {
//            // 여기서 저위의 클로저로 넘길 수 있나?
//            if let reward = self.rewardedAd?.adReward {
//                Utils.consoleLog("reward", "\(reward.amount) \(reward.type)")
//                completion(AdUnitResult.REWARD_SUCCESS)
//            }
//        })
//    }
////    override func loadRewardedAd(completion: (AdUnitResult) -> Void) {
////        let request = GADRequest()
////        
////        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",   // 전면광고 testID
////                               request: request) { [self] ad, error in
////            if let error = error {
////                Utils.consoleLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
////                completion(AdUnitResult.LOAD_FAIL)
////            }
////            interstitial = ad
////            interstitial?.fullScreenContentDelegate = self
////            
////            completion(AdUnitResult.LOAD_SUCCESS)
////            Utils.consoleLog("Successed to load interstitial ad")
////        }
////    }
//        
//        
//        
//        
//        // GADBannerView 인스턴스 생성
////        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
////        addBannerViewToView(bannerView)
////        
////        bannerView.adUnitID = "YOUR_AD_UNIT_ID" // 여기에 실제 광고 단위 ID를 넣으세요.
////        bannerView.rootViewController = self
////        bannerView.load(GADRequest())
//        
//    
//
//    
////    func addBannerViewToView(_ bannerView: GADBannerView) {
////        bannerView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(bannerView)
////        view.addConstraints(
////            [NSLayoutConstraint(item: bannerView,
////                                attribute: .bottom,
////                                relatedBy: .equal,
////                                toItem: bottomLayoutGuide,
////                                attribute: .top,
////                                multiplier: 1,
////                                constant: 0),
////             NSLayoutConstraint(item: bannerView,
////                                attribute: .centerX,
////                                relatedBy: .equal,
////                                toItem: view,
////                                attribute: .centerX,
////                                multiplier: 1,
////                                constant: 0)
////            ])
////    }
//}
//
//
//extension AdUnitAdmob: GADFullScreenContentDelegate {
//    // 전면광고
//    /// Tells the delegate that the ad failed to present full screen content.
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        Utils.consoleLog("Ad did fail to present full screen content.", error.localizedDescription)
//    }
//    
//    /// Tells the delegate that the ad will present full screen content.
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        Utils.consoleLog("Ad will present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad dismissed full screen content.
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        Utils.consoleLog("Ad did dismiss full screen content.")
//    }
}
