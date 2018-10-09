//
//  RegisterVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/19/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class RegisterVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var toLoginButton: UIButton!
    
    @IBOutlet weak var spinnyThing: UIActivityIndicatorView!
    @IBOutlet weak var serverMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButtonOutlet.backgroundColor = nebulaBlue
        registerButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        registerButtonOutlet.layer.cornerRadius = 12
        
        toLoginButton.backgroundColor = .clear
        toLoginButton.layer.cornerRadius = 12
        toLoginButton.layer.borderWidth = 1
        toLoginButton.layer.borderColor = borderColorOne.cgColor
        
        self.spinnyThing.color = nebulaPurple
    }
    
    // MARK: Route Functions
    func sendRegisterRequest(){
        var requestJson = [String:Any]()
        let url = URL(string: registerUserRoute)
        // This is in an array just in case several devices are logged into one account
        requestJson["registrationTokens"] = [FirebaseGlobals.globalDeviceToken]
        requestJson["name"] = nameField.text!
        requestJson["email"] = emailField.text!
        requestJson["username"] = usernameField.text!
        requestJson["password"] = passField.text!
        
        registerButtonOutlet.isHidden = true
        toLoginButton.isHidden = true
        spinnyThing.isHidden = false
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    if (jsonObject["success"] == false){
                        self.registerButtonOutlet.isHidden = false
                        self.toLoginButton.isHidden = false
                        self.spinnyThing.isHidden = true
                        
                        self.serverMessageLabel.text = jsonObject["msg"].string ?? "Registration failed."
                        self.showServerMessage()
                        
                        print("false")
                    }
                    if (jsonObject["success"] == true){
                        print("true")
                        self.nameField.text = ""
                        self.emailField.text = ""
                        self.usernameField.text = ""
                        self.passField.text = ""
                        //self.confirmPassField.text = ""
                        self.registerButtonOutlet.isHidden = false
                        self.toLoginButton.isHidden = false
                        self.spinnyThing.isHidden = true
                        self.performSegue(withIdentifier: "unwindFromRegister", sender: self)
                    }
                    
                case .failure(_):
                    self.registerButtonOutlet.isHidden = false
                    self.toLoginButton.isHidden = false
                    self.spinnyThing.isHidden = true
                    
                    self.serverMessageLabel.text = "Registration failed."
                    self.showServerMessage()
                    
                    print("Failed to register.")
                }
            })
        }catch{
            
        }
    }
    
    func showServerMessage(){
        self.serverMessageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.serverMessageLabel.isHidden = true
        }
    }
    
    // MARK: Actions
    @IBAction func registerButtonPress(_ sender: UIButton) {
        sendRegisterRequest()
    }
    
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func backToLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromRegister", sender: self)
    }
    

}
