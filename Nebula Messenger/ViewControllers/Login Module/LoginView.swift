//
//  LoginView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/7/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = nebulaPurple.cgColor
        
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
        textField.layer.borderColor = nebulaPurple.cgColor
        textField.isSecureTextEntry = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.returnKeyType = .go
        
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        
        return button
    }()
    
    let toRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Don't have an account? Tap here.", for: .normal)
        
        return button
    }()
    
    let spinnyThing: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        
        return actInd
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setConstraints(){
        usernameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                                   constant: -90).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,
                                                   constant: 5).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                               constant: 5).isActive = true
        loginButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor).isActive = true
    }
}
