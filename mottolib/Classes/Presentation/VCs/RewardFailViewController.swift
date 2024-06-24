//
//  RewardFailViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import Alamofire

final class RewardFailViewController: UIViewController {
    
    private let popupView: RewardFailView
    var DialogVC: RewardFailViewController?
      
    init() {
        self.popupView = RewardFailView()
        super.init(nibName: nil, bundle: nil)
        
        DialogVC = self
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.parentVC = DialogVC
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func retryMission() {
        self.dismiss(animated: false)
        NotificationCenter.default.post(name: .retrymission, object: nil)
    }
}
