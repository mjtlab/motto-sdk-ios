//
//  AdUnitBase.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit
import Foundation


enum AdUnitType {
    case ADMOB
    case UNITY
    case VULGLE
    case PANGLE
    case ADPOPCORN
}

enum AdUnitResult {
    case LOAD_SUCCESS
    case LOAD_FAIL
    case SHOW_SUCCESS
    case SHOW_FAIL
    case REWARD_SUCCESS
    case CLICKED
    case DISMISSED
    case UNKNOWN_FAIL
}

class AdUnitBase: NSObject {
    
    var callVC: AdNetworkViewController?
    
    static func initAds() {
//        AdUnitAdmob.shared.initAdmob()
        AdUnitUnity.shared.initUnity()
        AdUnitVungle.shared.initVungle()
//        AdUnitPangle.shared.initPangle()
//        AdUnitAdpopcorn.shared.initPopcorn()
    }
    
    func loadAd(completion: @escaping(AdUnitResult) -> Void) {
        
    }
    func showAd(viewController: UIViewController, completion: @escaping(AdUnitResult) -> Void) {
        
    }
}
