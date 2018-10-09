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
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var didScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.messageTextView.delegate = self
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.messagesCollection.keyboardDismissMode = .interactive
        
        RouteLogic.getMessages(id: self.id){messageList in
            self.msgList = messageList
            self.messagesCollection.reloadData()
            self.messagesCollection.layoutIfNeeded()
            //self.scrollToBottom()
        }
        
        messageTextView!.layer.borderWidth = 1
        messageTextView!.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 10.0
        
        self.setupKeyboardObservers()
        
        //Adding lines that make it look good
        //Top line
        var lineView = UIView(frame: CGRect(x: 0, y: self.messagesCollection.frame.origin.y, width: view.frame.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        //Bottom Line lol
        bottomLineView = UIView(frame: CGRect(x: 0, y: self.bottomView.frame.origin.y, width: view.frame.width, height: 1.0))
        bottomLineView.layer.borderWidth = 1.0
        bottomLineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(bottomLineView)
        
        self.deleteMsgLabel.isHidden = true
        
        self.openSocket {
        }
        
        self.sendButton.isEnabled = false
        
        GlobalUser.currentConv = self.friend
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.messagesCollection.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.messagesCollection.layoutIfNeeded()
        if !didScroll{
            self.scrollToBottom()
            didScroll = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        let constraintRect = CGSize(width: 0.66 * view.frame.width,
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
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            self.messagesCollection.layoutIfNeeded()
            var scrollToY = self.messagesCollection.contentSize.height - self.messagesCollection.frame.height + 8
            
            let contentPoint = CGPoint(x: 0, y: scrollToY)
            self.messagesCollection.setContentOffset(contentPoint, animated: false)
            //self.messagesCollection?.scrollToItem(at: IndexPath(item: self.msgList.count-1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: true)
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
        print("HHOHOHOH")
        let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect)
        
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardFrame.height+8, right: 0)
        
        self.bottomViewBottomAnchor?.constant += keyboardFrame.height
        self.bottomLineView.frame.origin.y -= keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration){
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.bottomViewBottomAnchor?.constant = 0
        self.bottomLineView.frame.origin.y = self.view.frame.height - self.bottomView.frame.height
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
                    //let jsonObject = JSON(Json)
                    self.messagesCollection.reloadData()
                    self.messageTextView.text = ""
                    SocketIOManager.sendMessage(message: [dec])
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
        GlobalUser.currentConv = ""
        self.performSegue(withIdentifier: "messengerVCToMainMenu", sender: self)
    }
    
    @IBAction func tappedOnTrashButton(_ sender: UIButton) {
        self.deleteModeOn = !self.deleteModeOn
        self.messagesCollection.allowsSelection = self.deleteModeOn
        self.messagesCollection.allowsMultipleSelection = self.deleteModeOn
        //self.messagesCollection.allowsMultipleSelectionDuringEditing = self.deleteModeOn
        if self.deleteModeOn{
            self.deleteMsgLabel.isHidden = !self.deleteModeOn
        }else{
            self.deleteMsgLabel.isHidden = true
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
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            do {
                
                let tempMsg = TerseMessage(_id: "", //Fix this
                                           sender: msg["sender"].string!,
                                           body: msg["body"].string!,
                                           dateTime: msg["dateTime"].string!,
                                           read: false)
                if msg["convId"].string! == self.involved{
                    self.msgList.append(tempMsg)
                    self.messagesCollection.reloadData()
                    //self.scrollToBottomAnimated(animated: true)
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
    }
}
