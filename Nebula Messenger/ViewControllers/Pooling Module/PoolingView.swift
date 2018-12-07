//
//  PoolingView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 12/6/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import MapKit

class PoolingView: UIView {
    let buttonHeight = CGFloat(30)
    let buttonBGHeight = CGFloat(40)
    
    var mapView: MKMapView = {
        let map = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        map.mapType = MKMapType.hybrid
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        map.showsBuildings = true
        map.showsCompass = true
        map.tintColor = nebulaPurple
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        addSubview(backButtonBackground)
        addSubview(backButton)
        
        layoutMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var bButtonBgX: NSLayoutConstraint?
    var bButtonBgY: NSLayoutConstraint?
    var mapViewHeightAnchor: NSLayoutConstraint?
    
    func layoutMapView(){
        mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mapViewHeightAnchor = mapView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85)
        mapViewHeightAnchor?.isActive = true
        
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
    }
    
    //Actions
    
    func draggedCircle(x: CGFloat, y: CGFloat){
        bButtonBgX?.constant += x
        
        let insetsTotal = self.safeAreaInsets.top
        
        if (bButtonBgY?.constant)! + y + (buttonBGHeight/2) + insetsTotal + 20 > self.safeAreaLayoutGuide.layoutFrame.size.height * 0.85{
            
        }else{
            bButtonBgY?.constant += y
        }
    }
}
