//
//  Utility.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/19/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    // Takes a bunch of JSON stuff and puts it in an array type
    static func toArray(json: JSON) -> [String] {
        var tempList = [String]()
        for (_, val) in json{
            if let object = val.string {
                tempList.append(object)
            }
        }
        return tempList
        //return string.components(separatedBy: ",")
    }
    
    // Takes convId and sorts the name alphabetically
    static func alphabetSort(preConvId: String) -> String{
        var index = 0
        var userList = [String]()
        userList.append("") // ???
        for char in preConvId {
            if (char == ":"){
                index += 1
                userList.append("")
            }
            else if (char == ";"){
                
            }else{
                userList[index] += String(char)
            }
        }
        
        var convId = ""
        index = 0
        userList.sort()
        for item in userList {
            convId += item
            if index + 1 >= userList.count{
                convId += ";"
            }else{
                convId += ":"
                index += 1
            }
        }
        return convId
    }
    
    static func createConvId(names: [String]) -> String{
        var convId = ""
        var userList = names
        userList.sort()
        var index = 0
        for item in userList {
            convId += item
            if index + 1 >= userList.count{
                convId += ";"
            }else{
                convId += ":"
                index += 1
            }
        }
        return convId
    }
    
    static func createGroupConvId(names: [String]) -> String{
        var convId = ""
        var userList = names
        userList.append(GlobalUser.username)
        userList.sort()
        var index = 0
        for item in userList {
            convId += item
            if index + 1 >= userList.count{
                convId += ";"
            }else{
                convId += ":"
                index += 1
            }
        }
        return convId
    }
    
    // Pass in the convId and this will take care of the rest (returning array of people in convId)
    static func getFriendsFromConvId(user: String, convId: String) -> String{
        var userArray = [String]()
        var currentUser = ""
        
        for char in convId{
            if (char == ":"){
                userArray.append(currentUser)
                currentUser = ""
            }
            else if (char == ";"){
                userArray.append(currentUser)
                currentUser = ""
            }else{
                currentUser += String(char)
            }
        }
        
        userArray = userArray.filter { $0 != user }
        //userArray = userArray.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        userArray.sort()
        let joint = ", "
        return userArray.joined(separator: joint)
    }
    
    // Pass in the convId and this will take care of the rest (returning array of people in convId)
    static func getFriendsFromConvIdAsArray(user: String, convId: String) -> [String]{
        var userArray = [String]()
        var currentUser = ""
        
        for char in convId{
            if (char == ":"){
                userArray.append(currentUser)
                currentUser = ""
            }
            else if (char == ";"){
                userArray.append(currentUser)
                currentUser = ""
            }else{
                currentUser += String(char)
            }
        }
        
        userArray = userArray.filter { $0 != user }
        //userArray = userArray.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        userArray.sort()
        return userArray
    }
    
    // This converts the date to the same format JS uses
    static func convertCalendarDate(date: String) -> String{
        var timeMode = false
        var tempString = ""
        var masterString = ""
        for char in date{
            if char == "-"{
                masterString += tempString
                masterString += "/"
                tempString = ""
            }
            else if char == " "{
                if timeMode == false{
                    masterString += tempString
                    masterString += " at "
                    tempString = ""
                    timeMode = true
                }else{
                    return masterString
                }
            }
            else{
                tempString += String(char)
            }
        }
        return masterString
    }
    
    //This takes a JSON Object and turns it into a dictionary
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func dayTimeCheck() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "a" // "a" prints "pm" or "am"
        let meridiemString = formatter.string(from: Date()) // "AM"
        print("MMMMM")
        print(meridiemString)
        print(hour)
        if hour > 19 || hour < 7{
            return "night"
        }else{
            return "day"
        }
    }
}
