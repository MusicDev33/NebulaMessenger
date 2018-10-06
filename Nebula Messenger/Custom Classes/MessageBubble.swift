//
//  MessageBubble.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class MessageBubble: UITableViewCell{
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let bubbleView: UIView = {
        var view = UIView()
        view.backgroundColor = nebulaPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(bubbleView)
        addSubview(messageLabel)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        messageLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 10).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        messageLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}
