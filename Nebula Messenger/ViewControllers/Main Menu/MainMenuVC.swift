//
//  MainMenuVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/21/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import FirebaseInstanceID

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UIGestureRecognizerDelegate, CAAnimationDelegate, UINavigationControllerDelegate {
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    var isGroupChat = false
    
    var searchResults = [String]()
    var searchBar: UISearchBar!
    var navSearchBar: UISearchBar!
    
    var convTable: UITableView!
    
    var profileButton: UIButton!
    
    var bottomBarView: UIView!
    var addFriendsButton: UIButton!
    var createMessageButton: UIButton!
    var nebulaButton: UIButton!
    
    var searchConvMode = false
    
    var profileLocation: CGFloat!
    var exitSearchButton: UIButton!
    
    // Add names here to allow the users to access pools
    let adminUsers = ["MusicDev"]
    
    var passMsgList = [TerseMessage]()
    
    var outdated = false
    
    var profileButtonCenterXAnchor: NSLayoutConstraint?
    var exitSearchRightAnchor: NSLayoutConstraint?
    
    let impact = UIImpactFeedbackGenerator(style: .light)
    let notifImpact = UINotificationFeedbackGenerator()
    
    var navType = NavType.fromRight
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchConvMode{
            return searchResults.count
        } else{
            return GlobalUser.conversations.count
        }
    }
    
    var searchBarWidthAnchor: NSLayoutConstraint?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "conversationCell")
        if self.searchConvMode{
            cell.textLabel?.text = self.searchResults[indexPath.row]
        } else{
            let convName = GlobalUser.convNames[indexPath.row]
            
            if GlobalUser.unreadList.contains(GlobalUser.masterDict[convName]!.id!){
                cell.textLabel?.textColor = nebulaBlue
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            }
            cell.textLabel?.text = convName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        self.searchBar.resignFirstResponder()
        var cellText = (currentCell.textLabel?.text!)!
        if cellText.contains(" READ"){
            cellText = String(cellText.dropLast(5))
        }
        self.passId = GlobalUser.masterDict[cellText]!.id!
        self.passInvolved = GlobalUser.conversations[indexPath.row]
        self.passFriend = cellText
        view.endEditing(true)
        
        let userCount = self.passInvolved.components(separatedBy:":").count
        if userCount-1>1{
            self.isGroupChat = true
        }
        
        let messageVC = MessengerVC()
        messageVC.modalPresentationStyle = .overCurrentContext
        messageVC.modalTransitionStyle = .crossDissolve
        
        MessageRoutes.getMessages(id: self.passId){messageList in
            self.passMsgList = messageList
            tableView.deselectRow(at: indexPath, animated: true)
            
            SocketIOManager.socket.off("message")
            if self.passInvolved.components(separatedBy:":").count-1 > 1{
                messageVC.skipNotif = true
            }
            messageVC.id = self.passId
            messageVC.involved = self.passInvolved
            messageVC.friend = self.passFriend
            messageVC.msgList = self.passMsgList
            messageVC.isGroupChat = self.isGroupChat
            self.isGroupChat = false
            
            //poolChatVC.poolId = self.passPoolId
            //poolChatVC.currentPoolMessages = self.passPoolMessages
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let deleteAction = self.contextualDelete(forRowAtIndexPath: indexPath)
 
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func contextualDelete(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            if true {
                                                let tempId = GlobalUser.masterDict[GlobalUser.convNames[indexPath.row]]!.id
                                                ConversationRoutes.deleteConversation(id: tempId!, convName: GlobalUser.convNames[indexPath.row]){
                                                    self.convTable.reloadData()
                                                }
                                                completionHandler(true)
                                            }
                                            completionHandler(false)
        }
        action.image = UIImage(named: "Trashcan")
        action.backgroundColor = UIColor.red
        return action
    }
    
    var searchBarWidth: NSLayoutConstraint?
    var searchBarRightAnchor: NSLayoutConstraint?
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchConvMode = true
        self.searchResults = GlobalUser.convNames
        self.searchBarWidthAnchor?.constant -= 40
        
        self.navSearchBarWidthAnchor?.constant -= 40
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.convTable.reloadData()
        self.searchBarWidthAnchor?.constant = 0
        self.navSearchBarWidthAnchor?.constant = -8
        
        UIView.animate(withDuration: 0.2, animations: {
            self.convTable.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchConvMode = false
        self.convTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // We're just going to pretend like I understand what these functions do
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HI")
        if searchText == "" {
            self.searchResults = GlobalUser.convNames
            self.convTable.reloadData()
        }else if searchText.count > 0{
            if self.searchConvMode{
                self.searchResults = [String]()
                for i in GlobalUser.convNames{
                    if i.lowercased().hasPrefix(searchText.lowercased()){
                        self.searchResults.append(i)
                    }
                }
                self.convTable.reloadData()
            }
        }else{
            if self.searchConvMode{
                self.searchResults = GlobalUser.convNames
            }else{
                self.searchResults = []
            }
            self.convTable.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString == "" {
            self.convTable.reloadData()
        }else if searchString!.count > 0{
            FriendRoutes.searchFriends(characters: searchString!){friends in
                self.searchResults = friends
            }
            self.convTable.reloadData()
        }else{
            self.searchResults = []
            self.convTable.reloadData()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, direction: self.navType)
        default:
            return CustomAnim(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, direction: self.navType)
        }
    }
    
    //Start of non-search part
    override func viewDidLoad() {
        super.viewDidLoad()
        profileLocation = (UIScreen.main.bounds.width * 0.075)
        
        navigationItem.hidesBackButton = true
        setupNavbar()
        
        self.createConvTable()
        
        self.view.backgroundColor = UIColor.white
        
        for i in GlobalUser.convNames{
            if GlobalUser.masterDict[i]?.lastMessage == GlobalUser.masterDict[i]?.lastRead{
            }else{
                //cell.backgroundColor = nebulaBlue
                let unreadId = GlobalUser.masterDict[i]!.id!
                GlobalUser.unreadList.append(unreadId)
            }
        }
        
        if outdated{
            Alert.basicAlert(on: self, with: "App is outdated!", message: "Update through TestFlight!")
        }
        
        SocketIOManager.establishConnection()
        //self.configureSearchController()
        if self.adminUsers.contains(GlobalUser.username) {
            
        }else{
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy hh:mm:ss"
            
            // Creating the date object
            let now = df.string(from: Date())
            DiagnosticRoutes.sendInfo(info: "Logged in.", optional: now)
        }
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                FirebaseGlobals.globalDeviceToken = result.token
                UserRoutes.refreshToken {
                    print("Refreshed Token.")
                }
            }
        }
        self.createBottomBar()
        self.createNebulaButton()
        self.createAddFriendsButton()
        self.createCreateMessageButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        impact.prepare()
        self.openSocket {
            
        }
        GlobalUser.currentConv = ""
        self.convTable.reloadData()
        
        self.navType = .fromRight
        navigationController?.delegate = self
        
        navSearchBar.delegate = self
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        exitSearchButton.addTarget(self, action: #selector(exitSearchButtonPressed), for: .touchUpInside)
    }
    
    var navSearchBarWidthAnchor: NSLayoutConstraint?
    
    func setupNavbar(){
        profileButton = UIButton(type: .system)
        profileButton.setImage(UIImage(named: "ProfileBlack"), for: .normal)
        profileButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        exitSearchButton = UIButton(type: .system)
        exitSearchButton.setImage(UIImage(named: "BlackX"), for: .normal)
        exitSearchButton.translatesAutoresizingMaskIntoConstraints = false
        
        navSearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        navSearchBar.placeholder = "Conversations"
        navSearchBar.translatesAutoresizingMaskIntoConstraints = false
        for subview in navSearchBar.subviews  {
            for subSubview in subview.subviews  {
                if let textField = subSubview as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 15 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.layer.cornerRadius = 10
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = nebulaPurple.cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
        
        navigationController?.navigationBar.addSubview(profileButton)
        navigationController?.navigationBar.addSubview(exitSearchButton)
        navigationController?.navigationBar.addSubview(navSearchBar)
        
        self.searchBar = navSearchBar
        navSearchBar.delegate = self
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        exitSearchButton.addTarget(self, action: #selector(exitSearchButtonPressed), for: .touchUpInside)
        
        navSearchBar.leftAnchor.constraint(equalTo: profileButton.centerXAnchor, constant: profileLocation-5).isActive = true
        navSearchBarWidthAnchor = navSearchBar.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -8)
        navSearchBarWidthAnchor?.isActive = true
        navSearchBar.centerYAnchor.constraint(equalTo: (navigationController?.navigationBar.centerYAnchor)!).isActive = true
        
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButtonCenterXAnchor = profileButton.centerXAnchor.constraint(equalTo: (navigationController?.navigationBar.leftAnchor)!, constant: profileLocation)
        profileButtonCenterXAnchor?.isActive = true
        profileButton.centerYAnchor.constraint(equalTo: navSearchBar.centerYAnchor).isActive = true
        
        exitSearchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitSearchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitSearchRightAnchor = exitSearchButton.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -6)
        exitSearchRightAnchor?.isActive = true
        exitSearchButton.centerYAnchor.constraint(equalTo: navSearchBar.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        self.searchBar.placeholder = "Conversations"
        self.profileButtonCenterXAnchor?.constant = profileLocation
        self.exitSearchRightAnchor?.constant = -6
        self.navSearchBarWidthAnchor?.constant = -8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.convTable.reloadData()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        convTableHeightAnchor = convTable.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.height - 60)
        convTableHeightAnchor?.isActive = true
    }
    
    //MARK: Actions
    @objc func exitSearchButtonPressed(){
        self.searchBar.resignFirstResponder()
        self.navSearchBar.text = ""
        self.searchResults = GlobalUser.convNames
        self.convTable.reloadData()
        
        self.navigationController?.navigationBar.endEditing(true)
    }
    
    @objc func profileButtonPressed(){
        //SocketIOManager.sendToTestSocket(title: "Hey! Listen!", message: "How are you?")
        self.view.endEditing(true)
        self.navSearchBar.resignFirstResponder()
        //self.searchBar.placeholder = "New Message"
        let profileVC = MyProfileVC()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func nebulaButtonPressed(){
        impact.impactOccurred()
        
        let mapVC = TestMapBoxVC()
        mapVC.modalTransitionStyle = .crossDissolve
        
        self.present(mapVC, animated: true)
    }
    
    @objc func createMessageButtonTapped() {
        let createMessageVC = CreateMessageVC()
        self.navSearchBar.placeholder = "New Message"
        createMessageVC.searchBar = self.navSearchBar
        createMessageVC.navProfileButton = profileButton
        createMessageVC.navProfileCenterXAnchor = self.profileButtonCenterXAnchor
        createMessageVC.searchBarRightAnchor = self.navSearchBarWidthAnchor
        createMessageVC.closeSearchButton = exitSearchButton
        
        self.navType = .fromRight
        
        createMessageVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(createMessageVC, animated: true)
    }
    
    @objc func addFriendsButtonPressed() {
        self.navSearchBar.placeholder = "Friend Requests"
        
        let friendsVC = FriendsVC()
        friendsVC.profileButton = self.profileButton
        friendsVC.exitSearchButton = self.exitSearchButton
        friendsVC.searchBar = self.navSearchBar
        
        friendsVC.exitSearchRightAnchor = self.exitSearchRightAnchor
        friendsVC.searchBarRightAnchor = self.navSearchBarWidthAnchor
        self.navType = .fromLeft
        
        navigationController?.pushViewController(friendsVC, animated: true)
    }
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            guard let msgConvId = msg["convId"].string else{
                print("Error on receive message: Main Menu")
                return
            }
            
            if msgConvId.contains(GlobalUser.username){
                GlobalUser.unreadList.append(msg["id"].string!)
                self.convTable.reloadData()
            }
            
            let conversationExists = GlobalUser.conversations.contains{conv in
                if case conv = msgConvId{
                    return true
                }else{
                    return false
                }
            }
            
            if !conversationExists{
                ConversationRoutes.getOneConversation(involved: msgConvId, completion: {convList in
                    // convList is an array of strings
                    GlobalUser.addConversation(involved: convList[0], id: convList[1], lastRead: convList[2], lastMessage: convList[3])
                    GlobalUser.unreadList.append(convList[1])
                    DispatchQueue.main.async {
                        self.convTable.reloadData()
                    }
                })
            }
        }
        
        SocketIOManager.socket.on("_test-socket") { ( data, ack) -> Void in
            print(data)
            guard let parsedData = data[0] as? String else {
                print("Error on Test Socket")
                return }
            let msg = JSON.init(parseJSON: parsedData)
            guard let alertMessage = msg["msg"].string else { return }
            Alert.basicAlert(on: (self.navigationController?.visibleViewController)!, with: "HEY!", message: alertMessage)
        }
        
        SocketIOManager.socket.on("_add-friend") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else {
                print("Error on add-friend")
                return }
            let friendRequest = JSON.init(parseJSON: parsedData)
            guard let friendUsername = friendRequest["sender"].string else { return }
            guard let requestedUser = friendRequest["friend"].string else { return }
            if GlobalUser.username == requestedUser{
                GlobalUser.requestedFriends.append(friendUsername)
            }
        }
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
    
    // MARK: UI Creation
    // This will be moved into another file soon
    var convTableHeightAnchor: NSLayoutConstraint?
    
    func createConvTable(){
        convTable = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        convTable.register(UITableViewCell.self, forCellReuseIdentifier: "conversationCell")
        convTable.register(SearchBarHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerCell")
        convTable.dataSource = self
        convTable.delegate = self
        convTable.translatesAutoresizingMaskIntoConstraints = false
        convTable.isScrollEnabled = true
        convTable.separatorStyle = .none
        convTable.separatorColor = convTable.backgroundColor
        self.view.addSubview(convTable)
        
        let combinedInsets = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        
        convTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        convTable.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        convTable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        convTableHeightAnchor = convTable.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.height - 60)
        convTableHeightAnchor?.isActive = true
    }
    
    var bottomBarHeightAnchor: NSLayoutConstraint?
    
    func createBottomBar(){
        bottomBarView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBarView.backgroundColor = panelColorTwo
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.layer.borderWidth = 1
        bottomBarView.layer.borderColor = panelColorOne.cgColor
        bottomBarView.alpha = 0.95
        
        self.view.addSubview(bottomBarView)
        
        bottomBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottomBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomBarHeightAnchor = bottomBarView.heightAnchor.constraint(equalToConstant: 60)
        bottomBarHeightAnchor?.isActive = true
    }
    
    
    func createAddFriendsButton(){
        addFriendsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "GroupAddBlack") {
            addFriendsButton.setImage(image, for: .normal)
        }
        addFriendsButton.tintColor = nebulaPurple
        addFriendsButton.addTarget(self, action: #selector(addFriendsButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(addFriendsButton)
        
        addFriendsButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addFriendsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addFriendsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        addFriendsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    // Lol what a name
    func createCreateMessageButton(){
        createMessageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        createMessageButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "EditIconBlack") {
            createMessageButton.setImage(image, for: .normal)
        }
        createMessageButton.tintColor = nebulaPurple
        createMessageButton.addTarget(self, action: #selector(createMessageButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(createMessageButton)
        
        createMessageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        createMessageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        createMessageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        createMessageButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
    }
    
    func createNebulaButton(){
        nebulaButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        nebulaButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "Pool") {
            nebulaButton.setImage(image, for: .normal)
        }
        nebulaButton.addTarget(self, action: #selector(nebulaButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(nebulaButton)
        
        nebulaButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nebulaButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nebulaButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        nebulaButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
