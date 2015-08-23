//
//  CardCollectionViewCell.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit


class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        // ...
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePanGesture:"))
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(1, 1)

    }
    
    // MARK: Gestures Handling
    
    private struct Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = 150
    }
    
    var swipeDistanceOnY = CGFloat() //Distance of the swipe over "y" axis.
    
    var originalPoint = CGPoint()
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        swipeDistanceOnY = sender.translationInView(self).y //Get the distance of the Swipe on "y" axis.
        
        switch sender.state {
        case .Began:
            originalPoint = self.center //Get the center of the Cell.
        case .Changed:
            println("Gesture Changed")
            self.center = CGPointMake(originalPoint.x, originalPoint.y + swipeDistanceOnY)
        case .Ended:
            println("Gesture Ended")
            afterSwipeAction()
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if swipeDistanceOnY > Constants.SwipeDistanceToTakeAction {
            println("Down")
            downAction()
        } else if swipeDistanceOnY < -Constants.SwipeDistanceToTakeAction {
            println("UP")
            upAction()
        } else {
            UIView.animateWithDuration(0.15, animations: {
                println("CENTER: \(self.swipeDistanceOnY)")
               self.center = self.originalPoint
            })
        }
    }
    
    func upAction() {
        let maxTopPoint: CGPoint = CGPointMake(originalPoint.x, -frame.maxY)
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.center = maxTopPoint
        }) { (completion) -> Void in
            self.removeFromSuperview()
            self.setNeedsDisplay()
        }
    }
    
    func downAction() {
        let maxDownPoint: CGPoint = CGPointMake(originalPoint.x, 2 * frame.maxY)
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.center = maxDownPoint
            }) { (completion) -> Void in
                self.removeFromSuperview()
                self.setNeedsDisplay()
        }
    }

    
}
