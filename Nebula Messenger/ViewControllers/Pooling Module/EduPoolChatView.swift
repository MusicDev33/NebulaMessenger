//
//  EduPoolChatView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/27/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class EduPoolChatView: MessengerBaseView {
    
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
