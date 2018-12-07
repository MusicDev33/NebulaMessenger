//
//  AlertBP.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 12/2/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    static func basicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I'm sorry...", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    // If I ever need functions
    static func showActionAlert(_ title: String, message: String,
                                actionTitle: String,
                                viewController: UIViewController,
                                actionHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                dismissHandler: ((UIAlertAction) -> Swift.Void)? = nil){
        // .............................................................................
        
    }
}
