//
//  MyProfileVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class MyProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var selectedUserColor: IndexPath!
    var selectedOtherColor: IndexPath!
    
    var topView: ProfileView?
    
    var userColorsOpen = false
    var otherColorsOpen = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorSquare", for: indexPath) as! ColorCell
        cell.colorImg.backgroundColor = globalColors[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.indexPathsForVisibleItems.forEach({item in
            if let cell = collectionView.cellForItem(at: item) as? ColorCell{
                cell.selectedImg.backgroundColor = UIColor.clear
            }
        })
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell{
            cell.selectedImg.backgroundColor = UIColor.white
            
            if collectionView == self.topView?.otherColorCollectionView{
                UserDefaults.standard.set(colorsList[indexPath.row], forKey: "otherTextColor")
                otherTextColor = colorsDict[colorsList[indexPath.row]] ?? nebulaBlue
                selectedOtherColor = indexPath
                topView?.otherColorView.backgroundColor = cell.colorImg.backgroundColor
            }else{
                UserDefaults.standard.set(colorsList[indexPath.row], forKey: "userTextColor")
                userTextColor = colorsDict[colorsList[indexPath.row]] ?? nebulaPurple
                selectedUserColor = indexPath
                topView?.personalColorView.backgroundColor = cell.colorImg.backgroundColor
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        topView = ProfileView(frame: self.view.frame)
        //CV
        topView?.selfColorCollectionView.delegate = self
        topView?.selfColorCollectionView.dataSource = self
        topView?.otherColorCollectionView.delegate = self
        topView?.otherColorCollectionView.dataSource = self
        self.view.addSubview(topView!)
        
        topView?.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        topView?.logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(personalViewTapped))
        tap1.delegate = self
        topView?.personalColorView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(otherViewTapped))
        tap2.delegate = self
        topView?.otherColorView.addGestureRecognizer(tap2)
        
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(draggedPersonalColorView(_:)))
        pan1.delegate = self
        topView?.personalColorView.addGestureRecognizer(pan1)
        
        topView?.selfColorCollectionView.reloadData()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        topView?.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userColorIndex = globalColors.firstIndex(of: userTextColor)
        let otherColorIndex = globalColors.firstIndex(of: otherTextColor)
        
        self.topView?.selfColorCollectionView.selectItem(at: IndexPath(row: userColorIndex ?? 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        
        self.collectionView((self.topView?.selfColorCollectionView)!, didSelectItemAt: IndexPath(row: userColorIndex ?? 0, section: 0))
        
        self.topView?.otherColorCollectionView.selectItem(at: IndexPath(row: otherColorIndex ?? 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        self.collectionView((self.topView?.otherColorCollectionView)!, didSelectItemAt: IndexPath(row: otherColorIndex ?? 0, section: 0))
        
        bounceColorViewsOnLoad()
    }
    
    @objc func logoutButtonPressed() {
        let alert = UIAlertController(title: "Do you want to log out?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            Messaging.messaging().unsubscribe(fromTopic: GlobalUser.username)
            GlobalUser.emptyGlobals()
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "password")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            let loginVC = LoginVC()
            self.navigationController?.setViewControllers([loginVC], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            
        }))
        self.present(alert, animated: true)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func personalViewTapped(){
        topView?.selfColorViewWidthAnchor?.constant += 5
        topView?.selfColorViewHeightAnchor?.constant += 5
        
        UIView.animate(withDuration: 0.1, animations: {
            self.topView?.layoutIfNeeded()
        }, completion:{_ in
            self.topView?.selfColorViewWidthAnchor?.constant -= 5
            self.topView?.selfColorViewHeightAnchor?.constant -= 5
            UIView.animate(withDuration: 0.1, animations: {
                self.topView?.layoutIfNeeded()
            })
        })
        
        if !userColorsOpen{
            topView?.selfColorHeightConstraint?.constant = 200
            
            UIView.animate(withDuration: 0.3, animations: {
                self.topView?.layoutIfNeeded()
                self.userColorsOpen = true
            }, completion: {_ in
                self.topView?.selfColorCollectionView.flashScrollIndicators()
            })
        }else{
            topView?.selfColorHeightConstraint?.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.topView?.layoutIfNeeded()
                self.userColorsOpen = false
            })
        }
    }
    
    @objc func otherViewTapped(){
        topView?.otherColorViewWidthAnchor?.constant += 5
        topView?.otherColorViewHeightAnchor?.constant += 5
        
        UIView.animate(withDuration: 0.1, animations: {
            self.topView?.layoutIfNeeded()
        }, completion:{_ in
            self.topView?.otherColorViewWidthAnchor?.constant -= 5
            self.topView?.otherColorViewHeightAnchor?.constant -= 5
            UIView.animate(withDuration: 0.1, animations: {
                self.topView?.layoutIfNeeded()
            })
        })
        
        if !otherColorsOpen{
            topView?.otherColorHeightConstraint?.constant = 200
            UIView.animate(withDuration: 0.3, animations: {
                self.topView?.layoutIfNeeded()
                self.otherColorsOpen = true
            }, completion: {_ in
                self.topView?.otherColorCollectionView.flashScrollIndicators()
            })
        }else{
            topView?.otherColorHeightConstraint?.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.topView?.layoutIfNeeded()
                self.otherColorsOpen = false
            })
        }
    }
    
    @objc func draggedPersonalColorView(_ sender:UIPanGestureRecognizer){
        var position: CGPoint
        let selfCViewPoint: CGPoint
        var difference: CGFloat = 0
        var translation: CGPoint = CGPoint(x: 0, y: 0)
        var lastVelocity: CGFloat = 1
        
        switch sender.state {
        case .began:
            position = sender.location(in: self.view)
            
            position = (self.topView?.convert(position, to: self.view))!
            print(position)
            selfCViewPoint = self.topView!.convert((self.topView?.selfColorCollectionView.frame.origin)!, to: self.view)
            print(selfCViewPoint)
            
            difference = selfCViewPoint.y - position.y
        case .changed:
            translation = sender.translation(in: self.topView)
            lastVelocity = sender.velocity(in: self.topView).y
            print(lastVelocity)
            self.topView?.selfColorHeightConstraint?.constant = translation.y - difference
            
        case .ended:
            let distance = CGFloat(500) - (self.topView?.selfColorHeightConstraint?.constant)!
            let timeInCGFloat = distance / sender.velocity(in: self.topView).y
            let time: TimeInterval = TimeInterval(timeInCGFloat)
            print("TIME")
            print(sender.velocity(in: self.topView).y)
            print(timeInCGFloat)
            print(time)
            
            self.topView?.selfColorHeightConstraint?.constant = 500
            UIView.animate(withDuration: time, animations: {
                self.topView?.layoutIfNeeded()
                self.userColorsOpen = true
            })
            
        default:
            break
        }
    }
    
    func bounceColorViewsOnLoad(){
        topView?.otherColorHeightConstraint?.constant = 30
        topView?.selfColorHeightConstraint?.constant = 30
        UIView.animate(withDuration: 0.3, animations: {
            self.topView?.layoutIfNeeded()
        }, completion: {_ in
            self.topView?.otherColorHeightConstraint?.constant = 0
            self.topView?.selfColorHeightConstraint?.constant = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.topView?.layoutIfNeeded()
            })
        })
    }
    
    // MARK: - Navigation
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEvent.EventSubtype.motionShake) {
            let alert = UIAlertController(title: "Shake Feedback", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Give Feedback", style: .default, handler: {action in
                let feedbackVC = FeedbackVC()
                feedbackVC.modalPresentationStyle = .overCurrentContext
                self.present(feedbackVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
