//
//  CardsViewFlowLayout.swift
//  Swiping Carousel
//
//  Created by Pablo Surfate on 8/20/15.
//  Copyright (c) 2015 Pablo Paciello. All rights reserved.
//

import UIKit

private struct CardsViewFlowConstants {
    static let activeDistance: CGFloat = 200
    static let zoomFactor: CGFloat = 0.3
    static let itemWidth: CGFloat = 200
    static let itemHeight: CGFloat = 315
    static let minLineSpacing: CGFloat = 50.0
    
}

class CardsViewFlowLayout:  UICollectionViewFlowLayout {
    

    override func prepareLayout() {
        super.prepareLayout()
        
        self.itemSize = CGSizeMake(CardsViewFlowConstants.itemWidth, CardsViewFlowConstants.itemHeight)
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = CardsViewFlowConstants.minLineSpacing;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var array = super.layoutAttributesForElementsInRect(rect)
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        
        for attributes in array! {
            var newAttributes: UICollectionViewLayoutAttributes = attributes as! UICollectionViewLayoutAttributes
            if CGRectIntersectsRect(attributes.frame, rect) {
                let distance = CGRectGetMidX(visibleRect) - attributes.center.x
                let normalizedDistance = distance / CardsViewFlowConstants.activeDistance
                if (abs(distance)) < CardsViewFlowConstants.activeDistance {
                    let zoom = 1 + CardsViewFlowConstants.zoomFactor*(1 - abs(normalizedDistance))
                    newAttributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    newAttributes.zIndex = 1
                }
            }
        }
        
        return array
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
               
        
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(collectionView!.bounds) / 2.0)
        
        let targetRect = CGRectMake(proposedContentOffset.x, 0.0, collectionView!.bounds.size.width, collectionView!.bounds.size.height)
        
        let array = super.layoutAttributesForElementsInRect(targetRect)
        
        for layoutAttributes in array! {
            let itemHorizontalCenter: CGFloat = layoutAttributes.center.x
            if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
    
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)
    }
    
    
    // Invalidate the Layout when the user is scrolling
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

}
