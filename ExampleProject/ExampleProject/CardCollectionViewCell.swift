//
//  CardCollectionViewCell.swift
//  ExampleProject
//
//  Created by Pablo Paciello on 10/27/16.
//  Copyright © 2016 PPacie. All rights reserved.
//

import UIKit
import SwipingCarousel

class CardCollectionViewCell: SwipingCarouselCollectionViewCell {    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

    static let reuseIdentifier = "CardCollectionViewCell"
    static var nib: UINib {
        get {
            return UINib(nibName: "CardCollectionViewCell", bundle: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Cell Corner and Shadows
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        // Emphasize the shadow on the bottom and right sides of the cell
        layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    func populateWith(card: Card) {
        profileImage.image = card.image
        nameLabel.text = card.name
        professionLabel.text = card.profession
        mainDescriptionLabel.text = card.mainDescription
        activityLabel.text = card.activity
        backgroundColor = card.backgroundColor
        likeImage.image = card.likedCard ? UIImage(named: "Liked") : UIImage(named:"Disliked")
    }
}
