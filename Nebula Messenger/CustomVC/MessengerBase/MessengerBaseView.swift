//
//  MessengerBaseView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/5/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class MessengerBaseView: UIView, DefaultMessengerUI, PoolChatViewProtocol {
    
    var hasMoved = false
    let screenBounds = UIScreen.main.bounds
    
    // Here are the properties because protocols don't support those either with constraints...smh
    var navBar: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 0.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var topLine: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    
    var backButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var trashButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Trashcan") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var confirmAddFriendBg: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.nebulaPurple
        view.layer.cornerRadius = 22
        
        return view
    }()
    
    var confirmAddFriendButton: UIButton = {
        let button = UIButton(type: .system)
        if let image = UIImage(named: "PlusSignBlack") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var involvedLabel: UILabel = {
        let label = UILabel()
        label.text = "Users"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bottomBarActionButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "FullscreenBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.alpha = 0
        return button
    }()
    
    var subscribeBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 11
        
        return view
    }()
    
    var subscribeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 8
        view.bounds.insetBy(dx: -18.0, dy: -18.0)
        
        return view
    }()
    
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        
        self.setupUI()
        
        buildConstraintsForNavBar()
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
    
    // Animations
    // Not entirely if I want to hide this away in a protocol
    func animateLayer(){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.pulsatingLayer.fillColor = UIColor.clear.cgColor
            self.pulsatingLayer.isHidden = true
            self.pulsatingLayer.removeAllAnimations()
        })
        let bgColor = Colors.nebulaPurple.withAlphaComponent(0.3)
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
    
    // Methods that should be a part of the protocol but they're not supported yet...
    func setupUI() {
        addSubview(navBar)
        addSubview(topLine)
        addSubview(backButton)
        addSubview(involvedLabel)
        addSubview(bottomBarActionButton)
        bottomBarActionButton.layer.addSublayer(pulsatingLayer)
        pulsatingLayer.frame = bottomBarActionButton.bounds
        pulsatingLayer.frame.origin.x += (buttonHeight-10)/2
        pulsatingLayer.frame.origin.y += (buttonHeight-10)/2
    }
    
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
        backButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 0).isActive = true
        
        //involvedWidthAnchor = involvedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33)
        //involvedWidthAnchor?.isActive = true
        involvedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        involvedCenterAnchor = involvedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        //involvedCenterAnchor?.isActive = true
        involvedLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: -10).isActive = true
        
        bottomBarActionButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        bottomBarActionButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        bottomBarActionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
        let topAnchorConst = 20 * (self.frame.height/896.0) - 20
        print("TOP")
        print(topAnchorConst)
        bottomBarActionButton.topAnchor.constraint(equalTo: involvedLabel.bottomAnchor, constant: topAnchorConst).isActive = true
    }
    
    func setPoolChatConst(){
        addSubview(subscribeBackground)
        addSubview(subscribeView)
        
        subscribeBackground.centerYAnchor.constraint(equalTo: involvedLabel.centerYAnchor).isActive = true
        subscribeBackground.leftAnchor.constraint(equalTo: involvedLabel.rightAnchor, constant: 4).isActive = true
        subscribeBackground.widthAnchor.constraint(equalToConstant: 22).isActive = true
        subscribeBackground.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        subscribeView.centerYAnchor.constraint(equalTo: subscribeBackground.centerYAnchor).isActive = true
        subscribeView.centerXAnchor.constraint(equalTo: subscribeBackground.centerXAnchor).isActive = true
        subscribeView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        subscribeView.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    var pulsatingLayer: CAShapeLayer {
        let layer = CAShapeLayer()
        // Here we add half of the button's width to the circle's center to get it to center on the button
        let point = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 25+(UIScreen.main.bounds.size.height/20))
        let circlePath = UIBezierPath(arcCenter: .zero, radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let bgColor = Colors.nebulaPurple.withAlphaComponent(0.0)
        layer.path = circlePath.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 10
        layer.fillColor = bgColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = point
        return layer
    }
    
    func layoutConfirmAddFriendButton(){
        let buttonHeight = CGFloat(60)
        confirmAddFriendBg.layer.cornerRadius = CGFloat(buttonHeight/2)
        confirmAddFriendButton.isHidden = true
        confirmAddFriendBg.isHidden = true
        
        self.addSubview(confirmAddFriendBg)
        self.addSubview(confirmAddFriendButton)
        
        confirmAddFriendBg.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        confirmAddFriendBg.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        confirmAddFriendBg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        confirmAddFriendBg.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 5).isActive = true
        
        confirmAddFriendButton.widthAnchor.constraint(equalTo: confirmAddFriendBg.widthAnchor).isActive = true
        confirmAddFriendButton.heightAnchor.constraint(equalTo: confirmAddFriendBg.heightAnchor).isActive = true
        confirmAddFriendButton.centerXAnchor.constraint(equalTo: self.confirmAddFriendBg.centerXAnchor, constant: 0).isActive = true
        confirmAddFriendButton.centerYAnchor.constraint(equalTo: self.confirmAddFriendBg.centerYAnchor, constant: 0).isActive = true
        
        confirmAddFriendButton.bounds = confirmAddFriendBg.bounds
    }
    
    func showConfirmAddFriendButton(){
        confirmAddFriendButton.isHidden = false
        confirmAddFriendBg.isHidden = false
    }
    
    func hideConfirmAddFriendButton(){
        confirmAddFriendButton.isHidden = true
        confirmAddFriendBg.isHidden = true
    }
}
