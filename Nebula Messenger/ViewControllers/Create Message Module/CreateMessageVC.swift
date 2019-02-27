//
//  CreateMessageVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class CreateMessageVC: UIViewController, UIGestureRecognizerDelegate {
    
    var mainTable: UITableView!
    
    var selectedFriendsList = [String]()
    var passMsgList = [TerseMessage]()
    
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    var topView: CreateMessageView?
    var backButton: UIButton!
    
    var navProfileButton: UIButton!
    var navProfileCenterXAnchor: NSLayoutConstraint?
    
    var searchBarRightAnchor: NSLayoutConstraint?
    
    var searchBar: UISearchBar!
    var searchResults = [String]()
    var searchMode = false
    var closeSearchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        navigationController?.delegate = self
        self.searchBar.delegate = self
        
        backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "BackArrowBlack"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(backButton)
        
        topView = CreateMessageView(frame: self.view.frame)
        self.view.addSubview(topView!)
        mainTable = topView?.friendsTable
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        // Do any additional setup after loading the view.
        backButton.addTarget(self, action: #selector(xButtonPressed), for: .touchUpInside)
        topView?.continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        closeSearchButton.addTarget(self, action: #selector(closeSearchButtonPressed), for: .touchUpInside)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(xButtonPressed))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        topView?.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.rightAnchor.constraint(equalTo: navProfileButton.leftAnchor, constant: -4).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navProfileButton.centerYAnchor).isActive = true
        
        navProfileCenterXAnchor?.constant += 30
        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        backButton.removeFromSuperview()
    }
    
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

    
    // MARK: - Navigation

    // TODO: Get rid of this...does it even get called????
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MessengerVC{
            let vc = segue.destination as? MessengerVC
            vc?.id = ""
            if self.selectedFriendsList.count > 1{
                vc?.skipNotif = true
                vc?.friend = self.passFriend
                
                if GlobalUser.convNames.contains(self.passFriend){
                    vc?.involved = GlobalUser.involvedDict[self.passFriend]!
                    vc?.id = GlobalUser.masterDict[self.passFriend]!.id!
                    vc?.msgList = self.passMsgList
                }else{
                    vc?.involved = self.passInvolved
                }
                
            }else{
                vc?.friend = self.selectedFriendsList[0]
                self.passFriend = self.selectedFriendsList[0]
                if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                    vc?.involved = GlobalUser.involvedDict[self.passFriend]!
                    vc?.id = GlobalUser.masterDict[self.passFriend]!.id!
                    vc?.msgList = self.passMsgList
                }else{
                    var passList = self.selectedFriendsList
                    passList.append(GlobalUser.username)
                    vc?.involved = Utility.createConvId(names: passList)
                }
            }
        }
    }
}


// MARK: UISearchBar Ext.
extension CreateMessageVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchMode = true
        self.searchResults = GlobalUser.friends
        print("???????????????")
        searchBarRightAnchor?.constant -= 40
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.mainTable.reloadData()
        print("!!!!!!!!!!!!")
        searchBarRightAnchor?.constant = -8
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchMode = false
        self.mainTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // We're just going to pretend like I understand what these functions do
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchResults = GlobalUser.friends
            self.mainTable.reloadData()
        }else if searchText.count > 0{
            if self.searchMode{
                self.searchResults = [String]()
                for i in GlobalUser.friends{
                    if i.lowercased().hasPrefix(searchText.lowercased()){
                        self.searchResults.append(i)
                    }
                }
                self.mainTable.reloadData()
            }
        }else{
            if self.searchMode{
                self.searchResults = GlobalUser.friends
            }else{
                self.searchResults = []
            }
            self.mainTable.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString == "" {
            self.mainTable.reloadData()
        } else if searchString!.count > 0{
            FriendRoutes.searchFriends(characters: searchString!){friends in
                self.searchResults = friends
            }
            self.mainTable.reloadData()
        } else{
            self.searchResults = []
            self.mainTable.reloadData()
        }
    }
}


