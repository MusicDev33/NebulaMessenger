//
//  CustomAnim.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

enum NavType {
    case fromLeft
    case fromRight
    case toRight
    case toLeft
}

class CustomAnim : NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var isPresenting : Bool
    
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
        case .fromLeft:
            toView.frame = isPresenting ?  CGRect(x: -fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        case .fromRight:
            toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        case .toLeft:
            toView.frame = isPresenting ?  toView.frame : CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        case .toRight:
            toView.frame = isPresenting ?  toView.frame : CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        }
        
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            switch self.direction {
            case .fromLeft:
                detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            case .fromRight:
                detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            case .toLeft:
                detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            case .toRight:
                detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            }
            
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
}
