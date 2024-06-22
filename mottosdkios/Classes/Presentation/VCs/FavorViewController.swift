//
//  FavorViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/03/02.
//

import UIKit

final class FavorViewController: UIViewController {
    
    let popupView: FavorView
    var FavorVC: FavorViewController?
    
    var guideType: Int = 0
    
    func setGuideType(type: Int) {
        guideType = type
    }
    func getGuideType() -> Int {
        return guideType
    }
      
    init() {
        self.popupView = FavorView()
        super.init(nibName: nil, bundle: nil)
        
        FavorVC = self
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.parentVC = FavorVC
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupView.partButton.addTarget(self, action: #selector(dismissFavor), for: .touchUpInside)
        popupView.closeButton.addTarget(self, action: #selector(dismissFavor), for: .touchUpInside)
        popupView.partZzimButton.addTarget(self, action: #selector(dismissFavor), for: .touchUpInside)
        popupView.closeZzimButton.addTarget(self, action: #selector(dismissFavor), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    @objc func dismissFavor() {
        self.dismiss(animated: true)
    }
}
