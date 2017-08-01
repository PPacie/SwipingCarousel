//
//  SwipingCarouselCollectionViewCell.swift
//  Swiping Cards
//
//  Created by Pablo Paciello on 10/26/16.
//  Copyright © 2016 Pablo Paciello. All rights reserved.
//

import UIKit

//Protocol to inform that cell is being swiped up or down.
public protocol SwipingCarouselDelegate : class {
    func cellSwipedUp(_ cell: UICollectionViewCell)
    func cellSwipedDown(_ cell: UICollectionViewCell)
}

open class SwipingCarouselCollectionViewCell: UICollectionViewCell {
    
    public weak var delegate: SwipingCarouselDelegate?
    public var deleteOnSwipeUp = false
    public var deleteOnSwipeDown = false
    fileprivate var cellManager: SwpingCarouselCellManager!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        //Init the Cell Manager
        cellManager = SwpingCarouselCellManager(withCell: self)
        // Add Gesture to Cell
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))        
    }
    
    @objc fileprivate func handlePanGesture(_ sender: UIPanGestureRecognizer) {        
        cellManager.handlePanGesture(sender)
    }    
}
