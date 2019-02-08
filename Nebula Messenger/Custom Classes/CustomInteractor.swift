//
//  CustomInteractor.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class CustomInteractor : UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    // TODO: Figure out wtf this means
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
        } else {
            return nil
        }
    }
}
