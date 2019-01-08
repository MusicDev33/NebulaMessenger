//
//  RegisterView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = nebulaBlue.cgColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.returnKeyType = .next
        
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = nebulaBlue.cgColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.returnKeyType = .next
        
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = nebulaBlue.cgColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.returnKeyType = .next
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = nebulaBlue.cgColor
        textField.isSecureTextEntry = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.returnKeyType = .go
        
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.tintColor = nebulaBlue
        
        return button
    }()
    
    let toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Already have an account? Tap here.", for: .normal)
        button.tintColor = nebulaBlue
        
        return button
    }()
    
    let spinnyThing: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        
        return actInd
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(toLoginButton)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setConstraints(){
        nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                                   constant: -130).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                               constant: 5).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        usernameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                            constant: 5).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,
                                               constant: 5).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                         constant: 5).isActive = true
        registerButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor).isActive = true
        
        toLoginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toLoginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor).isActive = true
        toLoginButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        toLoginButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor).isActive = true
    }
}
