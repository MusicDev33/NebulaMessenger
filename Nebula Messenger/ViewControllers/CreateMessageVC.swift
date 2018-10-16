//
//  CreateMessageVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class CreateMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var selectedFriendsList = [String]()
    
    var passId = ""
    var passInvolved = ""
    var passFriend = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mainCell")
        cell.textLabel?.text=GlobalUser.friends[indexPath.row]
        cell.detailTextLabel?.text=" "
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
            self.continueButton.isHidden = false
        }else{
            self.continueButton.isHidden = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.continueButton.isHidden = true
    }
    
    //MARK: Actions
    @IBAction func xButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromCreateMessage", sender: self)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        self.passInvolved = Utility.createConvId(names: self.selectedFriendsList)
        self.performSegue(withIdentifier: "toMessengerVCFromCreate", sender: self)
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
                var passList = self.selectedFriendsList
                passList.append(GlobalUser.username)
                let tempConvId = Utility.createConvId(names: passList)
                let friend = Utility.getFriendsFromConvId(user: GlobalUser.username, convId: tempConvId)
                
                self.passFriend = friend
                vc?.friend = self.passFriend
                if GlobalUser.convNames.contains(friend){
                    vc?.involved = GlobalUser.involvedDict[self.passFriend]!
                    vc?.id = GlobalUser.friendsConvDict[self.passFriend]!
                }else{
                    vc?.involved = tempConvId
                    vc?.friend = friend
                }
                
            }else{
                vc?.friend = self.selectedFriendsList[0]
                self.passFriend = self.selectedFriendsList[0]
                if GlobalUser.convNames.contains(self.selectedFriendsList[0]){
                    vc?.involved = GlobalUser.involvedDict[self.passFriend]!
                    vc?.id = GlobalUser.friendsConvDict[self.passFriend]!
                }else{
                    var passList = self.selectedFriendsList
                    passList.append(GlobalUser.username)
                    vc?.involved = Utility.createConvId(names: passList)
                }
            }
        }
    }
}
