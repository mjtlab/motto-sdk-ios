//
//  UIView+.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    /// UIView 의 모서리가 둥근 정도를 설정하는 메서드
    func makeRounded(cornerRadius: CGFloat?) {
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        } else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }

        self.clipsToBounds = true
//        self.layer.masksToBounds = false
    }

    func getStatusBarHeight() -> CGFloat {
        return self.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 + 6
    }

    @discardableResult
    func setGradient(colors: [CGColor],
                     locations: [NSNumber] = [0.0, 1.0],
                     startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                     endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)) -> Self {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = self.bounds
        layer.addSublayer(gradient)
        return self
    }
    
    // 특정 위치만 cornerRadius
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    func fadeIn(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    func fadeOut(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func showToast(_ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 75, y: self.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds  =  true
            
        self.addSubview(toastLabel)
            
        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
