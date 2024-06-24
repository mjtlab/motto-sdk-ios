//
//  UIColor+.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )
    }
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    

    @nonobjc class var baseRed: UIColor {
        return UIColor(r: 255, g: 20, b: 60)
    }
    @nonobjc class var baseBlack: UIColor {
        return UIColor(r: 0, g: 0, b: 0)
    }
    @nonobjc class var baseWhite: UIColor {
        return UIColor(r: 255, g: 255, b: 255)
    }
    @nonobjc class var baseGray: UIColor {
        return UIColor(r: 239, g: 239, b: 239)
    }
    @nonobjc class var baseGray1: UIColor {
        return UIColor(r: 214, g: 214, b: 214)
    }
    @nonobjc class var baseGray2: UIColor {
        return UIColor(r: 156, g: 156, b: 156)
    }
    @nonobjc class var baseGray3: UIColor {
        return UIColor(r: 98, g: 98, b: 98)
    }
    @nonobjc class var baseGray4: UIColor {
        return UIColor(r: 46, g: 46, b: 46)
    }
    @nonobjc class var baseGray5: UIColor {
        return UIColor(r: 25, g: 25, b: 25)
    }
    @nonobjc class var backgroundDark: UIColor {
        return UIColor(hexCode: "7D71C4")
    }
    @nonobjc class var backgroundLight: UIColor {
        return UIColor(hexCode: "F8F8F8")
    }
    @nonobjc class var colorWhite44: UIColor {
        return UIColor(hexCode: "FFFFFF", alpha: 0.27)
    }
    @nonobjc class var colorBlack0A: UIColor {
        return UIColor(hexCode: "000000", alpha: 0.03)
    }
    @nonobjc class var textColorDark: UIColor {
        return UIColor(hexCode: "F8F8F8")
    }
    @nonobjc class var textColorLight: UIColor {
        return UIColor(hexCode: "444444")
    }
    @nonobjc class var colorGrayF3: UIColor {
        return UIColor(hexCode: "F3F3F3")
    }
    @nonobjc class var homePrimary: UIColor {
        return UIColor(hexCode: "1540F2")
    }
    @nonobjc class var colorGrayCD: UIColor {
        return UIColor(hexCode: "cdcdcd")
    }
    @nonobjc class var colorMain1: UIColor {
        return UIColor(hexCode: "ff4356")
    }
    @nonobjc class var color_instagram_blue2: UIColor {
        return UIColor(hexCode: "5BBEFF")
    }
    @nonobjc class var base_gray: UIColor {
        return UIColor(hexCode: "c2c2c2")
    }
    @nonobjc class var color_instagram_red: UIColor {
        return UIColor(hexCode: "FF4356")
    }
    @nonobjc class var deep_gray: UIColor {
        return UIColor(hexCode: "636363")
    }
    @nonobjc class var light_gray: UIColor {
        return UIColor(hexCode: "efefef")
    }
    @nonobjc class var light_pink: UIColor {
        return UIColor(hexCode: "fff8f8")
    }
    @nonobjc class var purpleTip: UIColor {
        return UIColor(hexCode: "2E16BC")
    }
}
