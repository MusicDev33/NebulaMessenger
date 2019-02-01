//
//  MainMenuVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/21/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import FirebaseInstanceID

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UIGestureRecognizerDelegate {
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    var isGroupChat = false
    
    var searchController: UISearchController!
    var searchResults = [String]()
    var searchBar: UISearchBar!
    var exitSearchButton: UIButton!
    
    var convTable: UITableView!
    
    var bottomBarView: UIView!
    var addFriendsButton: UIButton!
    var createMessageButton: UIButton!
    var nebulaButton: UIButton!
    
    var searchConvMode = false
    
    // Add names here to allow the users to access pools
    let adminUsers = ["MusicDev", "ben666", "wesperrett", "Ashton"]
    
    var passMsgList = [TerseMessage]()
    
    var outdated = false
    
    let impact = UIImpactFeedbackGenerator(style: .light)
    let notifImpact = UINotificationFeedbackGenerator()
    
    var lineView: UIView!
    var lineViewBottomAnchor: NSLayoutConstraint?
    
    var bottomLineView: UIView!
    var bottomLineViewBottomAnchor: NSLayoutConstraint?
    
    var profileUIButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchConvMode{
            return searchResults.count
        } else{
            return GlobalUser.conversations.count
        }
        
    }
    
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
        self.searchController.isActive = false
        var cellText = (currentCell.textLabel?.text!)!
        if cellText.contains(" READ"){
            cellText = String(cellText.dropLast(5))
        }
        self.passId = GlobalUser.masterDict[cellText]!.id!
        self.passInvolved = GlobalUser.conversations[indexPath.row]
        self.passFriend = cellText
        view.endEditing(true)
        self.searchController.searchBar.endEditing(true)
        
        let userCount = self.passInvolved.components(separatedBy:":").count
        print("Important")
        print(self.passInvolved)
        if userCount-1>1{
            print("Group chat enabled")
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        lineViewBottomAnchor?.constant = 1 - scrollView.contentOffset.y
        
    }
    
    func contextualDelete(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            // 3
                                            if true {
                                                // 4
                                                //self.data[indexPath.row] = email
                                                let tempId = GlobalUser.masterDict[GlobalUser.convNames[indexPath.row]]!.id
                                                ConversationRoutes.deleteConversation(id: tempId!, convName: GlobalUser.convNames[indexPath.row]){
                                                    self.convTable.reloadData()
                                                    print(GlobalUser.convNames)
                                                }
                                                //print(GlobalUser.convNames)
                                                print("Delete")
                                                // 5
                                                completionHandler(true)
                                            } else {
                                                // 6
                                                completionHandler(false)
                                            }
        }
        action.image = UIImage(named: "Trashcan")
        action.backgroundColor = UIColor.red
        return action
    }
    
    var searchBarWidth: NSLayoutConstraint?
    var searchBarRightAnchor: NSLayoutConstraint?
    
    //Search Controller Setup
    func configureSearchController(){
        let buttonHeight = CGFloat(40)
        // profile button 2
        profileUIButton = UIButton(type: .system)
        profileUIButton.translatesAutoresizingMaskIntoConstraints = false
        profileUIButton.setImage(UIImage(named: "ProfileBlack"), for: .normal)
        profileUIButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        exitSearchButton = UIButton(type: .system)
        exitSearchButton.translatesAutoresizingMaskIntoConstraints = false
        exitSearchButton.setImage(UIImage(named: "BlackX"), for: .normal)
        exitSearchButton.addTarget(self, action: #selector(exitSearchButtonPressed), for: .touchUpInside)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        searchBar.delegate = self
        searchBar.placeholder = "Conversations"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.white
        
        let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5))
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        topLineView.backgroundColor = UIColor.white
        
        let bottomLineView = UIView(frame: CGRect(x: 0, y: 55, width: self.view.frame.width, height: 5))
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = UIColor.white
        
        for subview in searchBar.subviews  {
            for subSubview in subview.subviews  {
                if let textField = subSubview as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.layer.cornerRadius = 10
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = nebulaPurple.cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
        
        self.convTable.tableHeaderView = searchBar
        self.convTable.tableHeaderView?.addSubview(topLineView)
        self.convTable.tableHeaderView?.addSubview(bottomLineView)
        self.convTable.addSubview(profileUIButton)
        self.convTable.addSubview(exitSearchButton)
        
        exitSearchButton.alpha = 0
        
        searchBar.topAnchor.constraint(equalTo: self.convTable.topAnchor, constant: 3).isActive = true
        
        profileUIButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        profileUIButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        profileUIButton.leftAnchor.constraint(equalTo: self.convTable.leftAnchor, constant: 10).isActive = true
        profileUIButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        
        searchBarWidth = searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85)
        searchBarWidth?.isActive = true
        searchBarRightAnchor = searchBar.leftAnchor.constraint(equalTo: self.profileUIButton.rightAnchor, constant: 5)
        searchBarRightAnchor?.isActive = true
        
        exitSearchButton.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        exitSearchButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        exitSearchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        exitSearchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchConvMode = true
        self.searchResults = GlobalUser.convNames
        self.searchBarWidth?.constant -= 40
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.exitSearchButton.alpha = 1
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.convTable.reloadData()
        self.searchBarWidth?.constant = 0
        //searchBarRightAnchor?.constant = -5
        UIView.animate(withDuration: 0.2, animations: {
            self.convTable.layoutIfNeeded()
            self.exitSearchButton.alpha = 0
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchConvMode = false
        self.convTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    // We're just going to pretend like I understand what these functions do
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchResults = GlobalUser.convNames
            self.convTable.reloadData()
        }else if searchText.count > 0{
            let searchString = searchController.searchBar.text
            if self.searchConvMode{
                self.searchResults = [String]()
                for i in GlobalUser.convNames{
                    if i.lowercased().contains(searchText.lowercased()){
                        self.searchResults.append(i)
                    }
                }
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
    
    //Start of non-search part
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.createSettingsButton()
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
        self.configureSearchController()
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
                print("Error fetching remote instange ID: \(error)")
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
        //print("FB Token:")
        //print(FirebaseGlobals.globalDeviceToken)
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
        self.view.endEditing(true)
    }
    
    @objc func profileButtonPressed(){
        self.view.endEditing(true)
        self.searchBar.resignFirstResponder()
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
        createMessageVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(createMessageVC, animated: true)
    }
    
    @objc func addFriendsButtonPressed() {
        let addFriendVC = AddFriendVC()
        addFriendVC.modalPresentationStyle = .overCurrentContext
        self.present(addFriendVC, animated: true, completion: nil)
    }
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            print("Socket Beginning - Main Menu")
            // print(parsedData)
            // print(msg)
            guard let msgConvId = msg["convId"].string else{
                return
            }
            
            if msgConvId.contains(GlobalUser.username){
                GlobalUser.unreadList.append(msg["id"].string!)
                self.convTable.reloadData()
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
        // view for block the dark line at the top of the tableview
        lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.white
        
        convTable = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        convTable.register(UITableViewCell.self, forCellReuseIdentifier: "conversationCell")
        convTable.dataSource = self
        convTable.delegate = self
        convTable.translatesAutoresizingMaskIntoConstraints = false
        convTable.isScrollEnabled = true
        convTable.separatorStyle = .none
        convTable.separatorColor = convTable.backgroundColor
        self.view.addSubview(convTable)
        self.convTable.addSubview(lineView)
        
        let combinedInsets = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        print(combinedInsets)
        
        convTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        convTable.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        convTable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        convTableHeightAnchor = convTable.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.height - 60)
        convTableHeightAnchor?.isActive = true
        
        lineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineViewBottomAnchor = lineView.topAnchor.constraint(equalTo: convTable.topAnchor, constant: 1)
        lineViewBottomAnchor?.isActive = true
        lineView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
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
