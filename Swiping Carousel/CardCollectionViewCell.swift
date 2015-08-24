//
//  CardCollectionViewCell.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

//Protocol to inform its delegate of a Card being swiped up or down.
protocol CardViewCellDelegate : class {
    func cardSwipedUp(cell: CardCollectionViewCell)
    func cardSwipedDown(cell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    weak var delegate: CardViewCellDelegate?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        // Add Gesture to Cell
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePanGesture:"))
        // Cell Corner and Shadows
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.6
        // Emphasize the shadow on the bottom and right sides of the cell
        self.layer.shadowOffset = CGSizeMake(4, 4)
        
    }
    
    // MARK: Gestures Handling
    
    private struct Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = 140 //Distance required for the card to go off the screen.
    }
    
    var swipeDistanceOnY = CGFloat() //Distance of the swipe over "y" axis.
    var originalPoint = CGPoint()
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {        
        
        swipeDistanceOnY = sender.translationInView(self).y //Get the distance of the Swipe on "y" axis.
        
        switch sender.state {
        case .Began:
            originalPoint = self.center //Get the center of the Cell.
        case .Changed:
            //Move the card to the Y point while gesturing.
            self.center = CGPointMake(originalPoint.x, originalPoint.y + swipeDistanceOnY)
        case .Ended:
            //Take action after the Swipe gesture ends.
            afterSwipeAction()
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        //First, we check if the swiped card is the one in the middle of screen by cheking its size. If the card is one of the sides, we send it back to its original position.
        if (self.frame.size.height > self.bounds.size.height) {
            //If the card is the one at the center (biggest one), we proceed to check wheather or not the distance of the gesture is enough to move the card off the screen (up or down).
            if swipeDistanceOnY > Constants.SwipeDistanceToTakeAction {
                downAction()
            } else if swipeDistanceOnY < -Constants.SwipeDistanceToTakeAction {
                upAction()
            } else {
                UIView.animateWithDuration(0.20, animations: {
                    self.center = self.originalPoint
                })
            }
        } else {
            UIView.animateWithDuration(0.20, animations: {
                self.center = self.originalPoint
            })
        }
        
    }
    
    func upAction() {
        let maxTopPoint: CGPoint = CGPointMake(originalPoint.x, -frame.maxY)
        UIView.animateWithDuration(0.50, animations: { () -> Void in
            self.center = maxTopPoint //Move the card up off the screen.
            self.superview?.userInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
        }) { (completion) -> Void in
            self.superview?.userInteractionEnabled = true // Re-activate the user interaction.
            self.removeFromSuperview()
            self.delegate?.cardSwipedUp(self) //Delegate the SwipeUp action and send the view with it.
            
        }
        
    }
    
    func downAction() {
        let maxDownPoint: CGPoint = CGPointMake(originalPoint.x, 2 * frame.maxY)
        UIView.animateWithDuration(0.50, animations: { () -> Void in
            self.center = maxDownPoint //Move the card down off the screen.
            self.superview?.userInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }) { (completion) -> Void in
            self.superview?.userInteractionEnabled = true // Re-activate the user interaction.
            self.removeFromSuperview()
            self.delegate?.cardSwipedDown(self) //Delegate the SwipeDown action and send the view with it.
        }
        
    }

    
}
