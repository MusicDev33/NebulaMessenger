//
//  ModularKeyboard.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/23/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class ModularKeyboard: UIView {
    let screenSizeX = UIScreen.main.bounds.size.width
    let textViewMaxLines: CGFloat = 6
    
    var resizeMode = false
    var hasMoved = false
    
    let grabCircleBackground: UIView = {
        let circle = UIView()
        let height = CGFloat(20)
        circle.frame = CGRect(x: 0, y: 0, width: height, height: height)
        circle.backgroundColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.1)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = height/2
        
        return circle
    }()
    
    let messageField: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 13
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 4, bottom: 0, right: 4)
        textView.setContentOffset(.zero, animated: true)
        
        return textView
    }()
    
    let sendButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "SendBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let closeButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BlackX") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let downButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "DownArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        return button
    }()
    
    // Group Chat Stuff
    let groupFunctionButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "GroupAddBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let groupAddButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "PlusSignBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        return button
    }()
    
    var blurEffectView: UIView!
    
    var parentView = UIView()
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        self.parentView = view
        
        self.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(grabCircleBackground)
        addSubview(messageField)
        
        addSubview(sendButton)
        addSubview(downButton)
        addSubview(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var centerXConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var closeButtonCenterXConstraint: NSLayoutConstraint?
    var closeButtonCenterYConstraint: NSLayoutConstraint?
    var closeButtonLeftConstraint: NSLayoutConstraint?
    
    var downArrowTopConstraint: NSLayoutConstraint?
    var downArrowButtonCenterYConstraint: NSLayoutConstraint?
    
    var messageFieldHeightConstraint: NSLayoutConstraint?
    
    let buttonHeight = CGFloat(40)
    
    let screenBounds = UIScreen.main.bounds
    
    func buildConstraints(){
        let buttonHeight = CGFloat(40)
        
        addSubview(grabCircleBackground)
        addSubview(messageField)
        addSubview(sendButton)
        addSubview(closeButton)
        addSubview(downButton)
        
        centerXConstraint = self.centerXAnchor.constraint(equalTo: self.parentView.centerXAnchor, constant: 0)
        centerXConstraint?.isActive = true
        bottomConstraint = self.bottomAnchor.constraint(equalTo: self.parentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
        
        /*
        bottomBarToActionButtonX = bottomBar.centerXAnchor.constraint(equalTo: bottomBarActionButton.centerXAnchor, constant: 0)
        bottomBarToActionButtonY = bottomBar.centerYAnchor.constraint(equalTo: bottomBarActionButton.centerYAnchor, constant: 0)
         */
        
        widthConstraint = self.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: 0)
        widthConstraint?.isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: grabCircleBackground.centerYAnchor).isActive = true
        closeButtonLeftConstraint = closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5)
        closeButtonLeftConstraint?.isActive = true
        closeButtonCenterXConstraint = closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        closeButtonCenterXConstraint?.isActive = false
        
        closeButtonCenterYConstraint = closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        closeButtonCenterYConstraint?.isActive = false
        
        downButton.heightAnchor.constraint(equalToConstant: buttonHeight - 10).isActive = true
        downButton.widthAnchor.constraint(equalToConstant: buttonHeight - 10).isActive = true
        downArrowTopConstraint = downButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        downArrowTopConstraint?.isActive = true
        downButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        
        grabCircleBackground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        
        grabCircleBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        grabCircleBackground.widthAnchor.constraint(equalToConstant: 20).isActive = true
        grabCircleBackground.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        if messageField.numberOfLines() > 2 {
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: 2)
            messageFieldHeightConstraint = messageField.heightAnchor.constraint(equalToConstant: additionConstant+5)
            messageField.setContentOffset(.zero, animated: true)
        }else{
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: messageField.numberOfLines())
            messageFieldHeightConstraint = messageField.heightAnchor.constraint(equalToConstant: additionConstant+5)
            messageField.setContentOffset(.zero, animated: true)
        }
        
        messageFieldHeightConstraint?.isActive = true
        messageField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        messageField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        sendButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: grabCircleBackground.centerYAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: grabCircleBackground.leftAnchor, constant: -10).isActive = true
    }
    
    var groupAddButtonTopAnchor: NSLayoutConstraint?
    
    func buildGroupChatFeatures(){
        addSubview(groupFunctionButton)
        addSubview(groupAddButton)
        
        groupFunctionButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        groupFunctionButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        groupFunctionButton.centerYAnchor.constraint(equalTo: grabCircleBackground.centerYAnchor).isActive = true
        groupFunctionButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        
        groupAddButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        groupAddButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        groupAddButtonTopAnchor = groupAddButton.topAnchor.constraint(equalTo: groupFunctionButton.topAnchor)
        groupAddButtonTopAnchor?.isActive = true
        groupAddButton.centerXAnchor.constraint(equalTo: groupFunctionButton.centerXAnchor, constant: 2).isActive = true
    }
    
    
    // Actions
    func draggedCircle(x: CGFloat, y: CGFloat){
        if !hasMoved{
            hasMoved = true
            UIView.animate(withDuration: 0.6, animations: {
                self.layer.cornerRadius = 16
                self.alpha = 0.7
                self.messageField.alpha = 0.3
                self.layoutIfNeeded()
            })
        }
        
        bottomConstraint?.constant += y
        centerXConstraint?.constant += x
        
//        bottomBarBottom?.constant += y
//        bottomBarCenterX?.constant += x
    }
    
    func closeButtonTapped(finished:@escaping () -> Void){
        hasMoved = true
        groupFunctionOpen = true
        
        groupFunctionPressed()
        UIView.animate(withDuration: 0.2, animations: {
            self.grabCircleBackground.alpha = 0
            self.sendButton.alpha = 0
            self.messageField.alpha = 0
            self.groupFunctionButton.alpha = 0
            self.layer.cornerRadius = 16
            self.layoutIfNeeded()
        }, completion: { _ in
            self.widthConstraint?.constant = -self.screenSizeX + 40
            self.heightConstraint?.constant = 50
            self.closeButtonCenterXConstraint?.isActive = true
            self.closeButtonCenterYConstraint?.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.2
                self.layoutIfNeeded()
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.alpha = 0
                    self.closeButton.alpha = 0
                    self.layoutIfNeeded()
                    finished()
                })
            })
        })
    }
    
    func resizeTextView(){
        if messageField.numberOfLines() < 3 {
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: messageField.numberOfLines())
            messageFieldHeightConstraint?.constant = additionConstant + 5
            messageField.setContentOffset(.zero, animated: true)
        }
    }
    
    // Group Actions
    var groupFunctionOpen = false
    func groupFunctionPressed(){
        if !groupFunctionOpen{
            groupAddButtonTopAnchor?.constant = 20
            UIView.animate(withDuration: 0.2, animations: {
                self.groupFunctionButton.tintColor = Colors.nebulaBlue
                self.groupAddButton.alpha = 1
                self.groupAddButton.isHidden = false
                self.layoutIfNeeded()
            })
        }
        if groupFunctionOpen{
            groupAddButtonTopAnchor?.constant = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.groupFunctionButton.tintColor = Colors.nebulaPurple
                self.groupAddButton.alpha = 0
                self.layoutIfNeeded()
            }, completion: {_ in
                self.groupAddButton.isHidden = true
            })
        }
        groupFunctionOpen = !groupFunctionOpen
    }
}
