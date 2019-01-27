//
//  TestMapBoxVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/24/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Mapbox

class TestMapBoxVC: UIViewController, MGLMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mapView.poolCollectionView.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        cell.poolNameLabel.text = "Testing"
        
        return cell
    }
    
    
    var mapView: TestMapBoxView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = TestMapBoxView(frame: self.view.frame)
        mapView.map.userTrackingMode = .follow
        
        self.view.addSubview(mapView)
        
        mapView.map.delegate = self
        mapView.poolCollectionView.delegate = self
        mapView.poolCollectionView.dataSource = self
        
        mapView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

}
