//
//  Tutorial.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/21/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation

class Tutorial: NSObject{
    static var learnedPools = false
    
    
}

extension Tutorial {
    static func tutorialInit(){
        self.learnedPools = UserDefaults.standard.bool(forKey: "learnedPools")
    }
    
    static func didLearnPools() -> Bool{
        return UserDefaults.standard.bool(forKey: "learnedPools")
    }
}
