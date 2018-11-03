//
//  MainMenuVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/21/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    var isGroupChat = false
    
    var addFriendsMode = false
    
    var searchController: UISearchController!
    var searchResults = [String]()
    
    @IBOutlet weak var convTable: UITableView!
    @IBOutlet weak var poolButton: UIButton!
    
    @IBOutlet weak var addFriendsButton: UIButton!
    
    @IBOutlet weak var featureMessageLabel: UILabel!
    @IBOutlet weak var secretButton: UIButton!
    var searchConvMode = false
    
    // Add names here to allow the users to access pools
    let authorizedUsers = ["MusicDev", "ben666", "justinhunter20", "testaccount", "Mr.Rogers"]
    let adminUsers = ["MusicDev", "ben666", "wesperrett"]
    
    var passMsgList = [TerseMessage]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addFriendsMode{
            return searchResults.count
        }else if searchConvMode{
            return searchResults.count
        } else{
            return GlobalUser.conversations.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "conversationCell")
        if self.addFriendsMode{
            var cellText = self.searchResults[indexPath.row]
            if GlobalUser.friends.contains(cellText){
                cellText += "\u{2714}"
            }else if cellText == GlobalUser.username{
                cellText += " (You)\u{2714}"
            }else{
                
            }
            cell.textLabel?.text = cellText
        }else if self.searchConvMode{
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
        if self.addFriendsMode{
            let cellText = currentCell.textLabel?.text!
            if !(cellText?.contains("\u{2714}"))!{
                FriendRoutes.addFriend(friend: cellText!){
                    tableView.reloadData()
                    print("complete")
                }
            }
        }else{
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
            if userCount-1>1{
                print("Is Group Chat")
                self.isGroupChat = true
            }
            
            MessageRoutes.getMessages(id: self.passId){messageList in
                self.passMsgList = messageList
                tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(withIdentifier: "toMessengerVC", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let deleteAction = self.contextualDelete(forRowAtIndexPath: indexPath)
 
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func contextualDelete(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        // 1
        //var email = data[indexPath.row]
        // 2
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
            }else if self.addFriendsMode{
                FriendRoutes.searchFriends(characters: searchString!){friends in
                    self.searchResults = friends
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
    
    //Start of non-search part
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            self.featureMessageLabel.text = message
            self.featureMessageLabel.isHidden = false
        }
        
        self.secretButton.isHidden = false
        SocketIOManager.establishConnection()
        self.configureSearchController()
        if self.adminUsers.contains(GlobalUser.username) {
            self.secretButton.setTitle("Secret", for: .normal)
        }else if GlobalUser.username == "hockaboo"{
            self.secretButton.setTitle("Feedback", for: .normal)
        }else{
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy hh:mm:ss"
            
            // Creating the date object
            let now = df.string(from: Date())
            DiagnosticRoutes.sendInfo(info: "Logged in.", optional: now+": Login Event")
            self.secretButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.openSocket {
            
        }
        GlobalUser.currentConv = ""
        self.convTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.convTable.reloadData()
    }
    
    //MARK: Actions
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        self.searchController.isActive = false
        self.performSegue(withIdentifier: "toMyProfileView", sender: self)
    }
    
    @IBAction func poolButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPools", sender: self)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCreateMessageVC", sender: self)
    }
    
    @IBAction func addFriendsButtonPressed(_ sender: UIButton) {
        // Xtreme Hacking
        self.searchController.isActive = false
        self.addFriendsMode = !self.addFriendsMode
        if self.addFriendsMode{
            searchController.searchBar.placeholder = "Search for your friends!"
        }else{
            searchController.searchBar.placeholder = "Search for conversations here"
        }
        self.searchResults = []
        self.convTable.reloadData()
    }
    
    @IBAction func secretButtonPressed(_ sender: UIButton) {
        // Just in case!!!
        if self.adminUsers.contains(GlobalUser.username){
            self.performSegue(withIdentifier: "toSecretPage", sender: self)
        }else{
            let feedbackVC = FeedbackVC()
            feedbackVC.modalPresentationStyle = .overCurrentContext
            self.present(feedbackVC, animated: true, completion: nil)
        }
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
        }
    }
    
    // Unwinding
    /*
     The more of these I add, the more I get the feeling I'm doing something wrong/dumb...
     I bet I could probably collapse these into one or two functions,
     I'll do some research and find out.
    */
    @IBAction func didUnwindFromMessengerVC(_ sender: UIStoryboardSegue){
        guard sender.source is MessengerVC else {return}
    }
    
    @IBAction func didUnwindFromPools(_ sender: UIStoryboardSegue){
        guard sender.source is PoolingVC else {return}
    }
    
    @IBAction func didUnwindFromCreateMessage(_ sender: UIStoryboardSegue){
        guard sender.source is CreateMessageVC else {return}
    }
    
    @IBAction func didUnwindFromProfileView(_ sender: UIStoryboardSegue){
        guard sender.source is MyProfileVC else {return}
    }
    
    @IBAction func didUnwindFromSecretView(_ sender: UIStoryboardSegue){
        guard sender.source is SecretVC else {return}
    }
    
    @IBAction func didUnwindFromFeedbackView(_ sender: UIStoryboardSegue){
        guard sender.source is FeedbackVC else {return}
    }

}
