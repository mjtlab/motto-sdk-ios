//
//  BaseLibVC.swift
//  mottoapp
//
//  Created by MHD on 2024/02/14.
//

import UIKit

class BaseLibVC: UIViewController {

    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
