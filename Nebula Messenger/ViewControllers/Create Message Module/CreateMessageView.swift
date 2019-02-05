//
//  CreateMessageView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 12/29/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class CreateMessageView: UIView {
    
    let backButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BlackX") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let newMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "New Message"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        
        return label
    }()
    
    let continueButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(nebulaPurple, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.setTitle("Continue", for: .normal)
        
        return button
    }()
    
    let friendsTableTopLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    let friendsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        
        return table
    }()
    
    let friendsTableBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(friendsTable)
        addSubview(friendsTableBottomLine)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView(){
        friendsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        friendsTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTable.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //friendsTable.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        friendsTableBottomLine.topAnchor.constraint(equalTo: self.friendsTable.bottomAnchor).isActive = true
        friendsTableBottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTableBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTableBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
