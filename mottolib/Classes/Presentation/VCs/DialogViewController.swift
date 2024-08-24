//
//  DialogViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import Alamofire
import MottoFrameworks

final class DialogViewController: UIViewController {
    
    private let popupView: DialogView
    var DialogVC: DialogViewController?
      
    init() {
        self.popupView = DialogView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func alertMsg() {
        guard let pvc = self.presentingViewController else { return }
        
        self.dismiss(animated: false)
        
        let alert = UIAlertController(title: Global.notice, message: Global.ticketing, preferredStyle: .alert)
        let yes = UIAlertAction(title: Global.ok, style: .default) {_ in
        }
        alert.addAction(yes)
        pvc.present(alert, animated: true)
    }
    
    func goMission() {
        self.dismiss(animated: false)
        NotificationCenter.default.post(name: .gomission, object: nil)
    }
}
