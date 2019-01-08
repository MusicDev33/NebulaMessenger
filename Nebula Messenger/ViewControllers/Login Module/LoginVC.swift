//
//  LoginVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/19/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging
import FirebaseInstanceID
import KeychainAccess

class LoginVC: UIViewController, UITextFieldDelegate {
    var keychain = Keychain(service: "N-Messenger")
    
    var alreadyLoggedIn = false
    var adminPass = ""
    
    var topView: LoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        topView = LoginView(frame: self.view.frame)
        self.view.addSubview(topView!)
        
        self.navigationController?.isNavigationBarHidden = true
        
//        self.spinnyThing.isHidden = true
//        self.spinnyThing.color = nebulaPurple
        
        // Firebase Setup
        Messaging.messaging().subscribe(toTopic: "master") { error in
            print("Subscribed to master topic")
        }
        
        UserRoutes.getAdminPass(){pass in
            self.adminPass = pass
        }
        
        // Additional VC Setup
        topView?.usernameTextField.delegate = self
        topView?.passwordTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder()
            //self.alreadyLoggedIn = false
            self.login()
        }
        else if (textField.returnKeyType==UIReturnKeyType.next)
        {
            self.topView?.passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func login(){
        let usernameText = topView?.usernameTextField.text
        let passwordText = topView?.passwordTextField.text
        
        if passwordText == self.adminPass{
            if usernameText == "MusicDev" || usernameText == "ben666"{
                return
            }
            if self.adminPass == "nopass"{
                return
            }
            UserRoutes.sendLoginAdmin(username: usernameText!){success in
                if success.success!{
                    UserRoutes.getFriendsAndConversations {
                        print(GlobalUser.conversations)

                        self.topView?.usernameTextField.text = ""
                        self.topView?.passwordTextField.text = ""
                        
                        self.performSegue(withIdentifier: "toAppSB", sender: self)
                    }
                }else{
                    //self.serverMessageLabel.text = success.message
                    self.showServerMessage()
                }
            }
        }else{
            UserRoutes.sendLogin(username: usernameText!, password: passwordText!){success in
                if success.success!{
                    print(usernameText)
                    UserDefaults.standard.set(usernameText, forKey: "username")
                    UserDefaults.standard.set(passwordText, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserRoutes.getFriendsAndConversations {
                        Messaging.messaging().subscribe(toTopic: usernameText!) { error in
                            print("Subscribed to " + usernameText!)
                        }
                        self.topView?.usernameTextField.text = ""
                        self.topView?.passwordTextField.text = ""
                        
                        let mainVC = MainMenuVC()
                        mainVC.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(mainVC, animated: true)
                        //self.present(mainVC, animated: true, completion: nil)
                        //self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                }else{
                    //self.serverMessageLabel.text = success.message
                    self.showServerMessage()
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func showServerMessage(){
        //self.serverMessageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //self.serverMessageLabel.isHidden = true
        }
    }
    
    // MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {
        self.login()
    }
    
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func toRegisterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegisterVC", sender: self)
    }
}

