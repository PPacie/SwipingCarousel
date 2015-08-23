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
        let name: String
        let profession: String
        let mainDescription: String
        let activity: String
    }
    
    //Load some demo information into the [savedCards] Array.
    class func loadCards() -> [Card] {
        var savedCards = [Card]()
        for index in 1...14 {
            let newCard = Card(image: UIImage(named:"image\(index).png"), name: "User\(index)", profession: "Profesion\(index)", mainDescription: "To share my idea with somebody! I want to start my own fashion company. It's going to be called Black Milk! Ping me if you want to chat 😜", activity: "Activity\(index)")
            savedCards.append(newCard)
        }
        return savedCards
    }

    
}

