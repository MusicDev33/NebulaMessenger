//
//  EducationPoolVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/21/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Mapbox

class EducationPoolVC: UIViewController {

    var mapView: EducationPoolView!
    var poolsInArea = [PublicPool]()
    var currentPools = [PublicPool]()
    
    var questions = [TeacherQuestion]()
    
    // Shameless hack because I'm stupid
    var questionHeights = [String:CGFloat]()
    
    let defaultRadius = 30
    
    var didImpact = false
    let lightImpact = UIImpactFeedbackGenerator(style: .light)
    let impactNotif = UINotificationFeedbackGenerator()
    
    // This will probably always just be a global pool
    var testPool = PublicPool(coordinates: [0, 0], poolId: "testpool;;;", name: "Global Pool", creator: "MusicDev", connectionLimit: 1000, usersConnected: [String]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let question = TeacherQuestion(question: "Find the surface area of a pickle (Yes, this question is harder than Question 1).", date: "3/14/19", questionMode: ModKeyMode.multiChoice,
                                       answers: ["A":"I don't know",
                                                 "B":"To get to the other side",
                                                 "C":"I don't know dude",
                                                 "D":"I really don't know",
                                                 "E":"Uhhh...",], correctAnswer: "B", questionNumber: 1, optionalText: "Answer the question!", groupID: "SomeID",
                                                                  open: false)
        
        let question2 = TeacherQuestion(question: " Find the geodesic distance between two tesseracts in a 4th-dimensional non-Euclidean plane, then find the circumference of the subsequent hypersphere (4th-dimensional) with the diameter being the line segment connected by two points.", date: "3/14/19", questionMode: ModKeyMode.multiChoice,
                                       answers: ["A":"I don't know",
                                                 "B":"To get to the other side",
                                                 "C":"I don't know dude",
                                                 "D":"I really don't know",
                                                 "E":"Uhhh...",], correctAnswer: "B", questionNumber: 2, optionalText: "Answer the question!", groupID: "SomeID",
                                                                  open: false)
        
        questions.append(question)
        questions.append(question2)
        
        questionHeights[question.question] = 0
        questionHeights[question2.question] = 0
        
        mapView = EducationPoolView(frame: self.view.frame)
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
        
        self.mapView.normalViewButton.addTarget(self, action: #selector(switchViewButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for pool in globalEducationPools{
            let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
            
            let polygon = polygonCircleForCoordinate(coordinate: coordinate, withMeterRadius: Double(self.defaultRadius))
            self.mapView.map.addAnnotation(polygon)
        }
        
        if !Tutorial.didLearnPools(){
            Alert.basicAlert(on: self, with: "Nebula Pools", message: "Tap and hold anywhere on the map to place a pool. Make sure you're within its radius or you won't be able to chat into it!")
            UserDefaults.standard.set(true, forKey: "learnedPools")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for pool in globalEducationPools{
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
}



extension EducationPoolVC: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: UICollectionView Ext.
extension EducationPoolVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func findSize(text: String, label: UILabel) -> CGRect{
        let constraintRect = CGSize(width: 250, height: 1000)
        return NSString(string: text).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: label.font as Any], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.mapView.poolCollectionView.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        cell.poolNameLabel.text = self.currentPools[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eduVC = EduPoolChatVC()
        eduVC.modalPresentationStyle = .currentContext
        eduVC.poolId = "Id"
        eduVC.poolName = "TESTING"
        eduVC.currentPoolMessages = [TerseMessage]()
        self.present(eduVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! QuestionModule
        cell.questionLabel.text = questions[indexPath.row].question!
        var height: CGFloat = 80
        
        questionHeights[questions[indexPath.row].question] = cell.questionLabel.bounds.height + 15
        
        if questions[indexPath.row].open{
            height = cell.questionLabel.bounds.height + 215
        }else{
            height = cell.questionLabel.bounds.height + 15
        }
        
        return CGSize(width: view.frame.width, height: height)
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
}


// MARK: Mapbox Ext.
extension EducationPoolVC: MGLMapViewDelegate{
    
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
                annotationColor = Colors.nebulaPurple
            default:
                // UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
                // Saving this color for later
                annotationColor = Colors.nebulaBlue
            }
            
            if GlobalUser.subscribedPools.contains(castAnnotation.id){
                annotationBorderColor = UIColor.green.cgColor
                borderWidth = 2.0
            }else{
                annotationBorderColor = UIColor.white.cgColor
                borderWidth = 2.0
            }
            
            if ((castAnnotation.imageName) == nil) {
                print("NOPE")
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
        
        for pool in globalEducationPools{
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
        return Colors.nebulaPurple
    }
    
    // User location
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let userCoord = mapView.userLocation?.coordinate else {return}
        
        // guard statements
        let point = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        
        for pool in globalEducationPools{
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
}


// MARK: Listeners Ext.
extension EducationPoolVC{
    
    @objc func switchViewButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
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
                globalEducationPools.append(pool)
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
