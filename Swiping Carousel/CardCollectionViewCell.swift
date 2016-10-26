//
//  CardCollectionViewCell.swift
//  Swiping Carousel
//
//  Created by Pablo Paciello on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

//Protocol to inform its delegate of a Card being swiped up or down.
protocol CardViewCellDelegate : class {
    func cardSwipedUp(_ cell: CardCollectionViewCell)
    func cardSwipedDown(_ cell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    weak var delegate: CardViewCellDelegate?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        // Add Gesture to Cell
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CardCollectionViewCell.handlePanGesture(_:))))
        // Cell Corner and Shadows
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.6
        // Emphasize the shadow on the bottom and right sides of the cell
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    func populateWith(card: Card) {
        
        profileImage.image = card.image
        nameLabel.text = card.name
        professionLabel.text = card.profession
        mainDescriptionLabel.text = card.mainDescription
        activityLabel.text = card.activity
        backgroundColor = card.backgroundColor        
        likeImage.image = card.likedCard! ? UIImage(named: "Liked") : UIImage(named:"Disliked")
    }
    
    // MARK: Gestures Handling
    
    fileprivate struct Constants {
        static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5 //140 //Distance required for the card to go off the screen.
        static let SwipeImageAnimationDuration: TimeInterval = 0.30 //Duration of the Animation when Swiping Up/Down.
        static let CenterImageAnimationDuration: TimeInterval = 0.20 //Duration of the Animation when image gets back to original postion.
    }
    
    fileprivate var swipeDistanceOnY = CGFloat() //Distance of the swipe over "y" axis.
    fileprivate var originalPoint = CGPoint()
    
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {        
        
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
    
    func afterSwipeAction() {
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
    
    func upAction() {
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = self.originalPoint //Move the card back to the original point.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
        }, completion: { (completion) -> Void in
            self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
            self.delegate?.cardSwipedUp(self) //Delegate the SwipeUp action and send the view with it.
        }) 
        
    }
    
    func downAction() {
        let maxDownPoint: CGPoint = CGPoint(x: originalPoint.x, y: 2 * frame.maxY)
        UIView.animate(withDuration: Constants.SwipeImageAnimationDuration, animations: { () -> Void in
            self.center = maxDownPoint //Move the card down off the screen.
            self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
            }, completion: { (completion) -> Void in
            self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
            self.removeFromSuperview()
            self.delegate?.cardSwipedDown(self) //Delegate the SwipeDown action and send the view with it.
        })
    }
}
