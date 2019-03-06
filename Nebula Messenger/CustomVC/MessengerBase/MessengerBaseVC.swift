//
//  MessengerBaseVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/27/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class MessengerBaseVC: UIViewController {
    
    var msgList = [TerseMessage]()
    
    // PoolId or ConvId
    var id = ""
    
    // Pool name or name of actual conversation
    var conversationName = ""
    
    var modularKeyboard: ModularKeyboard!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        modularKeyboard = ModularKeyboard(frame: self.view.frame, view: self.view)
        self.view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
    }
}

// Keyboard Notifs N' Stuff
extension MessengerBaseVC{
    
}
