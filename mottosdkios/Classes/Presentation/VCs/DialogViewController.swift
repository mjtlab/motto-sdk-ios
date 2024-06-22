//
//  DialogViewController.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import Alamofire

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
        self.dismiss(animated: false)
        
        let alert = UIAlertController(title: Title.notice, message: Description.ticketing, preferredStyle: .alert)
        let yes = UIAlertAction(title: Dialog.ok, style: .default) {_ in
        }
        alert.addAction(yes)
        self.present(alert, animated: true)
    }
    
    func goMission() {
        self.dismiss(animated: false)
        NotificationCenter.default.post(name: .gomission, object: nil)
    }
}
