//
//  SearchBarHeaderView.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/3/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UITableViewHeaderFooterView {
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ProfileBlack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barTintColor = UIColor.white
        bar.placeholder = "Conversations"
        
        for subview in bar.subviews  {
            for subSubview in subview.subviews  {
                if let textField = subSubview as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.layer.cornerRadius = 10
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = Colors.nebulaPurple.cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
        
        return bar
    }()
    
    let hideLineTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let hideLineBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let exitSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "BlackX"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(bgView)
        addSubview(exitSearchButton)
        addSubview(profileButton)
        addSubview(searchBar)
        searchBar.addSubview(hideLineTop)
        searchBar.addSubview(hideLineBottom)
        self.backgroundColor = UIColor.white
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var searchBarWidthAnchor: NSLayoutConstraint?
    
    func setConstraints(){
        let buttonHeight = CGFloat(40)
        
        let profileLocation = (UIScreen.main.bounds.width * 0.075)
        
        bgView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bgView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        searchBar.leftAnchor.constraint(equalTo: profileButton.centerXAnchor, constant: profileLocation-5).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        searchBarWidthAnchor = searchBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85)
        searchBarWidthAnchor?.isActive = true
        
        hideLineTop.widthAnchor.constraint(equalTo: searchBar.widthAnchor).isActive = true
        hideLineTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        hideLineTop.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        hideLineTop.leftAnchor.constraint(equalTo: searchBar.leftAnchor).isActive = true
        
        hideLineBottom.widthAnchor.constraint(equalTo: searchBar.widthAnchor).isActive = true
        hideLineBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        hideLineBottom.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        hideLineBottom.leftAnchor.constraint(equalTo: searchBar.leftAnchor).isActive = true
        
        profileButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        profileButton.centerXAnchor.constraint(equalTo: self.leftAnchor, constant: profileLocation).isActive = true
        profileButton.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor).isActive = true
        
        exitSearchButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        exitSearchButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        exitSearchButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        exitSearchButton.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor).isActive = true
        
    }
}
