//
//  PoolChatCell.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/9/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class PoolChatCell: UICollectionViewCell{
    
    let poolNameLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let bgView: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.nebulaPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(poolNameLabel)
        
        bgView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        poolNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        poolNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        poolNameLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: 8).isActive = true
        poolNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
