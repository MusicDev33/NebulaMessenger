//
//  Routes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/26/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

let baseUrl = "http://159.89.152.215:3000"

let userRoot = "http://159.89.152.215:3000/users/"
let messageRoot = "http://159.89.152.215:3000/messages/"
let friendsRoot = "http://159.89.152.215:3000/friends/"
let conversationsRoot = "http://159.89.152.215:3000/conversations/"


// MARK: Messages

let sendRoute = messageRoot + "send"
let getMsgRoute = messageRoot + "getmsgswithid"
let deleteMsgRoute = messageRoot + "deletemsg"
let getOneMsgRoute = messageRoot + "getonemsg"
let deleteMsgsRoute = messageRoot + "deletemsgs"

// MARK: User
let registerUserRoute = userRoot + "register"
let authenticateUserRoute = userRoot + "authenticate"
let profileRoute = userRoot + "profile"
let getFriendsAndConvsRoute = userRoot + "getfriendsandconvs"

// MARK: Friends
let getFriendsRoute = friendsRoot + "getfriends"
let addFriendRoute = friendsRoot + "addfriend"
let testAddFriendRoute = friendsRoot + "testaddfriend"
let searchFriendsRoute = friendsRoot + "searchfriends"
let removeFriendRoute = friendsRoot + "removefriend"

// MARK: Conversations
let getConvsRoute = conversationsRoot + "getconvs"
let getConvRoute = conversationsRoot + "getconv"
let addConvRoute = conversationsRoot + "addconv"
let updateConvRoute = conversationsRoot + "updateconv"

// For later
func buildRequest(){
    
}