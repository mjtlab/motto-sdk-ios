//
//  ViewController.swift
//  mottolib
//
//  Created by daybreaker48 on 06/24/2024.
//  Copyright (c) 2024 daybreaker48. All rights reserved.
//

import UIKit
import mottolib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        let viewcontroller = Motto.create()
        Motto.uid = "mottosdkios"
        Motto.pubkey = "668dea5ee39c8"
        
        self.view.addSubview(viewcontroller.view)
                
        viewcontroller.view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        Motto.setBackgroundColor(.white)
        Motto.setIsDarkMode(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

