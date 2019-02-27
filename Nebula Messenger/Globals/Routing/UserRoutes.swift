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
                        GlobalUser.name = jObj["user"]["name"].stringValue
                        GlobalUser.email = jObj["user"]["email"].stringValue
                        GlobalUser.friends = Utility.toArray(json: jObj["user"]["friends"])
                        GlobalUser.requestedFriends = Utility.toArray(json: jObj["user"]["requestedFriends"])
                        GlobalUser.token = jObj["token"].stringValue
                        if jObj["user"]["poolSubs"] != JSON.null {
                            GlobalUser.subscribedPools = Utility.toArray(json: jObj["user"]["poolSubs"])
                        }
                        for topic in GlobalUser.subscribedPools{
                            Messaging.messaging().subscribe(toTopic: topic)
                        }
                        
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        let serverMessage = ServerMessage(message: "Successful", success: true)
                        
                        completion(serverMessage)
                    }
                    
                case .failure(let Json):
                    _ = JSON(Json)
                    print("UserRoutes: failed to login normally")
                    let serverMessage = ServerMessage(message: "No connection!", success: false)
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
                        GlobalUser.namesToUsernames[name] = username
                        index += 1
                    }
                    
                    for i in 0..<jsonObject["convs"].count{
                        var foundUsername = false
                        var currentConvId = jsonObject["convs"][i]["involved"].stringValue
                        currentConvId = Utility.alphabetSort(preConvId: currentConvId)
                        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: currentConvId)
                        
                        for username in Utility.getAllFromConvId(convId: currentConvId){
                            if username == GlobalUser.username{
                                foundUsername = true
                                break
                            }
                        }
                        
                        if !foundUsername{
                            continue
                        }
                        
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
                    print("UserRoutes: failed to retrieve friends and conversations")
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
                    print("UserRoutes: failed to get current version")
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
                    _ = JSON(Json)
                    completion()
                    
                case .failure( _):
                    print("UserRoutes: refresh token in database")
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
                    var returnList = [String]()
                    returnList.append(jsonObject["user"]["name"].stringValue)
                    returnList.append(jsonObject["user"]["username"].stringValue)
                    returnList.append("success")
                    completion(returnList)
                case .failure(_):
                    print("UserRoutes: failed to get userobject from username")
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
                    print("UserRoutes: failed to get quotes...this isn't really that big of a deal though")
                    var returnList = [String]()
                    returnList.append("Thanks for using Nebula!")
                    completion(returnList)
                }
            })
        }catch{
        }
    }
    
    static func addPhoneNumber(number:String, username: String, completion:@escaping () -> ()){
        let url = URL(string: addPhoneNumberRoute)
        var requestJson = [String:Any]()
        requestJson["token"] = GlobalUser.token
        requestJson["username"] = username
        requestJson["phoneNumber"] = number
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    _ = JSON(Json)
                    completion()
                case .failure(_):
                    print("UserRoutes: failed to add phone number for user")
                    completion()
                }
            })
        }catch{
        }
    }
    
}
