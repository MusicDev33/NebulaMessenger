//
//  FakeLaunchVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 12/28/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import FirebaseMessaging

class FakeLaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = UIColor.white
        
        let quoteLabel = UILabel()
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.textColor = UIColor.black
        quoteLabel.font = UIFont.systemFont(ofSize: 18)
        
        if UserDefaults.standard.stringArray(forKey: "quotesArray") != nil{
            let quotes = UserDefaults.standard.stringArray(forKey: "quotesArray")
            print(quotes)
            let quote = quotes?.randomElement()
            quoteLabel.text = quote
        }
        
        UserRoutes.getQuotes(completion: { quotes in
            UserDefaults.standard.set(quotes, forKey: "quotesArray")
        })
        
        let nebulaImg = UIImageView(image: UIImage(named: "Logo"))
        nebulaImg.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.view.addSubview(nebulaImg)
        self.view.addSubview(quoteLabel)
        
        nebulaImg.widthAnchor.constraint(equalToConstant: 160).isActive = true
        nebulaImg.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        nebulaImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nebulaImg.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        quoteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        quoteLabel.topAnchor.constraint(equalTo: nebulaImg.bottomAnchor, constant: 50).isActive = true

        let alreadyLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if alreadyLoggedIn{
            let username = UserDefaults.standard.string(forKey: "username") ?? ""
            let password = UserDefaults.standard.string(forKey: "password") ?? ""
            
            UserRoutes.sendLogin(username: username, password: password){success in
                if success.success!{
                    UserRoutes.getFriendsAndConversations {
                        Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
                            print("Subscribed to " + GlobalUser.username)
                        }
                        let mainVC = MainMenuVC()
                        mainVC.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(mainVC, animated: true)
                        //self.present(mainVC, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "launchToMain", sender: self)
                    }
                    
                }else{
                    Alert.basicAlert(on: self, with: "Connection Failed", message: "Couldn't connect to the server.")
                }
            }
        }
    }
}
