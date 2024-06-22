//
//  GuideViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

final class GuideViewController: UIViewController {
    
    let popupView: GuideView
    var GuideVC: GuideViewController?
    
    var guideType: Int = 0
    
    func setGuideType(type: Int) {
        guideType = type
    }
    func getGuideType() -> Int {
        return guideType
    }
      
    init() {
        self.popupView = GuideView()
        super.init(nibName: nil, bundle: nil)
        
        GuideVC = self
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.parentVC = GuideVC
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popupView.partButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.partAlarmButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeAlarmButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.partBlogButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeBlogButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.partBlog2Button.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        popupView.closeBlog2Button.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    @objc func dismissGuide() {
        self.dismiss(animated: true)
    }
}
