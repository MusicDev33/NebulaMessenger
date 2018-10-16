//
//  PoolingVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PoolingVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 250
    let defaultRadius = 50
    var shouldCenter = true
    
    var panRec: UIPanGestureRecognizer!
    
    var poolsInArea = [PublicPool]()
    var currentPools = [PublicPool]()
    
    @IBOutlet weak var segmentedTabs: UISegmentedControl!
    
    var poolTable: UICollectionView!
    
    var passPoolId = ""
    var passPoolMessages = [TerseMessage]()
    
    var testPool = PublicPool(coordinates: [0, 0], poolId: "testpool;;;", name: "Test Pool", creator: "MusicDev", connectionLimit: 50, usersConnected: [String]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        currentPools.append(self.testPool)
        
        self.mapView.tintColor = nebulaPurple
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true;
        self.mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        panRec = UIPanGestureRecognizer(target: self, action: #selector(draggedMap(gesture:)))
        panRec.delegate = self
        self.mapView.addGestureRecognizer(panRec)

        // Do any additional setup after loading the view.
        PoolRoutes.getPools(){pools in
            for pool in pools{
                self.poolsInArea.append(pool)
                let annotation = PoolAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: pool.coordinates![0], longitude: pool.coordinates![1])
                annotation.coordinate = coordinate
                let circle = MKCircle(center: coordinate, radius: CLLocationDistance(self.defaultRadius))
                self.mapView.addOverlay(circle)
                annotation.title = pool.name
                annotation.imageName = "CloudCircle"
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    @objc func draggedMap(gesture: UIPanGestureRecognizer){
        if (gesture.state == UIGestureRecognizer.State.ended){
            self.shouldCenter = false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}
        
        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.3
        return circleRenderer
    }
    
    //Map Functions
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        let point = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        if self.shouldCenter{
            self.centerMapOnLocation(location: point)
        }
        for pool in self.poolsInArea{
            let poolCenter = CLLocation(latitude: pool.coordinates?[0] ?? 0, longitude: pool.coordinates?[1] ?? 0)
            if point.distance(from: poolCenter) < CLLocationDistance(self.defaultRadius+1) {
                if !currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools.append(pool)
                    print(pool.poolId!)
                }
            }else{
                if currentPools.contains(where: { $0.poolId == pool.poolId}){
                    currentPools = currentPools.filter {$0.poolId != pool.poolId}
                    print(currentPools)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        if !(annotation is PoolAnnotation) {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "PoolAnnotation"
        
        var annotationView: MKAnnotationView?
        
        let poolAnnotation = annotation as! PoolAnnotation
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: poolAnnotation.imageName)
            annotationView.tintColor = nebulaPurple
        }
        return annotationView
    }
    
    // Set up the Pool Table (Funny joke haha)
    func setupPoolTable(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 50)
        layout.scrollDirection = .vertical
        
        let poolTableFrame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height-100)
        
        self.poolTable = UICollectionView(frame: poolTableFrame, collectionViewLayout: layout)
        self.poolTable.delegate = self
        self.poolTable.dataSource = self
        self.poolTable.isUserInteractionEnabled = true
        self.poolTable.allowsSelection = true
        self.poolTable.alwaysBounceVertical = true
        poolTable.register(PoolChatCell.self, forCellWithReuseIdentifier: "poolCell")
        poolTable.backgroundColor = UIColor.white
        self.view.addSubview(poolTable)
        self.view.bringSubviewToFront(poolTable)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentPools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.poolTable.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        cell.poolNameLabel.text = self.currentPools[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = self.poolTable.dequeueReusableCell(withReuseIdentifier: "poolCell",for: indexPath) as! PoolChatCell
        self.passPoolId = self.currentPools[indexPath.row].poolId ?? ""
        PoolRoutes.getPoolMessages(id: self.passPoolId){messagesList in
            self.passPoolMessages = messagesList
            self.performSegue(withIdentifier: "toPoolChat", sender: self)
        }
    }
    
    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToMainMenuFromPools", sender: self)
    }
    
    @IBAction func longPressedOnMap(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let alert = UIAlertController(title: "Pool Name", message: "Please enter a name for your pool", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
            textField.placeholder = "Pool Name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Create a Pool", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text ?? "Error: No Text Found")")
            annotation.title = textField.text
            PoolRoutes.createPool(name: textField.text!, coords: [annotation.coordinate.latitude, annotation.coordinate.longitude]){
                
                let coordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                
                let circle = MKCircle(center: coordinate, radius: CLLocationDistance(self.defaultRadius))
                self.mapView.addOverlay(circle)
                self.mapView.addAnnotation(annotation)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in alert
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //Set up pool view table
    
    @IBAction func pressedOnSegment(_ sender: UISegmentedControl) {
        switch segmentedTabs.selectedSegmentIndex{
        case 0:
            self.mapView.isHidden = false
            if (self.poolTable != nil){
                self.poolTable.isHidden = true
            }
        case 1:
            self.mapView.isHidden = true
            if (self.poolTable == nil){
                self.setupPoolTable()
                self.poolTable.reloadData()
            }else{
                self.poolTable.reloadData()
                self.poolTable.isHidden = false
            }
        default:
            print("Something happened")
        }
    }
    
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToMainMenuFromPools", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.destination is PoolChatVC{
            let vc = segue.destination as? PoolChatVC
            vc?.poolId = passPoolId
            vc?.currentPoolMessages = self.passPoolMessages
        }
    }
    
    @IBAction func didUnwindFromPoolChat(_ sender: UIStoryboardSegue){
        guard sender.source is PoolChatVC else {return}
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            let alert = UIAlertController(title: "Shake Feedback", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Give Feedback", style: .default, handler: {action in
                let feedbackVC = FeedbackVC()
                feedbackVC.modalPresentationStyle = .overCurrentContext
                self.present(feedbackVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
