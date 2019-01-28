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
    
    
    var mapView: TestMapBoxView!
    var poolsInArea = [PublicPool]()
    var currentPools = [PublicPool]()
    
    let defaultRadius = 50
    
    // Collectionview stuff
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mapView.poolCollectionView.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        cell.poolNameLabel.text = "Testing"
        
        return cell
    }
    
    // Mapbox stuff
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if let castAnnotation = annotation as? MBPoolAnnotation {
            if ((castAnnotation.imageName) == nil) {
                return nil
            }
        }
        
        // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        let reuseIdentifier = "reusableDotView"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = 2.0
            annotationView?.layer.borderColor = UIColor.white.cgColor
            annotationView!.backgroundColor = UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if let castAnnotation = annotation as? MBPoolAnnotation {
            if (castAnnotation.imageName == nil) {
                return nil
            }
        }
        
        // For better performance, always try to reuse existing annotations.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "CloudCircle")
        
        // If there is no reusable annotation image available, initialize a new one.
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: UIImage(named: "CloudCircle")!, reuseIdentifier: "CloudCircle")
        }
        
        return annotationImage
    }

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
        
        PoolRoutes.getPools(){pools in
            for pool in pools{
                self.poolsInArea.append(pool)
                let poolAtPoint = MBPoolAnnotation()
                
                //let annotation = PoolAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
                poolAtPoint.coordinate = coordinate
                
                poolAtPoint.title = pool.name
                poolAtPoint.subtitle = pool.creator
                poolAtPoint.imageName = "CloudCircle"
                poolAtPoint.id = pool.poolId
                self.mapView.map.addAnnotation(poolAtPoint)
            }
        }
    }
    
    // Button methods
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

}
