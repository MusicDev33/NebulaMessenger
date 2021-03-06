//
//  MessengerVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/20/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Foundation

class MessengerVC: MessengerBaseVC {
    
    var involved = ""
    var friend = ""
    var isGroupChat = false
    
    var skipNotif = false
    
    var deleteModeOn = false
    var deleteArray = [String]()
    var bottomLineView = UIView()
    
    var fromCreateMessage = false
    
    var maxChars = 22
    
    var didScroll = false
    
    var possibleMembers = [String]()
    var selectedPossibleMembers = [String]()
    var possibleMembersTable: UITableView!
    var selectedFriend = ""
    var possibleMembersTableVisible = false
    
    var timer: Timer?
    
    var collectionMoved = false
    
    var messagesCollectionBottomConstraint: NSLayoutConstraint?
    
    var possibleMembersVisibleConstraint: NSLayoutConstraint?
    var possibleMembersDefaultConstraint: NSLayoutConstraint?
    
    var didImpact = false
    let lightImpact = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        // This makes sure you don't exit to the create message page
        if fromCreateMessage{
            let vcAmount = self.navigationController?.viewControllers.count
            self.navigationController?.viewControllers.remove(at: vcAmount! - 2)
        }
        
        if self.conversationName.count > maxChars{
            self.conversationName.removeLast(self.conversationName.count-maxChars)
            self.conversationName += "..."
        }
        
        self.view.backgroundColor = UIColor.white
        
