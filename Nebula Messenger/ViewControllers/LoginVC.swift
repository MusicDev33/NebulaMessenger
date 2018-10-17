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
import KeychainAccess

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var goToRegisterButton: UIButton!
    @IBOutlet weak var serverMessageLabel: UILabel!
    
    @IBOutlet weak var spinnyThing: UIActivityIndicatorView!
    var keychain = Keychain(service: "N-Messenger")
    
    var alreadyLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButtonOutlet.backgroundColor = nebulaPurple
        loginButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        loginButtonOutlet.layer.cornerRadius = 12
        
        goToRegisterButton.backgroundColor = .clear
        goToRegisterButton.layer.cornerRadius = 12
        goToRegisterButton.layer.borderWidth = 1
        goToRegisterButton.layer.borderColor = borderColorOne.cgColor
        
        self.spinnyThing.isHidden = true
        self.spinnyThing.color = nebulaPurple
        
        // Firebase Setup
        Messaging.messaging().subscribe(toTopic: "master") { error in
            print("Subscribed to master topic")
        }
        
        // Additional VC Setup
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        alreadyLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if alreadyLoggedIn{
            let username = UserDefaults.standard.string(forKey: "username") ?? ""
            let password = UserDefaults.standard.string(forKey: "password") ?? ""
            RouteLogic.sendLogin(username: username, password: password){success in
                if success.success!{
                    RouteLogic.getFriendsAndConversations {
                        print(GlobalUser.conversations)
                        Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
                            print("Subscribed to " + GlobalUser.username)
                        }
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        
                        self.spinnyThing.isHidden = true
                        self.loginButtonOutlet.isHidden = false
                        self.goToRegisterButton.isHidden = false
                        
                        self.performSegue(withIdentifier: "toMainMenuVC", sender: self)
                    }
                    
                }else{
                    self.serverMessageLabel.text = success.message
                    self.showServerMessage()
                    self.alreadyLoggedIn = false
                }
            }
        }
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
            self.passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func login(){
        let usernameText = usernameTextField.text
        let passwordText = passwordTextField.text
        
        self.spinnyThing.isHidden = false
        self.loginButtonOutlet.isHidden = true
        self.goToRegisterButton.isHidden = true
        
        RouteLogic.sendLogin(username: usernameText!, password: passwordText!){success in
            if success.success!{
                UserDefaults.standard.set(usernameText, forKey: "username")
                UserDefaults.standard.set(passwordText, forKey: "password")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                RouteLogic.getFriendsAndConversations {
                    print(GlobalUser.conversations)
                    Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
                        print("Subscribed to " + GlobalUser.username)
                    }
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.spinnyThing.isHidden = true
                    self.loginButtonOutlet.isHidden = false
                    self.goToRegisterButton.isHidden = false
                    
                    self.performSegue(withIdentifier: "toMainMenuVC", sender: self)
                }
//                RouteLogic.getConversations {
//                    print(GlobalUser.conversations)
//                    Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
//                        print("Subscribed to " + GlobalUser.username)
//                    }
//                    self.usernameTextField.text = ""
//                    self.passwordTextField.text = ""
//
//                    self.spinnyThing.isHidden = true
//                    self.loginButtonOutlet.isHidden = false
//                    self.goToRegisterButton.isHidden = false
//
//                    self.performSegue(withIdentifier: "toMainMenuVC", sender: self)
//                }
            }else{
                self.serverMessageLabel.text = success.message
                self.showServerMessage()
                
                self.spinnyThing.isHidden = true
                self.loginButtonOutlet.isHidden = false
                self.goToRegisterButton.isHidden = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func showServerMessage(){
        self.serverMessageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.serverMessageLabel.isHidden = true
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
    
    // MARK: Navigation
    @IBAction func didUnwindFromRegister(_ sender: UIStoryboardSegue){
        guard sender.source is RegisterVC else {return}
    }
    
    @IBAction func didUnwindFromProfileViewToLogin(_ sender: UIStoryboardSegue){
        guard sender.source is MyProfileVC else {return}
    }
}

