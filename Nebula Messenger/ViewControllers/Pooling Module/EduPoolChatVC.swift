//
//  EduPoolChatVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/27/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class EduPoolChatVC: MessengerBaseVC {
    
    var currentPoolMessages = [TerseMessage]()
    var poolId = ""
    var poolName = ""
    
    var subscribed = false
    
    var messagesCollectionBottomConstraint: NSLayoutConstraint?
    
    var collectionMoved = false
    
    var questions = [TeacherQuestion]()
    
    // Shameless hack because I'm stupid
    var questionHeights = [String:CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let question = TeacherQuestion(question: "Find the surface area of a pickle (Yes, this question is harder than Question 1).", date: "3/14/19", questionMode: ModKeyMode.multiChoice,
                                       answers: ["A":"I don't know",
                                                 "B":"To get to the other side",
                                                 "C":"I don't know dude",
                                                 "D":"I really don't know",
                                                 "E":"Uhhh...",], correctAnswer: "B", questionNumber: 1, optionalText: "Answer the question!", groupID: "SomeID",
                                                                  open: false)
        
        let question2 = TeacherQuestion(question: "Find the geodesic distance between two tesseracts in a 4th-dimensional non-Euclidean plane, then find the circumference of the subsequent hypersphere (4th-dimensional) with the diameter being the line segment connected by two points.", date: "3/14/19", questionMode: ModKeyMode.multiChoice,
                                        answers: ["A":"I don't know",
                                                  "B":"To get to the other side",
                                                  "C":"I don't know dude",
                                                  "D":"I really don't know",
                                                  "E":"Uhhh...",], correctAnswer: "B", questionNumber: 2, optionalText: "Answer the question!", groupID: "SomeID",
                                                                   open: false)
        
        questions.append(question)
        questions.append(question2)
        
        questionHeights[question.question] = 0
        questionHeights[question2.question] = 0
        
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
        layout.itemSize = CGSize(width: self.view.frame.width-20, height: 50)
        layout.scrollDirection = .vertical
        
        messagesCollection = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 500), collectionViewLayout: layout)
        messagesCollection.register(QuestionModule.self, forCellWithReuseIdentifier: "questionModule")
        
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
        
        self.messagesCollection.reloadData()
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
extension EduPoolChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.messagesCollection.dequeueReusableCell(withReuseIdentifier: "questionModule", for: indexPath) as! QuestionModule
        //cell.poolNameLabel.text = self.currentPools[indexPath.row].name
        cell.questionLabel.text = self.questions[indexPath.row].question
        cell.questionNumberLabel.text = String(self.questions[indexPath.row].questionNumber)
        
        cell.setupConstraints()
        
        cell.bubbleHeightAnchor?.constant = cell.bounds.height
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionModule", for: indexPath) as! QuestionModule
        cell.questionLabel.text = questions[indexPath.row].question!
        cell.questionLabel.sizeToFit()
        var height: CGFloat = 300
        
        let labelLines = CGFloat(cell.questionLabel.calculateMaxLines())
        
        height = findSize(text: questions[indexPath.row].question, label: cell.questionLabel, width: cell.questionLabel.bounds.width).height + 25 + (11*(labelLines))
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        questions[indexPath.row].open = true
        // Works but it's still broken
        //cell?.frame = CGRect(x: (cell?.frame.origin.x)!, y: (cell?.frame.origin.y)!, width: (cell?.frame.width)!, height: (cell?.frame.height)! + 200)
        
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
            
        }, completion: {_ in
            
        })
    }
    
    func findSize(text: String, label: UILabel, width: CGFloat) -> CGRect{
        let constraintRect = CGSize(width: width,
                                    height: 1000)
        let defaultFontSize = CGFloat(16)
        
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize)], context: nil)
    }
}


// MARK: TextViewDelegate
extension EduPoolChatVC: UITextViewDelegate {
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
extension EduPoolChatVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


// MARK: Sockets
extension EduPoolChatVC {
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
extension EduPoolChatVC {
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
