//
//  PoolingVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 9/23/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit

class PoolingVC: UIViewController {

    @IBOutlet weak var futureUpdateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        futureUpdateLabel.text = "Look at all this empty space! It's almost like something's going to go here or something! Swipe right to go back."
    }
    
    @IBAction func tappedOnScreen(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToMainMenuFromPools", sender: self)
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
