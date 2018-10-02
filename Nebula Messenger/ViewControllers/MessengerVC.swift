//
//  MessengerVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/20/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class MessageTableViewCell: UITableViewCell{
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var detailedLabel: UILabel!
}

class MessengerVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var msgList = [TerseMessage]()
    
    var id = ""
    var involved = ""
    var friend = ""
    
    var skipNotif = false
    
    var deleteModeOn = false
    var deleteArray = [String]()
    
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.messageTextView.delegate = self
        self.messagesTable.delegate = self
        self.messagesTable.dataSource = self
        
        RouteLogic.getMessages(id: self.id){messageList in
            self.msgList = messageList
            self.messagesTable.reloadData()
            self.scrollToBottom()
        }
        
        messageTextView!.layer.borderWidth = 1
        messageTextView!.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 10.0
        
        self.messagesTable.estimatedRowHeight = 120.0
        self.messagesTable.rowHeight = UITableView.automaticDimension
        
        self.openSocket {
        }
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return self.msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.bodyLabel.text = self.msgList[indexPath.row].body
        cell.detailedLabel.text = "Sent from " + self.msgList[indexPath.row].sender! + " on " + self.msgList[indexPath.row].dateTime!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        //self.performSegue(withIdentifier: "toMessenger", sender: self)
        if self.deleteModeOn{
            print("Picked!")
            print(self.msgList[indexPath.row])
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollToBottom(){
        let numberOfSections = self.messagesTable.numberOfSections
        let indexPath = IndexPath(row: self.msgList.count-1, section: numberOfSections-1)
        if indexPath[1] > -1{
            self.messagesTable.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -210, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: 210, up: true)
    }
    
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    //MARK: Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        let url = URL(string: sendRoute)
        
        var requestJson = [String:Any]()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy hh:mm:ss"
        
        // Creating the date object
        var now = df.string(from: Date())
        print(now)
        print("DATE")
        now.insert("a", at: now.index(now.startIndex, offsetBy: +11))
        now.insert("t", at: now.index(now.startIndex, offsetBy: +12))
        now.insert(" ", at: now.index(now.startIndex, offsetBy: +13))
        
        if (self.skipNotif){
            print("No Notifs")
            requestJson["groupChat"] = "HELLO" // Set groupChat to something random, it doesn't matter
        }
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = self.messageTextView.text
        requestJson["convId"] = self.involved
        //requestJson["read"] = false
        requestJson["dateTime"] = now
        requestJson["topic"] = self.friend
        requestJson["id"] = self.id
        
        print(requestJson)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options:.prettyPrinted)
            // dec = decoded
            print(data)
            let dec = String(data: data, encoding: .utf8)
            
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
                    print("Success!!!")
                    //let jsonObject = JSON(Json)
                    self.messagesTable.reloadData()
                    self.messageTextView.text = ""
                    SocketIOManager.sendMessage(message: [dec])
                    self.scrollToBottom()
                    if jsonObject["id"].exists(){
                        self.id = jsonObject["id"].string!
                        GlobalUser.addToConvNames(convName: self.friend, id: self.id, involved: self.involved)
                    }
                case .failure(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    print("failed")
                }
            })
        }catch{
            print("Caught")
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "messengerVCToMainMenu", sender: self)
    }
    
    @IBAction func tappedOnTrashButton(_ sender: UIButton) {
        self.deleteModeOn = !self.deleteModeOn
        print(deleteModeOn)
        RouteLogic.deleteMessages(msgsArray: self.deleteArray){
            
        }
        self.deleteArray = [String]()
        
    }
    /*
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
        print("Tapped")
        view.endEditing(true)
    }*/
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            print("Socket Beginning")
            // print(parsedData)
            // print(msg)
            do {
                
                let tempMsg = TerseMessage(_id: "", //Fix this
                                           sender: msg["sender"].string!,
                                           body: msg["body"].string!,
                                           dateTime: msg["dateTime"].string!,
                                           read: false)
                if msg["convId"].string! == self.involved{
                    self.msgList.append(tempMsg)
                    self.messagesTable.reloadData()
                    self.scrollToBottom()
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
    }
}