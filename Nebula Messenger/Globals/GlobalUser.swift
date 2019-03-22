//
//  GlobalUser.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/15/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import CoreBluetooth

let mapboxToken = "pk.eyJ1IjoibXVzaWNkZXYiLCJhIjoiY2pyYWM1Mmk2MHFjMzRhbW1ubW9iajhzbSJ9.F57Lvmee_6U2NWnyRf1sTA"

let mapboxUrl1 = "mapbox://styles/musicdev/cjrat7obp0pv52tmqfiqow58d"
let mapboxSat1Url = "mapbox://styles/musicdev/cjri2kycn8y772srvicpllgjf"
let mapboxNavDay1 = "mapbox://styles/musicdev/cjri2oczc8ya82srv1bomb4cc"
let mapboxNavNight1 = "mapbox://styles/musicdev/cjri2msnu802x2spjfeg0dwwl"

var globalPools = [PublicPool]()

var globalEducationPools = [PublicPool]()

class GlobalUser: NSObject {
    static var userMapUrl = pickMap(mapName: UserDefaults.standard.string(forKey: "mapPreference") ?? "default")
    
    static var showNotification = true
    
    static var username = ""
    static var token = ""
    
    static var name = ""
    static var email = ""
    static var friends = [String]()
    static var requestedFriends = [String]()
    
    static var subscribedPools = [String]()
    
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
    
    //BT Stuff
    static let SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")
    static let RX_UUID = CBUUID(string: "3B66D024-2336-4F22-A980-8095F4898C42")
    static let RX_PROPERTIES: CBCharacteristicProperties = .write
    static let RX_PERMISSIONS: CBAttributePermissions = .writeable
    
    
    // MARK: Methods
    static func globalChangeGroupMembers(oldInvolved: String, newInvolved: String){
        let oldConvName = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: oldInvolved)
        let newConvName = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: newInvolved)
        
        GlobalUser.masterDict[oldConvName]?.involved = newInvolved
        GlobalUser.masterDict[newConvName] = GlobalUser.masterDict[oldConvName]
        GlobalUser.masterDict[oldConvName] = nil
        
        GlobalUser.conversations = GlobalUser.conversations.filter { $0 != oldInvolved }
        GlobalUser.conversations.append(newInvolved)
        
        GlobalUser.involvedDict[oldConvName] = nil
        GlobalUser.involvedDict[newConvName] = newInvolved
        
        GlobalUser.convNames = GlobalUser.convNames.filter { $0 != oldConvName }
        GlobalUser.convNames.append(newConvName)
    }
    
    static func addConversation(involved: String, id: String, lastRead: String, lastMessage: String){
        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: involved)
        
        let conversation = Conversation(involved: involved, name: friend, id: id, lastRead: lastRead, lastMessage: lastMessage)
        
        GlobalUser.masterDict[friend] = conversation
        GlobalUser.conversations.insert(involved, at: 0)
        GlobalUser.involvedDict[friend] = involved
        GlobalUser.convNames.insert(friend, at: 0)
    }
    
    static func removeFromConvNames(convName: String){
        if self.convNames.contains(convName){
            self.masterDict[convName] = nil
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
        self.masterDict = [String:Conversation]()
    }
    
    static func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] ?? "?.?"
        let build = dictionary["CFBundleVersion"] ?? "unknown"
        return "\(version) build: \(build)"
    }
    
}

func pickMap(mapName: String) -> String{
    switch mapName {
    case "experimental":
        return mapboxUrl1
    case "satellite":
        return mapboxSat1Url
    case "default":
        if Utility.dayTimeCheck() == "day"{
            return mapboxNavDay1
        }else{
            return mapboxNavNight1
        }
    default:
        return mapboxUrl1
    }
}
