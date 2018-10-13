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
        self.socket.emit("add-message", message)
    }
    
    static func newSendMessage(message: [Any], users: [String]){
        //self.socket.emit("add-message", message, users)
        print("HI!!!!!!!!!!!!")
        self.socket.emit("add-message", with: [message, users])
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
