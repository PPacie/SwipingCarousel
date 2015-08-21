//
//  SwipingCarouselCollectionViewController.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

let reuseIdentifier = "Card"

class SwipingCarouselCollectionViewController: UICollectionViewController {
    
    // MARK: Model
    // Load allTheCards from SavedCards Class and reload the collection view when setted.
    private var allTheCards = SavedCards.loadCards() {
        didSet {
            collectionView?.reloadData()
        }
    }
        
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Return the number of items in the section
        return allTheCards.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CardCollectionViewCell
        
        // Configure the cell
        let currentCard = allTheCards[indexPath.row]
        cell.imageView.image = currentCard.image
        cell.nameLabel.text = currentCard.name
        cell.professionLabel.text = currentCard.profession
        cell.mainDescriptionLabel.text = currentCard.mainDescription
        cell.activityLabel.text = currentCard.activity
        
        return cell
    }
 

}
