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
    
    override init(frame: CGRect, view: UIView) {
        super.init(frame: frame, view: view)
        //self.backgroundColor = UIColor.black
        addSubview(navBar)
        addSubview(topLine)
        addSubview(backButton)
        addSubview(involvedLabel)
        addSubview(subscribeBackground)
        addSubview(subscribeView)
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
}

