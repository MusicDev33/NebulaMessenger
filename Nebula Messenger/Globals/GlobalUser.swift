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
    static var token = ""
    
    static var name = ""
    static var email = ""
    static var friends = [String]()
    
    //Master Dictionary, hopefully this will be the only way to retrieve conversations
    //without the use of a massive amount of dictionaries
    //This will store everything in (Ben, Tim, Dan: Conversation object) format
    static var masterDict = [String:Conversation]()
    
    // Involved: username:username:username; format
    static var conversations = [String]()
    
    // Conv name, then involved: (Ben, Tim: ben:tim;) format
    static var involvedDict = [String:String]()
    
    // Only Conv Names: Ben, Tim, Dan
    static var convNames = [String]()
    
    // People's real names
    static var realNames = [String]()
    
    // Names to usernames dict - Name:Username
    static var namesToUsernames = [String:String]()
    
    static var unreadList = [String]()
    
    
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
        }else{
            print("Can't add conv")
        }
    }
    
    static func addConversation(involved: String, id: String, lastRead: String, lastMessage: String){
        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: involved)
        
        let conversation = Conversation(involved: involved, name: friend, id: id, lastRead: lastRead, lastMessage: lastMessage)
        
        GlobalUser.masterDict[friend] = conversation
        GlobalUser.conversations.append(involved)
        GlobalUser.involvedDict[friend] = involved
        GlobalUser.convNames.append(friend)
    }
    
    static func removeFromConvNames(convName: String){
        if self.convNames.contains(convName){
            self.convNames = self.convNames.filter { $0 != convName }
            self.conversations = self.conversations.filter { $0 != self.involvedDict[convName] }
            self.involvedDict[convName] = nil
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
    }
    
    static func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] ?? "?.?"
        let build = dictionary["CFBundleVersion"] ?? "unknown"
        return "\(version) build: \(build)"
    }
    
}
