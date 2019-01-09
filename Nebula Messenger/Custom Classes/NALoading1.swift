//
//  NALoading1.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 1/8/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class NALoading1: UIView {
    let circleViewDiameter = 20
    
    let centerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        view.backgroundColor = nebulaPurple
        view.layer.borderWidth = 10
        view.layer.borderColor = nebulaPurple.cgColor
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        centerView.layer.cornerRadius = CGFloat(circleViewDiameter/2)
        
        addSubview(centerView)
        
        createOuterCircleSegments()
        
        centerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        centerView.widthAnchor.constraint(equalToConstant: CGFloat(circleViewDiameter)).isActive = true
        centerView.heightAnchor.constraint(equalToConstant: CGFloat(circleViewDiameter)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createOuterCircleSegments(){
        let diameter = CGFloat(40)
        let circleX = (0 - (diameter/2) + (self.frame.width/2))
        let circleY = (0 - (diameter/2) + (self.frame.height/2))
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: circleX, y: circleY, width: diameter, height: diameter))
        var segments: [CAShapeLayer] = []
        let segmentAngle: CGFloat = (360 * 0.125) / 360
        
        var amountOfSegments = CGFloat(8)
        
        for i in 0...7 {
            let circleLayer = CAShapeLayer()
            //circleLayer.frame = centerView.bounds
            circleLayer.path = circlePath.cgPath
            
            // start angle is number of segments * the segment angle
            circleLayer.strokeStart = segmentAngle * CGFloat(i)
            
            // end angle is the start plus one segment, minus a little to make a gap
            // you'll have to play with this value to get it to look right at the size you need
            let gapSize: CGFloat = 0.01
            circleLayer.strokeEnd = circleLayer.strokeStart + segmentAngle - gapSize
            
            circleLayer.lineWidth = 3
            circleLayer.strokeColor = nebulaBlue.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            
            let segmentLength = (1/amountOfSegments)*360
            
            let degrees = ((1/amountOfSegments)*CGFloat(i)*360) + (segmentLength/2)
            print("RES")
            print(degrees)
            print(CustomMath.getPathToCircleCenter(degrees: degrees, radius: diameter/2))
            
            let coordRatios = CustomMath.getPathToCircleCenter(degrees: degrees, radius: diameter/2)
            
            
            //Move out animation
            let anim = CABasicAnimation(keyPath: "position")
            anim.fromValue = circleLayer.position
            let oldPos = circleLayer.position
            let newPos = CGPoint(x: circleLayer.position.x + (10*coordRatios[0]),
                                 y: circleLayer.position.y + (10*coordRatios[1]))
            anim.toValue = newPos
            anim.duration = 1.5
            
            let blueToPurpleAnim = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeColor))
            blueToPurpleAnim.fromValue = nebulaBlue.cgColor
            blueToPurpleAnim.toValue = nebulaPurple.cgColor
            blueToPurpleAnim.duration = 1.5
            
            // Return Animation
            let returnAnim = CABasicAnimation(keyPath: "position")
            returnAnim.fromValue = newPos
            returnAnim.toValue = oldPos
            returnAnim.duration = 1.5
            returnAnim.beginTime = 1.5
            
            let purpleToBlueAnim = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeColor))
            purpleToBlueAnim.fromValue = nebulaPurple.cgColor
            purpleToBlueAnim.toValue = nebulaBlue.cgColor
            purpleToBlueAnim.duration = 1.5
            purpleToBlueAnim.beginTime = 1.5
            
            let animGroup = CAAnimationGroup()
            animGroup.animations = [anim,blueToPurpleAnim, returnAnim, purpleToBlueAnim]
            animGroup.duration = 3
            animGroup.repeatCount = MAXFLOAT
            
            circleLayer.add(animGroup, forKey: nil)
            
            if i == 7{
                let purpleToBlueAnim = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.borderColor))
                purpleToBlueAnim.fromValue = nebulaPurple.cgColor
                purpleToBlueAnim.toValue = nebulaBlue.cgColor
                purpleToBlueAnim.duration = 1.5
                
                let blueToPurpleAnim = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.borderColor))
                blueToPurpleAnim.fromValue = nebulaBlue.cgColor
                blueToPurpleAnim.toValue = nebulaPurple.cgColor
                blueToPurpleAnim.duration = 1.5
                blueToPurpleAnim.beginTime = 1.5
                
                let animGroupCV = CAAnimationGroup()
                animGroupCV.animations = [purpleToBlueAnim, blueToPurpleAnim]
                animGroupCV.duration = 3
                animGroupCV.repeatCount = MAXFLOAT
                
                centerView.layer.add(animGroupCV, forKey: nil)
            }
            
            // add the segment to the segments array and to the view
            segments.insert(circleLayer, at: i)
            centerView.layer.addSublayer(segments[i])
        }
    }
}
