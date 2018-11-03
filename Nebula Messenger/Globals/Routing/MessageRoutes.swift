//
//  MessageRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/2/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

class MessageRoutes{
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
}
