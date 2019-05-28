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
        let url = URL(string: "http://159.89.152.215:3000/nova/v1/conversations/" + id + "/messages")
        var passMsgList = [TerseMessage]()
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
        
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
                completion(passMsgList)
            case .failure(_):
                print("MessageRoutes: failed to get messages")
                completion([TerseMessage]())
            }
        })
    }
    
    
}
