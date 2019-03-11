//
//  PoolChatView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/12/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class PoolChatView: MessengerBaseView {
    
    override init(frame: CGRect, view: UIView) {
        super.init(frame: frame, view: view)
        
        setupUI()
        
        buildConstraintsForNavBar()
        setPoolChatConst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

