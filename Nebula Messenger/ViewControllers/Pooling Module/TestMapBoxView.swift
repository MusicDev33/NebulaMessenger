//
//  TestMapBoxView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/24/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Mapbox

class TestMapBoxView: UIView {
    var poolCollectionView: UICollectionView!
    
    let buttonHeight = CGFloat(30)
    let buttonBGHeight = CGFloat(40)
    
    let map: MGLMapView = {
        let styleURL = URL(string: "mapbox://styles/musicdev/cjrat7obp0pv52tmqfiqow58d")
        let view = MGLMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), styleURL: styleURL)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = nebulaPurple
        view.showsUserLocation = true
        
        // TODO: Add logo and i button back to map
        //view.logoView.isHidden = true
        //view.attributionButton.isHidden = true
        
        
        return view
    }()
    
    let backButtonBackground: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nebulaPurple
        view.layer.cornerRadius = 20
        return view
    }()
    
    let backButton: UIButton = {
        var button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        return button
    }()
    
    func createCollectionView(){
        let bottomPadding = self.safeAreaInsets.bottom
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: bottomPadding + 6, right: 0)
        layout.itemSize = CGSize(width: self.frame.width-20, height: 50)
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        poolCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        poolCollectionView.isUserInteractionEnabled = true
        poolCollectionView.allowsSelection = true
        poolCollectionView.alwaysBounceVertical = true
        poolCollectionView.translatesAutoresizingMaskIntoConstraints = false
        poolCollectionView.register(PoolChatCell.self, forCellWithReuseIdentifier: "poolCell")
        poolCollectionView.backgroundColor = panelColorTwo
        poolCollectionView.layer.cornerRadius = 16
        addSubview(poolCollectionView)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(map)
        addSubview(backButtonBackground)
        addSubview(backButton)
        
        setupMap()
        createCollectionView()
        layoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupMap(){
        let latitude = UserDefaults.standard.object(forKey: "lastLatitude") as? Double ?? 0
        let longitude = UserDefaults.standard.object(forKey: "lastLongitude") as? Double ?? 0
        
        map.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 15, animated: false)
    }

    var bButtonBgX: NSLayoutConstraint?
    var bButtonBgY: NSLayoutConstraint?
    
    func layoutConstraints(){
        map.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        map.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        map.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        backButtonBackground.widthAnchor.constraint(equalToConstant: buttonBGHeight).isActive = true
        backButtonBackground.heightAnchor.constraint(equalToConstant: buttonBGHeight).isActive = true
        
        bButtonBgX = backButtonBackground.centerXAnchor.constraint(equalTo: leftAnchor, constant: 30)
        bButtonBgX?.isActive = true
        
        bButtonBgY = backButtonBackground.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30)
        bButtonBgY?.isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        backButton.centerXAnchor.constraint(equalTo: backButtonBackground.centerXAnchor, constant: -1).isActive = true
        backButton.centerYAnchor.constraint(equalTo: backButtonBackground.centerYAnchor, constant: 0).isActive = true
        
        poolCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        poolCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        poolCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        poolCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
