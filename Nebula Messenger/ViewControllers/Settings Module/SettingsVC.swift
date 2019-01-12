//
//  SettingsVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var topView: SettingsView?
    
    // Button Methods
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        topView = SettingsView(frame: self.view.frame)
        self.view.addSubview(topView!)
        
        topView?.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
}
