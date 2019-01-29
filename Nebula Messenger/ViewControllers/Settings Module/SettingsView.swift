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
    
    let pickMapLabel: UILabel = {
        let label = UILabel()
        label.text = "Map Options"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let satelliteOptionButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = nebulaBlue
        view.tintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
        view.setTitle("Satellite", for: .normal)
        view.layer.borderColor = nebulaPurple.cgColor
        
        return view
    }()
    
    let experimentalOptionButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = nebulaPurple
        view.tintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
        view.setTitle("Experimental", for: .normal)
        view.layer.borderColor = nebulaBlue.cgColor
        
        return view
    }()
    
    let defaultNavOptionButton: UIButton = {
        // Yes, it's default and nav...I'm 2 for 2 when it comes to terrible naming
        let view = UIButton(type: .system)
        if Utility.dayTimeCheck() == "day"{
            view.backgroundColor = nebulaSky
            view.tintColor = UIColor.black
            view.setTitle("Default: Day", for: .normal)
            view.layer.borderColor = UIColor(red: 9/255, green: 55/255, blue: 130/255, alpha: 1).cgColor
        }else{
            view.backgroundColor = UIColor(red: 9/255, green: 55/255, blue: 130/255, alpha: 1)
            view.tintColor = UIColor.white
            view.setTitle("Default: Night", for: .normal)
            view.layer.borderColor = nebulaSky.cgColor
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
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
        
        addSubview(backButton)
        addSubview(pickMapLabel)
        addSubview(satelliteOptionButton)
        addSubview(experimentalOptionButton)
        addSubview(defaultNavOptionButton)
        
        let chosenButton = UserDefaults.standard.string(forKey: "mapPreference") ?? "default"
        
        switch chosenButton {
        case "experimental":
            experimentalOptionButton.layer.borderWidth = 2
        case "satellite":
            satelliteOptionButton.layer.borderWidth = 2
        default:
            defaultNavOptionButton.layer.borderWidth = 2
        }
        
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
        
        pickMapLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pickMapLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        experimentalOptionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        experimentalOptionButton.topAnchor.constraint(equalTo: pickMapLabel.bottomAnchor, constant: 20).isActive = true
        experimentalOptionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        satelliteOptionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        satelliteOptionButton.rightAnchor.constraint(equalTo: experimentalOptionButton.leftAnchor, constant: -10).isActive = true
        satelliteOptionButton.centerYAnchor.constraint(equalTo: experimentalOptionButton.centerYAnchor).isActive = true
        
        defaultNavOptionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        defaultNavOptionButton.leftAnchor.constraint(equalTo: experimentalOptionButton.rightAnchor, constant: 10).isActive = true
        defaultNavOptionButton.centerYAnchor.constraint(equalTo: experimentalOptionButton.centerYAnchor).isActive = true
        
    }
    
    func chooseButton(chosen: String){
        experimentalOptionButton.layer.borderWidth = 0
        satelliteOptionButton.layer.borderWidth = 0
        defaultNavOptionButton.layer.borderWidth = 0
        
        switch chosen {
        case "experimental":
            let borderAnim: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            borderAnim.fromValue = 0
            borderAnim.toValue = 2
            borderAnim.duration = 0.3
            experimentalOptionButton.layer.add(borderAnim, forKey: "Width")
            experimentalOptionButton.layer.borderWidth = 2
        case "satellite":
            let borderAnim: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            borderAnim.fromValue = 0
            borderAnim.toValue = 2
            borderAnim.duration = 0.3
            satelliteOptionButton.layer.add(borderAnim, forKey: "Width")
            satelliteOptionButton.layer.borderWidth = 2
        default:
            let borderAnim: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            borderAnim.fromValue = 0
            borderAnim.toValue = 2
            borderAnim.duration = 0.3
            defaultNavOptionButton.layer.add(borderAnim, forKey: "Width")
            defaultNavOptionButton.layer.borderWidth = 2
        }
    }
}
