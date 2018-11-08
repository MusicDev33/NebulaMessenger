//
//  SecretVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class SecretVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView1: UICollectionView!
    let cellIdentifier = "custom"
    
    //MARK: Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("CALLED")
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        let text = "Message One"
        
        cell.messageLabel.text = text
        cell.bubbleWidthAnchor?.constant = findSize(text: text, label: cell.messageLabel).width + 20
        
        if "MusicDev" == GlobalUser.username{
            cell.bubbleView.backgroundColor = userTextColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = otherTextColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageBubble", for: indexPath) as! MessageBubble
        var height: CGFloat = 80
        height = findSize(text: "Message One", label: cell.messageLabel).height + 30
        return CGSize(width: view.frame.width, height: height)
    }
    
    func findSize(text: String, label: UILabel) -> CGRect{
        let constraintRect = CGSize(width: 0.8 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let returnRect = text.boundingRect(with: constraintRect,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [.font: label.font],
                                           context: nil)
        return returnRect
    }
    
    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromSecretView", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 375, height: 100)
        layout.scrollDirection = .vertical
        
        collectionView1 = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView1.delegate = self
        self.collectionView1.dataSource = self
        collectionView1.register(MessageBubble.self, forCellWithReuseIdentifier: "messageBubble")
        self.collectionView1.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView1.backgroundColor = UIColor.red
        //collectionView1.register(CustomCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        self.view.addSubview(collectionView1)
        
        collectionView1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView1.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        collectionView1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        //collectionView1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        collectionView1.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}

class CustomCell: UICollectionViewCell{
    
}
