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
    // Create the Color Pallete using the UIColor Extension
    let colors = UIColor.palette()
    
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
        cell.backgroundColor = colors[indexPath.item]
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
    //Extension to create a pallete of colors which is being used to set the cell.backgroundColor
private extension UIColor {
    
    class func colorFromRGB(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(Float(r) / 255), green: CGFloat(Float(g) / 255), blue: CGFloat(Float(b) / 255), alpha: 1)
    }
    
    class func palette() -> [UIColor] {
        let palette = [
            UIColor.colorFromRGB(85, g: 0, b: 255),
            UIColor.colorFromRGB(170, g: 0, b: 170),
            UIColor.colorFromRGB(85, g: 170, b: 85),
            UIColor.colorFromRGB(0, g: 85, b: 0),
            UIColor.colorFromRGB(255, g: 170, b: 0),
            UIColor.colorFromRGB(255, g: 85, b: 0),
            UIColor.colorFromRGB(0, g: 85, b: 85),
            UIColor.colorFromRGB(0, g: 85, b: 255),
            UIColor.colorFromRGB(170, g: 170, b: 255),
            UIColor.colorFromRGB(85, g: 0, b: 0),
            UIColor.colorFromRGB(170, g: 85, b: 85),
            UIColor.colorFromRGB(170, g: 255, b: 0),
            UIColor.colorFromRGB(85, g: 170, b: 255),
            UIColor.colorFromRGB(0, g: 170, b: 170)
        ]
        return palette
    }
}