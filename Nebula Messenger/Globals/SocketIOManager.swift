//
//  SocketIOManager.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/9/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    static let manager = SocketManager(socketURL: URL(string: baseUrl)!)
    static let socket = manager.defaultSocket
    
    override init(){
        super.init()
    }
    
    static func establishConnection(){
        self.socket.connect()
        self.socket.emit("create", GlobalUser.username)
        
    }
    
    static func closeConnection(){
        self.socket.disconnect()
    }
    
    static func sendMessage(message: [Any]){
        print("SOCKETIO")
        print(message)
        self.socket.emit("add-message", with: message)
    }
    
    static func sendTyping(id: String){
        var sendObj = [String:Any]()
        sendObj["friend"] = GlobalUser.username
        sendObj["id"] = id
        var dec: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: sendObj, options:.prettyPrinted)
            dec = String(data: data, encoding: .utf8)
        }catch{
            
        }
        self.socket.emit("currently-typing", with: [dec as Any])
    }
    
    static func setServerVersion(version: String, build: String){
        var sendObj = [String:Any]()
        sendObj["version"] = version
        sendObj["build"] = build
        var dec: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: sendObj, options:.prettyPrinted)
            dec = String(data: data, encoding: .utf8)
        }catch{
            
        }
        self.socket.emit("set-version", with: [dec as Any])
    }
    
    static func sendNotTyping(id: String){
        var sendObj = [String:Any]()
        sendObj["friend"] = GlobalUser.username
        sendObj["id"] = id
        var dec: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: sendObj, options:.prettyPrinted)
            dec = String(data: data, encoding: .utf8)
        }catch{
            
        }
        self.socket.emit("done-typing", with: [dec as Any])
    }
    
    static func sendRequest(friend: String, friendUsername: String){
        var sendObj = [String:Any]()
        sendObj["friend"] = friendUsername
        sendObj["friendName"] = friend
        sendObj["sender"] = GlobalUser.username
        var dec: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: sendObj, options:.prettyPrinted)
            dec = String(data: data, encoding: .utf8)
        }catch{
            
        }
        
        self.socket.emit("add-friend", with: [dec as Any])
    }
    
    static func sendToTestSocket(title: String, message: String){
        var sendObj = [String:Any]()
        sendObj["title"] = title
        sendObj["msg"] = message
        var dec: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: sendObj, options:.prettyPrinted)
            dec = String(data: data, encoding: .utf8)
        }catch{
            
        }
        
        self.socket.emit("test-socket", with: [dec as Any])
    }
    
    func createNewSocket() -> SocketIOClient{
        let manager = SocketManager(socketURL: URL(string: baseUrl)!)
        let socket = manager.defaultSocket
        return socket
    }
    
    static func shutOffListener(){
        self.socket.removeAllHandlers()
    }
    
}
