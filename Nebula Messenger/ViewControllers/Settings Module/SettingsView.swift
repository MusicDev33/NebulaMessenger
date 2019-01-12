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
    
    let backButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
        addSubview(backButton)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConstraints(){
        backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
