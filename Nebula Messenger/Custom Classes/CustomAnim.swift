//
//  CustomAnim.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class CustomAnim : NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var isPresenting : Bool
    
    enum NavType {
        case fromLeft
        case fromRight
    }
    
    var direction: NavType
    
    init(duration : TimeInterval, isPresenting : Bool, direction: NavType) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.direction = direction
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let detailView = isPresenting ? toView : fromView
        
        switch self.direction {
        case .fromRight:
            toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        case .fromLeft:
            toView.frame = isPresenting ?  toView.frame : CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        }
        
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
}
