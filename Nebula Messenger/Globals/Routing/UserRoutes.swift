//
//  UserRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/2/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseMessaging
import FirebaseInstanceID

class UserRoutes{
    static func sendLogin(username: String, password: String, completion:@escaping (ServerMessage) -> ()){
        let url = URL(string: authenticateUserRoute)
        var requestJson = [String:Any]()
        
        requestJson["username"] = username
        requestJson["password"] = password
        requestJson["newToken"] = FirebaseGlobals.globalDeviceToken
        print(requestJson)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jObj = JSON(Json)
                    //print(jObj)
                    if (jObj["success"] == false){
                        let serverMessage = ServerMessage(message: jObj["msg"].string!, success: false)
                        completion(serverMessage)
                    }
                    if (jObj["success"] == true){
                        //print("true")
                        GlobalUser.username = jObj["user"]["username"].stringValue
                        print("HEY")
                        print(GlobalUser.username)
                        GlobalUser.name = jObj["user"]["name"].stringValue
                        GlobalUser.email = jObj["user"]["email"].stringValue
                        GlobalUser.friends = Utility.toArray(json: jObj["user"]["friends"])
                        GlobalUser.requestedFriends = Utility.toArray(json: jObj["user"]["requestedFriends"])
                        GlobalUser.token = jObj["token"].stringValue
                        
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        let serverMessage = ServerMessage(message: "Successful", success: true)
                        
                        completion(serverMessage)
                    }
                    
                case .failure(let Json):
                    let jObj = JSON(Json)
                    print("Failed to register.")
                    let serverMessage = ServerMessage(message: "No connection!", success: false)
                    completion(serverMessage)
                }
            })
        }catch{
        }
    }
    
    
    static func getAdminPass(completion:@escaping (String) -> ()){
        let url = URL(string: adminPassRoute)
        var requestJson = [String:Any]()
        
        requestJson["blank"] = "blank"
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jObj = JSON(Json)
                    //print(jObj)
                    completion(jObj["pass"].string!)
                    
                case .failure(let Json):
                    completion("Blank")
                }
            })
        }catch{
        }
    }
    
    
    static func sendLoginAdmin(username: String, completion:@escaping (ServerMessage) -> ()){
        let url = URL(string: adminLoginRoute)
        var requestJson = [String:Any]()
        
        requestJson["username"] = username
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jObj = JSON(Json)
                    //print(jObj)
                    if (jObj["success"] == false){
                        let serverMessage = ServerMessage(message: jObj["msg"].string!, success: false)
                        completion(serverMessage)
                    }
                    if (jObj["success"] == true){
                        //print("true")
                        GlobalUser.username = jObj["user"]["username"].stringValue
                        print("HEY")
                        print(GlobalUser.username)
                        GlobalUser.name = jObj["user"]["name"].stringValue
                        GlobalUser.email = jObj["user"]["email"].stringValue
                        GlobalUser.friends = Utility.toArray(json: jObj["user"]["friends"])
                        
                        let serverMessage = ServerMessage(message: "Successful", success: true)
                        
                        completion(serverMessage)
                    }
                    
                case .failure(let Json):
                    let jObj = JSON(Json)
                    print("Failed to register.")
                    let serverMessage = ServerMessage(message: jObj["msg"].string!, success: false)
                    completion(serverMessage)
                }
            })
        }catch{
        }
    }
    
    static func getFriendsAndConversations(completion:@escaping () -> ()){
        let url = URL(string: getFriendsAndConvsRoute)
        var requestJson = [String:Any]()
        requestJson["username"] = GlobalUser.username
        requestJson["token"] = GlobalUser.token
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    var index = 0
                    for _ in jsonObject["friends"]{
                        let name = jsonObject["friends"][index]["name"].string ?? "N/A: Name not found"
                        let username = jsonObject["friends"][index]["username"].string ?? "N/A: Username not found"
                        GlobalUser.realNames.append(name)
                        print(name)
                        GlobalUser.namesToUsernames[name] = username
                        index += 1
                    }
                    
                    for i in 0..<jsonObject["convs"].count{
                        var currentConvId = jsonObject["convs"][i]["involved"].stringValue
                        currentConvId = Utility.alphabetSort(preConvId: currentConvId)
                        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: currentConvId)
                        
                        let lastRead = jsonObject["convs"][i]["lastMsgRead"][GlobalUser.username].string ?? ""
                        
                        let lastMessage = jsonObject["convs"][i]["lastMessage"].string ?? ""
                        let conversation = Conversation(involved: currentConvId, name: friend, id: jsonObject["convs"][i]["id"].stringValue, lastRead: lastRead, lastMessage: lastMessage)
                        GlobalUser.masterDict[friend] = conversation
                        GlobalUser.conversations.append(currentConvId)
                        GlobalUser.involvedDict[friend] = currentConvId
                        GlobalUser.convNames.append(friend)
                    }
                    completion()
                case .failure(_):
                    print("Not working!")
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func getIfCurrent(version: String, build: Int, completion:@escaping (String) ->()){
        let url = URL(string: getCurrentiOSRoute)
        var requestJson = [String:Any]()
        requestJson["version"] = version
        requestJson["build"] = build
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    if jsonObject["success"] == false{
                        completion(jsonObject["msg"].stringValue)
                    }else{
                        completion("")
                    }
                case .failure(_):
                    print("Not working!")
                    completion("")
                }
            })
        }catch{
        }
    }
    
    static func refreshToken(completion:@escaping () -> ()){
        let url = URL(string: refreshTokenRoute)
        var requestJson = [String:Any]()
        
        requestJson["username"] = GlobalUser.username
        requestJson["newToken"] = FirebaseGlobals.globalDeviceToken
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jObj = JSON(Json)
                    //print(jObj)
                    completion()
                    
                case .failure(let Json):
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func getUserFromUsername(username: String, completion:@escaping ([String]) -> ()){
        let url = URL(string: getUserRoute)
        var requestJson = [String:Any]()
        requestJson["username"] = username
        requestJson["token"] = GlobalUser.token
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    var returnList = [String]()
                    returnList.append(jsonObject["user"]["name"].stringValue)
                    returnList.append(jsonObject["user"]["username"].stringValue)
                    returnList.append("success")
                    completion(returnList)
                case .failure(_):
                    print("Not working!")
                    var returnList = [String]()
                    returnList.append("Name Unknown")
                    returnList.append("Error: No Username")
                    returnList.append("failure")
                    completion(returnList)
                }
            })
        }catch{
        }
    }
    
    static func getQuotes(completion:@escaping ([String]) -> ()){
        let url = URL(string: getQuotesRoute)
        var requestJson = [String:Any]()
        requestJson["token"] = GlobalUser.token
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    let quotesList = Utility.toArray(json: jsonObject["quotes"])
                    completion(quotesList)
                case .failure(_):
                    print("Not working!")
                    var returnList = [String]()
                    returnList.append("Thanks for using Nebula!")
                    completion(returnList)
                }
            })
        }catch{
        }
    }
    
}
