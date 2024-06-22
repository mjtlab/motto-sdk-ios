//
//  ViewController.swift
//  mottosdkios
//
//  Created by daybreaker48 on 06/18/2024.
//  Copyright (c) 2024 daybreaker48. All rights reserved.
//

import UIKit
import mottosdkios

class ViewController: UIViewController {	

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        let viewcontroller = Motto.create("DEBUG")
        self.view.addSubview(viewcontroller.view)
                
        viewcontroller.view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        Motto.uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        Motto.pubkey = "65dc458e742d5"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

