//
//  Colors.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/17/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    // UI Colors
    static let borderColorOne = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)
    static let borderColorTwo = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)
    
    static let panelColorOne = UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1)
    static let panelColorTwo = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
    
    static let panelColorOneAlt = UIColor(red: 235/255, green: 235/255, blue: 240/255, alpha: 1)
    
    // Disabled Button
    static let disabledButtonColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
    
    // Main Colors
    static let nebulaPurple = UIColor(red: 198/255, green: 65/255, blue: 168/255, alpha: 1)
    static let nebulaBlue = UIColor(red: 2/255, green: 148/255, blue: 227/255, alpha: 1)
    static let nebulaGreen = UIColor(red: 59/255, green: 219/255, blue: 167/255, alpha: 1)
    static let nebulaSky = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)
    static let nebulaFlame = UIColor(red: 206/255, green: 65/255, blue: 14/255, alpha: 1)
    static let nebulaYellow = UIColor(red: 216/255, green: 216/255, blue: 17/255, alpha: 1)
    static let nebulaBurn = UIColor(red: 206/255, green: 143/255, blue: 16/255, alpha: 1)
    static let nebulaPink = UIColor(red: 1, green: 209/255, blue: 220/255, alpha: 1)
    
    // Gradient Colors
    static let nebulaPurpleLight = UIColor(red: 228/255, green: 65/255, blue: 198/255, alpha: 0.5)
    static let nebulaPurpleLightUltra = UIColor(red: 228/255, green: 65/255, blue: 198/255, alpha: 0.4)
    
    static let nebulaBlueLight = UIColor(red: 2/255, green: 168/255, blue: 247/255, alpha: 0.6)
    
    // Misc
    static let nebulaSkyBorder = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)
}

var userTextColor = Colors.nebulaPurple
var otherTextColor = Colors.nebulaBlue

let globalColors = [Colors.nebulaPurple, Colors.nebulaBlue, Colors.nebulaGreen, Colors.nebulaSky, Colors.nebulaFlame, Colors.nebulaYellow, Colors.nebulaBurn, Colors.nebulaPink]
let colorsList = ["nebulaPurple", "nebulaBlue", "nebulaGreen", "nebulaSky", "nebulaFlame", "nebulaYellow", "nebulaBurn", "nebulaPink"]
var colorsDict = [String:UIColor]()

func setColors(){
    var index = 0
    for color in colorsList{
        colorsDict[color] = globalColors[index]
        index += 1
    }
    
    let userTextString = UserDefaults.standard.string(forKey: "userTextColor") ?? ""
    let otherTextString = UserDefaults.standard.string(forKey: "otherTextColor") ?? ""
    if userTextString.count > 1{
        userTextColor = colorsDict[userTextString] ?? Colors.nebulaPurple
    }
    
    if otherTextString.count > 1{
        otherTextColor = colorsDict[otherTextString] ?? Colors.nebulaBlue
    }
}
