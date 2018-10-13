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
    
    var addFriendsMode = false
    
    var searchController: UISearchController!
    var searchResults = [String]()
    
    @IBOutlet weak var convTable: UITableView!
    @IBOutlet weak var poolButton: UIButton!
    
    @IBOutlet weak var addFriendsButton: UIButton!
    
    @IBOutlet weak var featureMessageLabel: UILabel!
    @IBOutlet weak var secretButton: UIButton!
    
    // Add names here to allow the users to access pools
    let authorizedUsers = ["MusicDev", "ben666", "justinhunter20", "testaccount", "Mr.Rogers"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addFriendsMode{
            return searchResults.count
        }else{
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
        }else{
            cell.textLabel?.text = GlobalUser.convNames[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        if self.addFriendsMode{
            let cellText = currentCell.textLabel?.text!
            if !(cellText?.contains("\u{2714}"))!{
                FriendRoutes.addFriend(friend: cellText!){
                    tableView.reloadData()
                    print("complete")
                }
            }
        }else{
            let cellText = (currentCell.textLabel?.text!)!
            self.passId = GlobalUser.friendsConvDict[cellText]!
            self.passInvolved = GlobalUser.conversations[indexPath.row]
            self.passFriend = cellText
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
                                                let tempId = GlobalUser.friendsConvDict[GlobalUser.convNames[indexPath.row]]
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
        // 7
        action.image = UIImage(named: "Trashcan")
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.shouldShowResults = true
        self.convTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.convTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    // We're just going to pretend like I understand what these functions do
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.convTable.reloadData()
        }else if searchText.count > 3{
            let searchString = searchController.searchBar.text
            
            RouteLogic.searchFriends(characters: searchString!){friends in
                self.searchResults = friends
            }
            self.convTable.reloadData()
        }else{
            self.searchResults = []
            self.convTable.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString == "" {
            self.convTable.reloadData()
        }else if searchString!.count > 3{
            RouteLogic.searchFriends(characters: searchString!){friends in
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
        self.secretButton.isHidden = false
        SocketIOManager.establishConnection()
        RouteLogic.getFriendsAndConversations {
            self.configureSearchController()
        }
        if GlobalUser.username == "MusicDev" || GlobalUser.username == "ben666"{
            self.secretButton.setTitle("Secret", for: .normal)
        }else{
            self.secretButton.setTitle("Feedback", for: .normal)
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy hh:mm:ss"
            
            // Creating the date object
            let now = df.string(from: Date())
            DiagnosticRoutes.sendInfo(info: "Logged in.", optional: now+": Login Event")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        GlobalUser.currentConv = ""
        self.convTable.reloadData()
    }
    
    //MARK: Actions
    @IBAction func profileButtonPressed(_ sender: UIButton) {
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
        if GlobalUser.username == "MusicDev" || GlobalUser.username == "ben666"{
            self.performSegue(withIdentifier: "toSecretPage", sender: self)
        }else{
            self.performSegue(withIdentifier: "toFeedbackVC", sender: self)
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
            do {
                if msg["convId"].string!.contains(GlobalUser.username){
                    
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.destination is MessengerVC{
            let vc = segue.destination as? MessengerVC
            if self.passInvolved.components(separatedBy:":").count-1 > 1{
                vc?.skipNotif = true
            }
            vc?.id = self.passId
            vc?.involved = self.passInvolved
            vc?.friend = self.passFriend
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
