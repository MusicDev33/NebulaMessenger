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

class MessengerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var msgList = [TerseMessage]()
    
    var id = ""
    var involved = ""
    var friend = ""
    var isGroupChat = false
    
    var skipNotif = false
    
    var deleteModeOn = false
    var deleteArray = [String]()
    var bottomLineView = UIView()
    
    var keyboardIsUp = false
    
    var messagesCollection: UICollectionView! { didSet {
        messagesCollection.dataSource = self
        messagesCollection.delegate = self
        }
    }
    var maxChars = 22
    
    var didScroll = false
    
    var bottomPadding: CGFloat!
    var topPadding: CGFloat!
    
    var possibleMembers = [String]()
    var possibleMembersTable: UITableView!
    var selectedFriend = ""
    
    
    var timer: Timer?
    
    // Might build this in other file later
    func createTableView(){
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let barHeight: CGFloat = 100
        
        self.possibleMembersTable = UITableView(frame: CGRect(x: 0, y: self.view.frame.height, width: displayWidth, height: displayHeight - barHeight))
        self.possibleMembersTable.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
        self.possibleMembersTable.dataSource = self
        self.possibleMembersTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.possibleMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(self.possibleMembers[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellText = self.possibleMembers[indexPath.row]
        self.selectedFriend = cellText
        if self.selectedFriend != ""{
            //self.confirmAddButton.isEnabled = true
        }else{
            print(self.selectedFriend)
        }
    }
    
    /*
    @objc func confirmAddButtonPressed(){
        // This is basically just taking off the semicolon and adding a user then re-adding it
        // String manipulation in Swift sucks...that or I'm just dumb
        var newInvolved = self.involved
        newInvolved.remove(at: newInvolved.index(before: newInvolved.endIndex))
        newInvolved += ":"
        newInvolved += self.selectedFriend
        newInvolved += ";"
        newInvolved = Utility.alphabetSort(preConvId: newInvolved)
        
        ConversationRoutes.changeGroupMembers(id: id, newInvolved: newInvolved, oldInvolved: involved){
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.possibleMembersTable.frame.origin.y = self.view.frame.height
                self.exitGroupButton.alpha = 0
                self.exitGroupButton.frame.origin.x -= 50
                self.confirmAddButton.alpha = 0
                self.confirmAddButton.frame.origin.x += 50
                
                //Rotate buttons
                self.confirmAddButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.exitGroupButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }, completion: {finished in
                self.exitGroupButton.removeFromSuperview()
                self.possibleMembersTable.removeFromSuperview()
                self.confirmAddButton.removeFromSuperview()
            })
            self.addToGroupButton.isEnabled = true
            
            self.friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: newInvolved)
            if self.friend.count > self.maxChars{
                self.friend.removeLast(self.friend.count-self.maxChars)
                self.friend += "..."
            }
            self.involved = newInvolved
        }
    }*/
    
    @objc func doubleTapOnCircle(_ sender: UITapGestureRecognizer){
        newView.tappedGrabCircle()
    }
    
    @objc func closeButtonPressed(){
        if !keyboardIsUp{
            newView.closeButtonTapped()
            self.messagesCollectionBottomConstraint?.constant -= 3
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion:{_ in
                self.messagesCollectionBottomConstraint?.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    var collectionMoved = false
    @objc func draggedCircle(_ sender:UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            print("hi")
        case .changed:
            let translation = sender.translation(in: self.view)
            if !self.keyboardIsUp{
                newView.draggedCircle(x: translation.x, y: translation.y)
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else{
                if translation.y > 0{
                    //Possibly dismiss keyboard here
                }
            }
            if !collectionMoved{
                self.messagesCollectionBottomConstraint?.constant = 0
                //self.collectionBottomAnchor?.constant = 100
                let quickFrame = self.messagesCollection.frame
                UIView.animate(withDuration: 0.3){
                    self.messagesCollection.frame = CGRect(x: quickFrame.origin.x, y: quickFrame.origin.y, width: quickFrame.width, height: quickFrame.height+100)
                    self.view.layoutIfNeeded()
                }
                print("moved")
                self.collectionMoved = true
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc func resetButton(){
        collectionMoved = false
        newView.resetBottomBar()
        self.messagesCollectionBottomConstraint?.constant = -self.newView.bottomBar.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.scrollToBottom(animated: true)
        })
    }
    
    @objc func downButtonPressed(){
        view.endEditing(true)
    }
    
    @objc func groupFunctionButtonPressed(){
        newView.groupFunctionPressed()
    }
    
    @objc func goBack(sender: UIButton){
        GlobalUser.currentConv = ""
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "messengerVCToMainMenu", sender: self)
    }
    
    @objc func sendWrapper(sender: UIButton){
        self.sendMessage(sender)
    }
    
    var newView: MessengerView!
    var messagesCollectionBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        if self.friend.count > maxChars{
            self.friend.removeLast(self.friend.count-maxChars)
            self.friend += "..."
        }
        
        
        //Making a collectionview
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 375, height: 50)
        layout.estimatedItemSize = CGSize(width: 375, height: 50)
        layout.scrollDirection = .vertical
        
        messagesCollection = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 500), collectionViewLayout: layout)
        messagesCollection.register(MessageBubble.self, forCellWithReuseIdentifier: "messageBubble")
        
        messagesCollection.translatesAutoresizingMaskIntoConstraints = false
        messagesCollection.backgroundColor = UIColor.white
        messagesCollection.isScrollEnabled = true
        messagesCollection.isUserInteractionEnabled = true
        messagesCollection.alwaysBounceVertical = true
        
        newView = MessengerView(frame: self.view.frame, view: self.view)
        newView.involvedLabel.text = self.friend
        newView.involvedCenterAnchor?.isActive = true
        
        self.view.addSubview(newView)
        print(newView.bottomBar.alpha)
        print("THIS")
        self.newView.addSubview(self.messagesCollection)
        newView.sendSubviewToBack(self.messagesCollection)
        
        messagesCollection.topAnchor.constraint(equalTo: newView.navBar.bottomAnchor, constant: 0).isActive = true
        messagesCollectionBottomConstraint = messagesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -newView.bottomBar.frame.height)
        messagesCollectionBottomConstraint?.isActive = true
        messagesCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //messagesCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        messagesCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        //messagesCollection.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapOnCircle(_:)))
        tapGesture.numberOfTapsRequired = 2
        //newView.bottomBar.isUserInteractionEnabled = true
        newView.bottomBar.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedCircle(_:)))
        panGesture.delegate = self
        newView.bottomBar.isUserInteractionEnabled = true
        newView.bottomBar.addGestureRecognizer(panGesture)
        
        newView.bottomBarActionButton.addTarget(self, action: #selector(resetButton), for: .touchUpInside)
        newView.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        newView.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        newView.downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchUpInside)
        newView.sendButton.addTarget(self, action: #selector(sendWrapper(sender:)), for: .touchUpInside)
        //newView.groupFunctionButton.addTarget(self, action: #selector(addToGroupButtonPressed), for: .touchUpInside)
        
        let currentlyInvolved = Utility.getFriendsFromConvIdAsArray(user: GlobalUser.username, convId: self.involved)
        self.possibleMembers = GlobalUser.friends.filter {!currentlyInvolved.contains($0)}
        
        if self.isGroupChat{
            self.createTableView()
            newView.buildGroupChatFeatures()
            newView.groupFunctionButton.addTarget(self, action: #selector(groupFunctionButtonPressed), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view.
        newView.messageField.delegate = self
        if newView.messageField.text.count == 0{
            newView.sendButton.isEnabled = false
        }
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
        self.messagesCollection.keyboardDismissMode = .onDrag
        
        let window = UIApplication.shared.keyWindow
        topPadding = window?.safeAreaInsets.top ?? 0
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        self.setupKeyboardObservers()
        
        GlobalUser.currentConv = self.friend
        self.scrollToBottom(animated: false)
        if msgList.count > 0{
            ConversationRoutes.updateLastRead(id: self.id, msgId: msgList[msgList.count-1]._id ?? "NA"){
            }
        }
        GlobalUser.unreadList = GlobalUser.unreadList.filter {$0 != self.id}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.openSocket {
        }
        self.messagesCollection.layoutIfNeeded()
        self.view.alpha = 1
        newView.messageField.text = UserDefaults.standard.string(forKey: self.id) ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeVC), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openVC), name: UIApplication.didBecomeActiveNotification, object: nil)
        newView.resizeTextView()
        let bottom = NSMakeRange(newView.messageField.text.count - 1, 1)
        newView.messageField.scrollRangeToVisible(bottom)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.alpha = 0.3
        SocketIOManager.sendNotTyping(id: self.id)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.messagesCollection.layoutIfNeeded()
        if !didScroll{
            //self.scrollToBottom(animated: false)
            didScroll = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.alpha = 0.3
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func closeVC()  {
        view.endEditing(true)
    }
    
    @objc func openVC()  {
        self.messagesCollection.reloadData()
    }
    
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
            if cell.bubbleView.backgroundColor == nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            cell.senderHideBottomAnchor?.isActive = true
            cell.senderAboveBottomAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = onlyEmoji ? UIColor.clear : otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if cell.bubbleView.backgroundColor == nebulaPink{
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
        self.view.endEditing(true)
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            self.messagesCollection.layoutIfNeeded()
            let scrollToY = self.messagesCollection.contentSize.height - self.messagesCollection.frame.height + 12
            let cInset = self.messagesCollection.contentInset.bottom
            
            let contentPoint = CGPoint(x: 0, y: scrollToY + cInset)
            self.messagesCollection.setContentOffset(contentPoint, animated: animated)
        }
    }
    
    @objc func typingTimerComplete(){
        SocketIOManager.sendNotTyping(id: self.id)
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        if !self.keyboardIsUp{
            self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardSize.height+12-bottomPadding, right: 0)
            self.scrollToBottom(animated: true)
            UIView.animate(withDuration: keyboardDuration){
                self.view.layoutIfNeeded()
            }
            
            let safeAreaBottomInset = self.view.safeAreaInsets.bottom
            
            newView.moveWithKeyboard(yValue: keyboardSize.height - safeAreaBottomInset, duration: keyboardDuration)
        }
        self.keyboardIsUp = true
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        if self.keyboardIsUp{
            self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
            UIView.animate(withDuration: keyboardDuration){
                self.view.layoutIfNeeded()
            }
            newView.resetBottomBar()
        }
        self.keyboardIsUp = false
    }
    
    //MARK: Actions
    func sendMessage(_ sender: UIButton) {
        let url = URL(string: sendRoute)
        
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
        
        let body = self.newView.messageField.text
        
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = body
        
        requestJson["convId"] = self.involved
        //requestJson["read"] = false
        requestJson["dateTime"] = now
        requestJson["topic"] = self.friend
        requestJson["id"] = self.id
        
        print(requestJson)
        
        self.newView.sendButton.isEnabled = false
        
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
                    //let jsonObject = JSON(Json)
                    SocketIOManager.sendMessage(message: [dec])
                    
                    let tempMsg = TerseMessage(_id: "", //Fix this
                        sender: GlobalUser.username,
                        body: self.newView.messageField.text,
                        dateTime: now,
                        read: false)
                    
                    
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
                    }, completion: {done in
                        
                        let lastItem = self.messagesCollection.numberOfItems(inSection: 0) - 1
                        let lastIndex = IndexPath(item: lastItem, section: 0)
                        self.messagesCollection.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                    })
                    
                    
                    //self.msgList.append(tempMsg)
                    //self.messagesCollection.reloadData()
                    //self.scrollToBottom(animated: true)
                    self.newView.messageField.text = ""
                    
                    if jsonObject["conv"].exists(){
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            let alert = UIAlertController(title: "Shake Feedback", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Give Feedback", style: .default, handler: {action in
                let feedbackVC = FeedbackVC()
                feedbackVC.modalPresentationStyle = .overCurrentContext
                self.present(feedbackVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            do {
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
                        /*
                        let lastSectionIndex = self.messagesCollection!.numberOfSections - 1
                        // Then grab the number of rows in the last section
                        let lastRowIndex = self.messagesCollection!.numberOfItems(inSection: lastSectionIndex) - 1
                        // Now just construct the index path
                        let pathToLastRow = NSIndexPath(row: lastRowIndex+1, section: lastSectionIndex)
                        let pathToRow2 = NSIndexPath(row: lastRowIndex+1, section: lastSectionIndex)
                        self.messagesCollection.insertItems(at: [pathToLastRow as IndexPath])
                        self.messagesCollection.reloadItems(at: [pathToRow2 as IndexPath])*/
                        
                        //self.messagesCollection.reloadData()
                        
                        //self.messagesCollection.reloadData()
                        
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
                        }, completion: {done in
                            
                            let lastItem = self.messagesCollection.numberOfItems(inSection: 0) - 1
                            let lastIndex = IndexPath(item: lastItem, section: 0)
                            self.messagesCollection.scrollToItem(at: lastIndex, at: .bottom, animated: true)
                        })
                        
                    }
                    ConversationRoutes.updateLastRead(id: self.id, msgId: ""){
                    }
                    //self.scrollToBottomAnimated(animated: true)
                }else{
                    print("Something went wrong")
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
        
        SocketIOManager.socket.on("typing") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            do {
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
                    print("Something went wrong")
                }
            } catch {
                print("Error JSON: \(error)")
            }
        }
        
        SocketIOManager.socket.on("nottyping") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            do {
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
                    print("Something went wrong")
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
    }
    
    //MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SocketIOManager.socket.off("message")
        SocketIOManager.socket.off("typing")
        SocketIOManager.socket.off("nottyping")
        
        if segue.destination is MainMenuVC{
            let vc = segue.destination as? MessengerVC
            SocketIOManager.shutOffListener()
        }
    }
}

extension MessengerVC: UITextViewDelegate{
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == ""{
            if textView.text.count-1 > 0{
                newView.sendButton.isEnabled = true
            }else{
                newView.sendButton.isEnabled = false
            }
        }else{
            if textView.text.count+1 > 0{
                newView.sendButton.isEnabled = true
            }else{
                newView.sendButton.isEnabled = false
            }
        }
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(typingTimerComplete), userInfo: nil, repeats: true)
        SocketIOManager.sendTyping(id: self.id)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        newView.resizeTextView()
        if textView.text.count == 0{
            newView.sendButton.isEnabled = false
        }else{
            newView.sendButton.isEnabled = true
        }
        UserDefaults.standard.set(textView.text, forKey: self.id)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
}

// Simple solution for detecting emojis in a string
// Thanks, StackOverflow
extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            previousScalar = scalar
        }
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        return chars
    }
}
