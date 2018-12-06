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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        
        layoutMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutMapView(){
        mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
    }
}
