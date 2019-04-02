//
//  QuestionModule.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/24/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class QuestionModule: UICollectionViewCell{
    
    var infoViewOpen = false
    
    let bubbleView: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.nebulaPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let questionNumberView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        return view
    }()
    
    let questionNumberLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Colors.nebulaPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    let extraInfoView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.nebulaPurpleLight.cgColor
        
        return view
    }()
    
    let extraInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var extraInfoBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(extraInfoView)
        addSubview(extraInfoLabel)
        addSubview(bubbleView)
        addSubview(questionNumberView)
        addSubview(questionNumberLabel)
        addSubview(questionLabel)
    }
    
    func sizeWithLabel(){
        if questionLabel.numberOfLines > 1{
            bubbleHeightAnchor?.isActive = false
            bubbleView.bottomAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5).isActive = true
        }
    }
    
    func setupConstraints(){
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 50)
        bubbleHeightAnchor?.isActive = true
        
        //bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5)
        bubbleViewLeftAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        questionNumberView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        questionNumberView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        questionNumberView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        questionNumberView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        
        questionNumberLabel.centerXAnchor.constraint(equalTo: questionNumberView.centerXAnchor, constant: 0).isActive = true
        questionNumberLabel.centerYAnchor.constraint(equalTo: questionNumberView.centerYAnchor, constant: 0).isActive = true
        
        questionLabel.leftAnchor.constraint(equalTo: questionNumberView.rightAnchor, constant: 4).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -5).isActive = true
        questionLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        
        extraInfoView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        extraInfoView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        extraInfoView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        extraInfoBottomConstraint = extraInfoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        extraInfoBottomConstraint?.isActive = true
        
        extraInfoLabel.bottomAnchor.constraint(equalTo: extraInfoView.bottomAnchor, constant: -5).isActive = true
        extraInfoLabel.rightAnchor.constraint(equalTo: extraInfoView.rightAnchor, constant: -5).isActive = true
        extraInfoLabel.leftAnchor.constraint(equalTo: extraInfoView.leftAnchor, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

