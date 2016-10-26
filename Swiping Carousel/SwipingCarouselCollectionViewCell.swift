//
//  SwipingCarouselCollectionViewCell.swift
//  Swiping Carousel
//
//  Created by Pablo Paciello on 10/26/16.
//  Copyright © 2016 Pablo Paciello. All rights reserved.
//

import UIKit

//Protocol to inform its delegate of a Card being swiped up or down.
protocol SwipingCarouselCellDelegate : class {
    func cardSwipedUp(_ cell: UICollectionViewCell)
    func cardSwipedDown(_ cell: UICollectionViewCell)
}

class SwipingCarouselCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SwipingCarouselCellDelegate?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        // Add Gesture to Cell
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
 
    // MARK: Gestures Handling
    fileprivate struct Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5 //Distance required for the card to go off the screen.
        static let SwipeImageAnimationDuration: TimeInterval = 0.30 //Duration of the Animation when Swiping Up/Down.
        static let CenterImageAnimationDuration: TimeInterval = 0.20 //Duration of the Animation when image gets back to original postion.
    }
    
    fileprivate var swipeDistanceOnY = CGFloat() //Distance of the swipe over "y" axis.
    fileprivate var originalPoint = CGPoint()
    
    @objc fileprivate func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        
        swipeDistanceOnY = sender.translation(in: self).y //Get the distance of the Swipe on "y" axis.
        
        switch sender.state {
        case .began:
            originalPoint = self.center //Get the center of the Cell.
        case .changed:
            //Move the card to the Y point while gesturing.
            self.center = CGPoint(x: originalPoint.x, y: originalPoint.y + swipeDistanceOnY)
        case .ended:
            //Take action after the Swipe gesture ends.
            afterSwipeAction()
        default:
            break
        }
    }
    
    fileprivate func afterSwipeAction() {
        //First, we check if the swiped card is the one in the middle of screen by cheking its size. If the card is one of the sides, we send it back to its original position.
        if (self.frame.size.height > self.bounds.size.height) {
            //If the card is the one at the center (biggest one), we proceed to check wheather or not the distance of the gesture is enough to move the card off the screen (up or down).
            if swipeDistanceOnY > Constants.SwipeDistanceToTakeAction {
                downAction()
            } else if swipeDistanceOnY < -Constants.SwipeDistanceToTakeAction {
                upAction()
            } else {
                UIView.animate(withDuration: Constants.CenterImageAnimationDuration, animations: {
                    self.center = self.originalPoint
                })
                
            }
        } else {
            UIView.animate(withDuration: Constants.CenterImageAnimationDuration, animations: {
                self.center = self.originalPoint
            })
        }
        
    }
    
   fileprivate func upAction() {
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = self.originalPoint //Move the card back to the original point.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }, completion: { (completion) -> Void in
                self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
                self.delegate?.cardSwipedUp(self) //Delegate the SwipeUp action and send the view with it.
        })
        
    }
    
   fileprivate func downAction() {
        let maxDownPoint: CGPoint = CGPoint(x: originalPoint.x, y: 2 * frame.maxY)
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = maxDownPoint //Move the card down off the screen.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }, completion: { (completion) -> Void in
                self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
                self.delegate?.cardSwipedDown(self) //Delegate the SwipeDown action and send the view with it.
        })
    }
}
