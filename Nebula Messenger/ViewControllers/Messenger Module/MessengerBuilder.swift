//
//  MessengerBuilder.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class MessengerBuilder: NSObject{
    
    override init(){}
    
    // Create Group Chat Buttons
    func createAddToGroupButton(view: UIView) -> UIButton{
        let addToGroupButton = UIButton()
        addToGroupButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        addToGroupButton.center = view.center
        addToGroupButton.frame.origin.y = 50
        if let image = UIImage(named: "AddFriendBlack") {
            addToGroupButton.setImage(image, for: .normal)
        }
        
        return addToGroupButton
    }
    
    func createPulsatingLayer(button: UIButton, view: UIView) -> CAShapeLayer{
        let pulsatingLayer = CAShapeLayer()
        
        // Here we add half of the button's width to the circle's center to get it to center on the button
        let point = CGPoint(x: view.center.x, y: button.frame.origin.y+20)
        let circlePath = UIBezierPath(arcCenter: .zero, radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let bgColor = nebulaPurple.withAlphaComponent(0.0)
        pulsatingLayer.path = circlePath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = bgColor.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = point
        
        return pulsatingLayer
    }
    
    func createExitGroupButton(view: UIView, button: UIButton) -> UIButton{
        let exitGroupButton = UIButton()
        exitGroupButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        exitGroupButton.center = view.center
        exitGroupButton.frame.origin.y = button.frame.origin.y
        if let image = UIImage(named: "BlackX") {
            exitGroupButton.setImage(image, for: .normal)
        }
        exitGroupButton.alpha = 0
        
        return exitGroupButton
    }
    
    func createConfirmAddButton(view: UIView, button: UIButton) -> UIButton{
        let confirmAddButton = UIButton()
        confirmAddButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        confirmAddButton.center = view.center
        confirmAddButton.frame.origin.y = button.frame.origin.y
        if let image = UIImage(named: "PlusSignBlack") {
            confirmAddButton.setImage(image, for: .normal)
        }
        confirmAddButton.alpha = 0
        
        return confirmAddButton
    }
    
    //
    func buildNavBar(view: UIView, involved: String, vc: MessengerVC) -> UIView{
        let navBar = UIView()
        let backButton = UIButton()
        let trashButton = UIButton()
        let involvedLabel = UILabel()
        
        let addToGroupButton = UIButton()
        let exitGroupButton = UIButton()
        let confirmAddButton = UIButton()
        
        navBar.addSubview(backButton)
        navBar.addSubview(trashButton)
        navBar.addSubview(addToGroupButton)
        navBar.addSubview(exitGroupButton)
        navBar.addSubview(confirmAddButton)
        
        // Set up the basic frame
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/8)
        navBar.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        
        let lineView = UIView(frame: CGRect(x: 0, y: navBar.frame.height, width: view.frame.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        navBar.addSubview(lineView)
        
        let backButtonHeight = CGFloat(40)
        let backButtonY = (navBar.frame.height/2) - (backButtonHeight/2)
        backButton.frame = CGRect(x: 15, y: backButtonY+10, width: backButtonHeight, height: backButtonHeight)
        if let image = UIImage(named: "BackArrowBlack") {
            backButton.setImage(image, for: .normal)
        }
        
        trashButton.frame = CGRect(x: view.frame.width-backButtonHeight-15, y: backButtonY+10, width: backButtonHeight, height: backButtonHeight)
        if let image = UIImage(named: "Trashcan") {
            trashButton.setImage(image, for: .normal)
        }
        
        let involvedWidth = view.frame.width/2
        involvedLabel.frame = CGRect(x: 0, y: 0, width: involvedWidth, height: 21)
        involvedLabel.font = UIFont.systemFont(ofSize: 16)
        involvedLabel.textColor = UIColor.black
        involvedLabel.text = involved
        let involvedLabelY = (navBar.frame.height/2) - (involvedLabel.frame.height/2)
        involvedLabel.frame.origin.x = (view.frame.width/2) - (involvedLabel.frame.width/2)
        involvedLabel.frame.origin.y = involvedLabelY
        print(involvedLabel.frame.origin.x)
        print(involvedLabel.frame.origin.y)
        navBar.addSubview(involvedLabel)
        
        // Set functions of buttons
        backButton.addTarget(self, action: #selector(vc.goBack(sender:)), for: .touchUpInside)
        
        return navBar
    }
    
}
