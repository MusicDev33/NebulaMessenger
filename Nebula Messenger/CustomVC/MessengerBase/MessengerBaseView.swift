//
//  MessengerBaseView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/5/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class MessengerBaseView: UIView, DefaultMessengerUI {
    
    var hasMoved = false
    let screenBounds = UIScreen.main.bounds
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        
        addSubview(navBar)
        addSubview(topLine)
        addSubview(backButton)
        addSubview(involvedLabel)
        //self.layer.addSublayer(pulsatingLayer)
        addSubview(bottomBarActionButton)
        bottomBarActionButton.layer.addSublayer(pulsatingLayer)
        pulsatingLayer.frame = bottomBarActionButton.bounds
        pulsatingLayer.frame.origin.x += (buttonHeight-10)/2
        pulsatingLayer.frame.origin.y += (buttonHeight-10)/2
        
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
    
    let buttonHeight = CGFloat(30)
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
        
        involvedWidthAnchor = involvedLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33)
        involvedWidthAnchor?.isActive = true
        involvedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        involvedCenterAnchor = involvedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        //involvedCenterAnchor?.isActive = true
        involvedLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: -10).isActive = true
        
        bottomBarActionButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        bottomBarActionButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        bottomBarActionButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        bottomBarActionButton.topAnchor.constraint(equalTo: involvedLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    var messageFieldHeightAnchor: NSLayoutConstraint?
    
    var groupAddButtonTopAnchor: NSLayoutConstraint?
    
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
