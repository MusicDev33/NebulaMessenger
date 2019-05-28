//
//  Routes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/26/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

let baseUrl = "http://159.89.152.215:3000"
let novaBaseUrl = "http://159.89.152.215:3000/nova/v1/"

let novaUsersRoot = novaBaseUrl + "users"
let novaPoolsRoot = novaBaseUrl + "pools"
let novaConvsRoot = novaBaseUrl + "conversations"
let novaDiagsRoot = novaBaseUrl + "diagnostics"

let userRoot = "http://159.89.152.215:3000/users/"
let messageRoot = "http://159.89.152.215:3000/messages/"
let friendsRoot = "http://159.89.152.215:3000/friends/"
let conversationsRoot = "http://159.89.152.215:3000/conversations/"
let poolsRoot = "http://159.89.152.215:3000/pools/"
let diagRoot = "http://159.89.152.215:3000/diagnostics/"


// MARK: Messages

// MARK: User
let registerUserRoute = novaUsersRoot + "/register"
let refreshTokenRoute = novaUsersRoot + "/refreshtoken"
let addPhoneNumberRoute = novaUsersRoot + "/addphonenumber"

// MARK: Friends
let addFriendRoute = friendsRoot + "addfriend"
let testAddFriendRoute = friendsRoot + "testaddfriend"
let removeFriendRoute = friendsRoot + "removefriend"

// MARK: Conversations
let changeGroupMembersRoute = conversationsRoot + "changegroupmembers"

// MARK: Pools
let createPoolRoute = novaPoolsRoot + "/create"
let sendPoolsRoute = poolsRoot + "send"
let deletePoolRoute = poolsRoot + "deletepool"

// MARK: Diagnostics Data
let sendInfoRoute = novaDiagsRoot + "/sendinfo"

// For later
func buildRequest(){
    
}

// GET ROUTES

// MARK: User
let getQuotesRoute = novaBaseUrl + "users/quotes"
let getUserRoute = novaBaseUrl + "users/search/"

// MARK: Friends
let getFriendsRoute = friendsRoot + "getfriends"
let searchFriendsRoute = friendsRoot + "searchfriends"


// MARK: NOVA

let authUserRoute = novaUsersRoot + "/authenticate"

// MARK: Conversations
let sendMessageRoute = novaConvsRoot + "???"
let createConvRoute = novaConvsRoot + "/create"

// MARK: Pools
let getPoolsRoute = novaPoolsRoot
let getPoolMessagesRoute = novaPoolsRoot

let getCurrentiOSRoute = novaUsersRoot + "/getcurrentios"
