//
//  PhoneNumberRegVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/12/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Contacts

class PhoneNumberRegVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    // Phone Number Register VC
    // That's just in case I have another Phone Number VC somewhere
    
    var descLabel: UILabel?
    var addNumberButton: UIButton?
    var cancelButton: UIButton?
    var numberTextField: UITextField?
    
    // Creating the UI
    func createLabel(){
        descLabel = UILabel()
        descLabel?.translatesAutoresizingMaskIntoConstraints = false
        descLabel?.text = "Adding your phone number will let your contacts know you're on Nebula!"
        descLabel?.font = UIFont.systemFont(ofSize: 16)
        descLabel?.textColor = UIColor.black
        descLabel?.lineBreakMode = .byWordWrapping
        descLabel?.textAlignment = .center
        descLabel?.numberOfLines = 0
        self.view.addSubview(descLabel!)
    }
    
    func createTextField(){
        numberTextField = UITextField()
        numberTextField?.translatesAutoresizingMaskIntoConstraints = false
        numberTextField?.placeholder = "(012) 345-6789"
        numberTextField?.layer.cornerRadius = 8
        numberTextField?.layer.borderWidth = 1
        numberTextField?.layer.borderColor = nebulaBlue.cgColor
        numberTextField?.tintColor = nebulaBlue
        
        numberTextField?.keyboardType = .numberPad
        
        numberTextField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: (numberTextField?.frame.height)!))
        numberTextField?.leftViewMode = .always
        
        numberTextField?.returnKeyType = .continue
        numberTextField?.delegate = self
        
        self.view.addSubview(numberTextField!)
    }
    
    func createButtons(){
        addNumberButton = UIButton(type: .system)
        addNumberButton?.translatesAutoresizingMaskIntoConstraints = false
        addNumberButton?.setTitle("Add Number", for: .normal)
        addNumberButton?.tintColor = nebulaBlue
        
        cancelButton = UIButton(type: .system)
        cancelButton?.translatesAutoresizingMaskIntoConstraints = false
        cancelButton?.setTitle("Add Later", for: .normal)
        cancelButton?.tintColor = nebulaBlue
        
        self.view.addSubview(addNumberButton!)
        self.view.addSubview(cancelButton!)
    }
    
    //Methods - Buttons and stuff
    @objc func tappedOnScreen(){
        self.view.endEditing(true)
    }
    
    @objc func addLaterButtonPressed(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addNumberButtonPressed(){
        // Send to Route
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        self.fetchContacts()
        
        createLabel()
        createTextField()
        createButtons()
        
        createConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.cancelButton?.addTarget(self, action: #selector(addLaterButtonPressed), for: .touchUpInside)
    }
    
    func createConstraints(){
        descLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descLabel?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        descLabel?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        numberTextField?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberTextField?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        numberTextField?.widthAnchor.constraint(equalTo: self.view.widthAnchor,
                                                multiplier: 0.6).isActive = true
        numberTextField?.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        addNumberButton?.topAnchor.constraint(equalTo: (numberTextField?.bottomAnchor)!,
                                              constant: 5).isActive = true
        addNumberButton?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addNumberButton?.widthAnchor.constraint(equalTo: (numberTextField?.widthAnchor)!).isActive = true
        addNumberButton?.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        cancelButton?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cancelButton?.topAnchor.constraint(equalTo: (addNumberButton?.bottomAnchor)!,
                                           constant: 5).isActive = true
        cancelButton?.widthAnchor.constraint(equalTo: (numberTextField?.widthAnchor)!).isActive = true
        cancelButton?.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
    
    // delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Instance")
        print(string)
        print(range.location)
        if range.location > 2 && textField.text?.first != "("{
            if let pIndex = textField.text?.index((textField.text?.startIndex)!, offsetBy: 3){
                textField.text?.insert(")", at: pIndex)
                textField.text?.insert("(", at: (textField.text?.startIndex)!)
            }
        }else if range.location <= 4{
            textField.text = textField.text!.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range:nil)
            textField.text = textField.text!.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
        }
        
        if range.location > 7 && textField.text?.contains("-") == false{
            textField.text?.insert("-", at: (textField.text?.endIndex)!)
        }else if range.location <= 9{
            textField.text = textField.text!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
        }
        return true
    }
}

//Contacts
extension PhoneNumberRegVC{
    private func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) {granted, err in
            if let err = err{
                print("Error!")
                return
            }
            
            if granted{
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: {contact, stopPointer in
                        print(contact.givenName, contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue)
                        //print((contact.phoneNumbers[0].value).value(forKey: "digits") as! String)
                        print("")
                    })
                }catch let err {
                    print("Failed to enumerate contacts:", err)
                }
            }else{
                print("Denied bruh.")
            }
        }
    }
}
