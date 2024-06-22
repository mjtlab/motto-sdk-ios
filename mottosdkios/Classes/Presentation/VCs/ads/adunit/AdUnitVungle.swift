//
//  AdUnitVungle.swift
//  mottoapp
//
//  Created by MHD on 2024/05/22.
//

import UIKit
import VungleAdsSDK
import AppTrackingTransparency

class AdUnitVungle: AdUnitBase {
    
    static let shared = AdUnitVungle()
    
    var rewardedAd: VungleRewarded?
    var placementId: String? = "REWARDED_IOS-1467107"   // placement ID(IOS)
    
    func initVungle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { (status) in
                    switch status {
                    case .notDetermined, .restricted, .denied:
                        // 광고 진행 못함. alert
                        print("no ad")
                    case .authorized:
                        print("Vungle authorized") // 허용됨
                        VungleAds.initWithAppId("66627968506818ca1981f104") { error in  // App ID(IOS)
                            if error != nil {
                                print("Error initializing SDK")
                            } else {
                                print("Init is complete")
                            }
                        }

                        if (VungleAds.isInitialized()) {
                            print("SDK is initialized")
                        } else {
                            print("SDK is NOT initialized")
                        }
                    @unknown default:
                        // 광고 진행 못함. alert
                        print("error") // 알려지지 않음
                    }
                }
            }
        }
    }
    
    override func loadAd(completion: @escaping(AdUnitResult) -> Void) {
        if self.rewardedAd != nil {
            Utils.consoleLog("Clean up before load")
            
            self.rewardedAd?.delegate = nil
            self.rewardedAd = nil
        }
        
        guard let placementId = self.placementId else {
            completion(AdUnitResult.LOAD_FAIL)
            return
        }
        
        self.rewardedAd = VungleRewarded(placementId: placementId)
        self.rewardedAd?.delegate = self
        self.rewardedAd?.load()
        
        completion(AdUnitResult.LOAD_SUCCESS)
        Utils.consoleLog("Successed to load vungle ad")
        
        // Set incentivized rewarded text
        self.rewardedAd?.setAlertTitleText("Close Ad")
        self.rewardedAd?.setAlertBodyText("Are you sure you want to close the ad? You will lose out on your reward")
        self.rewardedAd?.setAlertContinueButtonText("Resume Ad")
        self.rewardedAd?.setAlertCloseButtonText("Close Ad")
    }
    override func showAd(viewController: UIViewController, completion: @escaping(AdUnitResult) -> Void) {
        if self.rewardedAd?.canPlayAd() != nil {
            self.rewardedAd?.present(with: viewController)
        }
    }
}


extension AdUnitVungle: VungleRewardedDelegate {
    // Ad load events
    func rewardedAdDidLoad(_ rewarded: VungleRewarded) {
        Utils.consoleLog("Successed to load vungle ad")
        callVC?.callbackAd(result: AdUnitResult.LOAD_SUCCESS)
    }
    
    func rewardedAdDidFailToLoad(_ rewarded: VungleRewarded, withError: NSError) {
        Utils.consoleLog("Failed to load vungle ad")
        callVC?.callbackAd(result: AdUnitResult.LOAD_FAIL)
    }
    
    // Ad Lifecycle Events
    func rewardedAdWillPresent(_ rewarded: VungleRewarded) {
        print("rewardedAdWillPresent")
    }
    
    func rewardedAdDidPresent(_ rewarded: VungleRewarded) {
        print("rewardedAdDidPresent")
    }
    
    func rewardedAdDidFailToPresent(_ rewarded: VungleRewarded, withError: NSError) {
        print("rewardedAdDidFailToPresent")
    }
    
    func rewardedAdDidTrackImpression(_ rewarded: VungleRewarded) {
        print("rewardedAdDidTrackImpression")
    }
    
    func rewardedAdDidClick(_ rewarded: VungleRewarded) {
        print("rewardedAdDidClick")
    }
    
    func rewardedAdWillLeaveApplication(_ rewarded: VungleRewarded) {
        print("rewardedAdWillLeaveApplication")
    }
    
    func rewardedAdDidRewardUser(_ rewarded: VungleRewarded) {
        print("rewardedAdDidRewardUser")
        callVC?.callbackAd(result: AdUnitResult.REWARD_SUCCESS)
    }
    
    func rewardedAdWillClose(_ rewarded: VungleRewarded) {
        print("rewardedAdWillClose")
    }
    
    func rewardedAdDidClose(_ rewarded: VungleRewarded) {
        print("rewardedAdDidClose")
    }
}
