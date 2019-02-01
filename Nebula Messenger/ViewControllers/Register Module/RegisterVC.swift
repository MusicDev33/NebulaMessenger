//
//  RegisterVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/19/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class RegisterVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var topView: RegisterView?
    var textFieldArray: [UITextField?]!
    var textFieldIndex = 0
    
    var isAdmin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        topView = RegisterView(frame: self.view.frame)
        self.view.addSubview(topView!)
        
        topView?.nameTextField.delegate = self
        topView?.emailTextField.delegate = self
        topView?.usernameTextField.delegate = self
        topView?.passwordTextField.delegate = self
        
        textFieldArray = [topView?.nameTextField, topView?.emailTextField,
                          topView?.usernameTextField, topView?.passwordTextField]
        
        topView?.toLoginButton.addTarget(self, action: #selector(backToLoginPressed), for: .touchUpInside)
        topView?.registerButton.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen(_:)))
        tap.delegate = self
        topView?.addGestureRecognizer(tap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backToLoginPressed))
        swipeLeft.direction = .right
        swipeLeft.delegate = self
        topView?.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        swipeUp.delegate = self
        topView?.addGestureRecognizer(swipeUp)
    }
    
    // MARK: Route Functions
    func sendRegisterRequest(){
        var requestJson = [String:Any]()
        let url = URL(string: registerUserRoute)
        // This is in an array just in case several devices are logged into one account
        requestJson["registrationTokens"] = [FirebaseGlobals.globalDeviceToken]
        requestJson["name"] = topView?.nameTextField.text!
        requestJson["email"] = topView?.emailTextField.text!
        requestJson["username"] = topView?.usernameTextField.text!
        requestJson["password"] = topView?.passwordTextField.text!
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    if (jsonObject["success"] == false){
                        
                        //self.serverMessageLabel.text = jsonObject["msg"].string ?? "Registration failed."
                        self.showServerMessage()
                        
                        print("false")
                    }
                    if (jsonObject["success"] == true){
                        print("true")
                        self.topView?.nameTextField.text! = ""
                        self.topView?.emailTextField.text! = ""
                        self.topView?.usernameTextField.text! = ""
                        self.topView?.passwordTextField.text! = ""
                        //self.confirmPassField.text = ""
                        let phoneNoVC = PhoneNumberRegVC()
                        self.navigationController?.pushViewController(phoneNoVC, animated: true)
                        //self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(_):
                    //self.serverMessageLabel.text = "Registration failed."
                    self.showServerMessage()
                    
                    print("Failed to register.")
                }
            })
        }catch{
            
        }
    }
    
    func showServerMessage(){
        //self.serverMessageLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //self.serverMessageLabel.isHidden = true
        }
    }
    
    // MARK: Actions
    @objc func registerButtonPress() {
        sendRegisterRequest()
    }
    
    @objc func tappedOnScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func backToLoginPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func swipedUp(){
        isAdmin = true
        print("Is Admin")
    }
    
    //just gonna toss these delegate methods down here
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField.returnKeyType==UIReturnKeyType.go){
            textField.resignFirstResponder()
            //self.alreadyLoggedIn = false
            self.registerButtonPress()
        }
        else if (textField.returnKeyType==UIReturnKeyType.next){
            self.textFieldIndex += 1
            self.textFieldArray[textFieldIndex]?.becomeFirstResponder()
            
            if self.textFieldIndex >= 3{
                self.textFieldIndex = 0
            }
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            if isAdmin{
                let alert = UIAlertController(title: "Super Secret Admin Tool!", message: "If you found this, good job! This probably isn't meant for you, but it's cool to play around with.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Create Test User", style: .default, handler: {action in
                    self.topView?.nameTextField.text = "Test User"
                    self.topView?.emailTextField.text = "bill@boosh.com"
                    self.topView?.usernameTextField.text = "test99"
                    self.topView?.passwordTextField.text = "password"
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
