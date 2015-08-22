//
//  SwipingCarouselCollectionViewController.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

let reuseIdentifier = "Card"

let ACTION_MARGIN: CGFloat      = 150      // Distance from center where action applies.   Higher = swipe further in order for the action to be called.


class SwipingCarouselCollectionViewController: UICollectionViewController {
    
    // MARK: Model
    // Load allTheCards from SavedCards Class and reload the collection view when setted.
    private var allTheCards = SavedCards.loadCards() {
        didSet {
            collectionView?.reloadData()
        }
    }
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
        cell.layer.cornerRadius = 10;
        cell.addGestureRecognizer(UIPanGestureRecognizer(target: cell, action: "handlePanGestureCell:"))
//        cell.layer.shadowRadius = 4;
//        cell.layer.shadowOpacity = 0.6;
//        cell.layer.shadowOffset = CGSizeMake(3, 3);
        return cell
    }
     
    // MARK: Gestures Handling
    
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var originalPoint = CGPoint()
    var swipedCell = UICollectionViewCell()
    var cellIndexPathToDelete = NSIndexPath()

    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let swipeLocation = sender.locationInView(collectionView!)
        if let swipeIndexPath = collectionView?.indexPathForItemAtPoint(swipeLocation) {
            swipedCell = collectionView!.cellForItemAtIndexPath(swipeIndexPath)!
            swipedCell.multipleTouchEnabled = false
            cellIndexPathToDelete = swipeIndexPath
        } else {
            return
        }
        
        xFromCenter = sender.translationInView(swipedCell).x
        yFromCenter = sender.translationInView(swipedCell).y
      
        switch sender.state {
        case .Began:
            originalPoint = swipedCell.center
        case .Changed:
             println("Gesture Changed")
             swipedCell.center = CGPointMake(originalPoint.x, originalPoint.y + yFromCenter)
             println("yFromCenter: \(yFromCenter)")
        case .Ended:
            println("Gesture Ended")
            afterSwipeAction()
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if yFromCenter > ACTION_MARGIN {
            println("Down")
            downAction()
        } else if yFromCenter < -ACTION_MARGIN {
            println("UP")
            upAction()
        } else {
            UIView.animateWithDuration(0.15, animations: {
                println("CENTER: \(self.yFromCenter)")
                
                self.swipedCell.center = self.originalPoint
              
            })
        }
    }
    
    func upAction() {
        let finishPoint: CGPoint = CGPointMake(originalPoint.x, -self.view.frame.maxY)
        UIView.animateWithDuration(0.15, animations: {
            self.swipedCell.center = finishPoint
        })
//        allTheCards.removeAtIndex(cellIndexPathToDelete.row)
//        collectionView?.setNeedsDisplay()
        NSLog("YES")
    }
    
    func downAction() {
        let finishPoint: CGPoint = CGPointMake(originalPoint.x, 2 * self.view.frame.maxY)
        
        UIView.animateWithDuration(0.15, animations: {
            self.swipedCell.center = finishPoint
        })
    
        NSLog("NO")
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