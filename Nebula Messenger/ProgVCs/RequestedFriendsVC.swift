//
//  RequestedFriendsVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/27/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class RequestedFriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendsTable: UITableView!
    var possibleMembers = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(GlobalUser.friends[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath as IndexPath)
        let action = UIContextualAction(style: .normal, title: "Delete") {(action, view, nil) in
            print("Action")
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        /*
        guard let cellText = cell.textLabel?.text else {
            print("ERROR IN FILE")
            return nil
        }
        print("TRUST")
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            if true {
                                                UserRoutes.deleteFriendRequest(friend: cellText, completion: {
                                                    self.friendsTable.reloadData()
                                                })
                                                completionHandler(true)
                                            }
                                            completionHandler(false)
        }
        
        action.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [action])
        return config*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let barHeight: CGFloat = 100
        
        friendsTable = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        friendsTable.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
        friendsTable.dataSource = self
        friendsTable.delegate = self
        self.view.addSubview(friendsTable)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true){
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
}
