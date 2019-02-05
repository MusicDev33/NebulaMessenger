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
        navigationItem.hidesBackButton = true
        
        self.view.backgroundColor = UIColor.white
        
        let quoteLabel = UILabel()
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.textColor = UIColor.black
        quoteLabel.font = UIFont.systemFont(ofSize: 18)
        quoteLabel.numberOfLines = 0
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.textAlignment = .center
        
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
        
        nebulaImg.widthAnchor.constraint(equalToConstant: 180).isActive = true
        nebulaImg.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        nebulaImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nebulaImg.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        quoteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        quoteLabel.topAnchor.constraint(equalTo: nebulaImg.bottomAnchor, constant: 50).isActive = true
        
        quoteLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true

        let alreadyLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if alreadyLoggedIn{
            let username = UserDefaults.standard.string(forKey: "username") ?? ""
            let password = UserDefaults.standard.string(forKey: "password") ?? ""
            
            let mainVC = MainMenuVC()
            
            UserRoutes.sendLogin(username: username, password: password){success in
                if success.success!{
                    UserRoutes.getFriendsAndConversations {
                        Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
                            print("Subscribed to " + GlobalUser.username)
                            
                            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                            let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
                            
                            // appVersion and buildNumber both exist for sure
                            UserRoutes.getIfCurrent(version: appVersion!,
                                                    build: Int(buildNumber!)!){ message in
                                if message == ""{
                                    
                                }else{
                                    if GlobalUser.username != "MusicDev"{
                                        mainVC.outdated = true
                                    }
                                }
                                                        
                                PoolRoutes.getPools(completion: {pools in
                                    globalPools = pools
                                    mainVC.modalPresentationStyle = .overCurrentContext
                                    self.navigationController?.pushViewController(mainVC, animated: true)
                                })
                            }
                        }
                    }
                }else{
                    Alert.basicAlert(on: self, with: "Connection Failed", message: "Couldn't connect to the server.")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
