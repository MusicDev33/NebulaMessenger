//
//  ProfileView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/2/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    var optionsView: UICollectionView!
    var selfColorCollectionView: UICollectionView!
    var otherColorCollectionView: UICollectionView!

    let backButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let settingsButton: UIButton = {
        var button = UIButton(type: .system)
        if let image = UIImage(named: "SettingsBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let logoutButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(Colors.nebulaPurple, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.setTitle("Log Out", for: .normal)
        
        return button
    }()
    
    let messageColorsLabel: UILabel = {
        var label = UILabel()
        label.text = "Message Colors"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let personalColorView: UIView = {
        let cornerRadius = CGFloat(16)
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = userTextColor
        view.layer.cornerRadius = cornerRadius
        
        return view
    }()
    
    let otherColorView: UIView = {
        let cornerRadius = CGFloat(16)
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = otherTextColor
        view.layer.cornerRadius = cornerRadius
        
        return view
    }()
    
    let profilePicView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.nebulaSky
        view.layer.cornerRadius = CGFloat(32)
        
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.nebulaFlame.cgColor
        
        return view
    }()
    
    func createOptionsCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: self.frame.width*0.9, height: 50)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        self.optionsView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.optionsView.isUserInteractionEnabled = true
        self.optionsView.allowsSelection = true
        self.optionsView.alwaysBounceVertical = true
        self.optionsView.translatesAutoresizingMaskIntoConstraints = false
        optionsView.register(PoolChatCell.self, forCellWithReuseIdentifier: "poolChatCell")
        optionsView.backgroundColor = Colors.panelColorTwo
        optionsView.layer.cornerRadius = 16
        
        addSubview(optionsView)
    }
    
    func createSelfCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        selfColorCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        selfColorCollectionView.isUserInteractionEnabled = true
        selfColorCollectionView.allowsSelection = true
        selfColorCollectionView.alwaysBounceVertical = true
        selfColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selfColorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorSquare")
        selfColorCollectionView.backgroundColor = Colors.panelColorTwo
        selfColorCollectionView.layer.cornerRadius = 8
        
        addSubview(selfColorCollectionView)
    }
    
    func createOtherCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        otherColorCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        otherColorCollectionView.isUserInteractionEnabled = true
        otherColorCollectionView.allowsSelection = true
        otherColorCollectionView.alwaysBounceVertical = true
        otherColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        otherColorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorSquare")
        otherColorCollectionView.backgroundColor = Colors.panelColorTwo
        otherColorCollectionView.layer.cornerRadius = 8
        
        addSubview(otherColorCollectionView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        addSubview(settingsButton)
        addSubview(logoutButton)
        addSubview(messageColorsLabel)
        addSubview(personalColorView)
        addSubview(otherColorView)
        //addSubview(profilePicView)
        //createOptionsCollectionView()
        createSelfCollectionView()
        createOtherCollectionView()
        
        setTopViewConstraints()
        setupColorCollectionViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var selfColorViewHeightAnchor: NSLayoutConstraint?
    var otherColorViewHeightAnchor: NSLayoutConstraint?
    
    var selfColorViewWidthAnchor: NSLayoutConstraint?
    var otherColorViewWidthAnchor: NSLayoutConstraint?
    
    func setTopViewConstraints(){
        let colorViewWidth = CGFloat(60)
        
        backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        settingsButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        logoutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        messageColorsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageColorsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        personalColorView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        personalColorView.centerXAnchor.constraint(equalTo: self.centerXAnchor,
                                                   constant: (-colorViewWidth/2) - 5).isActive = true
        selfColorViewWidthAnchor = personalColorView.widthAnchor.constraint(equalToConstant: colorViewWidth)
        selfColorViewWidthAnchor?.isActive = true
        selfColorViewHeightAnchor = personalColorView.heightAnchor.constraint(equalToConstant: colorViewWidth)
        selfColorViewHeightAnchor?.isActive = true
        
        otherColorView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        otherColorView.centerXAnchor.constraint(equalTo: self.centerXAnchor,
                                                constant: (colorViewWidth/2) + 5).isActive = true
        otherColorViewWidthAnchor = otherColorView.widthAnchor.constraint(equalToConstant: colorViewWidth)
        otherColorViewWidthAnchor?.isActive = true
        otherColorViewHeightAnchor = otherColorView.heightAnchor.constraint(equalToConstant: colorViewWidth)
        otherColorViewHeightAnchor?.isActive = true
        
//        profilePicView.topAnchor.constraint(equalTo: selfColorCollectionView.bottomAnchor, constant: 5).isActive = true
//        profilePicView.bottomAnchor.constraint(equalTo: profilePicView.topAnchor, constant: 120).isActive = true
//        profilePicView.widthAnchor.constraint(equalTo: profilePicView.heightAnchor).isActive = true
//
//        profilePicView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    var selfColorHeightConstraint: NSLayoutConstraint?
    var otherColorHeightConstraint: NSLayoutConstraint?
    
    func setupColorCollectionViews(){
        let cellWidth = CGFloat(50)
        
        selfColorCollectionView.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        selfColorHeightConstraint = selfColorCollectionView.heightAnchor.constraint(equalToConstant: 0)
        selfColorHeightConstraint?.isActive = true
        selfColorCollectionView.centerXAnchor.constraint(equalTo: personalColorView.centerXAnchor).isActive = true
        selfColorCollectionView.topAnchor.constraint(equalTo: personalColorView.bottomAnchor,
                                                     constant: 5).isActive = true
        
        otherColorCollectionView.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        otherColorHeightConstraint = otherColorCollectionView.heightAnchor.constraint(equalToConstant: 0)
        otherColorHeightConstraint?.isActive = true
        otherColorCollectionView.centerXAnchor.constraint(equalTo: otherColorView.centerXAnchor).isActive = true
        otherColorCollectionView.topAnchor.constraint(equalTo: otherColorView.bottomAnchor,
                                                      constant: 5).isActive = true
        
    }
}
