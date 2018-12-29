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
        
        addSubview(backButton)
        addSubview(continueButton)
        addSubview(friendsTableTopLine)
        addSubview(friendsTable)
        addSubview(friendsTableBottomLine)
        
        setupTopButtons()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTopButtons(){
        backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        continueButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupTableView(){
        friendsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        friendsTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTable.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTable.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        
        friendsTableTopLine.bottomAnchor.constraint(equalTo: self.friendsTable.topAnchor).isActive = true
        friendsTableTopLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTableTopLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTableTopLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        friendsTableBottomLine.topAnchor.constraint(equalTo: self.friendsTable.bottomAnchor).isActive = true
        friendsTableBottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTableBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTableBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
