//
//  PublicStructs.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

// UI Colors
let borderColorOne = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)
let borderColorTwo = UIColor(red: 199/255, green: 210/255, blue: 229/255, alpha: 1)

let panelColorOne = UIColor(red: 220/255, green: 220/255, blue: 225/255, alpha: 1)
let panelColorTwo = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)

let panelColorOneAlt = UIColor(red: 235/255, green: 235/255, blue: 240/255, alpha: 1)

// Disabled Button
let disabledButtonColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)

// Main Colors
let nebulaPurple = UIColor(red: 198/255, green: 65/255, blue: 168/255, alpha: 1)
let nebulaBlue = UIColor(red: 2/255, green: 148/255, blue: 227/255, alpha: 1)
let nebulaGreen = UIColor(red: 59/255, green: 219/255, blue: 167/255, alpha: 1)
let nebulaSky = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)
let nebulaFlame = UIColor(red: 206/255, green: 65/255, blue: 14/255, alpha: 1)
let nebulaYellow = UIColor(red: 216/255, green: 216/255, blue: 17/255, alpha: 1)
let nebulaBurn = UIColor(red: 206/255, green: 143/255, blue: 16/255, alpha: 1)
let nebulaPink = UIColor(red: 1, green: 209/255, blue: 220/255, alpha: 1)

// Misc
let nebulaSkyBorder = UIColor(red: 17/255, green: 214/255, blue: 214/255, alpha: 1)

var userTextColor = nebulaPurple
var otherTextColor = nebulaBlue

let globalColors = [nebulaPurple, nebulaBlue, nebulaGreen, nebulaSky, nebulaFlame, nebulaYellow, nebulaBurn, nebulaPink]
let colorsList = ["nebulaPurple", "nebulaBlue", "nebulaGreen", "nebulaSky", "nebulaFlame", "nebulaYellow", "nebulaBurn", "nebulaPink"]
var colorsDict = [String:UIColor]()

func setColors(){
    var index = 0
    for color in colorsList{
        colorsDict[color] = globalColors[index]
        index += 1
    }
    
    let userTextString = UserDefaults.standard.string(forKey: "userTextColor") ?? ""
    let otherTextString = UserDefaults.standard.string(forKey: "otherTextColor") ?? ""
    if userTextString.count > 1{
        userTextColor = colorsDict[userTextString] ?? nebulaPurple
    }
    
    if otherTextString.count > 1{
        otherTextColor = colorsDict[otherTextString] ?? nebulaBlue
    }
}


struct Message{
    let sender: String?
    let body: String?
    let friend: String?
    let id: String?
    let convId: String?
    let dateTime: String?
    let read: Bool?
}

struct User{
    let id: String?
    let name: String?
    let username: String?
    var friends: [String]?
    
}

struct TerseMessage {
    let _id: String?
    let sender: String?
    let body: String?
    let dateTime: String?
    let read: Bool?
}

struct PublicPool {
    let coordinates: [Double]?
    let poolId: String?
    let name: String?
    let creator: String?
    let connectionLimit: Int?
    let usersConnected: [String]?
}

struct ServerMessage {
    let message: String?
    let success: Bool?
}

struct Conversation {
    var involved: String
    var name: String
    let id: String?
    var lastRead: String
    var lastMessage: String
}


// Simple solution for detecting emojis in a string
// Thanks, StackOverflow
extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            previousScalar = scalar
        }
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        return chars
    }
}
