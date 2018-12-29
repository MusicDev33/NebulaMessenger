//
//  MyProfileVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class MyProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // I honestly have no idea why this says textview...
    @IBOutlet weak var yourTextView: UICollectionView!
    @IBOutlet weak var otherTextView: UICollectionView!
    
    var selectedUserColor: IndexPath!
    var selectedOtherColor: IndexPath!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        cell.colorImg.backgroundColor = globalColors[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.indexPathsForVisibleItems.forEach({item in
            if let cell = collectionView.cellForItem(at: item) as? ColorCell{
                cell.selectedImg.backgroundColor = UIColor.clear
            }
        })
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell{
            cell.selectedImg.backgroundColor = UIColor.white
            if collectionView == self.yourTextView{
                UserDefaults.standard.set(colorsList[indexPath.row], forKey: "userTextColor")
                userTextColor = colorsDict[colorsList[indexPath.row]] ?? nebulaPurple
                selectedUserColor = indexPath
            }else{
                UserDefaults.standard.set(colorsList[indexPath.row], forKey: "otherTextColor")
                otherTextColor = colorsDict[colorsList[indexPath.row]] ?? nebulaBlue
                selectedOtherColor = indexPath
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userColorIndex = globalColors.firstIndex(of: userTextColor)
        let otherColorIndex = globalColors.firstIndex(of: otherTextColor)
        
        self.yourTextView.selectItem(at: IndexPath(row: userColorIndex ?? 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        
        self.collectionView(self.yourTextView, didSelectItemAt: IndexPath(row: userColorIndex ?? 0, section: 0))
        
        self.otherTextView.selectItem(at: IndexPath(row: otherColorIndex ?? 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        self.collectionView(self.otherTextView, didSelectItemAt: IndexPath(row: otherColorIndex ?? 0, section: 0))
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            Messaging.messaging().unsubscribe(fromTopic: GlobalUser.username)
            GlobalUser.emptyGlobals()
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "password")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "toLoginFromMainSB", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromProfile", sender: self)
    }
    
    
    // MARK: - Navigation
    
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
