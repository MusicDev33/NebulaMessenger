//
//  PoolChatVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/9/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class PoolChatVC: MessengerBaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var currentPoolMessages = [TerseMessage]()
    var poolId = ""
    var poolName = ""
    
    var newView: PoolChatView!
    var messagesCollection: UICollectionView! { didSet {
        messagesCollection.dataSource = self
        messagesCollection.delegate = self
        }
    }
    
    var subscribed = false
    
    var bottomPadding: CGFloat!
    var topPadding: CGFloat!
    
    var keyboardIsUp = false
    
    var messagesCollectionBottomConstraint: NSLayoutConstraint?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPoolMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        let text = self.currentPoolMessages[indexPath.row].body
        
        cell.textView.text = text
        cell.bubbleWidthAnchor?.constant = findSize(text: text!, label: cell.textView).width + 32
        cell.senderLabel.text = ""
        
        cell.textView.textColor = UIColor.white
        
        cell.senderHeightAnchor?.constant = 0
        
        if self.currentPoolMessages[indexPath.row].sender == GlobalUser.username{
            cell.senderHeightAnchor?.constant = 0
            cell.bubbleView.backgroundColor = userTextColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            if cell.bubbleView.backgroundColor == nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            
        }else{
            cell.senderHeightAnchor?.constant = 20
            cell.bubbleView.backgroundColor = otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if cell.bubbleView.backgroundColor == nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            
            if indexPath.row > 0 && self.currentPoolMessages[indexPath.row-1].sender != self.currentPoolMessages[indexPath.row].sender{
                cell.senderLabel.text = self.currentPoolMessages[indexPath.row].sender
            }
            
            cell.senderLeftAnchor?.isActive = true
            cell.senderRightAnchor?.isActive = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        var height: CGFloat = 80
        height = findSize(text: self.currentPoolMessages[indexPath.row].body!, label: cell.textView).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
    
    func findSize(text: String, label: UITextView) -> CGRect{
        let constraintRect = CGSize(width: 200,
                                    height: 1000)
        
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: label.font as Any], context: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        
        GlobalUser.currentConv = self.poolId
        
        let window = UIApplication.shared.keyWindow
        topPadding = window?.safeAreaInsets.top ?? 0
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        self.newView = PoolChatView(frame: self.view.frame, view: self.view)
        self.view.addSubview(newView)
        
        newView.involvedLabel.text = "Pool"
        newView.involvedCenterAnchor?.isActive = true
        
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
        
        self.newView.addSubview(self.messagesCollection)
        newView.sendSubviewToBack(self.messagesCollection)
        
        messagesCollection.topAnchor.constraint(equalTo: newView.navBar.bottomAnchor, constant: 0).isActive = true
        messagesCollectionBottomConstraint = messagesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -newView.bottomBar.frame.height)
        messagesCollectionBottomConstraint?.isActive = true
        messagesCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messagesCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        // Do any additional setup after loading the view.
        newView.messageField.delegate = self
        if newView.messageField.text.count == 0{
            newView.sendButton.isEnabled = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapOnCircle(_:)))
        tapGesture.numberOfTapsRequired = 2
        //newView.bottomBar.isUserInteractionEnabled = true
        newView.grabCircle.addGestureRecognizer(tapGesture)
        
        let tapOnSubscribeGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnSubscribe))
        tapOnSubscribeGesture.delegate = self
        newView.subscribeView.addGestureRecognizer(tapOnSubscribeGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedCircle(_:)))
        panGesture.delegate = self
        newView.grabCircle.isUserInteractionEnabled = true
        newView.grabCircle.addGestureRecognizer(panGesture)
        
        newView.bottomBarActionButton.addTarget(self, action: #selector(resetButton), for: .touchUpInside)
        newView.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        newView.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        newView.downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchUpInside)
        newView.sendButton.addTarget(self, action: #selector(sendWrapper(sender:)), for: .touchUpInside)
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
        self.messagesCollection.keyboardDismissMode = .interactive
        
        self.setupKeyboardObservers()
        
        self.openSocket {
        }
        self.scrollToBottom(animated: true)
        self.newView.involvedLabel.text = self.poolName
        
        print("OOOOOOO")
        print(GlobalUser.subscribedPools)
        if GlobalUser.subscribedPools.contains(self.poolId){
            subscribed = true
            self.newView.subscribeView.backgroundColor = UIColor.green
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeVC), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openVC), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc func tappedOnSubscribe(){
        if subscribed{
            PoolRoutes.removePoolSubscription(poolId: self.poolId, completion: {success in
                if success == true{
                    self.newView.subscribeView.backgroundColor = UIColor.red
                    self.subscribed = false
                    Messaging.messaging().unsubscribe(fromTopic: self.poolId)
                    GlobalUser.subscribedPools = GlobalUser.subscribedPools.filter {$0 != self.poolId}
                }
            })
        }else{
            PoolRoutes.addPoolSubscription(poolId: self.poolId, completion: {success in
                if success == true{
                    self.subscribed = true
                    Messaging.messaging().subscribe(toTopic: self.poolId)
                    self.newView.subscribeView.backgroundColor = UIColor.green
                    GlobalUser.subscribedPools.append(self.poolId)
                }
            })
        }
    }
    
    @objc func closeVC()  {
        view.endEditing(true)
    }
    
    @objc func openVC()  {
        self.messagesCollection.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            self.messagesCollection.layoutIfNeeded()
            let scrollToY = self.messagesCollection.contentSize.height - self.messagesCollection.frame.height + 8
            let cInset = self.messagesCollection.contentInset.bottom
            
            let contentPoint = CGPoint(x: 0, y: scrollToY + cInset)
            self.messagesCollection.setContentOffset(contentPoint, animated: animated)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0{
            newView.sendButton.isEnabled = false
        }else{
            newView.sendButton.isEnabled = true
        }
        UserDefaults.standard.set(textView.text, forKey: self.poolId)
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
            
            let safeAreaBottomInset = self.view.safeAreaInsets.bottom
            UIView.animate(withDuration: keyboardDuration){
                self.view.layoutIfNeeded()
            }
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
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let url = URL(string: sendPoolsRoute)
        
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
        
        requestJson["groupChat"] = "HELLO"
        
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = self.newView.messageField.text
        requestJson["dateTime"] = now
        requestJson["topic"] = "POOL"
        requestJson["id"] = self.poolId
        requestJson["isPool"] = true
        
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
                case .success( _):
                    //let jsonObject = JSON(Json)
                    //let jsonObject = JSON(Json)
                    self.messagesCollection.reloadData()
                    self.newView.messageField.text = ""
                    SocketIOManager.sendMessage(message: [dec as Any])
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
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        print("Opened Pool Socket!")
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            let tempMsg = TerseMessage(_id: "", //Fix this
                sender: msg["sender"].string!,
                body: msg["body"].string!,
                dateTime: msg["dateTime"].string!,
                read: false)
            
            guard let msgId = msg["id"].string else{
                return
            }
            
            if msgId == self.poolId{
                self.currentPoolMessages.append(tempMsg)
                self.messagesCollection.reloadData()
                //self.scrollToBottomAnimated(animated: true)
                self.scrollToBottom(animated: true)
            }
        }
    }
    
    // newView Actions
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
    
    @objc func sendWrapper(sender: UIButton){
        self.sendButtonPressed(sender)
    }
    
    @objc func goBack(sender: UIButton){
        GlobalUser.currentConv = ""
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SocketIOManager.shutOffListener()
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
}
