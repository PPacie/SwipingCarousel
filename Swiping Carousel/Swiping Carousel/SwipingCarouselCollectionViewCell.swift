//
//  SwipingCarouselCollectionViewCell.swift
//  Swiping Cards
//
//  Created by Pablo Paciello on 10/26/16.
//  Copyright © 2016 Pablo Paciello. All rights reserved.
//

import UIKit

//Protocol to inform the delegate of a SwipingCarouselCell that cell is being swiped up or down.
protocol SwipingCarouselCellDelegate : class {
    func cellSwipedUp(_ cell: UICollectionViewCell)
    func cellSwipedDown(_ cell: UICollectionViewCell)
}

class SwipingCarouselCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SwipingCarouselCellDelegate?
    var deleteOnSwipeUp = false
    var deleteOnSwipeDown = false
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        // Add Gesture to Cell
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
 
    // MARK: Gestures Handling
    fileprivate struct Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5 //Distance required for the cell to go off the screen.
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
            //Move the cell to the Y point while gesturing.
            self.center = CGPoint(x: originalPoint.x, y: originalPoint.y + swipeDistanceOnY)
        case .ended:
            //Take action after the Swipe gesture ends.
            afterSwipeAction()
        default:
            break
        }
    }
    
    fileprivate func afterSwipeAction() {
        //First, we check if the swiped cell is the one in the middle of screen by cheking its size. If the cell is one of the sides, we send it back to its original position.
        if (self.frame.size.height > self.bounds.size.height) {
            //If the cell is the one at the center (biggest one), we proceed to check wheather or not the distance of the gesture is enough to move the cell off the screen (up or down).
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
        /* The maxUpperPoint will depend on deleteOnSwipeUp variable.
           Under default behavior, 'false', the cell will go back to the original position.
           If it's set to 'true' the cell will go down off the screen to be able to delete it throught its delegate. */
        let maxUpperPoint: CGPoint = deleteOnSwipeUp ? CGPoint(x: originalPoint.x, y: 2 * frame.minY) : self.originalPoint
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = maxUpperPoint //Move the cell to the maxUpperPoint.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }, completion: { (completion) -> Void in
                self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
                self.delegate?.cellSwipedUp(self) //Delegate the SwipeUp action and send the view with it.
        })
        
    }
    
   fileprivate func downAction() {
        /* The maxDownPoint will depend on deleteOnSwipeDown variable.
           Under default behavior, 'false', the cell will go back to the original position.
           If it's set to 'true' the cell will go down off the screen to be able to delete it throught its delegate. */
        let maxDownPoint: CGPoint = deleteOnSwipeDown ? CGPoint(x: originalPoint.x, y: 2 * frame.maxY) : self.originalPoint
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = maxDownPoint //Move the cell to the maxDownPoint.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }, completion: { (completion) -> Void in
                self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
                self.delegate?.cellSwipedDown(self) //Delegate the SwipeDown action and send the view with it.
        })
    }
}
