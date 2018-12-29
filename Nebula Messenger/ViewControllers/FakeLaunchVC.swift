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
                        
                        self.performSegue(withIdentifier: "launchToMain", sender: self)
                    }
                    
                }else{
                    
                }
            }
        }
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
