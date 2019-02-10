//
//  FriendsVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/6/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CAAnimationDelegate, UINavigationControllerDelegate {
    
    // Navbar goodies
    // These are here until I find a better way to do this
    // I might just subclass UIView and throw it on top of the navbar or something
    var searchBar: UISearchBar!
    var profileButton: UIButton!
    var exitSearchButton: UIButton!
    var backButton: UIButton!
    
    var exitSearchRightAnchor: NSLayoutConstraint?
    var searchBarRightAnchor: NSLayoutConstraint?
    
    var topView: FriendsView!
    var friendTable: UITableView!
    
    var searchMode = false
    var searchResults = [String]()
    var currentRequestedFriends = [String]()
    
    var addFriendButton: UIButton!
    
    
    // Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if searchMode{
                return searchResults.count
            }
            return currentRequestedFriends.count
        }else{
            return GlobalUser.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! RequestedTableViewCell
        
        if indexPath.section == 0{
            if searchMode{
                cell.usernameLabel.text = searchResults[indexPath.row]
            }else{
                cell.usernameLabel.text = currentRequestedFriends[indexPath.row]
            }
            
            cell.acceptButton.addTarget(cell, action: #selector(cell.acceptedRequest), for: .touchUpInside)
            
            cell.action = { (cell) in
                cell.acceptButton.backgroundColor = UIColor.white
                cell.acceptButton.setTitle("Accepted", for: .normal)
                cell.acceptButton.tintColor = nebulaPurple
                cell.acceptButton.isUserInteractionEnabled = false
                GlobalUser.requestedFriends = GlobalUser.requestedFriends.filter {$0 != cell.usernameLabel.text}
                tableView.reloadData()
            }
        }else {
            cell.usernameLabel.text = GlobalUser.friends[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addFriendsVC = AddFriendVC()
        addFriendsVC.modalPresentationStyle = .overCurrentContext
        self.present(addFriendsVC, animated: true, completion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchMode{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            if searchMode{
                return ""
            }
            return "Friend Requests"
        case 1:
            return "Friends"
        case 2:
            return "Suggested"
        default:
            return ""
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    // Set up tableview
    func setupTableview(){
        
    }
    
    // Actions
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, direction: .fromLeft)
        default:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, direction: .toLeft)
        }
    }

    
    @objc func swipedLeft(){
        self.backButton.removeFromSuperview()
        self.searchBar.endEditing(true)
        
        UIView.transition(with: self.addFriendButton,
                          duration: 0.2,
                          options: .transitionFlipFromRight,
                          animations: {
                            self.addFriendButton.setImage(UIImage(named: "ProfileBlack"), for: .normal) })
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addFriendButtonPressed(){
        let addVC = AddFriendVC()
        addVC.modalPresentationStyle = .overCurrentContext
        self.present(addVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        navigationController?.delegate = self
        self.searchBar.delegate = self
        self.searchBar.isUserInteractionEnabled = false
        
        for subview in searchBar.subviews  {
            for subSubview in subview.subviews  {
                if let textField = subSubview as? UITextField {
                    textField.backgroundColor = panelColorOneAlt
                }
            }
        }
        
        topView = FriendsView(frame: self.view.frame)
        self.view.addSubview(topView)
        friendTable = topView.friendsTable
        friendTable.delegate = self
        friendTable.dataSource = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "ForwardArrowBlack"), for: .normal)
        backButton.frame = CGRect(x: self.view.frame.width, y: self.view.frame.height, width: 0, height: 0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(swipedLeft), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(backButton)
        
        backButton.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        currentRequestedFriends = GlobalUser.requestedFriends
        
        topView.addGestureRecognizer(swipeLeft)
        
        UIView.transition(with: self.addFriendButton,
                          duration: 0.2,
                          options: .transitionFlipFromLeft,
                          animations: {
                            self.addFriendButton.setImage(UIImage(named: "AddFriendBlack"), for: .normal)})
        
        //self.addFriendButton.setImage(UIImage(named: "AddFriendBlack"), for: .normal)
        self.addFriendButton.removeTarget(nil, action: nil, for: .allEvents)
        self.addFriendButton.addTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        backButton.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -6).isActive = true
        backButton.centerYAnchor.constraint(equalTo: (navigationController?.navigationBar.centerYAnchor)!).isActive = true
        
        exitSearchRightAnchor?.constant -= 30
        searchBarRightAnchor?.constant -= 30
        
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
}

extension FriendsVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchMode = true
        self.friendTable.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        self.searchResults = GlobalUser.requestedFriends
        self.friendTable.reloadData()
        searchBarRightAnchor?.constant -= 40
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            self.searchMode = false
        }
        self.friendTable.reloadData()
        
        searchBarRightAnchor?.constant = -38
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchMode = false
        self.friendTable.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        self.friendTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchResults = GlobalUser.requestedFriends
            self.friendTable.reloadData()
        }else if searchText.count > 0{
            if self.searchMode{
                self.searchResults = [String]()
                for i in GlobalUser.requestedFriends{
                    if i.lowercased().hasPrefix(searchText.lowercased()){
                        self.searchResults.append(i)
                    }
                }
                self.friendTable.reloadData()
            }
        }else{
            if self.searchMode{
                self.searchResults = GlobalUser.requestedFriends
            }else{
                self.searchResults = []
            }
            self.friendTable.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString == "" {
            self.friendTable.reloadData()
        }else if searchString!.count > 0{
            FriendRoutes.searchFriends(characters: searchString!){friends in
                self.searchResults = friends
            }
            self.friendTable.reloadData()
        }else{
            self.searchResults = []
            self.friendTable.reloadData()
        }
    }
}
