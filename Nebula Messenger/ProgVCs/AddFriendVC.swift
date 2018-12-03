//
//  AddFriendVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/26/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class AddFriendVC: UIViewController, UITextFieldDelegate {
    
    var textField: UITextField!
    var feedbackButton: UIButton!
    var bg: UIView!
    
    var friendView: UIView!
    var realNameLabel: UILabel!
    var usernameLabel: UILabel!
    var sentLabel: UILabel!
    
    var friendRequestsButton: UIButton!
    var requestsView: UIView!
    var reqArrowView: UIView! // This will be the arrows behind the request view
    var rightReqArrow: UIButton! // Actual Arrow Buttons
    var leftReqArrow: UIButton!
    var reqUsername: UILabel!
    var reqName: UILabel!
    var acceptButton: UIButton!
    
    var addFriendButton: UIButton!
    
    var requestedIndex = 0
    var requestsArray = GlobalUser.requestedFriends
    var requestedNamesDict = [String:String]()
    var acceptedRequests = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        
        
        
        createBackground()
        createSentLabel()
        createTextField()
        createSearchView()
        createRequestsButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if textField.isFirstResponder{
            view.endEditing(true)
        }else{
            self.dismiss(animated: true){
                
            }
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer? = nil) {
        if textField.isFirstResponder{
            view.endEditing(true)
        }else{
            self.dismiss(animated: true){
                
            }
        }
    }
    
    @objc func exitView(){
        self.dismiss(animated: true){
            
        }
    }
    
    //Create UI
    func createBackground(){
        let bgWidth = view.frame.width*0.66
        let bgHeight = view.frame.height*0.33
        let posX = (view.frame.width/2) - (bgWidth/2)
        let posY = (view.frame.height/2) - (bgHeight/2)
        bg = UIView(frame: CGRect(x: posX, y: posY, width: bgWidth, height: bgHeight))
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = UIColor.white
        bg.layer.cornerRadius = 16
        self.view.addSubview(bg)
        
        bg.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.66).isActive = true
        bg.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        bg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bg.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    func createSentLabel(){
        sentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        sentLabel.text = "Sent!"
        sentLabel.translatesAutoresizingMaskIntoConstraints = false
        sentLabel.font = UIFont.systemFont(ofSize: 20)
        sentLabel.textColor = UIColor.black
        sentLabel.isHidden = true
        self.view.addSubview(sentLabel)
        
        sentLabel.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        sentLabel.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
    }
    
    func createLabel(){//????
        
    }
    
    func createTextField(){
        let fieldWidth = self.bg.frame.width - 40
        let fieldHeight = CGFloat(31)
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: fieldWidth, height: fieldHeight))
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Input friend's username"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.white
        
        // Super handy extension I found on Stack
        // Why doesn't UITextField have its own inset function like other UIKit objects???
        textField.padLeft(10)
        
        textField.returnKeyType = UIReturnKeyType.search
        
        self.view.addSubview(textField)
        
        textField.widthAnchor.constraint(equalTo: bg.widthAnchor, multiplier: 0.9).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 31).isActive = true
        textField.topAnchor.constraint(equalTo: bg.topAnchor, constant: 10).isActive = true
        textField.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        
    }
    
    func createSearchButton(){
        let buttonWidth = CGFloat(floatLiteral: 100.0)
        let buttonHeight = CGFloat(floatLiteral: 30)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = nebulaPurple
        button.layer.cornerRadius = 10
        button.setTitle("Send Feedback", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func createSearchView(){
        friendView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        friendView.translatesAutoresizingMaskIntoConstraints = false
        friendView.backgroundColor = nebulaPurple
        friendView.layer.cornerRadius = 16
        friendView.alpha = 0
        self.view.addSubview(friendView)
        
        realNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        realNameLabel.translatesAutoresizingMaskIntoConstraints = false
        realNameLabel.font = UIFont.systemFont(ofSize: 16)
        realNameLabel.textColor = UIColor.white
        
        usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.textColor = UIColor.white
        self.view.addSubview(realNameLabel)
        self.view.addSubview(usernameLabel)
        
        addFriendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        addFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addFriendButton.backgroundColor = nebulaBlue
        addFriendButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        addFriendButton.setTitleColor(UIColor.lightGray, for: .disabled)
        addFriendButton.layer.cornerRadius = 16
        addFriendButton.setTitle("Add", for: .normal)
        addFriendButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        addFriendButton.isEnabled = false
        self.view.addSubview(addFriendButton)
        
        friendView.widthAnchor.constraint(equalTo: bg.widthAnchor, multiplier: 0.9).isActive = true
        friendView.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        friendView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5).isActive = true
        friendView.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -8).isActive = true
        
        addFriendButton.widthAnchor.constraint(equalTo: friendView.widthAnchor, multiplier: 0.3).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        addFriendButton.topAnchor.constraint(equalTo: bg.bottomAnchor, constant: 5).isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: friendView.centerXAnchor).isActive = true
        
    }
    
    func setLabels(name: String, username: String){
        realNameLabel.text = name
        usernameLabel.text = username
        
        realNameLabel.topAnchor.constraint(equalTo: friendView.topAnchor, constant: 5).isActive = true
        realNameLabel.centerXAnchor.constraint(equalTo: friendView.centerXAnchor).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: realNameLabel.bottomAnchor, constant: 10).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: friendView.centerXAnchor).isActive = true
    }
    
    //Going to need these later
    var reqViewHeightAnchor: NSLayoutConstraint?
    
    var reqArrowViewHeightAnchor: NSLayoutConstraint?
    var reqArrowViewWidthAnchor: NSLayoutConstraint?
    
    func createRequestsButton(){
        friendRequestsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        friendRequestsButton.translatesAutoresizingMaskIntoConstraints = false
        friendRequestsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        friendRequestsButton.backgroundColor = nebulaBlue
        friendRequestsButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        friendRequestsButton.setTitleColor(UIColor.lightGray, for: .disabled)
        friendRequestsButton.layer.cornerRadius = 10
        friendRequestsButton.setTitle("Friend Requests", for: .normal)
        friendRequestsButton.addTarget(self, action: #selector(toRequestsView), for: .touchUpInside)
        if requestsArray.count == 0{
            friendRequestsButton.isEnabled = false
        }
        
        
        requestsView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        requestsView.translatesAutoresizingMaskIntoConstraints = false
        requestsView.layer.cornerRadius = 10
        requestsView.backgroundColor = nebulaBlue
        
        reqArrowView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        reqArrowView.translatesAutoresizingMaskIntoConstraints = false
        reqArrowView.layer.cornerRadius = 14
        reqArrowView.backgroundColor = nebulaPurple
        
        //Arrows
        rightReqArrow = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        rightReqArrow.translatesAutoresizingMaskIntoConstraints = false
        rightReqArrow.setImage(UIImage(named: "ForwardArrowBlack"), for: .normal)
        rightReqArrow.tintColor = UIColor.black
        rightReqArrow.addTarget(self, action: #selector(rightArrowPressed), for: .touchUpInside)
        
        leftReqArrow = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        leftReqArrow.translatesAutoresizingMaskIntoConstraints = false
        leftReqArrow.setImage(UIImage(named: "BackArrowBlack"), for: .normal)
        leftReqArrow.tintColor = UIColor.black
        leftReqArrow.addTarget(self, action: #selector(leftArrowPressed), for: .touchUpInside)
        
        leftReqArrow.isEnabled = false
        leftReqArrow.alpha = 0
        
        if requestsArray.count == 1{
            rightReqArrow.isEnabled = false
            rightReqArrow.alpha = 0
        }
        
        //Accept Button
        acceptButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        acceptButton.backgroundColor = nebulaPurple
        acceptButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        acceptButton.layer.cornerRadius = 8
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        
        self.view.addSubview(reqArrowView)
        self.view.addSubview(rightReqArrow)
        self.view.addSubview(leftReqArrow)
        self.view.addSubview(requestsView)
        self.view.addSubview(acceptButton)
        self.view.addSubview(friendRequestsButton)
        
        friendRequestsButton.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        friendRequestsButton.widthAnchor.constraint(equalTo: bg.widthAnchor).isActive = true
        friendRequestsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        friendRequestsButton.bottomAnchor.constraint(equalTo: bg.topAnchor, constant: -5).isActive = true
        
        
        reqArrowView.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        reqArrowViewWidthAnchor = reqArrowView.widthAnchor.constraint(equalTo: bg.widthAnchor, constant: 0)
        reqArrowViewWidthAnchor?.isActive = true
        reqArrowViewHeightAnchor = reqArrowView.heightAnchor.constraint(equalToConstant: 30)
        reqArrowViewHeightAnchor?.isActive = true
        reqArrowView.bottomAnchor.constraint(equalTo: bg.topAnchor, constant: -5).isActive = true
        
        // Because the arrow images have so much empty space in them, we kind of have to make up for it...
        rightReqArrow.centerYAnchor.constraint(equalTo: reqArrowView.centerYAnchor).isActive = true
        rightReqArrow.rightAnchor.constraint(equalTo: reqArrowView.rightAnchor, constant: 8).isActive = true
        
        leftReqArrow.centerYAnchor.constraint(equalTo: reqArrowView.centerYAnchor).isActive = true
        leftReqArrow.leftAnchor.constraint(equalTo: reqArrowView.leftAnchor, constant: -8).isActive = true
        
        requestsView.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        requestsView.widthAnchor.constraint(equalTo: bg.widthAnchor).isActive = true
        reqViewHeightAnchor = requestsView.heightAnchor.constraint(equalToConstant: 30)
        reqViewHeightAnchor?.isActive = true
        requestsView.bottomAnchor.constraint(equalTo: bg.topAnchor, constant: -5).isActive = true
        
        acceptButton.centerXAnchor.constraint(equalTo: requestsView.centerXAnchor).isActive = true
        acceptButton.bottomAnchor.constraint(equalTo: requestsView.bottomAnchor, constant: -5).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: friendView.widthAnchor, multiplier: 0.5).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    func createRequestLabels(){
        reqUsername = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        reqUsername.translatesAutoresizingMaskIntoConstraints = false
        reqUsername.font = UIFont.systemFont(ofSize: 20)
        reqUsername.textColor = UIColor.white
        self.view.addSubview(reqUsername)
        self.view.bringSubviewToFront(reqUsername)
        
        reqName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        reqName.translatesAutoresizingMaskIntoConstraints = false
        reqName.font = UIFont.systemFont(ofSize: 120)
        reqName.textColor = UIColor.white
        self.view.addSubview(reqName)
        
        reqUsername.topAnchor.constraint(equalTo: requestsView.topAnchor, constant: 5).isActive = true
        reqUsername.centerXAnchor.constraint(equalTo: requestsView.centerXAnchor).isActive = true
    }
    
    // Like a Transformer: Autobots, roll out!
    func createRequestsView(){
        createRequestLabels()
        let heightAddition = CGFloat(40)
        reqArrowViewWidthAnchor?.constant += CGFloat(60)
        reqArrowViewHeightAnchor?.constant += heightAddition
        reqViewHeightAnchor?.constant += heightAddition
        UIView.animate(withDuration: 0.3, animations: {
            self.friendRequestsButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.reqUsername.text = self.requestsArray[0]
        })
    }
    
    // MARK: Methods
    func enableButton(button: UIButton){
        button.isEnabled = true
        UIView.animate(withDuration: 0.2) {
            button.alpha = 1
        }
    }
    
    @objc func rightArrowPressed(){
        if requestedIndex < requestsArray.count-1{
            requestedIndex += 1
            changeReqLabels()
        }
        
        if requestedIndex > 0{
            enableButton(button: leftReqArrow)
        }
        
        if requestedIndex == requestsArray.count-1{
            disableButton(button: rightReqArrow)
        }
    }
    
    @objc func leftArrowPressed(){
        if requestedIndex > 0{
            requestedIndex -= 1
            changeReqLabels()
        }
        
        if requestedIndex < requestsArray.count-1{
            enableButton(button: rightReqArrow)
        }
        
        if requestedIndex == 0{
            disableButton(button: leftReqArrow)
        }
    }
    
    @objc func buttonAction(){
        
    }
    
    @objc func addFriend(){
        addFriendButton.isEnabled = false
        FriendRoutes.requestFriend(friend: usernameLabel.text!){
            self.usernameLabel.text = ""
            self.realNameLabel.text = ""
            self.sentLabel.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.friendView.alpha = 0.0
            }, completion:{_ in
                self.dismiss(animated: true, completion: {
                    
                })
            })
        }
    }
    
    @objc func toRequestsView(){
        self.createRequestsView()
    }
    
    @objc func acceptRequest(){
        if !acceptedRequests.contains(reqUsername.text!){
            let newFriend = reqUsername.text!
            acceptedRequests.append(newFriend)
            FriendRoutes.addFriend(friend: newFriend, completion: {
                self.acceptButton.setTitle("Accepted!", for: .normal)
                self.acceptButton.isEnabled = false
                GlobalUser.requestedFriends = GlobalUser.requestedFriends.filter {$0 != newFriend}
            })
        }
    }
    
    func disableButton(button: UIButton){
        button.isEnabled = false
        UIView.animate(withDuration: 0.2) {
            button.alpha = 0
        }
    }
    
    func changeReqLabels(){
        if self.acceptedRequests.contains(self.requestsArray[self.requestedIndex]){
            self.acceptButton.setTitle("Accepted!", for: .normal)
            self.acceptButton.isEnabled = false
        }else{
            self.acceptButton.setTitle("Accept", for: .normal)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.reqUsername.alpha = 0
            self.reqName.alpha = 0
        }, completion: {_ in
            self.reqUsername.text = self.requestsArray[self.requestedIndex]
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.reqUsername.alpha = 1
                self.reqName.alpha = 1
            })
        })
    }
    
    // MARK: Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.search)
        {
            textField.resignFirstResponder()
            UserRoutes.getUserFromUsername(username: textField.text ?? "none"){user in
                self.setLabels(name: user[0], username: user[1])
                UIView.animate(withDuration: 0.3, animations: {
                    self.friendView.alpha = 1.0
                })
                if user[2] == "success" && user[1] != GlobalUser.username{
                    self.addFriendButton.isEnabled = true
                }
            }
            textField.text = ""
        }
        return true
    }
}

extension UITextField {
    func padLeft(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