        self.view.setGradientRandom(colorOne: Colors.nebulaPurpleLightUltra, colorTwo: UIColor.white)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        blurEffectView.layer.zPosition = 0
        
        
        //Making a collectionview
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 375, height: 50)
        layout.estimatedItemSize = CGSize(width: 375, height: 50)
        layout.scrollDirection = .vertical
        
        messagesCollection = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 500), collectionViewLayout: layout)
        messagesCollection.register(MessageBubble.self, forCellWithReuseIdentifier: "messageBubble")
        
        messagesCollection.dataSource = self
        messagesCollection.delegate = self
        messagesCollection.translatesAutoresizingMaskIntoConstraints = false
        messagesCollection.backgroundColor = UIColor.white
        messagesCollection.isScrollEnabled = true
        messagesCollection.isUserInteractionEnabled = true
        messagesCollection.alwaysBounceVertical = true
        
        topView = MessengerView(frame: self.view.frame, view: self.view)
        topView.involvedLabel.text = self.conversationName
        topView.involvedCenterAnchor?.isActive = true
        
        self.view.addSubview(topView)
        self.topView.addSubview(self.messagesCollection)
        topView.sendSubviewToBack(self.messagesCollection)
        self.view.addSubview(modularKeyboard)
        modularKeyboard.buildConstraints()
        
        messagesCollection.topAnchor.constraint(equalTo: topView.navBar.bottomAnchor, constant: 0).isActive = true
        //messagesCollectionBottomConstraint = messagesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(modularKeyboard.heightConstraint?.constant)!)
        messagesCollectionBottomConstraint = messagesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        messagesCollectionBottomConstraint?.isActive = true
        messagesCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messagesCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedCircle(_:)))
        panGesture.delegate = self
        modularKeyboard.isUserInteractionEnabled = true
        modularKeyboard.addGestureRecognizer(panGesture)
        
        topView.bottomBarActionButton.addTarget(self, action: #selector(resetButton), for: .touchUpInside)
        topView.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        modularKeyboard.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        modularKeyboard.downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchUpInside)
        modularKeyboard.sendButton.addTarget(self, action: #selector(sendWrapper(sender:)), for: .touchUpInside)
        //modularKeyboard.groupFunctionButton.addTarget(self, action: #selector(addToGroupButtonPressed), for: .touchUpInside)
        
        let currentlyInvolved = Utility.getFriendsFromConvIdAsArray(user: GlobalUser.username, convId: self.involved)
        self.possibleMembers = GlobalUser.friends.filter {!currentlyInvolved.contains($0)}
        
        if self.isGroupChat{
            self.createTableView()
            modularKeyboard.buildGroupChatFeatures()
            modularKeyboard.groupFunctionButton.addTarget(self, action: #selector(groupFunctionButtonPressed), for: .touchUpInside)
            modularKeyboard.groupAddButton.addTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view.
        modularKeyboard.messageField.delegate = self
        if modularKeyboard.messageField.text.count == 0{
            modularKeyboard.sendButton.isEnabled = false
        }
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 112, right: 0)
        self.messagesCollection.keyboardDismissMode = .onDrag
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightOnCollection))
        rightSwipe.direction = .right
        self.messagesCollection.addGestureRecognizer(rightSwipe)
        
        self.setupKeyboardObservers()
        
        GlobalUser.currentConv = self.id
        self.scrollToBottom(animated: false)
        if msgList.count > 0{
            ConversationRoutes.updateConversation(convID: self.id, completion: {})
        }
        GlobalUser.unreadList = GlobalUser.unreadList.filter {$0 != self.id}
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.openSocket {}
        self.messagesCollection.layoutIfNeeded()
        //self.view.alpha = 1
        modularKeyboard.messageField.text = UserDefaults.standard.string(forKey: self.id) ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeVC), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openVC), name: UIApplication.didBecomeActiveNotification, object: nil)
        modularKeyboard.resizeTextView()
        let bottom = NSMakeRange(modularKeyboard.messageField.text.count - 1, 1)
        modularKeyboard.messageField.scrollRangeToVisible(bottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.id == ""{
            print("No ID")
            var idString = ""
            let epochTime = String(Int(NSDate().timeIntervalSince1970))
            idString += epochTime
            idString += ":"
            idString += GlobalUser.username
            self.id = idString
        }
        print("NAME")
        print(self.conversationName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.sendNotTyping(id: self.id)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.messagesCollection.layoutIfNeeded()
        if !didScroll{
            didScroll = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: UIGestureRecognizer Ext.
extension MessengerVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

// MARK: Network Ext.
extension MessengerVC{
    
    func createConv(completion:@escaping () -> ()){
        var url = URL(string: novaConvsRoot)
        var urlString = novaConvsRoot
        
        if self.id == ""{
            // create convid here
            let currentEpochTime = Int(NSDate().timeIntervalSince1970)
            let strEpochTime = String(currentEpochTime)
            urlString += "/"
            urlString += strEpochTime
            urlString += ":"
            urlString += GlobalUser.username
            urlString += "/send"
            url = URL(string: urlString)
        }else{
            urlString += "/"
            urlString += self.id
            urlString += "/send"
            url = URL(string: urlString)
        }
        
        var requestJson = [String:Any]()
        requestJson["sender"] = GlobalUser.username
        requestJson["involved"] = self.involved
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            var request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print("JSON RES")
                    print(jsonObject)
                    completion()
                case .failure(let Json):
                    let jObj = JSON(Json)
                    print(jObj)
                    print("Couldn't create thing")
                }
            })
        }catch{
        }
    }
    
    func sendMessage(_ sender: UIButton) {
        var urlString = novaConvsRoot + "/" + self.id + "/send"
        let url = URL(string: urlString)
        
        var requestJson = [String:Any]()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy hh:mm:ss"
        
        // Creating the date object
        var now = df.string(from: Date())
        now.insert("a", at: now.index(now.startIndex, offsetBy: +11))
        now.insert("t", at: now.index(now.startIndex, offsetBy: +12))
        now.insert(" ", at: now.index(now.startIndex, offsetBy: +13))
        
        if (self.skipNotif){
            print("No Notifs")
            requestJson["groupChat"] = "HELLO" // Set groupChat to something random, it doesn't matter
        }
        
        let body = self.modularKeyboard.messageField.text
        
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = body
        
        requestJson["involved"] = self.involved
        //requestJson["read"] = false
        requestJson["dateTime"] = now
        requestJson["topic"] = self.conversationName
        requestJson["id"] = self.id
        
        print(requestJson)
        
        self.modularKeyboard.sendButton.isEnabled = false
        
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
            request.addValue(GlobalUser.token, forHTTPHeaderField: "Authorization")
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    //let jsonObject = JSON(Json)
                    SocketIOManager.sendMessage(message: [dec as Any])
                    
                    let tempMsg = TerseMessage(_id: "", //Fix this
                        sender: GlobalUser.username,
                        body: self.modularKeyboard.messageField.text,
                        dateTime: now,
                        read: false)
                    
                    /*
                     let lastRow = self.msgList.count - 1
                     let lastIndex = IndexPath(item: lastRow, section: 0)
                     let newLastIndex = IndexPath(item: lastRow+1, section: 0)
                     
                     self.messagesCollection.performBatchUpdates({
                     print("Last Indices")
                     print(lastRow)
                     print(self.messagesCollection.numberOfItems(inSection: 0))
                     let indexPath = IndexPath(row: self.msgList.count, section: 0)
                     self.msgList.append(tempMsg)
                     self.messagesCollection.insertItems(at: [indexPath])
                     //self.messagesCollection.reloadData()
                     }, completion: {done in
                     
                     let lastItem = self.messagesCollection.numberOfItems(inSection: 0) - 1
                     let lastIndex = IndexPath(item: lastItem, section: 0)
                     self.messagesCollection.reloadData()
                     self.messagesCollection.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                     })*/
                    
                    
                    self.msgList.append(tempMsg)
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
                    self.modularKeyboard.messageField.text = ""
                    
                    if jsonObject["didCreateConv"].boolValue == true{
                        self.id = jsonObject["conv"]["id"].string!
                        let lastMessage = jsonObject["conv"]["lastMessage"].string!
                        let lastRead = jsonObject["conv"]["lastMsgRead"][GlobalUser.username].string!
                        let involved = jsonObject["conv"]["involved"].string!
                        
                        // Sets the saved message draft to nothing for this conversation
                        UserDefaults.standard.set("", forKey: self.id)
                        GlobalUser.addConversation(involved: involved, id: self.id, lastRead: lastRead, lastMessage: lastMessage)
                    }else{
                        UserDefaults.standard.set("", forKey: self.id)
                    }
                case .failure(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    print("Failed to send message.")
                }
            })
        }catch{
            print("Caught")
        }
    }
    
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            print(self.involved)
            
            guard let conversationsId = msg["id"].string else{
                return
            }
            
            let tempMsg = TerseMessage(_id: "", //Fix this
                sender: msg["sender"].string!,
                body: msg["body"].string!,
                dateTime: msg["dateTime"].string!,
                read: false)
            if tempMsg.sender == GlobalUser.username{
                return
            }
            
            print(tempMsg)
            
            // This is for when the message is sent to you
            if conversationsId == self.id{
                print("Something happened!")
                if msg["sender"].string! == GlobalUser.username{
                    
                }else{
                    playIncomingMessage()
                }
                
                let lastIndex = self.msgList.count-1
                
                if self.msgList[lastIndex]._id == "Chatting"{
                    self.msgList[lastIndex] = tempMsg
                    /*
                     let lastSectionIndex = self.messagesCollection!.numberOfSections - 1
                     // Then grab the number of rows in the last section
                     let lastRowIndex = self.messagesCollection!.numberOfItems(inSection: lastSectionIndex) - 1
                     // Now just construct the index path
                     let pathToLastRow = NSIndexPath(row: lastRowIndex+1, section: lastSectionIndex)
                     let pathToRow2 = NSIndexPath(row: lastRowIndex+1, section: lastSectionIndex)
                     self.messagesCollection.insertItems(at: [pathToLastRow as IndexPath])
                     self.messagesCollection.reloadItems(at: [pathToRow2 as IndexPath])*/
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
                }else{
                    
                    // For when it's an actual message, not "Someone is typing"
                    self.msgList.append(tempMsg)
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
                    
                    if self.possibleMembersTableVisible{
                        self.lightImpact.impactOccurred()
                        UIView.animate(withDuration: 0.4, delay: 0.2, animations: {
                            self.possibleMembersTable.alpha = 0.5
                        }, completion: {_ in
                            UIView.animate(withDuration: 0.2, delay: 0.7, animations: {
                                self.possibleMembersTable.alpha = 1
                            })
                        })
                    }
                    /*
                     self.messagesCollection.reloadData()
                     let lastRow = self.msgList.count - 1
                     let lastIndex = IndexPath(item: lastRow, section: 0)
                     let newLastIndex = IndexPath(item: lastRow + 1, section: 0)
                     
                     self.messagesCollection.performBatchUpdates({
                     print("Last Indices")
                     print(lastRow)
                     print(self.messagesCollection.numberOfItems(inSection: 0))
                     let indexPath = IndexPath(row: self.msgList.count, section: 0)
                     self.msgList.append(tempMsg)
                     self.messagesCollection.insertItems(at: [indexPath])
                     self.messagesCollection.reloadData()
                     }, completion: {done in
                     
                     let lastItem = self.messagesCollection.numberOfItems(inSection: 0) - 1
                     let lastIndex = IndexPath(item: lastItem, section: 0)
                     self.messagesCollection.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                     self.messagesCollection.reloadData()
                     })*/
                    
                }
                ConversationRoutes.updateConversation(convID: self.id, completion: {})
                //self.scrollToBottomAnimated(animated: true)
            }else{
                print("Something went wrong (Not really, i'm just dumb)")
            }
        }
        
        SocketIOManager.socket.on("typing") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            let tempMsg = TerseMessage(_id: "Chatting",
                                       sender: msg["friend"].string!,
                                       body: ". . .",
                                       dateTime: "",
                                       read: false)
            
            guard let conversationsId = msg["id"].string else{
                return
            }
            
            if conversationsId == self.id{
                let isTypingBubbles = self.msgList.filter { $0._id == "Chatting" }
                if isTypingBubbles.count == 0 && tempMsg.sender != GlobalUser.username{
                    self.msgList.append(tempMsg)
                    /*
                     let lastSectionIndex = self.messagesCollection!.numberOfSections - 1
                     // Then grab the number of rows in the last section
                     let lastRowIndex = self.messagesCollection!.numberOfItems(inSection: lastSectionIndex) - 1
                     // Now just construct the index path
                     let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                     self.messagesCollection.reloadItems(at: [pathToLastRow as IndexPath])*/
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
                }
            }else{
                self.messagesCollection.reloadData()
                print("Something went wrong")
            }
        }
        
        SocketIOManager.socket.on("nottyping") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            guard let conversationsId = msg["id"].string else{
                return
            }
            
            if conversationsId == self.id{
                let isTypingBubbles = self.msgList.filter { $0._id == "Chatting" }
                if isTypingBubbles.count > 0 && msg["friend"].string! != GlobalUser.username{
                    self.msgList = self.msgList.filter { $0._id != "Chatting" }
                    /*
                     let lastSectionIndex = self.messagesCollection!.numberOfSections - 1
                     // Then grab the number of rows in the last section
                     let lastRowIndex = self.messagesCollection!.numberOfItems(inSection: lastSectionIndex) - 1
                     // Now just construct the index path
                     let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                     self.messagesCollection.reloadItems(at: [pathToLastRow as IndexPath])*/
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
                }
            }else{
                self.messagesCollection.reloadData()
                print("Something went wrong")
            }
        }
    }
}

