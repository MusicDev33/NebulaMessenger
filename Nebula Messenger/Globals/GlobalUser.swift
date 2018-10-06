//
//  GlobalUser.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/15/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

class GlobalUser: NSObject {
    static var showNotification = true
    
    static var username = ""
    
    static var name = ""
    static var email = ""
    static var friends = [String]()
    
    // Involved: username:username:username; format
    static var conversations = [String]()
    
    // Conv name, then involved: (Ben, Tim: ben:tim;) format
    static var involvedDict = [String:String]()
    
    // Actual Conv Name, then id: (Ben, Tim: 123456789:Username) format
    static var friendsConvDict = [String:String]()
    
    // Only Conv Names: Ben, Tim, Dan
    static var convNames = [String]()
    
    // Conv Name then Boolean: Ben: true
    // This will be for muting conversations in the future
    static var notificationDict = [String: Bool]()
    
    static var currentConv = ""
    
    
    // MARK: Methods
    static func addToConvNames(convName: String, id: String, involved: String){
        if !self.convNames.contains(convName){
            self.convNames.append(convName)
            self.conversations.append(involved)
            self.involvedDict[convName] = involved
            self.friendsConvDict[convName] = id
        }else{
            print("Can't add conv")
        }
    }
    
    static func removeFromConvNames(convName: String){
        if self.convNames.contains(convName){
            self.convNames = self.convNames.filter { $0 != convName }
            self.conversations = self.conversations.filter { $0 != self.involvedDict[convName] }
            self.involvedDict[convName] = nil
            self.friendsConvDict[convName] = nil
        }
    }
    
    static func addFriend(friend: String){
        if !self.friends.contains(friend){
            self.friends.append(friend)
        }
    }
    
    static func emptyGlobals(){
        self.name = ""
        self.username = ""
        self.email = ""
        self.friends = []
        self.conversations = []
        self.convNames = []
        self.involvedDict = [String:String]()
        self.friendsConvDict = [String:String]()
        
    }
    
}
