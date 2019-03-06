//
//  PoolChatView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/12/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class PoolChatView: MessengerBaseView {
    
    let subscribeBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 11
        
        return view
    }()
    
    let subscribeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 8
        view.bounds.insetBy(dx: -18.0, dy: -18.0)
        
        return view
    }()
    
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
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        textView.setContentOffset(.zero, animated: true)
        
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
        textView.contentInset.top = topCorrect
        
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
    
    override init(frame: CGRect, view: UIView) {
        super.init(frame: frame, view: view)
        //self.backgroundColor = UIColor.black
        addSubview(navBar)
        addSubview(topLine)
        addSubview(backButton)
        addSubview(trashButton)
        addSubview(involvedLabel)
        addSubview(subscribeBackground)
        addSubview(subscribeView)
        //self.layer.addSublayer(pulsatingLayer)
        addSubview(bottomBarActionButton)
        bottomBarActionButton.layer.addSublayer(pulsatingLayer)
        pulsatingLayer.frame = bottomBarActionButton.bounds
        pulsatingLayer.frame.origin.x += (buttonHeight-10)/2
        pulsatingLayer.frame.origin.y += (buttonHeight-10)/2
        
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
    
    override func buildConstraintsForNavBar(){
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
        
        //involvedWidthAnchor = involvedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33)
        //involvedWidthAnchor?.isActive = true
        involvedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        involvedCenterAnchor = involvedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        //involvedCenterAnchor?.isActive = true
        involvedLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: -10).isActive = true
        
        subscribeBackground.centerYAnchor.constraint(equalTo: involvedLabel.centerYAnchor).isActive = true
        subscribeBackground.leftAnchor.constraint(equalTo: involvedLabel.rightAnchor, constant: 4).isActive = true
        subscribeBackground.widthAnchor.constraint(equalToConstant: 22).isActive = true
        subscribeBackground.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        subscribeView.centerYAnchor.constraint(equalTo: subscribeBackground.centerYAnchor).isActive = true
        subscribeView.centerXAnchor.constraint(equalTo: subscribeBackground.centerXAnchor).isActive = true
        subscribeView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        subscribeView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        bottomBarActionButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        bottomBarActionButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        bottomBarActionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        bottomBarActionButton.topAnchor.constraint(equalTo: involvedLabel.bottomAnchor, constant: 0).isActive = true
    }
    
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
        //bottomBarHeightAnchor?.constant = 100-bottomBar.frame.height
        
        closeButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: grabCircle.centerYAnchor).isActive = true
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
        
        messageField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageField.widthAnchor.constraint(equalTo: bottomBar.widthAnchor, multiplier: 0.9).isActive = true
        messageField.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor).isActive = true
        messageField.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -10).isActive = true
        
        sendButton.heightAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: buttonHeight-10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: grabCircle.centerYAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: grabCircleBackground.leftAnchor, constant: -10).isActive = true
        
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
        self.bringSubviewToFront(grabCircle)
        
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
        
        if grabCircle.frame.origin.x > screenSizeX-20{
            grabCircleRightAnchor?.isActive = false
            grabCircleRightAnchor?.constant = -5
            grabCircleLeftAnchor?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
            circleSide = "left"
        }
        if grabCircle.frame.origin.x < 7{
            grabCircleLeftAnchor?.isActive = false
            grabCircleLeftAnchor?.constant = 5
            grabCircleRightAnchor?.isActive = true
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
            circleSide = "right"
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
            self.grabCircle.backgroundColor = nebulaPurple
            self.bottomBar.layer.cornerRadius = 0
            self.bottomBarActionButton.alpha = 0
            self.bottomBar.alpha = 1
            self.sendButton.alpha = 1
            self.grabCircle.alpha = 1
            self.closeButton.alpha = 1
            self.messageField.alpha = 1
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
        
        if resizeMode{
            UIView.animate(withDuration: 0.5, animations: {
                self.grabCircle.backgroundColor = nebulaBlue
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.grabCircle.backgroundColor = nebulaPurple
            })
        }
    }
    
    func closeButtonTapped(){
        hasMoved = true
        self.bottomBarActionButton.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.grabCircleBackground.alpha = 0
            self.sendButton.alpha = 0
            self.grabCircle.alpha = 0
            self.messageField.alpha = 0
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
}

