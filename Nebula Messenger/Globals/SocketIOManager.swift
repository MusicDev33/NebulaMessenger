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
    }
    
    static func closeConnection(){
        self.socket.disconnect()
    }
    
    static func sendMessage(message: [Any]){
        print("SOCKETIO")
        print(message)
        self.socket.emit("add-message", with: message)
    }
    
    func createNewSocket() -> SocketIOClient{
        let manager = SocketManager(socketURL: URL(string: baseUrl)!)
        let socket = manager.defaultSocket
        return socket
    }
    
}
