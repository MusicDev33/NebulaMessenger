//
//  FeedbackVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var feedbackMessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTextView!.layer.borderWidth = 1
        feedbackTextView!.layer.borderColor = UIColor.lightGray.cgColor
        feedbackTextView.layer.cornerRadius = 10.0
    }
    
    // MARK: Actions
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToMainMenuFromFeedback", sender: self)
    }
    
    @IBAction func feedBackButtonPressed(_ sender: UIButton) {
        if feedbackTextView.text.count > 0{
            DiagnosticRoutes.sendInfo(info: feedbackTextView.text, optional: "Feedback Screen")
            self.feedbackMessageLabel.isHidden = false
            self.feedbackTextView.text = ""
        }
    }
}
