//
//  SwipingCarouselCellManager.swift
//  SwipingCarousel
//
//  Created by Pablo Paciello on 8/1/17.
//  Copyright © 2017 PPacie. All rights reserved.
//

import UIKit

final class SwpingCarouselCellManager {
    private var cell: SwipingCarouselCollectionViewCell!
    private lazy var swipeDistanceOnY = CGFloat() //Distance of the swipe over "y" axis.
    private lazy var originalPoint = CGPoint()
    
    init(withCell cell: SwipingCarouselCollectionViewCell) {
        self.cell = cell
    }
    
    //MARK: - Gestures Handling
    private enum Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5 //Distance required for the cell to go off the screen.
        static let SwipeImageAnimationDuration: TimeInterval = 0.30 //Duration of the Animation when Swiping Up/Down.
        static let CenterImageAnimationDuration: TimeInterval = 0.20 //Duration of the Animation when image gets back to original postion.
    }
    
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        //Get the distance of the Swipe on "y" axis.
        swipeDistanceOnY = sender.translation(in: self.cell).y
        
        switch sender.state {
        case .began:
            originalPoint = cell.center //Get the center of the Cell.
        case .changed:
            //Move the cell to the Y point while gesturing.
            cell.center = CGPoint(x: originalPoint.x, y: originalPoint.y + swipeDistanceOnY)
        case .ended:
            //Take action after the Swipe gesture ends.
            afterSwipeAction()
        default:
            break
        }
    }
    
    private func afterSwipeAction() {
        //First, we check if the swiped cell is the one in the middle of screen by cheking its size. If the cell is one of the sides, we send it back to its original position.
        if (cell.frame.size.height > cell.bounds.size.height) {
            //If the cell is the one at the center (biggest one), we proceed to check wheather or not the distance of the gesture is enough to move the cell off the screen (up or down).
            if swipeDistanceOnY > Constants.SwipeDistanceToTakeAction {
                downAction()
            } else if swipeDistanceOnY < -Constants.SwipeDistanceToTakeAction {
                upAction()
            } else {
                UIView.animate(withDuration: Constants.CenterImageAnimationDuration, animations: {
                    self.cell?.center = self.originalPoint
                })
            }
        } else {
            UIView.animate(withDuration: Constants.CenterImageAnimationDuration, animations: {
                self.cell?.center = self.originalPoint
            })
        }
    }
    
    private func upAction() {
        /* The maxUpperPoint will depend on deleteOnSwipeUp variable.
         Under default behavior, 'false', the cell will go back to the original position.
         If it's set to 'true' the cell will go down off the screen to be able to delete it throught its delegate. */
        let maxUpperPoint: CGPoint = cell.deleteOnSwipeUp ? CGPoint(x: originalPoint.x, y: 2 * cell.frame.minY) : originalPoint
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.cell?.center = maxUpperPoint //Move the cell to the maxUpperPoint.
            self.cell?.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
        }, completion: { (completion) -> Void in
            self.cell?.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
            self.cell?.delegate?.cellSwipedUp(self.cell!) //Delegate the SwipeUp action and send the view with it.
        })
    }
    
    func downAction() {
        /* The maxDownPoint will depend on deleteOnSwipeDown variable.
         Under default behavior, 'false', the cell will go back to the original position.
         If it's set to 'true' the cell will go down off the screen to be able to delete it throught its delegate. */
        let maxDownPoint: CGPoint = cell.deleteOnSwipeDown ? CGPoint(x: originalPoint.x, y: 2 * cell.frame.maxY) : originalPoint
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.cell?.center = maxDownPoint //Move the cell to the maxDownPoint.
            self.cell?.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
        }, completion: { (completion) -> Void in
            self.cell?.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
            self.cell?.delegate?.cellSwipedDown(self.cell!) //Delegate the SwipeDown action and send the view with it.
        })
    }
}
