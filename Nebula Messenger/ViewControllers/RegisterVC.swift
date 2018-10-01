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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        do {
            let data = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            let request = RouteUtils.basicJsonRequest(url: url!, method: "POST", data: data)
            
            Alamofire.request(request).responseJSON(completionHandler: { response -> Void in
                
                switch response.result{
                case .success(let Json):
                    let jsonObject = JSON(Json)
                    print(jsonObject)
                    if (jsonObject["success"] == false){
                        print("false")
                    }
                    if (jsonObject["success"] == true){
                        print("true")
                        self.nameField.text = ""
                        self.emailField.text = ""
                        self.usernameField.text = ""
                        self.passField.text = ""
                        //self.confirmPassField.text = ""
                        self.performSegue(withIdentifier: "unwindFromRegister", sender: self)
                    }
                    
                case .failure(_):
                    print("Failed to register.")
                }
            })
        }catch{
            
        }
    }
    
    // MARK: Actions
    @IBAction func registerButtonPress(_ sender: UIButton) {
        sendRegisterRequest()
    }
    

}
