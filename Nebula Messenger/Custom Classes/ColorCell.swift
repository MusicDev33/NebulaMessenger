//
//  ColorCell.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

class ColorCell: UICollectionViewCell{
    
    let colorImg: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.nebulaFlame
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var random = ""
    
    let selectedImg: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    func setAsColor(){
        selectedImg.backgroundColor = UIColor.white
    }
    
    func unsetAsColor(){
        selectedImg.backgroundColor = UIColor.clear
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.setAsColor()
            }
            else
            {
                self.unsetAsColor()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(colorImg)
        addSubview(selectedImg)
        
        colorImgRightAnchor = colorImg.rightAnchor.constraint(equalTo: self.rightAnchor)
        colorImgRightAnchor?.isActive = true
        colorImg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        colorImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorImg.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        selectedImg.rightAnchor.constraint(equalTo: colorImg.rightAnchor, constant: -15).isActive = true
        selectedImg.topAnchor.constraint(equalTo: colorImg.topAnchor, constant: 15).isActive = true
        
        selectedImg.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selectedImg.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    var colorImgRightAnchor: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(colorImg)
        addSubview(selectedImg)
        
        colorImgRightAnchor = colorImg.rightAnchor.constraint(equalTo: self.rightAnchor)
        colorImgRightAnchor?.isActive = true
        colorImg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        colorImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorImg.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        selectedImg.rightAnchor.constraint(equalTo: colorImg.rightAnchor, constant: -15).isActive = true
        selectedImg.topAnchor.constraint(equalTo: colorImg.topAnchor, constant: 15).isActive = true
        
        selectedImg.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selectedImg.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
}
