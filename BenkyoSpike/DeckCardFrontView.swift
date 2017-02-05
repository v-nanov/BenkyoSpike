//
//  DeckCollectionViewCell.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 9/23/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class DeckCardFrontView: CardView {
    
  
    @IBOutlet weak var frontText: UILabel!
    
    static let identifier = "DeckCardFrontView"
    
    @IBOutlet var textLabel:UILabel?
    
    static func Card() -> DeckCardFrontView {
        let card = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as! DeckCardFrontView
        
        return card
    }
    

  
}
