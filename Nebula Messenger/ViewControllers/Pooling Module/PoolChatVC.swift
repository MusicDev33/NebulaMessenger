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

class PoolChatVC: MessengerBaseVC {
    
    var currentPoolMessages = [TerseMessage]()
    var poolId = ""
    var poolName = ""
    
    var subscribed = false
    
    var messagesCollectionBottomConstraint: NSLayoutConstraint?
    
    var collectionMoved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.setGradientRandom(colorOne: Colors.nebulaBlueLight, colorTwo: UIColor.white)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        blurEffectView.layer.zPosition = 0
        
        GlobalUser.currentConv = self.poolId
        
        self.topView = PoolChatView(frame: self.view.frame, view: self.view)
        
        self.view.addSubview(topView)
        
        topView.involvedLabel.text = "Pool"
        topView.involvedCenterAnchor?.isActive = true
        
        //Making a collectionview
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
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
        
        self.topView.addSubview(self.messagesCollection)
        topView.sendSubviewToBack(self.messagesCollection)
        self.view.addSubview(modularKeyboard)
        //modularKeyboard.buildConstraints()
        //modularKeyboard.buildMultiChoiceButtons()
        //modularKeyboard.cButton.addTarget(self, action: #selector(cButtonPressed), for: .touchUpInside)
        modularKeyboard.buildTFButtons()
        modularKeyboard.trueButton.addTarget(self, action: #selector(trueButtonPressed), for: .touchUpInside)
        
        messagesCollection.topAnchor.constraint(equalTo: topView.navBar.bottomAnchor, constant: 0).isActive = true
        messagesCollectionBottomConstraint = messagesCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        messagesCollectionBottomConstraint?.isActive = true
        messagesCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messagesCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        // Do any additional setup after loading the view.
        modularKeyboard.messageField.delegate = self
        if modularKeyboard.messageField.text.count == 0{
            modularKeyboard.sendButton.isEnabled = false
        }
        
        let tapOnSubscribeGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnSubscribe))
        tapOnSubscribeGesture.delegate = self
        topView.subscribeView.addGestureRecognizer(tapOnSubscribeGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedCircle(_:)))
        panGesture.delegate = self
        modularKeyboard.isUserInteractionEnabled = true
        modularKeyboard.addGestureRecognizer(panGesture)
        
        topView.bottomBarActionButton.addTarget(self, action: #selector(resetButton), for: .touchUpInside)
        topView.backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        modularKeyboard.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        modularKeyboard.downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchUpInside)
        modularKeyboard.sendButton.addTarget(self, action: #selector(sendWrapper(sender:)), for: .touchUpInside)
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 112, right: 0)
        self.messagesCollection.keyboardDismissMode = .interactive
        
        self.setupKeyboardObservers()
        
        self.openSocket {
        }
        self.scrollToBottom(animated: true)
        self.topView.involvedLabel.text = self.poolName
        
        if GlobalUser.subscribedPools.contains(self.poolId){
            subscribed = true
            self.topView.subscribeView.backgroundColor = UIColor.green
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeVC), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openVC), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        modularKeyboard.animateTFButtonsOut()
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
}

// MARK: CollectionView
extension PoolChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            if cell.bubbleView.backgroundColor == Colors.nebulaPink{
                cell.textView.textColor = UIColor.black
            }
            
        }else{
            cell.senderHeightAnchor?.constant = 20
            cell.bubbleView.backgroundColor = otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            if cell.bubbleView.backgroundColor == Colors.nebulaPink{
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
        let constraintRect = CGSize(width: 200, height: 1000)
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: label.font as Any], context: nil)
    }
}


// MARK: TextViewDelegate
extension PoolChatVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        modularKeyboard.resizeTextView()
        if textView.text.count == 0{
            modularKeyboard.sendButton.isEnabled = false
        }else{
            modularKeyboard.sendButton.isEnabled = true
        }
        UserDefaults.standard.set(textView.text, forKey: self.poolId)
    }
}


// MARK: GestureRecognizers
extension PoolChatVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


// MARK: Sockets
extension PoolChatVC {
    func openSocket(completion: () -> Void) {
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
                self.scrollToBottom(animated: true)
            }
        }
    }
}


// MARK: Listeners
extension PoolChatVC {
    @objc func tappedOnSubscribe(){
        if subscribed{
            PoolRoutes.removePoolSubscription(poolId: self.poolId, completion: {success in
                if success == true{
                    self.topView.subscribeView.backgroundColor = UIColor.red
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
                    self.topView.subscribeView.backgroundColor = UIColor.green
                    GlobalUser.subscribedPools.append(self.poolId)
                }
            })
        }
    }
    
    @objc func closeButtonPressed(){
        if !keyboardIsUp{
            topView.bottomBarActionButton.isHidden = false
            modularKeyboard.closeButtonTapped(){
                self.topView.bottomBarActionButton.alpha = 1
                self.topView.animateLayer()
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 102, right: 0)
                self.view.layoutIfNeeded()
            }, completion:{_ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    @objc func draggedCircle(_ sender:UIPanGestureRecognizer){
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
    
    @objc func resetButton(){
        collectionMoved = false
        self.resetBottomBar()
        
        self.topView.bottomBarActionButton.isHidden = true
        self.messagesCollectionBottomConstraint?.constant = -self.modularKeyboard.frame.height
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
        self.dismiss(animated: true, completion: {
            self.topView.removeFromSuperview()
        })
    }
    
    @objc func cButtonPressed(){
        self.view.layoutIfNeeded()
        modularKeyboard.animateMultiButtonsIn()
    }
    
    @objc func trueButtonPressed(){
        self.view.layoutIfNeeded()
        modularKeyboard.animateTFButtonsIn()
    }
    
    @objc func sendButtonPressed(_ sender: UIButton) {
        let url = URL(string: sendPoolsRoute)
        
        var requestJson = [String:Any]()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy hh:mm:ss"
        
        // Creating the date object
        var now = df.string(from: Date())
        now.insert("a", at: now.index(now.startIndex, offsetBy: +11))
        now.insert("t", at: now.index(now.startIndex, offsetBy: +12))
        now.insert(" ", at: now.index(now.startIndex, offsetBy: +13))
        
        requestJson["groupChat"] = "HELLO"
        
        requestJson["sender"] = GlobalUser.username
        requestJson["body"] = self.modularKeyboard.messageField.text
        requestJson["dateTime"] = now
        requestJson["topic"] = "POOL"
        requestJson["id"] = self.poolId
        requestJson["isPool"] = true
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options:.prettyPrinted)
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
                    self.modularKeyboard.messageField.text = ""
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
}
