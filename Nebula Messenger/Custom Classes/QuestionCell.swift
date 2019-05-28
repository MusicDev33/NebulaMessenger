//
//  QuestionCell.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 4/23/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    var bgViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(questionLabel)
        
        //setupConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setupConstraints(){
        //bgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        bgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgViewHeightConstraint = bgView.heightAnchor.constraint(equalToConstant: 50)
        bgViewHeightConstraint?.isActive = true
        
        questionLabel.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 5).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -5).isActive = true
        questionLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 5).isActive = true
    }
}
