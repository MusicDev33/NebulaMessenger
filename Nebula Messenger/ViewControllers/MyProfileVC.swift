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
    
    @IBOutlet weak var yourTextView: UICollectionView!
    @IBOutlet weak var otherTextView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        cell.colorImg.backgroundColor = globalColors[indexPath.row]
        if collectionView == self.yourTextView{
            if globalColors[indexPath.row] == userTextColor{
                cell.selectedImg.backgroundColor = UIColor.white
            }
        }else{
            if globalColors[indexPath.row] == otherTextColor{
                cell.selectedImg.backgroundColor = UIColor.white
            }
        }
        
        
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
            }else{
                UserDefaults.standard.set(colorsList[indexPath.row], forKey: "otherTextColor")
                otherTextColor = colorsDict[colorsList[indexPath.row]] ?? nebulaBlue
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            Messaging.messaging().unsubscribe(fromTopic: GlobalUser.username)
            GlobalUser.emptyGlobals()
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "password")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "toLoginFromProfileView", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromProfile", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
