//
//  FriendsView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/6/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class FriendsView: UIView {
    
    let continueButtonBg: UIView = {
        let view = UIView()
        view.backgroundColor = nebulaPurple
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    let continueButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "ForwardArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = UIColor.white
        button.isHidden = true
        
        return button
    }()
    
    let friendsTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RequestedTableViewCell.self, forCellReuseIdentifier: "friendCell")
        
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
        addSubview(continueButtonBg)
        addSubview(continueButton)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView(){
        continueButtonBg.widthAnchor.constraint(equalToConstant: 40).isActive = true
        continueButtonBg.heightAnchor.constraint(equalToConstant: 40).isActive = true
        continueButtonBg.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        continueButtonBg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
        continueButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: continueButtonBg.centerYAnchor).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: continueButtonBg.centerXAnchor, constant: 1).isActive = true
        
        friendsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        friendsTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTable.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        friendsTableBottomLine.topAnchor.constraint(equalTo: self.friendsTable.bottomAnchor).isActive = true
        friendsTableBottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        friendsTableBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        friendsTableBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func continueSwitch(buttonOn: Bool){
        if buttonOn{
            continueButton.isHidden = false
            continueButtonBg.isHidden = false
        }else{
            continueButton.isHidden = true
            continueButtonBg.isHidden = true
        }
    }
}
