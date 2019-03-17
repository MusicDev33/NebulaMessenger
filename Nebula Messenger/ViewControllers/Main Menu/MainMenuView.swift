//
//  MainMenuView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/27/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class MainMenuView: UIView {
    
    let convTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "conversationCell")
        table.register(SearchBarHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.separatorStyle = .none
        table.separatorColor = table.backgroundColor
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        return table
    }()
    
    let bottomBarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.panelColorTwo
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.panelColorOne.cgColor
        view.alpha = 0.95
        
        return view
    }()
    
    let addFriendsButton: UIButton = {
        let addFriendsButton = UIButton(type: .system)
        addFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "GroupAddBlack") {
            addFriendsButton.setImage(image, for: .normal)
        }
        addFriendsButton.tintColor = Colors.nebulaPurple
        
        return addFriendsButton
    }()
    
    let nebulaButton: UIButton = {
        let nebulaButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        nebulaButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Pool") {
            nebulaButton.setImage(image, for: .normal)
        }
        
        return nebulaButton
    }()
    
    let createMessageButton: UIButton = {
        let createMessageButton = UIButton(type: .system)
        createMessageButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "EditIconBlack") {
            createMessageButton.setImage(image, for: .normal)
        }
        createMessageButton.tintColor = Colors.nebulaPurple
        
        return createMessageButton
    }()
    
    var parentView: UIView!
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        parentView = view
        
        addSubview(convTable)
        addSubview(bottomBarView)
        addSubview(addFriendsButton)
        addSubview(nebulaButton)
        addSubview(createMessageButton)
        
        setConstraintsConvTable()
        setConstraintsBottomBar()
        setConstraintsBottomButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var convTableHeightAnchor: NSLayoutConstraint?
    
    func setConstraintsConvTable(){
        convTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        convTable.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        convTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        convTable.bottomAnchor.constraint(equalTo: self.bottomBarView.topAnchor, constant: 60).isActive = true
    }
    
    var bottomBarHeightAnchor: NSLayoutConstraint?
    
    func setConstraintsBottomBar(){
        
        bottomBarView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomBarView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bottomBarView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomBarHeightAnchor = bottomBarView.heightAnchor.constraint(equalToConstant: 60)
        bottomBarHeightAnchor?.isActive = true
    }
    
    func setConstraintsBottomButtons(){
        addFriendsButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addFriendsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addFriendsButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        addFriendsButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        nebulaButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nebulaButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nebulaButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        nebulaButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        createMessageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        createMessageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        createMessageButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        createMessageButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
    }

}
