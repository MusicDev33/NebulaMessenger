//
//  MasterAudio.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 10/16/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation

import AVFoundation

var player: AVAudioPlayer?

// K this doesn't work on my phone, but it works in the simulator....WHY??????
func playIncomingMessage() {
    guard let url = Bundle.main.url(forResource: "Incoming-Message", withExtension: "caf") else {
        print("Sound won't play...")
        return }
    
    do {
        print("sound played")
        //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try AVAudioSession.sharedInstance().setActive(true)
        
        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
        
        /* iOS 10 and earlier require the following line:
         player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
        
        guard let player = player else { return }
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}
