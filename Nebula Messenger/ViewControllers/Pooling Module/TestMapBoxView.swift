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
    let map: MGLMapView = {
        let styleURL = URL(string: "mapbox://styles/musicdev/cjrat7obp0pv52tmqfiqow58d")
        let view = MGLMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), styleURL: styleURL)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = nebulaPurple
        view.showsUserLocation = true
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(map)
        
        layoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func layoutConstraints(){
        map.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        map.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        map.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
    }
}
