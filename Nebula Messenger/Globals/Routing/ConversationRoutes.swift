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
    
    static func updateLastRead(id: String, msgId: String, completion:@escaping () -> ()){
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
}
