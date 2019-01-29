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
    
    @objc func expMapButtonPressed(){
        topView?.chooseButton(chosen: "experimental")
        UserDefaults.standard.set("experimental", forKey: "mapPreference")
        GlobalUser.userMapUrl = pickMap(mapName: "experimental")
    }
    
    @objc func satMapButtonPressed(){
        topView?.chooseButton(chosen: "satellite")
        UserDefaults.standard.set("satellite", forKey: "mapPreference")
        GlobalUser.userMapUrl = pickMap(mapName: "satellite")
    }
    
    @objc func defaultMapButtonPressed(){
        topView?.chooseButton(chosen: "default")
        UserDefaults.standard.set("default", forKey: "mapPreference")
        GlobalUser.userMapUrl = pickMap(mapName: "default")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        topView = SettingsView(frame: self.view.frame)
        self.view.addSubview(topView!)
        
        topView?.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        topView?.experimentalOptionButton.addTarget(self, action: #selector(expMapButtonPressed), for: .touchUpInside)
        topView?.satelliteOptionButton.addTarget(self, action: #selector(satMapButtonPressed), for: .touchUpInside)
        topView?.defaultNavOptionButton.addTarget(self, action: #selector(defaultMapButtonPressed), for: .touchUpInside)
    }
}
