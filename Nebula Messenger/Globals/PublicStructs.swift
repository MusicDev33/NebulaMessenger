//
//  PublicStructs.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

// UI Colors
let borderColorOne = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)
let borderColorTwo = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)

let panelColorOne = UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1)
let panelColorTwo = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)

let panelColorOneAlt = UIColor(red: 235/255, green: 235/255, blue: 240/255, alpha: 1)

// Disabled Button
let disabledButtonColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)

// Main Colors
let nebulaPurple = UIColor(red: 198/255, green: 65/255, blue: 168/255, alpha: 1)
let nebulaBlue = UIColor(red: 2/255, green: 148/255, blue: 227/255, alpha: 1)
let nebulaGreen = UIColor(red: 59/255, green: 219/255, blue: 167/255, alpha: 1)
let nebulaSky = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)
let nebulaFlame = UIColor(red: 206/255, green: 65/255, blue: 14/255, alpha: 1)
let nebulaYellow = UIColor(red: 216/255, green: 216/255, blue: 17/255, alpha: 1)
let nebulaBurn = UIColor(red: 206/255, green: 143/255, blue: 16/255, alpha: 1)
let nebulaPink = UIColor(red: 1, green: 209/255, blue: 220/255, alpha: 1)

// Misc
let nebulaSkyBorder = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)

var userTextColor = nebulaPurple
var otherTextColor = nebulaBlue

let globalColors = [nebulaPurple, nebulaBlue, nebulaGreen, nebulaSky, nebulaFlame, nebulaYellow, nebulaBurn, nebulaPink]
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
        userTextColor = colorsDict[userTextString] ?? nebulaPurple
    }
    
    if otherTextString.count > 1{
        otherTextColor = colorsDict[otherTextString] ?? nebulaBlue
    }
}


struct Message{
    let sender: String?
    let body: String?
    let friend: String?
    let id: String?
    let convId: String?
    let dateTime: String?
    let read: Bool?
}

struct User{
    let id: String?
    let name: String?
    let username: String?
    var friends: [String]?
    
}

struct TerseMessage {
    let _id: String?
    let sender: String?
    let body: String?
    let dateTime: String?
    let read: Bool?
}

struct PublicPool {
    let coordinates: [Double]?
    let poolId: String?
    let name: String?
    let creator: String?
    let connectionLimit: Int?
    let usersConnected: [String]?
}

struct ServerMessage {
    let message: String?
    let success: Bool?
}

struct Conversation {
    var involved: String
    var name: String
    let id: String?
    var lastRead: String
    var lastMessage: String
}
