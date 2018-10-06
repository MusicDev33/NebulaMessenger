//
//  PublicStructs.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

let nebulaPurple = UIColor(red: 198/255, green: 65/255, blue: 168/255, alpha: 1)
let nebulaBlue = UIColor(red: 2/255, green: 148/255, blue: 227/255, alpha: 1)

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
    let connectionLimit: Int?
    let usersConnected: [String]?
}
