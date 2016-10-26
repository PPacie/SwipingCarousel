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
    fileprivate var allTheCards = SavedCards.loadCards()
    
    fileprivate struct Constants {
        static let LikedImage = "Liked"
        static let DislikedImage = "Disliked"
        static let SegueIdentifier = "OpenChat"
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Return the number of items in the section
        return allTheCards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        
        // Configure the cell
        let currentCard = allTheCards[(indexPath as NSIndexPath).row]
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
    
    func cardSwipedUp(_ cell: CardCollectionViewCell) {
        
        print("Swiped Up - Card to Like: \(cell.nameLabel.text)")
        //Get the IndexPath from Cell being passed (swiped up).
        if let indexPath = collectionView?.indexPath(for: cell) {
            //Change the Like status to Like/Dislike.
            allTheCards[(indexPath as NSIndexPath).row].likedCard! = !allTheCards[(indexPath as NSIndexPath).row].likedCard!
            // Update the Like Image
            cell.likeImage.image = allTheCards[(indexPath as NSIndexPath).row].likedCard! ? UIImage(named: Constants.LikedImage) : UIImage(named:Constants.DislikedImage)
            //We are going to Scroll to the next item or to the previous one after Liking/Disliking a card. 
            //So, we check if we ara at the end of the Array to know if we can scroll to the next item.
            if (indexPath as NSIndexPath).row+1 < allTheCards.count {
                let nextIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: 0)
                collectionView?.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            } else { //Otherwise, we scroll back to the previous one.
                let previousIndexPath = IndexPath(row: (indexPath as NSIndexPath).row - 1, section: 0)
                collectionView?.scrollToItem(at: previousIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    func cardSwipedDown(_ cell: CardCollectionViewCell) {
        
        print("Swiped Down - Card to Delete: \(cell.nameLabel.text)")
        if let indexPath = collectionView?.indexPath(for: cell) { //Get the IndexPath from Cell being passed (swiped down).
            var indexPaths = [IndexPath]()
            indexPaths.append(indexPath)
            allTheCards.remove(at: (indexPath as NSIndexPath).row)                //Delete the swiped card from the Model.
            collectionView?.deleteItems(at: indexPaths)     //Delete the swiped card from CollectionView.
        }
    }
    
    //MARK: Segue Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if identifier == Constants.SegueIdentifier {
            if let selectedRowIndex = collectionView?.indexPathsForSelectedItems?.last {
                if let cell = collectionView?.cellForItem(at: selectedRowIndex) {
                    //We check if the selected Card is the one in the middle to open the chat. If it's not, we scroll to the side card selected.
                    if cell.frame.size.height > cell.bounds.size.height {
                        return true
                    } else {
                        collectionView?.scrollToItem(at: selectedRowIndex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
