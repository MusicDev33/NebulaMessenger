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
    
    static func getOneConversation(convID: String, completion:@escaping ([String]) -> ()){
        let url = URL(string: novaConvsRoot + "/" + convID)
        var request = URLRequest(url: url!)
        request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
            switch response.result{
            case .success(let Json):
                let jsonObject = JSON(Json)
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
                print("ConversationRoutes: getOneConversation failed")
                completion(["Failed"])
            }
        })
    }
    
    
    
    static func deleteConversation(id: String, convName: String, completion:@escaping () -> ()){
        let url = URL(string: novaConvsRoot + "/" + id)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
            switch response.result{
            case .success(let Json):
                _ = JSON(Json)
                GlobalUser.removeFromConvNames(convName: convName)
                
                completion()
            case .failure(_):
                print("ConversationRoutes: couldn't delete conversation")
                completion()
            }
        })
    }
    
    static func updateConversation(convID: String, completion:@escaping () -> Void){
        let url = URL(string: novaConvsRoot + "/" + convID + "/update")
        var requestJson = [String:Any]()
        requestJson["id"] = convID
        requestJson["sender"] = GlobalUser.username
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: {response -> Void in
                switch response.result{
                case .success(let Json):
                    _ = JSON(Json)
                    
                    completion()
                case .failure(_):
                    print("ConversationRoutes: couldn't update last read message")
                    completion()
                }
            })
            
        }catch {
            
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
                    let _ = JSON(Json)
                    GlobalUser.globalChangeGroupMembers(oldInvolved: oldInvolved, newInvolved: newInvolved)
                    completion()
                case .failure(_):
                    print("ConversationRoutes: couldn't change group members")
                    completion()
                }
            })
        }catch{
        }
    }
}
