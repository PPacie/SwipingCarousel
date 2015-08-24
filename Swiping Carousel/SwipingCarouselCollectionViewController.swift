//
//  SwipingCarouselCollectionViewController.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

let reuseIdentifier = "Card"

class SwipingCarouselCollectionViewController: UICollectionViewController, CardViewCellDelegate{
    
    // MARK: Model
    // Load allTheCards from SavedCards Class.
    private var allTheCards = SavedCards.loadCards()

    
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
        cell.backgroundColor = currentCard.backgroundColor
        cell.delegate = self
        return cell
    }
    // MARK: Conform to the CellCollectionView Delegate
    
    func cardSwipedUp(cell: CardCollectionViewCell) {
        println("Swiped Up - Card to Save: \(cell.nameLabel.text)")
        
        if let indexPath = collectionView?.indexPathForCell(cell) { //Get the IndexPath from Cell being passed (swiped up).
            var indexPaths = [NSIndexPath]()
            indexPaths.append(indexPath)
            allTheCards.removeAtIndex(indexPath.row)                //Delete the swiped card from the Model.
            collectionView?.deleteItemsAtIndexPaths(indexPaths)     //Delete the swiped card from CollectionView.
        }

    }
    
    func cardSwipedDown(cell: CardCollectionViewCell) {
        println("Swiped Down - Card to Delete: \(cell.nameLabel.text)")
        if let indexPath = collectionView?.indexPathForCell(cell) {
            var indexPaths = [NSIndexPath]()
            indexPaths.append(indexPath)
            allTheCards.removeAtIndex(indexPath.row)
            collectionView?.deleteItemsAtIndexPaths(indexPaths)
        }
    }

}