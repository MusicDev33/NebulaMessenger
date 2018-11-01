//
//  RouteLogic.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/21/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

// Contains the more complicated route logic
// I honestly don't know how to organize this
class RouteLogic {
    static func sendLogin(username: String, password: String, completion:@escaping (ServerMessage) -> ()){
        let url = URL(string: authenticateUserRoute)
        var requestJson = [String:Any]()
        
        requestJson["username"] = username
        requestJson["password"] = password
        
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
                    let serverMessage = ServerMessage(message: jObj["msg"].string!, success: false)
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
                        GlobalUser.friendsConvDict[friend] = jsonObject["conv"][i]["id"].stringValue
                        GlobalUser.convNames.append(friend)
                    }
                    print("GLOBALS!!!!!!!")
                    print(GlobalUser.conversations)
                    print(GlobalUser.friendsConvDict)
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
                    print("GETTING")
                    print(jsonObject)
                    var index = 0
                    for _ in jsonObject["friends"]{
                        let name = jsonObject["friends"][index]["name"].string ?? "N/A: Name not found"
                        let username = jsonObject["friends"][index]["username"].string ?? "N/A: Username not found"
                        GlobalUser.realNames.append(name)
                        print(name)
                        GlobalUser.namesToUsernames[name] = username
                        index += 1
                    }
                    print(GlobalUser.realNames)
                    
                    for i in 0..<jsonObject["convs"].count{
                        let currentConvId = jsonObject["convs"][i]["involved"].stringValue
                        let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: currentConvId)
                        GlobalUser.conversations.append(currentConvId)
                        GlobalUser.involvedDict[friend] = currentConvId
                        GlobalUser.friendsConvDict[friend] = jsonObject["convs"][i]["id"].stringValue
                        GlobalUser.convNames.append(friend)
                        GlobalUser.convLastMsg[friend] = jsonObject["convs"][i]["lastMessage"].string ?? ""
                        GlobalUser.convLastRead[friend] = jsonObject["convs"][i]["lastMsgRead"][GlobalUser.username].string ?? ""
                        
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
    
    static func deleteMessages(msgsArray: [String], completion:@escaping () -> ()){
        let url = URL(string: deleteMsgsRoute)
        var requestJson = [String:Any]()
        requestJson["idList"] = msgsArray
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("GETTING")
                    print(jsonObject)
                    
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
    
    static func getMessages(id: String, completion: @escaping ([TerseMessage]) -> Void){
        let url = URL(string: getMsgRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = id
        requestJson["token"] = GlobalUser.token
        
        var passMsgList = [TerseMessage]()
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    var index = 0
                    for _ in jsonObject["msgs"]{
                        let tempMsg = TerseMessage(_id: jsonObject["msgs"][index]["_id"].string!,
                                                   sender: jsonObject["msgs"][index]["sender"].string!,
                                                   body: jsonObject["msgs"][index]["body"].string!,
                                                   dateTime: jsonObject["msgs"][index]["dateTime"].string!,
                                                   read: false)
                        passMsgList.append(tempMsg)
                        index += 1
                    }
                    //self.messagesTable.reloadData()
                    //self.scrollToBottom()
                    completion(passMsgList)
                case .failure(_):
                    print("failed")
                }
            })
        }catch{
            
        }
    }
    
    static func searchFriends(characters: String, completion: @escaping ([String]) -> Void){
        var requestJson = [String: Any]()
        let url = URL(string: searchFriendsRoute)
        requestJson["string"] = characters
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    var searchResults = [String]()
                    if let results = jsonObject["friends"].arrayObject as? [String] {
                        searchResults = results
                    }
                    completion(searchResults)
                case .failure(_):
                    print("failed")
                }
            })
        }catch{
            
        }
    }
}