// MARK: UICollectionView Ext.
extension MessengerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.msgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        let text = self.msgList[indexPath.row].body
        
        var onlyEmoji = false
        
        cell.textView.text = text
        cell.senderLabel.text = ""
        
        if (text?.containsOnlyEmoji)! && (text?.count)! <= 3{
            cell.textView.font = UIFont.systemFont(ofSize: 48)
            print(cell.textView.text)
            cell.bubbleView.backgroundColor = UIColor.clear
            onlyEmoji = true
        }else{
            cell.textView.font = UIFont.systemFont(ofSize: 16)
        }
        
        cell.bubbleWidthAnchor?.constant = findSize(text: text!, label: cell.textView).width + 32
        
        cell.textView.textColor = UIColor.white
        
        
        if self.msgList[indexPath.row].sender == GlobalUser.username{
            cell.bubbleView.backgroundColor = onlyEmoji ? UIColor.clear : userTextColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            if cell.bubbleView.backgroundColor == Colors.nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            cell.senderHideBottomAnchor?.isActive = true
            cell.senderAboveBottomAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = onlyEmoji ? UIColor.clear : otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if cell.bubbleView.backgroundColor == Colors.nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            if isGroupChat{
                if indexPath.row > 0 && self.msgList[indexPath.row-1].sender != self.msgList[indexPath.row].sender{
                    cell.senderLabel.text = self.msgList[indexPath.row].sender
                }
            }
            
            cell.senderLeftAnchor?.isActive = true
            cell.senderRightAnchor?.isActive = false
            cell.senderHideBottomAnchor?.isActive = false
            cell.senderAboveBottomAnchor?.isActive = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        var height: CGFloat = 160
        height = findSize(text: self.msgList[indexPath.row].body!, label: cell.textView).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    func findSize(text: String, label: UITextView) -> CGRect{
        let constraintRect = CGSize(width: 200,
                                    height: 1000)
        var defaultFontSize = CGFloat(16)
        if text.containsOnlyEmoji && text.count <= 3{
            print(text)
            defaultFontSize = CGFloat(48)
        }else{
            defaultFontSize = CGFloat(16)
        }
        
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.view.endEditing(true)
    }
    
}

