//
//  Motto.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import Foundation
import UIKit


public class Motto {
    
    private init() {}
    
    public static var uid: String = ""
    static var adid: String = ""
    public static var pubkey: String = "motto"
    static var ticket: Int = 0
    static var myTicket: Int = 0
    static var currentRound: String = ""
    static var isLaunched: Bool = false
    static var pathWay: String = "VC"
    
    static var isDarkMode: Bool = true // false = light
    static var backgroundColor: UIColor = .clear
    static var mainColor: UIColor = .clear
    static var currentSharedUrl: String = ""
    
    static var pcode: String = ""
    static var store: String = ""
    static var adrole: Int = 0
    static var jmethod: Int = 1
    
    static var routeString = "DEBUG"
    static var currentDomain = Domains.debugURL
    
    /* 6개 번호 추첨 */
    static func startSlotNumber() -> [Int] {
        var numbers = Array(1...45)
        var selectedNumbers: [Int] = []
        
        for _ in 0...5 {
            let selectedIndex = Int.random(in: 0...numbers.count-1)
            let selectedNumber = numbers[selectedIndex]
            selectedNumbers.append(selectedNumber)
            numbers.remove(at: selectedIndex)
        }
        
        Utils.consoleLog("selectedNumbers", selectedNumbers, true)
        
        return selectedNumbers
    }
    
    static func allClear() {
        uid = ""
        adid = ""
        pubkey = ""
        ticket = 0
        currentRound = ""
        isLaunched = false
        
        isDarkMode = true // false = light
        backgroundColor = .clear
        mainColor = .clear
        currentSharedUrl = ""
        
        campaignInfoClear()
    }
    
    static func campaignInfoClear() {
        ticket = 0
        pcode = ""
        store = ""
        adrole = 0
        jmethod = 1
    }
    
    
    

    static func makeNewHomeViewController() -> UIViewController {
        let viewController = NewHomeViewController()
        return viewController
    }
    
    public static func create(_ route: String = "RELEASE") -> UIViewController {
        routeString = route
        
        if routeString.contains("DEBUG") {
            Motto.currentDomain = Domains.debugURL
        } else if routeString.contains("RELEASE") {
            Motto.currentDomain = Domains.releaseURL
        }
        let viewController = IndexViewController()
        return viewController
    }
        
    static func makeMyMottoViewController() -> UIViewController {
        let viewController = MyMottoViewController()
        return viewController
    }

    static func makePrizeNumberViewController() -> UIViewController {
        let viewController = PrizeNumberViewController()
        return viewController
    }

    static func makeHallOfFameViewController() -> UIViewController {
        let viewController = NewHallOfFameViewController()
        return viewController
    }
    
    static func makeAccountViewController() -> UIViewController {
        let viewController = AccountViewController()
        return viewController
    }
    
    
    static func IsDarkMode() -> Bool {
        return isDarkMode
    }
    public static func setIsDarkMode(_ isdarkmode: Bool) {
        isDarkMode = isdarkmode
    }
    static func getBackgroundColor() -> UIColor {
        return backgroundColor
    }
    public static func setBackgroundColor(_ backgroundcolor: UIColor) {
        backgroundColor = backgroundcolor
    }
    static func getMainColor() -> UIColor {
        return mainColor
    }
    public static func setMainColor(_ maincolor: UIColor) {
        mainColor = maincolor
    }
}
