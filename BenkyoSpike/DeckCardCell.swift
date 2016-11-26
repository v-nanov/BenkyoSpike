//
//  DeckCell.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 11/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class DeckCardCell: UICollectionViewCell {
    
    //#MARK: Statics
    static let identifier = "DeckCardCell"
    
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //#MARK: Properties
  
    
    var cardFront = DeckCardFrontView.Card()
    var cardBack = DeckCardBackView.Card()
    var card:CardObject = CardObject(front: "front", back: "back") {
        didSet {
            cardFront.textLabel?.text = card.frontValue
            cardBack.textLabel?.text = card.backValue
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cardrect = CGRect(x: 0, y: 0, width: DeckCollectionViewLayout.cardSize.width, height: DeckCollectionViewLayout.cardSize.height)
        
        cardBack.frame = cardrect
        cardFront.frame = cardrect
        addSubview(cardFront)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DeckCardCell.tapped))
        tap.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tap)
        contentView.isUserInteractionEnabled = true
    }
    
    func tapped() {
        NSLog("\(DeckCardCell.identifier) :Tapped!")
        flipCard(animated: true)
    }
    
    func flipCard(animated:Bool=false) {
        let dur:TimeInterval = animated ? 0.5 : 0
        if card.flipped {
            UIView.transition(from: cardBack, to: cardFront, duration: dur, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        }else{
            UIView.transition(from: cardFront, to:cardBack , duration: dur, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        }
        card.flipped = !card.flipped
    }
    
}

class CardView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Cell Corner and Shadows
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.borderWidth = 1
        // Emphasize the shadow on the bottom and right sides of the cell
        layer.shadowOffset = CGSize(width: 4, height: 4)
        
        
    }
}