//MARK: UITableView Ext.
extension MessengerVC: UITableViewDataSource, UITableViewDelegate{
    
    // Might build this in other file later
    func createTableView(){
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let barHeight: CGFloat = 100
        
        self.possibleMembersTable = UITableView(frame: CGRect(x: 0, y: self.view.frame.height, width: displayWidth, height: displayHeight - barHeight))
        self.possibleMembersTable.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
        self.possibleMembersTable.dataSource = self
        self.possibleMembersTable.delegate = self
        
        self.topView.addSubview(self.possibleMembersTable)
        self.possibleMembersTable.translatesAutoresizingMaskIntoConstraints = false
        self.possibleMembersTable.widthAnchor.constraint(equalTo: self.topView.widthAnchor).isActive = true
        self.possibleMembersTable.bottomAnchor.constraint(equalTo: self.modularKeyboard.topAnchor, constant: 0).isActive = true
        
        possibleMembersDefaultConstraint = self.possibleMembersTable.topAnchor.constraint(equalTo: self.modularKeyboard.topAnchor, constant: 0)
        possibleMembersDefaultConstraint?.isActive = true
        
        possibleMembersVisibleConstraint = self.possibleMembersTable.topAnchor.constraint(equalTo: self.topView.navBar.bottomAnchor, constant: 0)
        possibleMembersVisibleConstraint?.isActive = false
        
        self.topView.layoutConfirmAddFriendButton()
        topView.confirmAddFriendButton.addTarget(self, action: #selector(confirmAddButtonPressed), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.possibleMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "friendCell")
        cell.textLabel!.text = "\(self.possibleMembers[indexPath.row])"
        
        if self.selectedPossibleMembers.contains((cell.textLabel?.text!)!){
            cell.detailTextLabel?.text = "\u{2714}"
        }else{
            cell.detailTextLabel?.text = " "
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        let cellText = self.possibleMembers[indexPath.row]
        self.selectedFriend = cellText
        
        if self.selectedPossibleMembers.contains(cellText){
            currentCell.detailTextLabel?.text = " "
            self.selectedPossibleMembers = self.selectedPossibleMembers.filter {$0 != cellText}
        }else{
            self.selectedPossibleMembers.append(cellText)
            currentCell.detailTextLabel?.text = "\u{2714}"
        }
        
        if self.selectedPossibleMembers.count > 0{
            self.topView.showConfirmAddFriendButton()
        }else{
            self.topView.hideConfirmAddFriendButton()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lightImpact.prepare()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetConstant = (Double.pi/49)/2
        
        if let tableView = scrollView as? UITableView
        {
            if tableView.contentOffset.y > -50.0 && tableView.contentOffset.y < 0
            {
                self.topView.confirmAddFriendButton.transform = CGAffineTransform(rotationAngle: tableView.contentOffset.y * CGFloat(offsetConstant))
            }
            
            if tableView.contentOffset.y <= -50{
                self.topView.confirmAddFriendButton.transform = CGAffineTransform(rotationAngle: .pi*2)
                if !didImpact {
                    lightImpact.impactOccurred()
                    didImpact = true
                }
            }
            
            if tableView.contentOffset.y > -50{
                didImpact = false
            }
            
            if tableView.contentOffset.y >= 0{
                self.topView.confirmAddFriendButton.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let tableView = scrollView as? UITableView
        {
            if tableView.contentOffset.y <= -50.0
            {
                addFriendButtonPressed()
                self.selectedPossibleMembers = [String]()
                self.topView.hideConfirmAddFriendButton()
                self.topView.confirmAddFriendButton.transform = CGAffineTransform.identity
                tableView.reloadData()
            }
        }
    }
}


// MARK: UITextView Ext.
extension MessengerVC: UITextViewDelegate{
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == ""{
            if textView.text.count-1 > 0{
                modularKeyboard.sendButton.isEnabled = true
            }else{
                modularKeyboard.sendButton.isEnabled = false
            }
        }else{
            if textView.text.count+1 > 0{
                modularKeyboard.sendButton.isEnabled = true
            }else{
                modularKeyboard.sendButton.isEnabled = false
            }
        }
        /*
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(typingTimerComplete), userInfo: nil, repeats: true)
        SocketIOManager.sendTyping(id: self.id)*/
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        modularKeyboard.resizeTextView()
        if textView.text.count == 0{
            modularKeyboard.sendButton.isEnabled = false
        }else{
            modularKeyboard.sendButton.isEnabled = true
        }
        UserDefaults.standard.set(textView.text, forKey: self.id)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
}

// MARK: UINavigationController Ext.
extension MessengerVC: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, direction: .toRight)
        default:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, direction: .toRight)
        }
    }
}


