//
//  AdUnitUnity.swift
//  mottoapp
//
//  Created by MHD on 2024/05/22.
//

import Foundation
import AppTrackingTransparency
import UnityAds
import MottoFrameworks


class AdUnitUnity: AdUnitBase {
    
    static let shared = AdUnitUnity()
    
    var placementId: String? = Global.UnityPlacementId   // placement ID(IOS)
    
    func initUnity() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { (status) in
                    switch status {
                    case .notDetermined, .restricted, .denied:
                        // 광고 진행 못함. alert
                        print("no ad")
                    case .authorized:
                        print("Unity authorized") // 허용됨
                        // UnityAds
                        UnityAds.initialize(Global.UnityAdsInitializeKey, testMode: true)
                    @unknown default:
                        // 광고 진행 못함. alert
                        print("error") // 알려지지 않음
                    }
                }
            }
        }
    }
    
    override func loadAd(completion: @escaping(AdUnitResult) -> Void) {
        guard let placementId = self.placementId else {
            completion(AdUnitResult.LOAD_FAIL)
            return
        }
        
        UnityAds.load(placementId, loadDelegate: self)
    }
    override func showAd(viewController: UIViewController, completion: @escaping(AdUnitResult) -> Void) {
        guard let placementId = self.placementId else {
            completion(AdUnitResult.LOAD_FAIL)
            return
        }
        
        UnityAds.show(viewController, placementId: placementId, showDelegate: self)
    }
}


//extension AdUnitUnity {
extension AdUnitUnity: UnityAdsInitializationDelegate, UnityAdsLoadDelegate, UnityAdsShowDelegate {
    func initializationComplete() {
        Utils.consoleLog("initializationComplete")
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        Utils.consoleLog(message)
    }
    
    func unityAdsAdLoaded(_ placementId: String) {
        Utils.consoleLog(placementId)
        callVC?.callbackAd(result: AdUnitResult.LOAD_SUCCESS)
    }
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        Utils.consoleLog(placementId + "///" + message)
        callVC?.callbackAd(result: AdUnitResult.LOAD_FAIL)
    }
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        Utils.consoleLog(placementId)
        
        if state == UnityAdsShowCompletionState.showCompletionStateCompleted {
            callVC?.callbackAd(result: AdUnitResult.REWARD_SUCCESS)
        }
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        Utils.consoleLog(placementId + "///" + message)
    }
    
    func unityAdsShowStart(_ placementId: String) {
        Utils.consoleLog(placementId)
    }
    
    func unityAdsShowClick(_ placementId: String) {
        Utils.consoleLog(placementId)
    }
}
