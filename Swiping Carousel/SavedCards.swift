//
//  SavedCards.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

class SavedCards {
    
    struct Card {
        let image: UIImage?
        let name: String?
        let profession: String?
        let mainDescription: String?
        let activity: String?
        let backgroundColor: UIColor
        let likedCard: Bool?
        
        init(dictionary: NSDictionary) {
            self.image = UIImage(named: (dictionary["Image"] as! String))
            self.name = dictionary["Name"] as? String
            self.profession = dictionary["Profession"] as? String
            self.mainDescription = dictionary["Description"] as? String
            self.activity = dictionary["Activity"] as? String
            self.backgroundColor = UIColor.random
            self.likedCard = dictionary["Liked"] as? Bool
        }
    }
    
    //Load some demo information into the [savedCards] Array.
    class func loadCards() -> [Card] {
        var savedCards = [Card]()
        if let URL = NSBundle.mainBundle().URLForResource("Cards", withExtension: "plist") {
            if let cardsFromPlist = NSArray(contentsOfURL: URL) {
                for card in cardsFromPlist{
                    let newCard = Card(dictionary: card as! NSDictionary)
                    savedCards.append(newCard)
                }
            }
        }
        return savedCards
    }

}

    //MARK: Extensions
    //Function to create a Random number in CGFloat.
private extension CGFloat {
    static func random (max: Int) -> CGFloat {
        return CGFloat (arc4random() % UInt32(max))
    }
}

    //Function to create a color from RGB and Computed property to get a Random UIColor based on this UIColorFromRGB method.
private extension UIColor {
    
    class func colorFromRGB(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(Float(r) / 255), green: CGFloat(Float(g) / 255), blue: CGFloat(Float(b) / 255), alpha: 1)
    }

    class var random: UIColor {
        switch arc4random() % 13 {
        case 0: return UIColor.colorFromRGB(85, g: 0, b: 255)
        case 1: return UIColor.colorFromRGB(170, g: 0, b: 170)
        case 2: return UIColor.colorFromRGB(85, g: 170, b: 85)
        case 3: return UIColor.colorFromRGB(0, g: 85, b: 0)
        case 4: return UIColor.colorFromRGB(255, g: 170, b: 0)
        case 5: return UIColor.colorFromRGB(255, g: 85, b: 0)
        case 6: return UIColor.colorFromRGB(0, g: 85, b: 85)
        case 7: return UIColor.colorFromRGB(0, g: 85, b: 255)
        case 8: return UIColor.colorFromRGB(170, g: 170, b: 255)
        case 9: return UIColor.colorFromRGB(85, g: 0, b: 0)
        case 10: return UIColor.colorFromRGB(170, g: 85, b: 85)
        case 11: return UIColor.colorFromRGB(85, g: 170, b: 255)
        case 12: return UIColor.colorFromRGB(0, g: 170, b: 170)
        default : return UIColor.blackColor() //Not going to be called
        }
    }
}
