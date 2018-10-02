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
                    print("complte")
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
        
        SocketIOManager.establishConnection()
        RouteLogic.getFriendsAndConversations {
            self.configureSearchController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    //MARK: Sockets
    func openSocket(completion: () -> Void) {
        SocketIOManager.socket.on("message") { ( data, ack) -> Void in
            guard let parsedData = data[0] as? String else { return }
            let msg = JSON.init(parseJSON: parsedData)
            print("Socket Beginning - Main Menu")
            // print(parsedData)
            // print(msg)
            do {
                let tempMsg = TerseMessage(_id: "", //Fix this
                    sender: msg["sender"].string!,
                    body: msg["body"].string!,
                    dateTime: msg["dateTime"].string!,
                    read: false)
                if msg["convId"].string!.contains(GlobalUser.username){
                    
                }
            } catch {
                print(msg)
                print("Error JSON: \(error)")
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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

}
