//
//  CanvasCourseRouting.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/9/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import Alamofire

func getStudents(stringUrl: String){
    print("HEY")
    let requestJson = [String: Any]()
    let url = URL(string: stringUrl)
    
    do {
        let _ = try JSONSerialization.data(withJSONObject: requestJson, options: [])
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer 7~3GQHD93XsKy9sVc6G0q1T0dHRngBb9625gU839g24tRnyMEYtQVyUIXZoRVSyW6S", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
            print("READY")
            switch response.result{
            case .success(let Json):
                print(Json)
                let jsonObject = JSON(Json)
                print(jsonObject)
            case .failure(_):
                print("CANVAS FAILED")
            }
        })
    }catch{
        print("what")
    }
}
