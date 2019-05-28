//
//  PublicStructs.swift
//  Nebula Messenger
//
//  Created by Shelby McCowan on 8/7/18.
//  Copyright © 2018 Shelby McCowan. All rights reserved.
//

import Foundation
import UIKit

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

struct TeacherQuestion {
    var question: String!
    var date: String!
    var questionMode: ModKeyMode!
    var answers: [String:String]!
    var correctAnswer: String!
    var questionNumber: Int!
    var optionalText: String!
    var groupID: String!
    var open: Bool!
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

extension UIView {
    func setGradient(colorOne: UIColor, colorTwo: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setGradientRandom(colorOne: UIColor, colorTwo: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        let addLocation = Double.random(in: 0.0...0.2)
        let subtractLocation = Double.random(in: 0.8...1.0)
        
        gradient.locations = [NSNumber(value: addLocation), NSNumber(value : subtractLocation)]
        
        let startX = Int.random(in: 0...1)
        let startY = Int.random(in: 0...1)
        
        gradient.startPoint = CGPoint(x: CGFloat(startX), y: CGFloat(startY))
        gradient.endPoint = CGPoint(x: CGFloat(startX - 1).magnitude, y: CGFloat(startY - 1).magnitude)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    func createRandomGradientView(colorOne: UIColor, colorTwo: UIColor) -> UIView{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        let bgView = UIView(frame: bounds)
        
        let addLocation = Double.random(in: 0.0...0.2)
        let subtractLocation = Double.random(in: 0.8...1.0)
        
        gradient.locations = [NSNumber(value: addLocation), NSNumber(value : subtractLocation)]
        
        let startX = Int.random(in: 0...1)
        let startY = Int.random(in: 0...1)
        
        gradient.startPoint = CGPoint(x: CGFloat(startX), y: CGFloat(startY))
        gradient.endPoint = CGPoint(x: CGFloat(startX - 1).magnitude, y: CGFloat(startY - 1).magnitude)
        
        bgView.layer.insertSublayer(gradient, at: 0)
        
        return bgView
    }
    
    func createRandomGradientHalf(colorOne: UIColor, colorTwo: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        let addLocation = Double.random(in: 0.0...0.2)
        let subtractLocation = Double.random(in: 0.8...1.0)
        
        gradient.locations = [NSNumber(value: addLocation), NSNumber(value : subtractLocation)]
        
        let startX = Int.random(in: 0...1)
        let startY = Double.random(in: 0.5...1)
        
        gradient.startPoint = CGPoint(x: CGFloat(startX), y: CGFloat(startY))
        gradient.endPoint = CGPoint(x: CGFloat(startX - 1).magnitude, y: CGFloat(startY - 1.5).magnitude)
        
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIViewController {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (event?.subtype == UIEvent.EventSubtype.motionShake) {
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
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
