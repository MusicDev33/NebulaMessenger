//
//  MessengerBaseViewProto.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 3/10/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

protocol DefaultMessengerUI {
    
    var screenSizeX: CGFloat { get }
    var textViewMaxLines: CGFloat { get }
    var hasMoved: Bool { get set }
    
    var navBar: UIView { get }
    var topLine: UIView { get }
    
    var backButton: UIButton { get }
    var trashButton: UIButton { get }
    var involvedLabel: UILabel { get }
    
    var bottomBarActionButton: UIButton { get }
    var pulsatingLayer: CAShapeLayer { get }
}

extension DefaultMessengerUI where Self: UIView {
    
    var screenSizeX: CGFloat { return UIScreen.main.bounds.size.width }
    var textViewMaxLines: CGFloat { return 6 }
    
    var navBar: UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 239/255, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }
    
    var topLine: UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }
    
    
    var backButton: UIButton {
        let button = UIButton()
        if let image = UIImage(named: "BackArrowBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    var trashButton: UIButton {
        let button = UIButton()
        if let image = UIImage(named: "Trashcan") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    var involvedLabel: UILabel {
        let label = UILabel()
        label.text = "Users"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    var bottomBarActionButton: UIButton {
        let button = UIButton()
        if let image = UIImage(named: "FullscreenBlack") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.alpha = 0
        return button
    }
    
    //For animation
    var pulsatingLayer: CAShapeLayer {
        let layer = CAShapeLayer()
        // Here we add half of the button's width to the circle's center to get it to center on the button
        let point = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 25+(UIScreen.main.bounds.size.height/20))
        let circlePath = UIBezierPath(arcCenter: .zero, radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let bgColor = nebulaPurple.withAlphaComponent(0.0)
        layer.path = circlePath.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 10
        layer.fillColor = bgColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = point
        return layer
    }
}
