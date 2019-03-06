//
//  MessengerView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class MessengerView: MessengerBaseView {
    
}

extension UITextView {
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}
