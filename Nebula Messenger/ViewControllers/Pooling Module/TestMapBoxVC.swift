//
//  TestMapBoxVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/24/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Mapbox

class TestMapBoxVC: UIViewController, MGLMapViewDelegate {
    
    var mapView: TestMapBoxView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = TestMapBoxView(frame: self.view.frame)
        mapView.map.userTrackingMode = .follow
        
        self.view.addSubview(mapView)
        
        mapView.map.delegate = self

        // Do any additional setup after loading the view.
    }

}
