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
    
    var convTable: UITableView!
    
    var profileButton: UIButton!
    var settingsButton: UIButton!
    
    var bottomBarView: UIView!
    var addFriendsButton: UIButton!
    var createMessageButton: UIButton!
    var nebulaButton: UIButton!
    
    var searchConvMode = false
    
    // Add names here to allow the users to access pools
    let adminUsers = ["MusicDev", "ben666", "wesperrett", "Ashton"]
    
    var passMsgList = [TerseMessage]()
    
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
        
        MessageRoutes.getMessages(id: self.passId){messageList in
            self.passMsgList = messageList
            tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "toMessengerVC", sender: self)
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
        
        if -(scrollView.contentOffset.y*2) + 40 > 40{
            profileButtonHeightAnchor?.constant = 40
        }else{
            profileButtonHeightAnchor?.constant = -(scrollView.contentOffset.y*2) + 40
        }
        
        //convTable.contentOffset.y = 0
        
        print("CONSTANT")
        print(convTableHeightAnchor?.constant)
        
        if profileButtonHeightAnchor?.constant ?? 0 < CGFloat(20){
            profileButton.setTitle("", for: .normal)
            settingsButton.setTitle("", for: .normal)
        }else{
            profileButton.setTitle("Profile", for: .normal)
            settingsButton.setTitle("Settings", for: .normal)
        }
        
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
        //action.title = "What the hell????"
        action.backgroundColor = UIColor.red
        return action
    }
    
    //Search Controller Setup
    func configureSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for conversations here"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.convTable.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchConvMode = true
        self.searchResults = GlobalUser.convNames
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.convTable.reloadData()
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
        self.createProfileButton()
        self.createSettingsButton()
        self.createConvTable()
        
        self.view.bringSubviewToFront(profileButton)
        self.view.backgroundColor = panelColorOne
        
        for i in GlobalUser.convNames{
            if GlobalUser.masterDict[i]?.lastMessage == GlobalUser.masterDict[i]?.lastRead{
            }else{
                //cell.backgroundColor = nebulaBlue
                let unreadId = GlobalUser.masterDict[i]!.id!
                GlobalUser.unreadList.append(unreadId)
            }
        }
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        
        // appVersion and buildNumber both exist for sure
        UserRoutes.getIfCurrent(version: appVersion!, build: Int(buildNumber!)!){message in
            if message == ""{
                
            }else{
                if GlobalUser.username != "MusicDev"{
                    Alert.basicAlert(on: self, with: "App is outdated!", message: message)
                }
            }
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
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
        // ... your layout code here
        convTableHeightAnchor = convTable.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.height - 65)
        convTableHeightAnchor?.isActive = true
    }
    
    //MARK: Actions
    @objc func profileButtonPressed(){
        self.searchController.isActive = false
        self.performSegue(withIdentifier: "toMyProfileView", sender: self)
    }
    
    @objc func nebulaButtonPressed(){
        self.performSegue(withIdentifier: "toPools", sender: self)
    }
    
    @objc func createMessageButtonTapped() {
        self.performSegue(withIdentifier: "toCreateMessageVC", sender: self)
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

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        SocketIOManager.socket.off("message")
        if segue.destination is MessengerVC{
            let vc = segue.destination as? MessengerVC
            if self.passInvolved.components(separatedBy:":").count-1 > 1{
                vc?.skipNotif = true
            }
            vc?.id = self.passId
            vc?.involved = self.passInvolved
            vc?.friend = self.passFriend
            vc?.msgList = self.passMsgList
            vc?.isGroupChat = self.isGroupChat
            self.isGroupChat = false
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
            
            if self.adminUsers.contains(GlobalUser.username){
                alert.addAction(UIAlertAction(title: "Secret Page", style: .default, handler: {action in
                    self.performSegue(withIdentifier: "toSecretPage", sender: self)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Unwinding
    // Now the switch statement looks ugly...
    // This is probably about as good as it gets, I suppose
    @IBAction func didUnwindToMainMenu(_ sender: UIStoryboardSegue){
        /*
        switch sender.source {
            
        case is MessengerVC:
            print("MessengerVC")
        case is PoolingVC:
            print("PoolingVC")
        case is CreateMessageVC:
            print("CreateMessageVC")
        case is MyProfileVC:
            print("MyProfileVC")
        case is SecretVC:
            print("SecretVC")
        case is FeedbackVC:
            print("FeedbackVC")
        default:
            print("NOTHING LOL")
        }*/
    }
    
    // MARK: UI Creation
    // This will be moved into another file soon
    var convTableHeightAnchor: NSLayoutConstraint?
    
    func createConvTable(){
        convTable = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        convTable.register(UITableViewCell.self, forCellReuseIdentifier: "conversationCell")
        convTable.dataSource = self
        convTable.delegate = self
        convTable.translatesAutoresizingMaskIntoConstraints = false
        convTable.isScrollEnabled = true
        
        self.view.addSubview(convTable)
        
        var combinedInsets = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        print(combinedInsets)
        
        convTable.topAnchor.constraint(equalTo: self.profileButton.bottomAnchor, constant: 2).isActive = true
        convTable.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        convTable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        convTableHeightAnchor = convTable.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.height - 65)
        convTableHeightAnchor?.isActive = true
    }
    
    var profileButtonHeightAnchor: NSLayoutConstraint?
    var settingsButtonHeightAnchor: NSLayoutConstraint?
    
    func createProfileButton(){
        profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        profileButton.backgroundColor = nebulaBlue
        profileButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        profileButton.setTitleColor(UIColor.lightGray, for: .disabled)
        profileButton.layer.cornerRadius = 10
        profileButton.setTitle("Profile", for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(profileButton)
        
        profileButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.47).isActive = true
        profileButtonHeightAnchor = profileButton.heightAnchor.constraint(equalToConstant: 40)
        profileButtonHeightAnchor?.isActive = true
        
        profileButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        profileButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    
    func createSettingsButton(){
        settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        settingsButton.backgroundColor = nebulaPurple
        settingsButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        settingsButton.setTitleColor(UIColor.lightGray, for: .disabled)
        settingsButton.layer.cornerRadius = 10
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(settingsButton)
        
        settingsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.47).isActive = true
        settingsButtonHeightAnchor = settingsButton.heightAnchor.constraint(equalTo: profileButton.heightAnchor)
        settingsButtonHeightAnchor?.isActive = true
        
        settingsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        settingsButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    
    var bottomBarHeightAnchor: NSLayoutConstraint?
    
    func createBottomBar(){
        bottomBarView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBarView.backgroundColor = panelColorTwo
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.layer.borderWidth = 1
        bottomBarView.layer.borderColor = UIColor.lightGray.cgColor
        bottomBarView.alpha = 0.8
        
        self.view.addSubview(bottomBarView)
        
        bottomBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottomBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomBarHeightAnchor = bottomBarView.heightAnchor.constraint(equalToConstant: 65)
        bottomBarHeightAnchor?.isActive = true
    }
    
    
    func createAddFriendsButton(){
        addFriendsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "GroupAddBlack") {
            addFriendsButton.setImage(image, for: .normal)
        }
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
        nebulaButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -3).isActive = true
    }
}