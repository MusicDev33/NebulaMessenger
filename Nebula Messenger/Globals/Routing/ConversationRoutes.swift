//
//  ConversationRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/2/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

class ConversationRoutes{
    static func getOneConversation(involved: String, completion:@escaping ([String]) -> ()){
        let url = URL(string: getConvRoute)
        var requestJson = [String:Any]()
        requestJson["users"] = Utility.getAllFromConvId(convId: involved)
        requestJson["token"] = GlobalUser.token
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("CONVERSATION")
                    print(jsonObject)
                    guard
                        let involved = jsonObject["involved"].string,
                        let id = jsonObject["id"].string,
                        let lastMessage = jsonObject["lastMessage"].string
                        else {
                            print("Error adding conversation!")
                            return
                            
                    }
                    
                    completion([involved, id, "N/A", lastMessage])
                case .failure(_):
                    print("Not working!")
                    completion(["Failed"])
                }
            })
        }catch{
        }
    }
    
    static func getConversations(completion:@escaping () -> ()){
        let url = URL(string: getConvsRoute)
        var requestJson = [String:Any]()
        requestJson["user"] = GlobalUser.username
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    for i in 0..<jsonObject["conv"].count{
                        let currentConvId = jsonObject["conv"][i]["involved"].stringValue
                        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: currentConvId)
                        GlobalUser.conversations.append(currentConvId)
                        GlobalUser.involvedDict[friend] = currentConvId
                        GlobalUser.convNames.append(friend)
                    }
                    print("GLOBALS!!!!!!!")
                    print(GlobalUser.conversations)
                    print(GlobalUser.convNames)
                    
                    completion()
                case .failure(_):
                    print("Not working!")
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func deleteConversation(id: String, convName: String, completion:@escaping () -> ()){
        let url = URL(string: deleteConvRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = id
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("DELETING")
                    print(jsonObject)
                    GlobalUser.removeFromConvNames(convName: convName)
                    
                    completion()
                case .failure(_):
                    print("Not working!")
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func updateLastRead(id: String, msgId: String, completion:@escaping () -> Void){
        let url = URL(string: updateLastReadRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = id
        requestJson["messageId"] = msgId
        requestJson["username"] = GlobalUser.username
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("DELETING")
                    print(jsonObject)
                    
                    completion()
                case .failure(_):
                    print("Couldn't update last read!")
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func changeGroupMembers(id: String, newInvolved: String, oldInvolved: String, completion:@escaping () -> Void){
        let url = URL(string: changeGroupMembersRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = id
        requestJson["involved"] = newInvolved
        requestJson["token"] = GlobalUser.token
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("DELETING")
                    print(jsonObject)
                    GlobalUser.globalChangeGroupMembers(oldInvolved: oldInvolved, newInvolved: newInvolved)
                    completion()
                case .failure(_):
                    print("Couldn't update last read!")
                    completion()
                }
            })
        }catch{
        }
    }
}
