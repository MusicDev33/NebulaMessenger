//
//  DiagnosticRoutes.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

class DiagnosticRoutes{
    static func sendInfo(info: String, optional: String){
        let url = URL(string: sendInfoRoute)
        var requestJson = [String:Any]()
        requestJson["username"] = GlobalUser.username
        requestJson["info"] = info
        requestJson["optional"] = optional
        requestJson["device"] = "iOS"
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success( _):
                    print("Data sent")
                case .failure(_):
                    print("Can't send data.")
                }
            })
        }catch{
        }
    }
}
