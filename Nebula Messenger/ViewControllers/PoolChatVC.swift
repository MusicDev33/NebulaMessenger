//
//  PoolChatVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/9/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class PoolChatVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    
    @IBOutlet weak var messagesCollection: UICollectionView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    var currentPoolMessages = [TerseMessage]()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPoolMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageTextView.delegate = self
        messageTextView!.layer.borderWidth = 1
        messageTextView!.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 10.0
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToPoolingView", sender: self)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
