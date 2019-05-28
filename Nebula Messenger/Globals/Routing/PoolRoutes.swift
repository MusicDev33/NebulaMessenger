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
    
    static func createPool(name: String, coords: [Double], completion:@escaping (PublicPool) -> ()){
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
                    
                    var doubleList = [Double]()
                    doubleList.append(jsonObject["pool"]["coordinates"][0].doubleValue)
                    doubleList.append(jsonObject["pool"]["coordinates"][1].doubleValue)
                    
                    var usersList = [String]()
                    let count = jsonObject["pool"]["usersConnected"].count
                    for i in stride(from: 0, to: count, by: 1) {
                        usersList.append(jsonObject["pool"]["usersConnected"][i].string!)
                    }
                    
                    let tempPool = PublicPool(coordinates: doubleList,
                                              poolId: jsonObject["pool"]["poolId"].string!,
                                              name: jsonObject["pool"]["name"].string!,
                                              creator: jsonObject["pool"]["creator"].string!,
                                              connectionLimit: jsonObject["pool"]["connectionLimit"].int!,
                                              usersConnected: usersList)
                    
                    completion(tempPool)
                case .failure(_):
                    print("PoolRoutes: couldn't create a pool")
                }
            })
        }catch{
        }
    }
    
    static func getPools(completion:@escaping ([PublicPool]) -> ()){
        let url = URL(string: getPoolsRoute + "?userid=" + GlobalUser.mongoUserId)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
        
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
                    
                    let tempPool = PublicPool(coordinates: doubleList,
                                              poolId: jsonObject["pools"][index]["poolId"].string!,
                                              name: jsonObject["pools"][index]["name"].string!,
                                              creator: jsonObject["pools"][index]["creator"].string!,
                                              connectionLimit: jsonObject["pools"][index]["connectionLimit"].int!,
                                              usersConnected: usersList)
                    pools.append(tempPool)
                    index += 1
                }
                completion(pools)
            case .failure(_):
                print("PoolRoutes: couldn't get pools")
                completion([])
            }
        })
    }
    
    
    static func getPoolMessages(id: String, completion: @escaping ([TerseMessage]) -> Void){
        let url = URL(string: getPoolMessagesRoute + "/" + id + "/messages")
        var passMsgList = [TerseMessage]()
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
            switch response.result{
            case .success(let Json):
                let jsonObject = JSON(Json)
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
                
                completion(passMsgList)
            case .failure(_):
                print("PoolRoutes: couldn't get pool messages")
            }
        })
    }
    
    static func deletePool(poolId: String, completion:@escaping (Bool) -> Void){
        let url = URL(string: deletePoolRoute)
        var requestJson = [String:Any]()
        requestJson["id"] = poolId
        requestJson["username"] = GlobalUser.username
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    
                    completion(jsonObject["success"].bool ?? false)
                case .failure(_):
                    print("PoolRoutes: couldn't delete pool")
                    completion(false)
                }
            })
        }catch{
        }
    }
    
    static func addPoolSubscription(poolId: String, completion:@escaping (Bool) -> Void){
        let url = URL(string: novaUsersRoot + "/" + GlobalUser.mongoUserId + "/pools/subscriptions/add")
        print(url)
        var requestJson = [String:Any]()
        requestJson["poolId"] = poolId
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    
                    completion(jsonObject["success"].bool ?? false)
                case .failure(_):
                    print("PoolRoutes: couldn't add pool subscription")
                    completion(false)
                }
            })
        }catch{
        }
    }
    
    static func removePoolSubscription(poolId: String, completion:@escaping (Bool) -> Void){
        let url = URL(string: novaUsersRoot + "/" + GlobalUser.mongoUserId + "/pools/subscriptions/remove")
        var requestJson = [String:Any]()
        requestJson["poolId"] = poolId
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    
                    completion(jsonObject["success"].bool ?? false)
                case .failure(_):
                    print("PoolRoutes: couldn't remove pool subscription")
                    completion(false)
                }
            })
        }catch{
        }
    }
}
