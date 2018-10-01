//
//  MainMenuVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/21/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    @IBOutlet weak var convTable: UITableView!
    @IBOutlet weak var poolButton: UIButton!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalUser.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "conversationCell")
        cell.textLabel?.text = GlobalUser.convNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        let cellText = (currentCell.textLabel?.text!)!
        self.passId = GlobalUser.friendsConvDict[cellText]!
        self.passInvolved = GlobalUser.conversations[indexPath.row]
        self.passFriend = cellText
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toMessengerVC", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SocketIOManager.establishConnection()
        RouteLogic.getFriendsAndConversations {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.convTable.reloadData()
    }
    
    //MARK: Actions
    @IBAction func poolButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPools", sender: self)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCreateMessageVC", sender: self)
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

}
