//
//  MessengerBaseViewProto.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/10/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

protocol DefaultMessengerUI: class {
    
    var screenSizeX: CGFloat { get }
    var textViewMaxLines: CGFloat { get }
    var buttonHeight: CGFloat { get }
    var hasMoved: Bool { get set }
}

// Properties
extension DefaultMessengerUI where Self: UIView {
    
    var screenSizeX: CGFloat { return UIScreen.main.bounds.size.width }
    var textViewMaxLines: CGFloat { return 6 }
    var buttonHeight: CGFloat { return 30 }
    
}
