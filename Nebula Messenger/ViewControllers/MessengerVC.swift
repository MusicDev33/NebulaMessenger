//
//  MessengerVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/20/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class MessengerVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var msgList = [TerseMessage]()
    
    var id = ""
    var involved = ""
    var friend = ""
    
    var skipNotif = false
    
    var deleteModeOn = false
    var deleteArray = [String]()
    var bottomLineView = UIView()
    
    //@IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var deleteMsgLabel: UILabel!
    @IBOutlet weak var messagesCollection: UICollectionView!
    
    @IBOutlet weak var trashButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var didScroll = false
    
    var bottomPadding: CGFloat!
    var topPadding: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.messageTextView.delegate = self
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.messagesCollection.keyboardDismissMode = .interactive
        
        let window = UIApplication.shared.keyWindow
        topPadding = window?.safeAreaInsets.top ?? 0
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        messageTextView!.layer.borderWidth = 1
        messageTextView!.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 10.0
        
        self.setupKeyboardObservers()
        
        //Adding lines that make it look good
        //Top line
        let lineView = UIView(frame: CGRect(x: 0, y: 0-self.messagesCollection.frame.origin.y, width: view.frame.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        //Bottom Line lol
        bottomLineView = UIView(frame: CGRect(x: 0, y: view.frame.height-self.bottomView.frame.height-bottomPadding, width: view.frame.width, height: 1.0))
        print("Y")
        print(self.bottomView.frame.origin.y)
        print(self.bottomLineView.frame.origin.y)
        bottomLineView.layer.borderWidth = 1.0
        bottomLineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(bottomLineView)
        
        self.deleteMsgLabel.text = self.friend
        
        self.sendButton.isEnabled = false
        
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
        self.messageTextView.text = UserDefaults.standard.string(forKey: self.id) ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeVC), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openVC), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    @objc func closeVC()  {
        view.endEditing(true)
    }
    
    @objc func openVC()  {
        self.messagesCollection.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.alpha = 0.3
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.msgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        let text = self.msgList[indexPath.row].body
        
        cell.messageLabel.text = text
        cell.bubbleWidthAnchor?.constant = findSize(text: text!, label: cell.messageLabel).width + 20
        
        if self.msgList[indexPath.row].sender == GlobalUser.username{
            cell.bubbleView.backgroundColor = userTextColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        var height: CGFloat = 80
        height = findSize(text: self.msgList[indexPath.row].body!, label: cell.messageLabel).height + 30
        return CGSize(width: view.frame.width, height: height)
    }
    
    func findSize(text: String, label: UILabel) -> CGRect{
        let constraintRect = CGSize(width: 0.8 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let returnRect = text.boundingRect(with: constraintRect,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: label.font],
                                           context: nil)
        return returnRect
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        print(self.messagesCollection.contentOffset)
        print(self.messagesCollection.contentSize.height)
        print(self.messagesCollection.frame.height)
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
    
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        print(textView.text)
        print(":"+text+":")
        if text == ""{
            if textView.text.count-1 > 0{
                self.sendButton.isEnabled = true
            }else{
                self.sendButton.isEnabled = false
            }
        }else{
            if textView.text.count+1 > 0{
                self.sendButton.isEnabled = true
            }else{
                self.sendButton.isEnabled = false
            }
        }
        UserDefaults.standard.set(textView.text, forKey: self.id)
        return true
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
        let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect)
        
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardFrame.height+8-bottomPadding, right: 0)
        
        self.bottomViewBottomAnchor?.constant += keyboardFrame.height - bottomPadding
        self.bottomLineView.frame.origin.y -= keyboardFrame.height - bottomPadding
        self.scrollToBottom(animated: true)
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.bottomViewBottomAnchor?.constant = 0
        self.bottomLineView.frame.origin.y = view.frame.height-self.bottomView.frame.height-bottomPadding
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
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
        requestJson["body"] = self.messageTextView.text
        requestJson["convId"] = self.involved
        //requestJson["read"] = false
        requestJson["dateTime"] = now
        requestJson["topic"] = self.friend
        requestJson["id"] = self.id
        
        print(requestJson)
        
        self.sendButton.isEnabled = false
        
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
                    self.messageTextView.text = ""
                    SocketIOManager.sendMessage(message: [dec])
                    if jsonObject["id"].exists(){
                        self.id = jsonObject["id"].string!
                        UserDefaults.standard.set("", forKey: self.id)
                        GlobalUser.addToConvNames(convName: self.friend, id: self.id, involved: self.involved)
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
    
    @IBAction func tappedOnTrashButton(_ sender: UIButton) {
        self.deleteModeOn = !self.deleteModeOn
        self.messagesCollection.allowsSelection = self.deleteModeOn
        self.messagesCollection.allowsMultipleSelection = self.deleteModeOn
        //self.messagesCollection.allowsMultipleSelectionDuringEditing = self.deleteModeOn
        if self.deleteModeOn{
            self.trashButton.imageView?.tintColor = nebulaFlame
        }else{
            self.trashButton.imageView?.tintColor = nebulaPurple
        }
        if self.deleteArray.count > 0{
            let alert = UIAlertController(title: "Do you want to delete these messages?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                RouteLogic.deleteMessages(msgsArray: self.deleteArray){
                    for id in self.deleteArray{
                        self.msgList = self.msgList.filter { $0._id != id }
                    }
                    
                    self.deleteArray = [String]()
                    self.messagesCollection.reloadData()
                    self.deleteMsgLabel.isHidden = !self.deleteModeOn
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
                self.messagesCollection.reloadData()
                self.deleteArray = [String]()
                self.deleteMsgLabel.isHidden = !self.deleteModeOn
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
            print("DATA")
            print(parsedData)
            let msg = JSON.init(parseJSON: parsedData)
            print(msg)
            do {
                
                let tempMsg = TerseMessage(_id: "", //Fix this
                                           sender: msg["sender"].string!,
                                           body: msg["body"].string!,
                                           dateTime: msg["dateTime"].string!,
                                           read: false)
                print(tempMsg)
                print(self.involved)
                
                guard let msgConvId = msg["convId"].string else{
                    return
                }
                
                if Utility.alphabetSort(preConvId: msgConvId) == Utility.alphabetSort(preConvId: self.involved){
                    print("Something happened!")
                    if msg["sender"].string! == GlobalUser.username{
                        
                    }else{
                        playIncomingMessage()
                    }
                    self.msgList.append(tempMsg)
                    self.messagesCollection.reloadData()
                    self.scrollToBottom(animated: true)
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
    }
    
    //MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SocketIOManager.socket.off("message")
        if segue.destination is MainMenuVC{
            let vc = segue.destination as? MessengerVC
            SocketIOManager.shutOffListener()
        }
    }
}
