//
//  Card.swift
//  Swiping Cards
//
//  Created by Pablo Paciello on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit  

struct Card {
    let image: UIImage
    let name: String
    let profession: String
    let mainDescription: String
    let activity: String
    let backgroundColor: UIColor
    var likedCard: Bool
    
    init(dictionary: NSDictionary) {
        self.image = UIImage(named: (dictionary["Image"] as! String))!
        self.name = dictionary["Name"] as! String
        self.profession = dictionary["Profession"] as! String
        self.mainDescription = dictionary["Description"] as! String
        self.activity = dictionary["Activity"] as! String
        self.backgroundColor = UIColor.random
        self.likedCard = dictionary["Liked"] as! Bool
    }
    
    //Load some demo information into the [savedCards] Array.
    static func loadCards() -> [Card] {
        var savedCards = [Card]()
        if let URL = Bundle.main.url(forResource: "Cards", withExtension: "plist") {
            if let cardsFromPlist = NSArray(contentsOf: URL) {
                for card in cardsFromPlist{
                    let newCard = Card(dictionary: card as! NSDictionary)
                    savedCards.append(newCard)
                }
            }
        }
        return savedCards
    }
}
