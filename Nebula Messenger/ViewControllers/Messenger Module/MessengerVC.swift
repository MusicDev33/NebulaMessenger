//
//  MessengerVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/20/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class MessengerVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
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
    
    var addToGroupButton = UIButton()
    var exitGroupButton = UIButton()
    var confirmAddButton = UIButton()
    
    var possibleMembers = [String]()
    var possibleMembersTable: UITableView!
    var selectedFriend = ""
    
    //Pulsating Layer
    var pulsatingLayer: CAShapeLayer!
    
    var timer: Timer?
    
    func animateLayer(){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.pulsatingLayer.fillColor = UIColor.clear.cgColor
            self.pulsatingLayer.isHidden = true
            self.pulsatingLayer.removeAllAnimations()
        })
        let bgColor = nebulaPurple.withAlphaComponent(0.3)
        self.pulsatingLayer.fillColor = bgColor.cgColor
        self.pulsatingLayer.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "transform.scale.xy")
        animation.toValue = 2
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.isRemovedOnCompletion = false
        
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.toValue = 0.0
        alphaAnim.duration = 0.4
        alphaAnim.fillMode = CAMediaTimingFillMode.forwards
        alphaAnim.isRemovedOnCompletion = false
        
        pulsatingLayer.add(alphaAnim, forKey: "alphaChange")
        pulsatingLayer.add(animation, forKey: "pulsing")
        CATransaction.commit()
    }
    
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
            self.confirmAddButton.isEnabled = true
        }else{
            print(self.selectedFriend)
        }
    }
    
    @objc func addToGroupButtonPressed(){
        self.possibleMembersTable.reloadData()
        self.view.addSubview(self.possibleMembersTable)
        UIView.animate(withDuration: 0.4, animations: {
            self.possibleMembersTable.frame.origin.y = 100
        })
        self.view.endEditing(true)
    }
    
    @objc func exitGroupButtonPressed(){
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.possibleMembersTable.frame.origin.y = self.view.frame.height
            self.exitGroupButton.alpha = 0
            self.exitGroupButton.frame.origin.x -= 50
            self.confirmAddButton.alpha = 0
            self.confirmAddButton.frame.origin.x += 50
            
            //Rotate buttons
            self.confirmAddButton.transform = CGAffineTransform.identity
            self.exitGroupButton.transform = CGAffineTransform.identity
        }, completion: {finished in
            self.confirmAddButton.removeFromSuperview()
            self.exitGroupButton.removeFromSuperview()
            self.possibleMembersTable.removeFromSuperview()
        })
        self.addToGroupButton.isEnabled = true
    }
    
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
    }
    
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
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
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
        newView.grabCircle.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedCircle(_:)))
        panGesture.delegate = self
        newView.grabCircle.isUserInteractionEnabled = true
        newView.grabCircle.addGestureRecognizer(panGesture)
        
        newView.bottomBarActionButton.addTarget(self, action: #selector(resetButton), for: .touchUpInside)
        newView.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        newView.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        newView.downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchUpInside)
        newView.sendButton.addTarget(self, action: #selector(sendWrapper(sender:)), for: .touchUpInside)
        //newView.groupFunctionButton.addTarget(self, action: #selector(addToGroupButtonPressed), for: .touchUpInside)
        
        print(self.isGroupChat)
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
        self.messagesCollection.keyboardDismissMode = .interactive
        
        let window = UIApplication.shared.keyWindow
        topPadding = window?.safeAreaInsets.top ?? 0
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        self.setupKeyboardObservers()
        
        //Adding lines that make it look good
        //Top line
        
        GlobalUser.currentConv = self.friend
        self.scrollToBottom(animated: true)
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
        
        cell.textView.text = text
        
        cell.bubbleWidthAnchor?.constant = findSize(text: text!, label: cell.textView).width + 32
        
        if self.msgList[indexPath.row].sender == GlobalUser.username{
            print("User sent")
            cell.bubbleView.backgroundColor = userTextColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            print("Other sent")
            cell.bubbleView.backgroundColor = otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        var height: CGFloat = 80
        height = findSize(text: self.msgList[indexPath.row].body!, label: cell.textView).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    func findSize(text: String, label: UITextView) -> CGRect{
        let constraintRect = CGSize(width: 200,
                                    height: 1000)
        
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: label.font], context: nil)
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
        if textView.text.count == 0{
            newView.sendButton.isEnabled = false
        }else{
            newView.sendButton.isEnabled = true
        }
        UserDefaults.standard.set(textView.text, forKey: self.id)
    }
    
    @objc func typingTimerComplete(){
        SocketIOManager.sendNotTyping(id: self.id)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
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
            newView.moveWithKeyboard(yValue: keyboardSize.height, duration: keyboardDuration)
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
    
    @objc func sendWrapper(sender: UIButton){
        self.sendMessage(sender)
    }
    
    
    //MARK: Actions
    @IBAction func sendMessage(_ sender: UIButton) {
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
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = self.newView.messageField.text
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
                    self.messagesCollection.reloadData()
                    self.newView.messageField.text = ""
                    SocketIOManager.sendMessage(message: [dec])
                    
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
    
    @IBAction func backButton(_ sender: UIButton) {
        GlobalUser.currentConv = ""
        self.performSegue(withIdentifier: "messengerVCToMainMenu", sender: self)
    }
    
    @objc func goBack(sender: UIButton){
        GlobalUser.currentConv = ""
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "messengerVCToMainMenu", sender: self)
    }
    
    @IBAction func tappedOnTrashButton(_ sender: UIButton) {
        self.deleteModeOn = !self.deleteModeOn
        self.messagesCollection.allowsSelection = self.deleteModeOn
        self.messagesCollection.allowsMultipleSelection = self.deleteModeOn
        //self.messagesCollection.allowsMultipleSelectionDuringEditing = self.deleteModeOn
        if self.deleteModeOn{
            //self.trashButton.imageView?.tintColor = nebulaFlame
        }else{
            //self.trashButton.imageView?.tintColor = nebulaPurple
        }
        if self.deleteArray.count > 0{
            let alert = UIAlertController(title: "Do you want to delete these messages?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                MessageRoutes.deleteMessages(msgsArray: self.deleteArray){
                    for id in self.deleteArray{
                        self.msgList = self.msgList.filter { $0._id != id }
                    }
                    
                    self.deleteArray = [String]()
                    self.messagesCollection.reloadData()
                    //self.deleteMsgLabel.isHidden = !self.deleteModeOn
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
                self.messagesCollection.reloadData()
                self.deleteArray = [String]()
                //self.deleteMsgLabel.isHidden = !self.deleteModeOn
            }))
            
            self.present(alert, animated: true)
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
                        self.msgList.append(tempMsg)
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
