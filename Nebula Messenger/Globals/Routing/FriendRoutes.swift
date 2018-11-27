//
//  FriendRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/1/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

class FriendRoutes{
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
    
    static func addFriend(friend: String, completion: @escaping () -> ()){
        var requestJson = [String: Any]()
        let url = URL(string: addFriendRoute)
        requestJson["user"] = GlobalUser.username
        requestJson["friend"] = friend
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let _):
                    //let jsonObject = JSON(Json)
                    GlobalUser.addFriend(friend: friend)
                    print("Added friend!")
                    completion()
                case .failure(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    print("failed")
                    completion()
                }
            })
        }catch{
            
        }
    }
    
    static func requestFriend(friend: String, completion: @escaping () -> ()){
        var requestJson = [String: Any]()
        let url = URL(string: requestFriendRoute)
        requestJson["username"] = GlobalUser.username
        requestJson["friend"] = friend
        requestJson["token"] = GlobalUser.token
        
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
                    completion()
                case .failure(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    print("failed")
                    completion()
                }
            })
        }catch{
            
        }
    }
    
    static func removeFriend(friend: String, completion: @escaping () -> Void){
        var requestJson = [String: Any]()
        let url = URL(string: removeFriendRoute)
        requestJson["user"] = GlobalUser.username
        requestJson["friend"] = friend
        
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
                    print("Removed")
                    GlobalUser.friends = GlobalUser.friends.filter { $0 != friend }
                    completion()
                case .failure(_):
                    print("failed")
                    completion()
                }
            })
        }catch{
            
        }
    }
}
