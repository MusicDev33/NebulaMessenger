//
//  MessageBubble.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class MessageBubble: UICollectionViewCell{
    
    let textView: UITextView = {
        var tv = UITextView()
        tv.text = ""
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.isUserInteractionEnabled = false
        
        return tv
    }()
    
    let dateView: UILabel = {
        var label = UILabel()
        label.text = ""
        label.isHidden = true
        
        return label
    }()
    
    let senderLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let bubbleView: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.nebulaPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var senderRightAnchor: NSLayoutConstraint?
    var senderLeftAnchor: NSLayoutConstraint?
    
    var senderAboveBottomAnchor: NSLayoutConstraint?
    var senderHideBottomAnchor: NSLayoutConstraint?
    
    var senderHeightAnchor: NSLayoutConstraint?
    
    var selfHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(senderLabel)
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: self.frame.width*0.66)
        bubbleWidthAnchor?.isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        senderHeightAnchor = senderLabel.heightAnchor.constraint(equalToConstant: 20)
        //senderHeightAnchor?.isActive = true
        
        senderAboveBottomAnchor = senderLabel.bottomAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0)
        senderAboveBottomAnchor?.isActive = true
        
        senderRightAnchor = senderLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -6)
        senderRightAnchor?.isActive = true
        
        senderLeftAnchor = senderLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 6)
        senderLeftAnchor?.isActive = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
