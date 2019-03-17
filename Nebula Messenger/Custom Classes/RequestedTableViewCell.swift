//
//  RequestedTableViewCell.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/10/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class RequestedTableViewCell: UITableViewCell {
    
    var action: ((RequestedTableViewCell) -> Void)?
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = Colors.nebulaPurple
        button.layer.cornerRadius = 15
        button.layer.borderColor = Colors.nebulaPurple.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(usernameLabel)
        addSubview(acceptButton)
        
        usernameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        acceptButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func acceptedRequest(){
        self.action?(self)
    }
}
