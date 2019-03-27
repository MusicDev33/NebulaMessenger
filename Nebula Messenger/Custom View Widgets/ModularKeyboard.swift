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
    
    var mode = ModKeyMode.blank
    var hasMoved = false
    
    var textStorage = ""
    
    let grabCircleBackground: UIView = {
        let circle = UIView()
        let height = CGFloat(24)
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
        textView.layer.cornerRadius = 15
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
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
    
    // Other Modes
    let multipleChoiceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let aButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("A", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    let bButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("B", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    let cButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("C", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    let dButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("D", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    let eButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("E", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    // True/False view
    let tfView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let trueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("True", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    let falseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("False", for: .normal)
        button.tintColor = Colors.nebulaPurple
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        
        button.layer.cornerRadius = 25
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    var blurEffectView: UIView!
    
    var parentView = UIView()
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        self.parentView = view
        
        self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 0.8)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
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
    
    let buttonHeight = CGFloat(50)
    
    let multiButtonHeight = CGFloat(60)
    
    let screenBounds = UIScreen.main.bounds
    
    var multiButtonsCenterConstraint: NSLayoutConstraint?
    var multiButtonsLaidOutConstraint: NSLayoutConstraint?
    
    func setMainWindow(){
        centerXConstraint = self.centerXAnchor.constraint(equalTo: self.parentView.centerXAnchor, constant: 0)
        centerXConstraint?.isActive = true
        bottomConstraint = self.bottomAnchor.constraint(equalTo: self.parentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
        
        widthConstraint = self.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: 0)
        widthConstraint?.isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.isActive = true
    }
    
    func buildConstraints(){
        setMainWindow()
        
        let buttonHeight = CGFloat(40)
        
        addSubview(grabCircleBackground)
        addSubview(messageField)
        addSubview(sendButton)
        addSubview(closeButton)
        addSubview(downButton)
        
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
        grabCircleBackground.widthAnchor.constraint(equalToConstant: 24).isActive = true
        grabCircleBackground.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        if messageField.numberOfLines() > 2 {
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: 2)
            messageFieldHeightConstraint = messageField.heightAnchor.constraint(equalToConstant: additionConstant+20)
            messageField.setContentOffset(.zero, animated: true)
        }else{
            print("SIZING")
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: messageField.numberOfLines())
            messageFieldHeightConstraint = messageField.heightAnchor.constraint(equalToConstant: additionConstant)
            messageField.setContentOffset(.zero, animated: true)
        }
        
        messageFieldHeightConstraint?.constant += 20
        
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
    
    var tfButtonsCenterConstraints = [NSLayoutConstraint]()
    var tfButtonsLaidOutConstraints = [NSLayoutConstraint]()
    
    func buildTFButtons(){
        setMainWindow()
        let tfButtonWidth = CGFloat(160)
        
        addSubview(trueButton)
        addSubview(falseButton)
        
        trueButton.backgroundColor = UIColor.white
        falseButton.backgroundColor = UIColor.white
        
        self.bringSubviewToFront(trueButton)
        
        trueButton.layer.cornerRadius = multiButtonHeight/2.0
        falseButton.layer.cornerRadius = multiButtonHeight/2.0
        
        trueButton.widthAnchor.constraint(equalToConstant: tfButtonWidth).isActive = true
        falseButton.widthAnchor.constraint(equalToConstant: tfButtonWidth).isActive = true
        
        trueButton.heightAnchor.constraint(equalToConstant: multiButtonHeight).isActive = true
        falseButton.heightAnchor.constraint(equalToConstant: multiButtonHeight).isActive = true
        
        trueButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        falseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        tfButtonsCenterConstraints.append(trueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0))
        tfButtonsCenterConstraints.append(falseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0))
        
        for constraint in tfButtonsCenterConstraints{
            constraint.isActive = true
        }
        
        self.layoutIfNeeded()
        
        tfButtonsLaidOutConstraints.append(trueButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20))
        tfButtonsLaidOutConstraints.append(falseButton.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 20))
    }
    
    func animateTFButtonsOut(){
        for constraint in tfButtonsCenterConstraints{
            constraint.isActive = false
        }
        
        for constraint in tfButtonsLaidOutConstraints{
            constraint.isActive = true
        }
        
        self.trueButton.isHidden = false
        self.falseButton.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0.4, animations: {
            self.layoutIfNeeded()
            self.trueButton.alpha = 1
            self.falseButton.alpha = 1
        })
    }
    
    func animateTFButtonsIn(){
        for constraint in tfButtonsCenterConstraints{
            constraint.isActive = true
        }
        
        for constraint in tfButtonsLaidOutConstraints{
            constraint.isActive = false
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.4, animations: {
                self.trueButton.alpha = 0
                self.falseButton.alpha = 0
            }, completion: {_ in
                self.trueButton.isHidden = true
                self.falseButton.isHidden = true
            })
        })
    }
    
    func buildMultiChoiceButtons(){
        setMainWindow()
        let choiceButtons = [aButton, bButton, cButton, dButton, eButton]
        
        for i in 0..<choiceButtons.count{
            addSubview(choiceButtons[i])
            choiceButtons[i].backgroundColor = UIColor.white
            choiceButtons[i].layer.cornerRadius = multiButtonHeight/2.0
            choiceButtons[i].titleLabel?.font = UIFont.systemFont(ofSize: 26)
            
            choiceButtons[i].widthAnchor.constraint(equalToConstant: multiButtonHeight).isActive = true
            choiceButtons[i].heightAnchor.constraint(equalToConstant: multiButtonHeight).isActive = true
            choiceButtons[i].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            choiceButtons[i].centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        }
        
        self.bringSubviewToFront(cButton)
        
        self.layoutIfNeeded()
    }
    
    var multiButtonConstraints = [NSLayoutConstraint]()
    
    func animateMultiButtonsOut(){
        let choiceButtons = [aButton, bButton, cButton, dButton, eButton]
        
        let screenSizeInset = screenSizeX + 40
        
        multiButtonConstraints = [NSLayoutConstraint]()
        
        for i in 0..<choiceButtons.count{
            let floatI = CGFloat(i)
            let addConstant = (floatI+1.0)/6.0
            
            multiButtonConstraints.append(choiceButtons[i].centerXAnchor.constraint(equalTo: self.leftAnchor, constant: (screenSizeInset * addConstant)-20))
            
            multiButtonConstraints[i].isActive = true
        }
        
        for button in choiceButtons{
            button.isHidden = false
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.4, animations: {
            for button in choiceButtons{
                button.alpha = 1
            }
            self.layoutIfNeeded()
        })
    }
    
    func animateMultiButtonsIn(){
        let choiceButtons = [aButton, bButton, cButton, dButton, eButton]
        
        for i in 0..<choiceButtons.count{
            multiButtonConstraints[i].isActive = false
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, animations: {
                for button in choiceButtons{
                    button.alpha = 0
                }
            }, completion: {_ in
                for button in choiceButtons{
                    button.isHidden = true
                }
            })
        })
    }
    
    
    // Actions
    func draggedCircle(x: CGFloat, y: CGFloat){
        if !hasMoved{
            hasMoved = true
            self.groupFunctionButton.isEnabled = false
            if groupFunctionOpen{
                self.groupFunctionPressed()
            }
            UIView.animate(withDuration: 0.6, animations: {
                self.layer.cornerRadius = 16
                self.alpha = 0.7
                self.messageField.alpha = 0.3
                self.layoutIfNeeded()
            })
        }
        
        bottomConstraint?.constant += y
        centerXConstraint?.constant += x
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
            messageFieldHeightConstraint?.constant = additionConstant + 10
            messageField.setContentOffset(.zero, animated: true)
        }
        
        if messageField.numberOfLines() > 1 && self.groupFunctionOpen{
            groupFunctionPressed()
        }
    }
    
    func resizeTextViewToOneLine(){
        let additionConstant = (messageField.font?.lineHeight)!
        messageFieldHeightConstraint?.constant = additionConstant + 10
        messageField.setContentOffset(.zero, animated: true)
    }
    
    // Group Actions
    var groupFunctionOpen = false
    func groupFunctionPressed(){
        if !groupFunctionOpen{
            resizeTextViewToOneLine()
            self.endEditing(true)
            groupAddButtonTopAnchor?.constant = (buttonHeight/2)
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
    
    func disableButtons(){
        self.closeButton.isEnabled = false
        self.textStorage = self.messageField.text
        self.messageField.text = ""
        self.sendButton.isEnabled = false
    }
    
    func enableButtons(){
        self.closeButton.isEnabled = true
        self.messageField.text = self.textStorage
        self.textStorage = ""
        if self.messageField.text.count > 0{
            self.sendButton.isEnabled = true
        }
    }
}
