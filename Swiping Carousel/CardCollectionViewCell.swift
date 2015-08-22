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
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    init(frame: CGRect, delegate: AnyObject) {
//        super.init(frame: frame)
//        
//        
//        // Initialization code
//        //  self.delegate                 = (delegate as ProfileSelectorViewController)
//        self.layer.cornerRadius = 10;
//        self.layer.shadowRadius = 4;
//        self.layer.shadowOpacity = 0.6;
//        self.layer.shadowOffset = CGSizeMake(3, 3);
//
// 
//    }
    
    // MARK: Gestures Handling
    
    private struct Constants {
        static let ActionMargin: CGFloat  = 200
    }
    
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var originalPoint = CGPoint()
    
    func handlePanGestureCell(sender: UIPanGestureRecognizer) {
        
        xFromCenter = sender.translationInView(self).x
        yFromCenter = sender.translationInView(self).y
        
        switch sender.state {
        case .Began:
            originalPoint = self.center
        case .Changed:
            println("Gesture Changed")
            self.center = CGPointMake(originalPoint.x, originalPoint.y + yFromCenter)
            println("yFromCenter: \(yFromCenter)")
        case .Ended:
            println("Gesture Ended")
            afterSwipeAction()
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if yFromCenter > Constants.ActionMargin {
            println("Down")
            downAction()
        } else if yFromCenter < -Constants.ActionMargin {
            println("UP")
            upAction()
        } else {
            UIView.animateWithDuration(0.15, animations: {
                println("CENTER: \(self.yFromCenter)")
                
               self.center = self.originalPoint
                
            })
        }
    }
    
    func upAction() {
        let finishPoint: CGPoint = CGPointMake(originalPoint.x, -frame.maxY)
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.center = finishPoint
        }) { (completion) -> Void in
            self.removeFromSuperview()
            self.setNeedsDisplay()
        }
        
        //        allTheCards.removeAtIndex(cellIndexPathToDelete.row)
        //        collectionView?.setNeedsDisplay()
        NSLog("YES")
    }
    
    func downAction() {
        let finishPoint: CGPoint = CGPointMake(originalPoint.x, 2 * frame.maxY)
        
        UIView.animateWithDuration(0.15, animations: {
            self.center = finishPoint
        })
        
        NSLog("NO")
    }


    
}
