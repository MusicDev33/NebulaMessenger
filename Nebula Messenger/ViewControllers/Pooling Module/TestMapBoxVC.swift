//
//  TestMapBoxVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/24/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Mapbox

class TestMapBoxVC: UIViewController, MGLMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    
    var mapView: TestMapBoxView!
    var poolsInArea = [PublicPool]()
    var currentPools = [PublicPool]()
    
    let defaultRadius = 30
    
    var didImpact = false
    let lightImpact = UIImpactFeedbackGenerator(style: .light)
    let impactNotif = UINotificationFeedbackGenerator()
    
    var testPool = PublicPool(coordinates: [0, 0], poolId: "testpool;;;", name: "Global Pool", creator: "MusicDev", connectionLimit: 1000, usersConnected: [String]())
    
    // Collectionview stuff
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mapView.poolCollectionView.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        cell.poolNameLabel.text = self.currentPools[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = self.poolTable.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        let poolId = self.currentPools[indexPath.row].poolId ?? ""
        let poolName = self.currentPools[indexPath.row].name ?? "Pool"
        PoolRoutes.getPoolMessages(id: poolId){messagesList in
            var messages = [TerseMessage]()
            messages = messagesList
            let poolChatVC = PoolChatVC()
            poolChatVC.modalPresentationStyle = .currentContext
            poolChatVC.poolId = poolId
            poolChatVC.poolName = poolName
            poolChatVC.currentPoolMessages = messages
            self.present(poolChatVC, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            var scrollOffset = abs(scrollView.contentOffset.y)
            if scrollOffset >= 30{
                scrollOffset = 30
                if !didImpact{
                    lightImpact.impactOccurred()
                    didImpact = true
                }
            }else{
                didImpact = false
            }
            self.mapView.cViewXBGWidth?.constant = scrollOffset
            self.mapView.cViewXBGHeight?.constant = scrollOffset
            self.mapView.cViewXBackground.layer.cornerRadius = scrollOffset/2
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -30 {
            UIView.animate(withDuration: 0.2, animations: {
                self.mapView.poolCollectionBottomAnchor?.constant = 200
                self.view.layoutIfNeeded()
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, delay: 0.03, animations: {
                    self.mapView.expandArrow.alpha = 1
                    self.mapView.expandArrowBackground.alpha = 1
                })
            })
        }
    }
    
    // Gesture Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Mapbox stuff
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if annotation.isKind(of: MGLPolygon.self) {
            return
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        var annotationColor = UIColor.lightGray
        var annotationBorderColor = UIColor.lightGray.cgColor
        var borderWidth = 2.0
        
        if let castAnnotation = annotation as? MBPoolAnnotation {
            switch castAnnotation.creator {
            case GlobalUser.username:
                annotationColor = nebulaPurple
            default:
                // UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
                // Saving this color for later
                annotationColor = nebulaBlue
            }
            
            if GlobalUser.subscribedPools.contains(castAnnotation.id){
                annotationBorderColor = UIColor.green.cgColor
                borderWidth = 2.0
            }else{
                annotationBorderColor = UIColor.white.cgColor
                borderWidth = 2.0
            }
            
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
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = CGFloat(borderWidth)
            annotationView?.layer.borderColor = annotationBorderColor
            
            annotationView!.backgroundColor = annotationColor
        }else{
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = CGFloat(borderWidth)
            annotationView?.layer.borderColor = annotationBorderColor
            
            annotationView!.backgroundColor = annotationColor
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let latitude: Double? = mapView.userLocation?.coordinate.latitude ?? 0
        let longitude: Double? = mapView.userLocation?.coordinate.longitude ?? 0
        if (latitude?.magnitude)! > Double(90){
            UserDefaults.standard.set(0, forKey: "lastLatitude")
        }else{
            UserDefaults.standard.set(latitude, forKey: "lastLatitude")
        }
        if (longitude?.magnitude)! > Double(180){
            UserDefaults.standard.set(0, forKey: "lastLatitude")
        }else{
            UserDefaults.standard.set(longitude, forKey: "lastLongitude")
        }
        
        guard let userCoord = mapView.userLocation?.coordinate else {return}
        
        // guard statements
        let point = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        
        for pool in globalPools{
            let poolCenter = CLLocation(latitude: pool.coordinates?[0] ?? 0, longitude: pool.coordinates?[1] ?? 0)
            if point.distance(from: poolCenter) < CLLocationDistance(self.defaultRadius+1) {
                if !currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools.append(pool)
                    print(pool.poolId!)
                }
            }else{
                if currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools = currentPools.filter {$0.poolId != pool.poolId}
                }
            }
        }
        if self.mapView.poolCollectionView != nil {
            self.mapView.poolCollectionView.reloadData()
        }
    }
    
    // Mapbox polygons
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.1
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .white
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return nebulaPurple
    }
    
    // User location
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let userCoord = mapView.userLocation?.coordinate else {return}
        
        // guard statements
        let point = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        
        for pool in globalPools{
            let poolCenter = CLLocation(latitude: pool.coordinates?[0] ?? 0, longitude: pool.coordinates?[1] ?? 0)
            if point.distance(from: poolCenter) < CLLocationDistance(self.defaultRadius+1) {
                if !currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools.append(pool)
                    print(pool.poolId!)
                }
            }else{
                if currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools = currentPools.filter {$0.poolId != pool.poolId}
                }
            }
        }
        if self.mapView.poolCollectionView != nil {
            self.mapView.poolCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Beginning")
        mapView = TestMapBoxView(frame: self.view.frame)
        mapView.map.userTrackingMode = .follow
        
        self.view.addSubview(mapView)
        
        mapView.map.delegate = self
        mapView.poolCollectionView.delegate = self
        mapView.poolCollectionView.dataSource = self
        
        mapView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        mapView.expandArrow.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        
        self.currentPools.append(testPool)
        
        // gestures
        let mapViewLongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressedOnMap(_:)))
        mapViewLongPress.delegate = self
        self.mapView.map.addGestureRecognizer(mapViewLongPress)

        // Do any additional setup after loading the view.
        print("End")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for pool in globalPools{
            let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
            
            let polygon = polygonCircleForCoordinate(coordinate: coordinate, withMeterRadius: Double(self.defaultRadius))
            self.mapView.map.addAnnotation(polygon)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for pool in globalPools{
            let poolAtPoint = MBPoolAnnotation()
            
            //let annotation = PoolAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
            poolAtPoint.coordinate = coordinate
            poolAtPoint.title = pool.name
            poolAtPoint.creator = pool.creator
            
            poolAtPoint.subtitle = pool.creator
            poolAtPoint.imageName = "CloudCircle"
            poolAtPoint.id = pool.poolId
            self.mapView.map.addAnnotation(poolAtPoint)
        }
    }
    
     override func viewDidDisappear(_ animated: Bool) {
        if let annotations = self.mapView.map.annotations{
            self.mapView.map.removeAnnotations(annotations)
        }
    }
    
    // Button methods
    
    @objc func backButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func expandButtonPressed(){
        UIView.animate(withDuration: 0.3, animations: {
            self.mapView.poolCollectionBottomAnchor?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 0.1, animations: {
                self.mapView.expandArrow.alpha = 0
                self.mapView.expandArrowBackground.alpha = 0
            })
        })
    }
    
    @objc func longPressedOnMap(_ sender: UILongPressGestureRecognizer){
        let location = sender.location(in: self.mapView.map)
        let coordinate = mapView.map.convert(location,toCoordinateFrom: mapView.map)
        
        // Add annotation:
        let annotation = MBPoolAnnotation()
        annotation.coordinate = coordinate
        
        let alert = UIAlertController(title: "Pool Name", message: "Please enter a name for your pool", preferredStyle: .alert)
        
        //2. Add the text field
        alert.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.placeholder = "Pool Name"
            textField.layer.cornerRadius = 5
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create a Pool", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text ?? "Error: No Text Found")")
            if textField.text == nil || textField.text == ""{
                self.impactNotif.notificationOccurred(.error)
                return
            }
            
            annotation.title = textField.text
            PoolRoutes.createPool(name: textField.text!, coords: [annotation.coordinate.latitude, annotation.coordinate.longitude]){pool in
                
                print("POOLTHING")
                print(pool)
                globalPools.append(pool)
                let annotation = MBPoolAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
                annotation.coordinate = coordinate
                let polygon = polygonCircleForCoordinate(coordinate: coordinate, withMeterRadius: Double(self.defaultRadius))
                self.mapView.map.addAnnotation(polygon)
                annotation.title = pool.name
                annotation.subtitle = pool.creator
                annotation.imageName = "CloudCircle"
                annotation.id = pool.poolId
                self.mapView.map.addAnnotation(annotation)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in alert
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

}
