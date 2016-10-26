//
//  CardCollectionViewCell.swift
//  Swiping Carousel
//
//  Created by Pablo Paciello on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

class CardCollectionViewCell: SwipingCarouselCollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    
        // Cell Corner and Shadows
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.6
        // Emphasize the shadow on the bottom and right sides of the cell
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    func populateWith(card: Card) {
        
        profileImage.image = card.image
        nameLabel.text = card.name
        professionLabel.text = card.profession
        mainDescriptionLabel.text = card.mainDescription
        activityLabel.text = card.activity
        backgroundColor = card.backgroundColor        
        likeImage.image = card.likedCard! ? UIImage(named: "Liked") : UIImage(named:"Disliked")
    }
}
