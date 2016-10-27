//
//  CardViewController.swift
//  ExampleProject
//
//  Created by Pablo Paciello on 10/27/16.
//  Copyright © 2016 PPacie. All rights reserved.
//

import UIKit
import SwipingCarousel

class CardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! { didSet {
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        }
    }
    
    // MARK: Model
    // Load allTheCards from SavedCards Class.
    fileprivate var allTheCards = Card.loadCards()
    fileprivate let segueIdentifier = "OpenChat"
    
    //MARK: Segue Navigation    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if identifier == segueIdentifier {
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
    // MARK: UICollectionView DataSource
extension CardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Return the number of items in the section
        return allTheCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        
        // Configure the cell
        cell.populateWith(card: allTheCards[(indexPath as NSIndexPath).row])
        cell.delegate = self
        cell.deleteOnSwipeDown = true
        return cell
    }
}
    // MARK: Conform to the SwipingCarousel Delegate
extension CardViewController: SwipingCarouselCellDelegate {
    
    func cellSwipedUp(_ cell: UICollectionViewCell) {
        
        guard let cell = cell as? CardCollectionViewCell else { return }
        print("Swiped Up - Card to Like: \(cell.nameLabel.text!)")
        //Get the IndexPath from Cell being passed (swiped up).
        if let indexPath = collectionView?.indexPath(for: cell) {
            //Change the Like status to Like/Dislike.
            allTheCards[(indexPath as NSIndexPath).row].likedCard! = !allTheCards[(indexPath as NSIndexPath).row].likedCard!
            // Update the Like Image
            cell.likeImage.image = allTheCards[(indexPath as NSIndexPath).row].likedCard! ? UIImage(named: "Liked") : UIImage(named:"Disliked")
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
    
    func cellSwipedDown(_ cell: UICollectionViewCell) {
        
        guard let cell = cell as? CardCollectionViewCell else { return }
        print("Swiped Down - Card to Delete: \(cell.nameLabel.text!)")
        if let indexPath = collectionView?.indexPath(for: cell) { //Get the IndexPath from Cell being passed (swiped down).
            var indexPaths = [IndexPath]()
            indexPaths.append(indexPath)
            allTheCards.remove(at: (indexPath as NSIndexPath).row)                //Delete the swiped card from the Model.
            collectionView?.deleteItems(at: indexPaths)     //Delete the swiped card from CollectionView.
            cell.removeFromSuperview()
        }
    }
}
