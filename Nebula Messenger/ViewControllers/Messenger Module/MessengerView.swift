//
//  MessengerView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class MessengerView: UIView {
    let screenSizeX = UIScreen.main.bounds.size.width
    let textViewMaxLines: CGFloat = 6
    
    let navBar: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let topLine: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    
    let backButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let trashButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "Trashcan") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let involvedLabel: UILabel = {
        var label = UILabel()
        label.text = "Users"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomBarActionButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "FullscreenBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
    //For animation
    let pulsatingLayer: CAShapeLayer = {
        var layer = CAShapeLayer()
        // Here we add half of the button's width to the circle's center to get it to center on the button
        let point = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 25+(UIScreen.main.bounds.size.height/20))
        let circlePath = UIBezierPath(arcCenter: .zero, radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let bgColor = nebulaPurple.withAlphaComponent(0.0)
        layer.path = circlePath.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 10
        layer.fillColor = bgColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = point
        return layer
    }()
    
    // Bottom View
    let bottomBar: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 300, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    var resizeMode = false
    var hasMoved = false
    var circleSide = "right"
    
    private let grabCircleBackground: UIView = {
        let circle = UIView()
        let height = CGFloat(20)
        circle.frame = CGRect(x: 0, y: 0, width: height, height: height)
        circle.backgroundColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.1)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = height/2
        circle.layer.masksToBounds = true
        
        return circle
    }()
    
    let messageField: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 13
        textView.layer.masksToBounds = true
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
    
    let screenBounds = UIScreen.main.bounds
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.black
        addSubview(navBar)
        addSubview(topLine)
        addSubview(backButton)
        addSubview(trashButton)
        addSubview(involvedLabel)
        //self.layer.addSublayer(pulsatingLayer)
        addSubview(bottomBarActionButton)
        bottomBarActionButton.layer.addSublayer(pulsatingLayer)
        pulsatingLayer.frame = bottomBarActionButton.bounds
        pulsatingLayer.frame.origin.x += (buttonHeight-10)/2
        pulsatingLayer.frame.origin.y += (buttonHeight-10)/2
        
        addSubview(bottomBar)
        addSubview(grabCircleBackground)
        addSubview(messageField)
        if involvedLabel.text?.count == 0{
            sendButton.isEnabled = false
        }
        addSubview(sendButton)
        addSubview(downButton)
        addSubview(closeButton)
        
        buildConstraintsForNavBar()
        buildConstraintsForBottomBar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var involvedWidthAnchor: NSLayoutConstraint?
    var involvedCenterAnchor: NSLayoutConstraint?
    
    var bottomBarCenterX: NSLayoutConstraint?
    var bottomBarBottom: NSLayoutConstraint?
    var bottomBarWidthAnchor: NSLayoutConstraint?
    var bottomBarHeightAnchor: NSLayoutConstraint?
    
    var bottomBarToActionButtonX: NSLayoutConstraint?
    var bottomBarToActionButtonY: NSLayoutConstraint?
    
    var closeButtonCenterXAnchor: NSLayoutConstraint?
    var closeButtonCenterYAnchor: NSLayoutConstraint?
    var closeButtonLeftAnchor: NSLayoutConstraint?
    
    var downArrowTopAnchor: NSLayoutConstraint?
    var downArrowButtonCenterYAnchor: NSLayoutConstraint?
    
    var grabCircleRightAnchor: NSLayoutConstraint?
    var grabCircleLeftAnchor: NSLayoutConstraint?
    
    let buttonHeight = CGFloat(40)
    func buildConstraintsForNavBar(){
        navBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        navBar.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        navBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
        navBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        
        topLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLine.centerYAnchor.constraint(equalToSystemSpacingBelow: navBar.bottomAnchor, multiplier: 1).isActive = true
        topLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        backButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        backButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 0).isActive = true
        
        trashButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        trashButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        trashButton.centerXAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        trashButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        involvedWidthAnchor = involvedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33)
        involvedWidthAnchor?.isActive = true
        involvedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        involvedCenterAnchor = involvedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        //involvedCenterAnchor?.isActive = true
        involvedLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: -10).isActive = true
        
        bottomBarActionButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        bottomBarActionButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        bottomBarActionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        bottomBarActionButton.topAnchor.constraint(equalTo: involvedLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    var messageFieldHeightAnchor: NSLayoutConstraint?
    
    func buildConstraintsForBottomBar(){
        let buttonHeight = CGFloat(40)
        
        bottomBarCenterX = bottomBar.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        bottomBarCenterX?.isActive = true
        bottomBarBottom = bottomBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomBarBottom?.isActive = true
        
        bottomBarToActionButtonX = bottomBar.centerXAnchor.constraint(equalTo: bottomBarActionButton.centerXAnchor, constant: 0)
        bottomBarToActionButtonY = bottomBar.centerYAnchor.constraint(equalTo: bottomBarActionButton.centerYAnchor, constant: 0)
        
        bottomBarWidthAnchor = bottomBar.widthAnchor.constraint(equalTo: widthAnchor, constant: 0)
        bottomBarWidthAnchor?.isActive = true
        bottomBarHeightAnchor = bottomBar.heightAnchor.constraint(equalToConstant: 100)
        bottomBarHeightAnchor?.isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: grabCircleBackground.centerYAnchor).isActive = true
        closeButtonLeftAnchor = closeButton.leftAnchor.constraint(equalTo: bottomBar.leftAnchor, constant: 5)
        closeButtonLeftAnchor?.isActive = true
        closeButtonCenterXAnchor = closeButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor, constant: 0)
        closeButtonCenterXAnchor?.isActive = false
        
        closeButtonCenterYAnchor = closeButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: 0)
        closeButtonCenterYAnchor?.isActive = false
        
        downButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        downButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        downArrowTopAnchor = downButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        downArrowTopAnchor?.isActive = true
        downButton.leftAnchor.constraint(equalTo: bottomBar.leftAnchor, constant: 5).isActive = true
        
        grabCircleBackground.rightAnchor.constraint(equalTo: bottomBar.rightAnchor, constant: -5).isActive = true
        
        grabCircleBackground.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 5).isActive = true
        grabCircleBackground.widthAnchor.constraint(equalToConstant: 20).isActive = true
        grabCircleBackground.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        if messageField.numberOfLines() > 2 {
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: 2)
            messageFieldHeightAnchor = messageField.heightAnchor.constraint(equalToConstant: additionConstant+5)
            messageField.setContentOffset(.zero, animated: true)
        }else{
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: messageField.numberOfLines())
            messageFieldHeightAnchor = messageField.heightAnchor.constraint(equalToConstant: additionConstant+5)
            messageField.setContentOffset(.zero, animated: true)
        }
        
        messageFieldHeightAnchor?.isActive = true
        messageField.widthAnchor.constraint(equalTo: bottomBar.widthAnchor, multiplier: 0.9).isActive = true
        messageField.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor).isActive = true
        messageField.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -10).isActive = true
        
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
            bottomBarActionButton.isHidden = false
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomBar.layer.cornerRadius = 16
                self.bottomBar.alpha = 0.7
                self.messageField.alpha = 0.3
                self.bottomBarActionButton.alpha = 1
                self.layoutIfNeeded()
            })
        }
        
        if resizeMode{
            bottomBarHeightAnchor?.constant -= y
            if circleSide == "right"{
                bottomBarWidthAnchor?.constant += x
            }else{
                bottomBarWidthAnchor?.constant -= x
            }
        }else{
            bottomBarBottom?.constant += y
            bottomBarCenterX?.constant += x
        }
    }
    
    func resetBottomBar(){
        self.bottomBarHeightAnchor?.constant = 100
        self.bottomBarWidthAnchor?.constant = 0
        
        self.bottomBarBottom?.constant = 0
        self.bottomBarCenterX?.constant = 0
        
        self.closeButtonCenterXAnchor?.isActive = false
        self.closeButtonCenterYAnchor?.isActive = false
        
        closeButtonLeftAnchor?.constant = 0
        downArrowTopAnchor?.constant = 0
        
        resizeMode = false
        UIView.animate(withDuration: 0.3, animations: {
            self.downButton.isHidden = true
            self.bottomBar.layer.cornerRadius = 0
            self.bottomBarActionButton.alpha = 0
            self.bottomBar.alpha = 1
            self.sendButton.alpha = 1
            self.closeButton.alpha = 1
            self.messageField.alpha = 1
            self.groupFunctionButton.alpha = 1
            self.grabCircleBackground.alpha = 1
            self.closeButton.isEnabled = true
            self.layoutIfNeeded()
        }, completion: {_ in
            self.bottomBarActionButton.isHidden = true
        })
        hasMoved = false
    }
    
    func moveWithKeyboard(yValue: CGFloat, duration: Double){
        resetBottomBar()
        bottomBarBottom?.constant -= yValue
        closeButtonLeftAnchor?.constant = 30
        downArrowTopAnchor?.constant = -30
        
        UIView.animate(withDuration: duration, animations: {
            self.downButton.isHidden = false
            self.closeButton.isEnabled = false
            self.layoutIfNeeded()
        })
    }
    
    
    func tappedGrabCircle(){
        resizeMode = !resizeMode
    }
    
    func closeButtonTapped(){
        hasMoved = true
        groupFunctionOpen = true
        
        groupFunctionPressed()
        self.bottomBarActionButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.grabCircleBackground.alpha = 0
            self.sendButton.alpha = 0
            self.messageField.alpha = 0
            self.groupFunctionButton.alpha = 0
            self.bottomBar.layer.cornerRadius = 16
            self.layoutIfNeeded()
        }, completion: { _ in
            self.bottomBarWidthAnchor?.constant = -self.screenSizeX + 40
            self.bottomBarHeightAnchor?.constant = 50
            self.closeButtonCenterXAnchor?.isActive = true
            self.closeButtonCenterYAnchor?.isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomBar.alpha = 0.2
                self.layoutIfNeeded()
            }, completion: {_ in
                self.animateLayer()
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomBar.alpha = 0
                    self.closeButton.alpha = 0
                    self.bottomBarActionButton.alpha = 1
                    self.layoutIfNeeded()
                })
            })
        })
    }
    
    func resizeTextView(){
        if messageField.numberOfLines() < 3 {
            let additionConstant = (messageField.font?.lineHeight)! * CGFloat(integerLiteral: messageField.numberOfLines())
            messageFieldHeightAnchor?.constant = additionConstant + 5
            messageField.setContentOffset(.zero, animated: true)
        }
    }
    
    // Group Actions
    var groupFunctionOpen = false
    func groupFunctionPressed(){
        if !groupFunctionOpen{
            groupAddButtonTopAnchor?.constant = 20
            UIView.animate(withDuration: 0.2, animations: {
                self.groupFunctionButton.tintColor = nebulaBlue
                self.groupAddButton.alpha = 1
                self.groupAddButton.isHidden = false
                self.layoutIfNeeded()
            })
        }
        if groupFunctionOpen{
            groupAddButtonTopAnchor?.constant = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.groupFunctionButton.tintColor = nebulaPurple
                self.groupAddButton.alpha = 0
                self.layoutIfNeeded()
            }, completion: {_ in
                self.groupAddButton.isHidden = true
            })
        }
        groupFunctionOpen = !groupFunctionOpen
    }
    
    // Animations
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
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.isRemovedOnCompletion = false
        
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.toValue = 0.0
        alphaAnim.duration = 0.5
        alphaAnim.fillMode = CAMediaTimingFillMode.forwards
        alphaAnim.isRemovedOnCompletion = false
        
        pulsatingLayer.add(alphaAnim, forKey: "alphaChange")
        pulsatingLayer.add(animation, forKey: "pulsing")
        CATransaction.commit()
    }
}

extension UITextView {
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}
