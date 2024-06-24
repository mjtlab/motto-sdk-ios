//
//  AdUnitPangle.swift
//  mottoapp
//
//  Created by MHD on 2024/05/22.
//

import Foundation

class AdUnitPangle: AdUnitBase {
    
    static let shared = AdUnitPangle()
    
    func initPangle() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if #available(iOS 14, *) {
//                ATTrackingManager.requestTrackingAuthorization { (status) in
//                    switch status {
//                    case .notDetermined, .restricted, .denied:
//                        // 광고 진행 못함. alert
//                        print("no ad")
//                    case .authorized:
//                        print("authorized") // 허용됨
//                        GADMobileAds.sharedInstance().start(completionHandler: nil)
//                    @unknown default:
//                        // 광고 진행 못함. alert
//                        print("error") // 알려지지 않음
//                    }
//                }
//            }
//        }
    }
}
