//
//  PoolRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/2/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

class PoolRoutes{
    
    static func createPool(name: String, coords: [Double], completion:@escaping () -> ()){
        let url = URL(string: createPoolRoute)
        var requestJson = [String:Any]()
        requestJson["coordinates"] = [coords[0], coords[1]]
        requestJson["name"] = name
        requestJson["connectionLimit"] = 10
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
                    print("Not working!")
                    completion()
                }
            })
        }catch{
        }
    }
    
    static func getPools(completion:@escaping ([PublicPool]) -> ()){
        let url = URL(string: getPoolsRoute)
        var requestJson = [String:Any]()
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    var pools = [PublicPool]()
                    var index = 0
                    for _ in jsonObject["pools"]{
                        var doubleList = [Double]()
                        doubleList.append(jsonObject["pools"][index]["coordinates"][0].doubleValue)
                        doubleList.append(jsonObject["pools"][index]["coordinates"][1].doubleValue)
                        
                        var usersList = [String]()
                        let count = jsonObject["pools"][index]["usersConnected"].count
                        for i in stride(from: 0, to: count, by: 1) {
                            usersList.append(jsonObject["pools"][index]["usersConnected"][i].string!)
                        }
                        
                        var tempPool = PublicPool(coordinates: doubleList,
                            poolId: jsonObject["pools"][index]["poolId"].string!,
                            name: jsonObject["pools"][index]["name"].string!,
                            creator: jsonObject["pools"][index]["creator"].string!,
                            connectionLimit: jsonObject["pools"][index]["connectionLimit"].int!,
                            usersConnected: usersList)
                        pools.append(tempPool)
                        index += 1
                    }
                    print("DELETING")
                    print(jsonObject)
                    completion(pools)
                case .failure(_):
                    print("Not working!")
                    completion([])
                }
            })
        }catch{
        }
    }
    
    
    static func getPoolMessages(id: String, completion: @escaping ([TerseMessage]) -> Void){
        let url = URL(string: getPoolMessagesRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = id
        
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
                    print(jsonObject)
                    var index = 0
                    if jsonObject.count > 0{
                        for item in jsonObject{
                            print(item)
                            let tempMsg = TerseMessage(_id: jsonObject[index]["_id"].string!,
                                                       sender: jsonObject[index]["sender"].string!,
                                                       body: jsonObject[index]["body"].string!,
                                                       dateTime: jsonObject[index]["dateTime"].string!,
                                                       read: false)
                            passMsgList.append(tempMsg)
                            index += 1
                        }
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
}
