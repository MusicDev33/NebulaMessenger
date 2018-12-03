//
//  BluetoothVC.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 11/29/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothVC: UIViewController {
    
    var deviceUUID = UUID(uuidString: "80C7BD1B-D995-4B4F-80AD-729B774881C7")
    var deviceAttributes : String = ""
    var selectedPeripheral : CBPeripheral?
    var centralManager: CBCentralManager?
    var peripheralManager = CBPeripheralManager()
    
    var feedbackMessage: UILabel!
    var btButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createExitButton()
        createBTSendButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
    
    // MARK: BT
    func setDeviceValues() {
        let deviceData = deviceAttributes.components(separatedBy: "|")
    }
    
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let advertisementData = "Butt"
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[GlobalUser.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    
    func initService() {
        
        let serialService = CBMutableService(type: GlobalUser.SERVICE_UUID, primary: true)
        let rx = CBMutableCharacteristic(type: GlobalUser.RX_UUID, properties: GlobalUser.RX_PROPERTIES, value: nil, permissions: GlobalUser.RX_PERMISSIONS)
        serialService.characteristics = [rx]
        
        peripheralManager.add(serialService)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
    @objc func exitView(){
        self.dismiss(animated: true){
            
        }
    }
    
    //Create UI
    func createExitButton(){
        let exitButtonWidth = CGFloat(48)
        let exitButtonHeight = CGFloat(48)
        let exitButtonX = (view.frame.width/2)-(exitButtonWidth/2)
        let exitButtonY = CGFloat(100)
        let exitButton = UIButton(frame: CGRect(x: exitButtonX, y: exitButtonY, width: exitButtonWidth, height: exitButtonHeight))
        exitButton.setImage(UIImage(named: "BlackX"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitView), for: .touchUpInside)
        
        view.addSubview(exitButton)
    }
    
    func createBTSendButton(){
        let width = CGFloat(200)
        let height = CGFloat(30)
        let posX = (view.frame.width/2)-(width/2)
        let posY = CGFloat(180)
        btButton = UIButton(frame: CGRect(x: posX, y: posY, width: width, height: height))
        btButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btButton.backgroundColor = nebulaBlue
        btButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        btButton.setTitleColor(UIColor.lightGray, for: .disabled)
        btButton.layer.cornerRadius = 16
        btButton.setTitle("Test Bluetooth", for: .normal)
        btButton.addTarget(self, action: #selector(sendBT), for: .touchUpInside)
        
        view.addSubview(btButton)
    }
    
    //MARK: Actions
    
    @objc func sendBT(){
        centralManager?.connect(selectedPeripheral!, options: nil)
    }
}

extension BluetoothVC : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if (central.state == .poweredOn){
            
            self.centralManager?.scanForPeripherals(withServices: nil/*[GlobalUser.SERVICE_UUID]*/, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if (peripheral.identifier == deviceUUID) {
            selectedPeripheral = peripheral
            print(peripheral)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
}

extension BluetoothVC : CBPeripheralDelegate {
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?) {
        
        for characteristic in service.characteristics! {
            
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(GlobalUser.RX_UUID)) {
                let data = "booty".data(using: .utf8)
                peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                print("Sent: booty")
            }
            
        }
    }
}

extension BluetoothVC : CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn){
            
            initService()
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                
                let messageText = String(data: value, encoding: String.Encoding.utf8) as String!
                btButton.setTitle(messageText, for: .normal)
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}
