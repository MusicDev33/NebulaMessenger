//
//  SecretVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/5/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import CoreBluetooth

class SecretVC: UIViewController, UITextFieldDelegate {
    
    var buildField: UITextField!
    var versionField: UITextField!
    var sendVersionButton: UIButton!
    
    var btButton: UIButton!
    
    var testButton: UIButton!
    
    // Bluetooth Stuff
    //var centralManager: CBCentralManager!

    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainMenuFromSecretView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildField = UITextField(frame: CGRect(x: 20, y: 100, width: 70, height: 20))
        buildField.placeholder = "B"
        buildField.font = UIFont.systemFont(ofSize: 15)
        buildField.borderStyle = UITextField.BorderStyle.roundedRect
        buildField.keyboardType = UIKeyboardType.decimalPad
        buildField.layer.borderColor = UIColor.lightGray.cgColor
        buildField.delegate = self
        
        versionField = UITextField(frame: CGRect(x: 20, y: 140, width: 70, height: 20))
        versionField.placeholder = "V"
        versionField.font = UIFont.systemFont(ofSize: 15)
        versionField.borderStyle = UITextField.BorderStyle.roundedRect
        versionField.keyboardType = UIKeyboardType.decimalPad
        versionField.layer.borderColor = UIColor.lightGray.cgColor
        versionField.delegate = self
        
        sendVersionButton = UIButton(frame: CGRect(x: 20, y: 180, width: 130, height: 20))
        sendVersionButton.setTitle("Send Version", for: .normal)
        sendVersionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendVersionButton.backgroundColor = nebulaPurple
        sendVersionButton.layer.cornerRadius = 8
        sendVersionButton.showsTouchWhenHighlighted = true
        sendVersionButton.addTarget(self, action: #selector(sendVersionButtonPressed), for: .touchUpInside)
        
        testButton = UIButton(frame: CGRect(x: 20, y: 220, width: 130, height: 20))
        testButton.setTitle("Test Route", for: .normal)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        testButton.backgroundColor = nebulaPurple
        testButton.layer.cornerRadius = 8
        testButton.showsTouchWhenHighlighted = true
        testButton.addTarget(self, action: #selector(testOutRoute), for: .touchUpInside)
        
        btButton = UIButton(frame: CGRect(x: 20, y: 260, width: 130, height: 20))
        btButton.setTitle("Bluetooth", for: .normal)
        btButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btButton.backgroundColor = nebulaBlue
        btButton.layer.cornerRadius = 8
        btButton.showsTouchWhenHighlighted = true
        btButton.addTarget(self, action: #selector(toBluetooth), for: .touchUpInside)
        
        self.view.addSubview(buildField)
        self.view.addSubview(versionField)
        self.view.addSubview(sendVersionButton)
        self.view.addSubview(testButton)
        self.view.addSubview(btButton)
        
        //Bluetooth
        //centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //Actions
    @objc func sendVersionButtonPressed(){
        if GlobalUser.username == "MusicDev"{
            SocketIOManager.setServerVersion(version: self.versionField.text!, build: self.buildField.text!)
            self.versionField.text = ""
            self.buildField.text = ""
        }
    }
    
    @objc func testOutRoute(){
        FriendRoutes.removeFriend(friend: "testaccount") {
            
        }
    }
    
    @objc func toBluetooth(){
        let btVC = BluetoothVC()
        btVC.modalPresentationStyle = .overCurrentContext
        self.present(btVC, animated: true, completion: nil)
    }
    /*
    //Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print("HI")
    }*/
}



