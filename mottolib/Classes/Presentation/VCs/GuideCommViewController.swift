//
//  GuideCommViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

final class GuideCommViewController: UIViewController {
    
    let popupView: GuideCommView
    var GuideCommVC: GuideCommViewController?
    var viewFromVC: AdMissionViewController?
    
    var guideType: Int = 0
    
    func setGuideType(type: Int) {
        guideType = type
    }
    func getGuideType() -> Int {
        return guideType
    }
    
      
    init() {
        self.popupView = GuideCommView()
        super.init(nibName: nil, bundle: nil)
        
        GuideCommVC = self
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.parentVC = GuideCommVC
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popupView.partGoodsButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeGoodsButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.partPlaceButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closePlaceButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        
        popupView.centerLoginButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.partShopButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeShopButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.centerFailButton.addTarget(self, action: #selector(dismissGuideAndGoback), for: .touchUpInside)
        popupView.centerTrafficButton.addTarget(self, action: #selector(dismissGuideAndStartTimer), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    @objc func dismissGuide() {
        self.dismiss(animated: true)
    }
    @objc func dismissGuideAndGoback() {
        self.dismiss(animated: true)
        viewFromVC?.goBack()
    }
    @objc func dismissGuideAndStartTimer() {
        self.dismiss(animated: true)
        let eachView: AdNPTrafficView = viewFromVC?.moveView as! AdNPTrafficView
        eachView.processTrafficPopup(state: AdNPTrafficView.TrafficPopupState.PROGRESS)
        eachView.isTipAnimation = true
        eachView.startCountDown()
    }
}
