//
//  FriendsVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 2/6/19.
//  Copyright © 2019 Shelby McCowan. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Navbar goodies
    // These are here until I find a better way to do this
    // I might just subclass UIView and throw it on top of the navbar or something
    var searchBar: UISearchBar!
    var profileButton: UIButton!
    var exitSearchButton: UIButton!
    
    var exitSearchRightAnchor: NSLayoutConstraint?
    var searchBarRightAnchor: NSLayoutConstraint?
    
    
    // Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return GlobalUser.requestedFriends.count
        }else{
            return GlobalUser.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "friendCell")
        if indexPath.section == 0{
            cell.textLabel?.text = GlobalUser.requestedFriends[indexPath.row]
        }else{
            cell.textLabel?.text = GlobalUser.friends[indexPath.row]
        }
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
