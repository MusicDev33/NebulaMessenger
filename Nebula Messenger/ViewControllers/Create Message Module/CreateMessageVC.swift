//
//  CreateMessageVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class CreateMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mainTable: UITableView!
    
    
    var selectedFriendsList = [String]()
    var passMsgList = [TerseMessage]()
    
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    var topView: CreateMessageView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mainCell")
        cell.textLabel?.text = GlobalUser.friends[indexPath.row]
        cell.detailTextLabel?.text = " "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        let cellText = (currentCell.textLabel?.text!)!
        if self.selectedFriendsList.contains(cellText){
            currentCell.detailTextLabel?.text = " "
            self.selectedFriendsList = self.selectedFriendsList.filter {$0 != cellText}
        }else{
            self.selectedFriendsList.append(cellText)
            currentCell.detailTextLabel?.text = "\u{2714}"
        }
        
        if self.selectedFriendsList.count > 0{
            topView?.continueButton.isHidden = false
        }else{
            topView?.continueButton.isHidden = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView = CreateMessageView(frame: self.view.frame)
        self.view.addSubview(topView!)
        mainTable = topView?.friendsTable
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        // Do any additional setup after loading the view.
        topView?.continueButton.isHidden = true
        
        topView?.backButton.addTarget(self, action: #selector(xButtonPressed), for: .touchUpInside)
        topView?.continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
    
    //MARK: Actions
    @objc func xButtonPressed() {
        self.performSegue(withIdentifier: "toMainMenuFromCreateMessage", sender: self)
    }
    
    @objc func continueButtonPressed() {
        if self.selectedFriendsList.count > 1{
            var quickInvolved = Utility.createGroupConvId(names: self.selectedFriendsList)
            quickInvolved = Utility.alphabetSort(preConvId: quickInvolved)
            let quickConvName = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: quickInvolved)
            
            print(quickInvolved)
            print(quickConvName)
            self.passFriend = quickConvName
            self.passInvolved = quickInvolved
            if GlobalUser.convNames.contains(quickConvName){
                print("YAAAA")
                let quickId = GlobalUser.masterDict[quickConvName]!.id
                print(quickId)
                MessageRoutes.getMessages(id: quickId!){messageList in
                    self.passMsgList = messageList
                    self.performSegue(withIdentifier: "toMessengerVCFromCreate", sender: self)
                }
            }else{
                self.performSegue(withIdentifier: "toMessengerVCFromCreate", sender: self)
            }
        }else{
            if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                let friend = self.selectedFriendsList[0]
                let quickId = GlobalUser.masterDict[friend]!.id
                MessageRoutes.getMessages(id: quickId!){messageList in
                    self.passMsgList = messageList
                    self.performSegue(withIdentifier: "toMessengerVCFromCreate", sender: self)
                }
            }else{
                self.performSegue(withIdentifier: "toMessengerVCFromCreate", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
