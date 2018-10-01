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
    
    
    var keychain = Keychain(service: "N-Messenger")
    
    var alreadyLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                if success{
                    RouteLogic.getConversations {
                        Messaging.messaging().subscribe(toTopic: GlobalUser.username) { error in
                            print("Subscribed to " + GlobalUser.username)
                        }
                        self.performSegue(withIdentifier: "toMainMenuVC", sender: self)
                    }
                }else{
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
            //self.logIn()
        }
        else if (textField.returnKeyType==UIReturnKeyType.next)
        {
            self.passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {
        let usernameText = usernameTextField.text
        let passwordText = passwordTextField.text
        RouteLogic.sendLogin(username: usernameText!, password: passwordText!){success in
            if success{
                UserDefaults.standard.set(usernameText, forKey: "username")
                UserDefaults.standard.set(passwordText, forKey: "password")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                RouteLogic.getConversations {
                    print(GlobalUser.conversations)
                    self.performSegue(withIdentifier: "toMainMenuVC", sender: self)
                }
            }
        }
    }
    
    @IBAction func toRegisterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegisterVC", sender: self)
    }
    
    // MARK: Navigation
    @IBAction func didUnwindFromRegister(_ sender: UIStoryboardSegue){
        guard sender.source is RegisterVC else {return}
    }
}

