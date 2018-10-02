//
//  GlobalUser.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/15/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

class GlobalUser: NSObject {
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
    
    static func addFriend(friend: String){
        if !self.friends.contains(friend){
            self.friends.append(friend)
        }
    }
    
}
