//
//  PublicStructs.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

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