// MARK: Listeners/Selectors Ext.
extension MessengerVC{
    
    @objc func groupFunctionButtonPressed(){
        modularKeyboard.groupFunctionPressed()
        
        if self.possibleMembersTableVisible{
            addFriendButtonPressed()
        }
    }
    
    @objc func addFriendButtonPressed(){
        if !self.possibleMembersTableVisible{
            possibleMembersVisibleConstraint?.isActive = true
            possibleMembersDefaultConstraint?.isActive = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.modularKeyboard.groupAddButton.tintColor = Colors.nebulaBlue
            }, completion: {_ in
                self.possibleMembersTableVisible = true
                self.modularKeyboard.disableButtons()
            })
        }else{
            possibleMembersVisibleConstraint?.isActive = false
            possibleMembersDefaultConstraint?.isActive = true
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
                self.modularKeyboard.groupAddButton.tintColor = Colors.nebulaPurple
            }, completion: {_ in
                self.possibleMembersTableVisible = false
                self.modularKeyboard.enableButtons()
                self.topView.hideConfirmAddFriendButton()
                self.didImpact = false
                self.selectedPossibleMembers = [String]()
                self.possibleMembersTable.reloadData()
            })
        }
    }
    
    
    @objc func confirmAddButtonPressed(){
        // This is basically just taking off the semicolon and adding a user then re-adding it
        // String manipulation in Swift sucks...that or I'm just dumb
        var newInvolved = self.involved
        newInvolved.remove(at: newInvolved.index(before: newInvolved.endIndex))
        
        for friend in self.selectedPossibleMembers{
            newInvolved += ":"
            newInvolved += friend
        }
        
        newInvolved += ";"
        newInvolved = Utility.alphabetSort(preConvId: newInvolved)
        
        ConversationRoutes.changeGroupMembers(id: id, newInvolved: newInvolved, oldInvolved: involved){
            
            self.friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: newInvolved)
            if self.friend.count > self.maxChars{
                self.friend.removeLast(self.friend.count-self.maxChars)
                self.friend += "..."
            }
            self.involved = newInvolved
            self.topView.involvedLabel.text = self.friend
            self.addFriendButtonPressed()
        }
    }
    
    @objc func closeButtonPressed(){
        if !keyboardIsUp{
            topView.bottomBarActionButton.isHidden = false
            modularKeyboard.closeButtonTapped(){
                self.topView.bottomBarActionButton.alpha = 1
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 100, right: 0)
                self.view.layoutIfNeeded()
            }, completion:{_ in
                self.topView.animateLayer()
                UIView.animate(withDuration: 0.2, animations: {
                    self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    @objc func draggedCircle(_ sender:UIPanGestureRecognizer){
        if self.possibleMembersTableVisible{
            return
        }
        
        switch sender.state {
        case .began:
            if !modularKeyboard.hasMoved{
                self.topView.bottomBarActionButton.isHidden = false
                UIView.animate(withDuration: 0.6, animations: {
                    self.topView.bottomBarActionButton.alpha = 1
                })
            }
        case .changed:
            let translation = sender.translation(in: self.view)
            if !self.keyboardIsUp{
                modularKeyboard.draggedCircle(x: translation.x, y: translation.y)
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else{
                if translation.y > 0{
                    //Possibly dismiss keyboard here
                }
            }
            if !collectionMoved{
                UIView.animate(withDuration: 0.3){
                    self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
                    self.view.layoutIfNeeded()
                }
                self.collectionMoved = true
            }
        default:
            break
        }
    }
    
    @objc func resetButton(){
        collectionMoved = false
        self.resetBottomBar()
        UIView.animate(withDuration: 0.3, animations: {
            self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 112, right: 0)
            self.view.layoutIfNeeded()
            self.topView.bottomBarActionButton.alpha = 0
        }, completion: {_ in
            self.scrollToBottom(animated: true)
        })
    }
    
    @objc func downButtonPressed(){
        view.endEditing(true)
        if self.possibleMembersTableVisible{
            self.modularKeyboard.closeButton.isEnabled = false
        }
    }
    
    @objc func sendWrapper(sender: UIButton){
        self.sendMessage(sender)
    }
    
    @objc func goBack(sender: UIButton){
        GlobalUser.currentConv = ""
        self.view.endEditing(true)
        let vcAmount = self.navigationController?.viewControllers.count
        if let mainVC = self.navigationController?.viewControllers[vcAmount!-2] as? MainMenuVC{
            mainVC.convTable.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func swipeRightOnCollection(){
        GlobalUser.currentConv = ""
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeVC()  {
        view.endEditing(true)
    }
    
    @objc func openVC()  {
        self.messagesCollection.reloadData()
    }
}
