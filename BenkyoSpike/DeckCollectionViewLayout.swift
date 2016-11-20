//
//  DeckCollectionViewLayout.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 9/25/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class DeckCollectionViewLayout: UICollectionViewFlowLayout {
    
    static let cardSize = CGSize(width: 200, height: 300)
    
    fileprivate struct Constants {
        static let activeDistance: CGFloat = 200
        static let zoomFactor: CGFloat = 0.3
        static let itemWidth: CGFloat = cardSize.width       //Width of the Cell.
        static let itemHeight: CGFloat = cardSize.height      //Height of the Cell.
        static let minLineSpacing: CGFloat = 50.0
    }

    
    override public func prepare() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        minimumLineSpacing = 50.0
        sectionInset = UIEdgeInsetsMake(100.0, 60.0, 100.0, 60.0)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView!.contentOffset
        visibleRect.size = collectionView!.bounds.size
        
        for itemAttributes in array! {
            //let newAttributes: UICollectionViewLayoutAttributes = itemAttributes
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            if itemAttributesCopy.frame.intersects(rect) {
                let distance = visibleRect.midX - itemAttributes.center.x
                let normalizedDistance = distance / Constants.activeDistance
                if (abs(distance)) < Constants.activeDistance {
                    let zoom = 1 + Constants.zoomFactor*(1 - abs(normalizedDistance))
                    itemAttributesCopy.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    itemAttributesCopy.zIndex = 1
                }
            }
            attributesCopy.append(itemAttributesCopy)
        }
        return attributesCopy
    }

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + (collectionView!.bounds.width / 2.0)
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        
        if let array = super.layoutAttributesForElements(in: targetRect) {
            for layoutAttributes in array {
                let itemHorizontalCenter: CGFloat = layoutAttributes.center.x
                if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    // Invalidate the Layout when the user is scrolling
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
}
