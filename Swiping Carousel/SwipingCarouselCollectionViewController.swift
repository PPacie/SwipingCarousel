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
    
    private struct Constants {
        static let LikedImage = "Liked"
        static let DislikedImage = "Disliked"
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
        cell.profileImage.image = currentCard.image
        cell.nameLabel.text = currentCard.name
        cell.professionLabel.text = currentCard.profession
        cell.mainDescriptionLabel.text = currentCard.mainDescription
        cell.activityLabel.text = currentCard.activity
        cell.backgroundColor = currentCard.backgroundColor
        cell.delegate = self
        cell.likeImage.image = currentCard.likedCard! ? UIImage(named: Constants.LikedImage) : UIImage(named:Constants.DislikedImage)
        return cell
    }
    // MARK: Conform to the CellCollectionView Delegate
    
    func cardSwipedUp(cell: CardCollectionViewCell) {
        
        println("Swiped Up - Card to Like: \(cell.nameLabel.text)")
        //Get the IndexPath from Cell being passed (swiped up).
        if let indexPath = collectionView?.indexPathForCell(cell) {
            //Change the Like status to Like/Dislike.
            allTheCards[indexPath.row].likedCard! = !allTheCards[indexPath.row].likedCard!
            // Update the Like Image
            cell.likeImage.image = allTheCards[indexPath.row].likedCard! ? UIImage(named: Constants.LikedImage) : UIImage(named:Constants.DislikedImage)
            //We are going to Scroll to the next item or to the previous one after Liking/Disliking a card. 
            //So, we check if we ara at the end of the Array to know if we can scroll to the next item.
            if indexPath.row+1 < allTheCards.count {
                let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: 0)
                collectionView?.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            } else { //Otherwise, we scroll back to the previous one.
                let previousIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: 0)
                collectionView?.scrollToItemAtIndexPath(previousIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            }
        }
    }
    
    func cardSwipedDown(cell: CardCollectionViewCell) {
        
        println("Swiped Down - Card to Delete: \(cell.nameLabel.text)")
        if let indexPath = collectionView?.indexPathForCell(cell) { //Get the IndexPath from Cell being passed (swiped down).
            var indexPaths = [NSIndexPath]()
            indexPaths.append(indexPath)
            allTheCards.removeAtIndex(indexPath.row)                //Delete the swiped card from the Model.
            collectionView?.deleteItemsAtIndexPaths(indexPaths)     //Delete the swiped card from CollectionView.
        }
    }

}