//
//  FeedbackVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController, UITextViewDelegate {
    
    var textView: UITextView!
    var feedbackButton: UIButton!
    
    var feedbackMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        createTextField()
        createFeedbackButton()
        createExitButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
    @objc func buttonAction(){
        if textView.text.count > 0{
            let optionalString = "Feedback Screen"
            DiagnosticRoutes.sendInfo(info: textView.text, optional: optionalString)
            self.dismiss(animated: true){
                
            }
        }
    }
    
    @objc func exitView(){
        self.dismiss(animated: true){
            
        }
    }
    
    //Create UI
    func createTextField(){
        let txtWidth = view.frame.width*0.66
        let txtHeight = view.frame.height*0.7
        let txtX = (view.frame.width/2)-(txtWidth/2)
        let txtY = (view.frame.height/2)-(txtHeight/2)
        textView = UITextView(frame: CGRect(x: txtX, y: txtY, width: txtWidth, height: txtHeight-30))
        textView.delegate = self
        textView.text = "Type in your feedback here. We appreciate it!"
        textView.textColor = UIColor.lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10.0
        textView.textAlignment = NSTextAlignment.left
        textView.backgroundColor = UIColor.white
        
        self.view.addSubview(textView)
    }
    
    func createFeedbackButton(){
        let buttonWidth = CGFloat(floatLiteral: 100.0)
        let buttonHeight = CGFloat(floatLiteral: 30)
        let buttonX = (view.frame.width/2)-(buttonWidth/2)
        let buttonY = textView.frame.origin.y + textView.frame.height + 30
        let button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = nebulaPurple
        button.layer.cornerRadius = 10
        button.setTitle("Send Feedback", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func createExitButton(){
        let exitButtonWidth = CGFloat(48)
        let exitButtonHeight = CGFloat(48)
        let exitButtonX = (view.frame.width/2)-(exitButtonWidth/2)
        let exitButtonY = textView.frame.origin.y - exitButtonHeight - 20
        let exitButton = UIButton(frame: CGRect(x: exitButtonX, y: exitButtonY, width: exitButtonWidth, height: exitButtonHeight))
        exitButton.setImage(UIImage(named: "BlackX"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitView), for: .touchUpInside)
        
        view.addSubview(exitButton)
    }
    
    // MARK: Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type in your feedback here. We appreciate it!"
            textView.textColor = UIColor.lightGray
        }
    }
}
