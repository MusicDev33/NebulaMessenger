//
//  MessengerBaseVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/27/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire

class MessengerBaseVC: UIViewController {
    
    var msgList = [TerseMessage]()
    
    // PoolId or ConvId
    var id = ""
    
    // Pool name or name of actual conversation
    var conversationName = ""
    
    var modularKeyboard: ModularKeyboard!
    var keyboardIsUp = false
    var bottomPadding: CGFloat!
    var topPadding: CGFloat!
    
    var topView: MessengerBaseView!
    
    var messagesCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        modularKeyboard = ModularKeyboard(frame: self.view.frame, view: self.view)
        self.view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 1)
        
        topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}

// Keyboard Notifs N' Stuff
extension MessengerBaseVC{
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        if !self.keyboardIsUp{
            self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: keyboardSize.height+12-bottomPadding, right: 0)
            self.scrollToBottom(animated: true)
            UIView.animate(withDuration: keyboardDuration){
                self.view.layoutIfNeeded()
            }
            
            let safeAreaBottomInset = self.view.safeAreaInsets.bottom
            
            modularKeyboard.moveWithKeyboard(yValue: keyboardSize.height - safeAreaBottomInset, duration: keyboardDuration)
        }
        self.keyboardIsUp = true
    }
    
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration: Double = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        if self.keyboardIsUp{
            self.messagesCollection.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
            UIView.animate(withDuration: keyboardDuration){
                self.view.layoutIfNeeded()
            }
            modularKeyboard.resetBottomBar(){
                self.topView.bottomBarActionButton.isHidden = true
            }
        }
        self.keyboardIsUp = false
    }
}


// MARK: VC Functions
extension MessengerBaseVC {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            self.messagesCollection.layoutIfNeeded()
            let scrollToY = self.messagesCollection.contentSize.height - self.messagesCollection.frame.height + 12
            let cInset = self.messagesCollection.contentInset.bottom
            
            let contentPoint = CGPoint(x: 0, y: scrollToY + cInset)
            self.messagesCollection.setContentOffset(contentPoint, animated: animated)
        }
    }
}
