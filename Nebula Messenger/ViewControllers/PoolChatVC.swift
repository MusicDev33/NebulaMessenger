//
//  PoolChatVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/9/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class PoolChatVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var messagesCollection: UICollectionView!
    @IBOutlet weak var messageTextView: UITextView!
    
    var currentPoolMessages = [TerseMessage]()
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomAnchor: NSLayoutConstraint!
    
    var bottomLineView: UIView!
    var poolId = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPoolMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        let text = self.currentPoolMessages[indexPath.row].body
        
        cell.messageLabel.text = text
        cell.bubbleWidthAnchor?.constant = findSize(text: text!, label: cell.messageLabel).width + 20
        
        if self.currentPoolMessages[indexPath.row].sender == GlobalUser.username{
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
        height = findSize(text: self.currentPoolMessages[indexPath.row].body!, label: cell.messageLabel).height + 30
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.messagesCollection.keyboardDismissMode = .interactive
        
        self.setupKeyboardObservers()

        // Do any additional setup after loading the view.
        messageTextView.delegate = self
        messageTextView!.layer.borderWidth = 1
        messageTextView!.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 10.0
        
        // Top line
        let lineView = UIView(frame: CGRect(x: 0, y: self.messagesCollection.frame.origin.y, width: view.frame.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        bottomLineView = UIView(frame: CGRect(x: 0, y: self.bottomView.frame.origin.y, width: view.frame.width, height: 1.0))
        bottomLineView.layer.borderWidth = 1.0
        bottomLineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(bottomLineView)
        self.sendButton.isEnabled = false
        
        self.openSocket {
        }
        self.scrollToBottom(animated: true)
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
        self.scrollToBottom(animated: true)
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToPoolingView", sender: self)
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
        requestJson["body"] = self.messageTextView.text
        //requestJson["read"] = false
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
                    self.messageTextView.text = ""
                    SocketIOManager.sendMessage(message: [dec])
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
            do {
                
                let tempMsg = TerseMessage(_id: "", //Fix this
                    sender: msg["sender"].string!,
                    body: msg["body"].string!,
                    dateTime: msg["dateTime"].string!,
                    read: false)
                if msg["id"].string! == self.poolId{
                    self.currentPoolMessages.append(tempMsg)
                    self.messagesCollection.reloadData()
                    //self.scrollToBottomAnimated(animated: true)
                    self.scrollToBottom(animated: true)
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
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