// MARK: UITableView Ext.
extension CreateMessageVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMode{
            return searchResults.count
        }else{
            return GlobalUser.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mainCell")
        
        if self.searchMode{
            cell.textLabel?.text = searchResults[indexPath.row]
        }else{
            cell.textLabel?.text = GlobalUser.friends[indexPath.row]
            cell.detailTextLabel?.text = " "
            
            if selectedFriendsList.contains((cell.textLabel?.text)!){
                cell.detailTextLabel?.text = "\u{2714}"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! // as! UITableViewCell
        let cellText = (currentCell.textLabel?.text!)!
        if self.selectedFriendsList.contains(cellText){
            currentCell.detailTextLabel?.text = " "
            self.selectedFriendsList = self.selectedFriendsList.filter {$0 != cellText}
        }else{
            self.selectedFriendsList.append(cellText)
            currentCell.detailTextLabel?.text = "\u{2714}"
        }
        
        if self.selectedFriendsList.count > 0{
            topView?.continueSwitch(buttonOn: true)
        }else{
            topView?.continueSwitch(buttonOn: false)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: UINavControllerDelegate Ext.
extension CreateMessageVC: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, direction: .fromRight)
        default:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, direction: .toRight)
        }
    }
}


// MARK: Listeners Ext.
extension CreateMessageVC{
    
    @objc func xButtonPressed() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeSearchButtonPressed(){
        self.searchBar.resignFirstResponder()
        self.searchMode = false
        self.searchResults = []
        self.mainTable.reloadData()
    }
    
    @objc func continueButtonPressed() {
        let messageVC = MessengerVC()
        messageVC.id = ""
        messageVC.fromCreateMessage = true
        self.searchBar.resignFirstResponder()
        
        if self.selectedFriendsList.count > 1{
            var quickInvolved = Utility.createGroupConvId(names: self.selectedFriendsList)
            quickInvolved = Utility.alphabetSort(preConvId: quickInvolved)
            let quickConvName = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: quickInvolved)
            
            self.passFriend = quickConvName
            self.passInvolved = quickInvolved
            if GlobalUser.convNames.contains(quickConvName){
                let quickId = GlobalUser.masterDict[quickConvName]!.id
                MessageRoutes.getMessages(id: quickId!){messageList in
                    self.passMsgList = messageList
                    
                    messageVC.skipNotif = true
                    messageVC.friend = self.passFriend
                    
                    if GlobalUser.convNames.contains(self.passFriend){
                        messageVC.involved = GlobalUser.involvedDict[self.passFriend]!
                        messageVC.id = GlobalUser.masterDict[self.passFriend]!.id!
                        messageVC.msgList = self.passMsgList
                    }else{
                        messageVC.involved = self.passInvolved
                    }
                    self.navigationController?.pushViewController(messageVC, animated: true)
                }
            }else{
                messageVC.skipNotif = true
                messageVC.friend = self.passFriend
                
                if GlobalUser.convNames.contains(self.passFriend){
                    messageVC.involved = GlobalUser.involvedDict[self.passFriend]!
                    messageVC.id = GlobalUser.masterDict[self.passFriend]!.id!
                    messageVC.msgList = self.passMsgList
                }else{
                    messageVC.involved = self.passInvolved
                }
                self.navigationController?.pushViewController(messageVC, animated: true)
            }
        }else{
            if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                let friend = self.selectedFriendsList[0]
                let quickId = GlobalUser.masterDict[friend]!.id
                MessageRoutes.getMessages(id: quickId!){messageList in
                    self.passMsgList = messageList
                    
                    messageVC.friend = self.selectedFriendsList[0]
                    self.passFriend = self.selectedFriendsList[0]
                    if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                        messageVC.involved = GlobalUser.involvedDict[self.passFriend]!
                        messageVC.id = GlobalUser.masterDict[self.passFriend]!.id!
                        messageVC.msgList = self.passMsgList
                    }else{
                        var passList = self.selectedFriendsList
                        passList.append(GlobalUser.username)
                        messageVC.involved = Utility.createConvId(names: passList)
                    }
                    self.navigationController?.pushViewController(messageVC, animated: true)
                }
            }else{
                messageVC.friend = self.selectedFriendsList[0]
                self.passFriend = self.selectedFriendsList[0]
                if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                    messageVC.involved = GlobalUser.involvedDict[self.passFriend]!
                    messageVC.id = GlobalUser.masterDict[self.passFriend]!.id!
                    messageVC.msgList = self.passMsgList
                }else{
                    var passList = self.selectedFriendsList
                    passList.append(GlobalUser.username)
                    messageVC.involved = Utility.createConvId(names: passList)
                }
                self.navigationController?.pushViewController(messageVC, animated: true)
            }
        }
    }
}
