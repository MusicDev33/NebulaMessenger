//
//  EduModKey.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/23/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class EduModKey: UIView {
    let screenSizeX = UIScreen.main.bounds.size.width
    let textViewMaxLines: CGFloat = 6
    
    var mode = ModKeyMode.blank
    
    var resizeMode = false
    var hasMoved = false
    
    var textStorage = ""
    
    let multipleChoiceView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let aButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    let bButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    let cButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    let dButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    let eButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    // True/False view
    let tfView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let trueButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    let falseButton: UIButton = {
        let button = UIButton(type: .system)
        
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
    
    let buttonHeight = CGFloat(50)
    
    let screenBounds = UIScreen.main.bounds
    
    func buildConstraints(){
        
        centerXConstraint = self.centerXAnchor.constraint(equalTo: self.parentView.centerXAnchor, constant: 0)
        centerXConstraint?.isActive = true
        bottomConstraint = self.bottomAnchor.constraint(equalTo: self.parentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
        
        widthConstraint = self.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: 0)
        widthConstraint?.isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.isActive = true
        
        buildMultiChoiceButtons()
    }
    
    func buildTFButtons(){
        
    }
    
    func buildMultiChoiceButtons(){
        let choiceButtons = [aButton, bButton, cButton, dButton, eButton]
        
        addSubview(multipleChoiceView)
        multipleChoiceView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        multipleChoiceView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        multipleChoiceView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        multipleChoiceView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        for i in 0..<choiceButtons.count{
            let addConstant = CGFloat((i+1)/6)
            
            addSubview(choiceButtons[i])
            
            choiceButtons[i].widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            choiceButtons[i].heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            choiceButtons[i].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            choiceButtons[i].centerXAnchor.constraint(equalTo: self.leftAnchor, constant: screenSizeX*addConstant)
        }
    }
}
