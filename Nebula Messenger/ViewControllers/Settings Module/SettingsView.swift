//
//  SettingsView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    var settingsCView: UICollectionView!
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
    
    let logoutButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(nebulaPurple, for: .normal)
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
        view.backgroundColor = nebulaSky
        view.layer.cornerRadius = CGFloat(32)
        
        view.layer.borderWidth = 1
        view.layer.borderColor = nebulaFlame.cgColor
        
        return view
    }()
    
    func createSettingsCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.itemSize = CGSize(width: self.frame.width*0.9, height: 50)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        self.settingsCView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.settingsCView.isUserInteractionEnabled = true
        self.settingsCView.allowsSelection = true
        self.settingsCView.alwaysBounceVertical = true
        self.settingsCView.translatesAutoresizingMaskIntoConstraints = false
        settingsCView.register(PoolChatCell.self, forCellWithReuseIdentifier: "poolChatCell")
        settingsCView.backgroundColor = panelColorTwo
        settingsCView.layer.cornerRadius = 16
        
        addSubview(settingsCView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
