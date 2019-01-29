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
        let styleURL = URL(string: GlobalUser.userMapUrl)
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
    
    let cViewXBackground: UIView = {
        let view = UIView()
        view.backgroundColor = nebulaPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 0
        
        return view
    }()
    
    let cViewX: UIImageView = {
        let view = UIImageView(image: UIImage(named: "BlackX"))
        view.tintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let expandArrowBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nebulaPurple
        view.layer.cornerRadius = 19
        view.alpha = 0
        
        return view
    }()
    
    let expandArrow: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(named: "UpArrowBlack"), for: .normal)
        view.tintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
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
        poolCollectionView.showsVerticalScrollIndicator = false
        addSubview(poolCollectionView)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(map)
        addSubview(backButtonBackground)
        addSubview(backButton)
        addSubview(expandArrowBackground)
        addSubview(expandArrow)
        
        setupMap()
        createCollectionView()
        
        addSubview(cViewXBackground)
        addSubview(cViewX)
        
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
    
    // Possibly the worst variable names of the century
    // It's a good thing there are still 81 years for someone else to beat me
    // Anyway, cViewXBG = collectionView X Background
    // This is the X that pops up on the collectionView to show if it's going away or not
    // If you have questions, don't call me
    // Just get rid of this and make one that makes more sense
    var cViewXBGWidth: NSLayoutConstraint?
    var cViewXBGHeight: NSLayoutConstraint?
    
    var poolCollectionHeightConstraint: NSLayoutConstraint?
    var poolCollectionBottomAnchor: NSLayoutConstraint?
    
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
        
        
        expandArrowBackground.widthAnchor.constraint(equalToConstant: 38).isActive = true
        expandArrowBackground.heightAnchor.constraint(equalToConstant: 38).isActive = true
        expandArrowBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        expandArrowBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        expandArrow.centerXAnchor.constraint(equalTo: expandArrowBackground.centerXAnchor).isActive = true
        expandArrow.centerYAnchor.constraint(equalTo: expandArrowBackground.centerYAnchor).isActive = true
        expandArrow.widthAnchor.constraint(equalTo: expandArrowBackground.widthAnchor, multiplier: 0.85).isActive = true
        expandArrow.heightAnchor.constraint(equalTo: expandArrowBackground.heightAnchor, multiplier: 0.85).isActive = true
        
        
        poolCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        poolCollectionBottomAnchor = poolCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        poolCollectionBottomAnchor?.isActive = true
        poolCollectionHeightConstraint = poolCollectionView.heightAnchor.constraint(equalToConstant: 200)
        poolCollectionHeightConstraint?.isActive = true
        poolCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        cViewXBackground.topAnchor.constraint(equalTo: poolCollectionView.topAnchor, constant: 5).isActive = true
        cViewXBackground.rightAnchor.constraint(equalTo: poolCollectionView.rightAnchor, constant: -5).isActive = true
        
        cViewXBGWidth = cViewXBackground.widthAnchor.constraint(equalToConstant: 0)
        cViewXBGWidth?.isActive = true
        cViewXBGHeight = cViewXBackground.heightAnchor.constraint(equalToConstant: 0)
        cViewXBGHeight?.isActive = true
        
        cViewX.centerXAnchor.constraint(equalTo: cViewXBackground.centerXAnchor).isActive = true
        cViewX.centerYAnchor.constraint(equalTo: cViewXBackground.centerYAnchor).isActive = true
        cViewX.widthAnchor.constraint(equalTo: cViewXBackground.widthAnchor, multiplier: 0.8).isActive = true
        cViewX.heightAnchor.constraint(equalTo: cViewXBackground.heightAnchor, multiplier: 0.8).isActive = true
    }
}
