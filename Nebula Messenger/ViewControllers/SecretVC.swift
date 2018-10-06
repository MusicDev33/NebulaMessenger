//
//  SecretVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class SecretVC: UIViewController {
    
    //MARK: Methods
    func showOutgoingMessage(color: UIColor, text: String) {
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleImageSize = CGSize(width: label.frame.width + 28,
                                     height: label.frame.height + 20)
        
        let outgoingMessageView = UIImageView(frame:
            CGRect(x: view.frame.width - bubbleImageSize.width - 10,
                   y: view.frame.height - bubbleImageSize.height - 150,
                   width: bubbleImageSize.width,
                   height: bubbleImageSize.height))
        
        let bubbleImage = UIImage(named: "OutgoingMessageBubble")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        outgoingMessageView.image = bubbleImage
        outgoingMessageView.tintColor = color
        
        view.addSubview(outgoingMessageView)
        
        label.center = outgoingMessageView.center
        
        view.addSubview(label)
    }
    
    func showIncomingMessage(color: UIColor, text: String) {
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * view.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleImageSize = CGSize(width: label.frame.width + 28,
                                     height: label.frame.height + 20)
        
        let incomingMessageView = UIImageView(frame:
            CGRect(x: 10,
                   y: view.frame.height - bubbleImageSize.height - 43,
                   width: bubbleImageSize.width,
                   height: bubbleImageSize.height))
        
        let bubbleImage = UIImage(named: "IncomingMessageBubble")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        incomingMessageView.image = bubbleImage
        incomingMessageView.tintColor = color
        
        view.addSubview(incomingMessageView)
        
        label.center = incomingMessageView.center
        
        view.addSubview(label)
    }
    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromSecretView", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let purple = UIColor(red: 198/255, green: 65/255, blue: 168/255, alpha: 1)
        let blue = UIColor(red: 2/255, green: 148/255, blue: 227/255, alpha: 1)
        
        showOutgoingMessage(color: purple, text: "Super long text and stuff that goes on and on forever and does stuff!")
        
        showIncomingMessage(color: blue, text: "Hi!")
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
