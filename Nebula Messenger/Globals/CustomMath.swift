//
//  CustomMath.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class CustomMath {
    static func getPathToCircleCenter(degrees: CGFloat, radius: CGFloat) -> [CGFloat]{
        let rads = (degrees * CGFloat.pi)/180
        
        let xRatio = cos(rads)
        let yRatio = sin(rads)
        
        return [xRatio, yRatio]
    }
}
