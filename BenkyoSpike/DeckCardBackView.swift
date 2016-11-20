//
//  DeckCollectionViewBackCell.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 11/20/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class DeckCardBackView: CardView {
    
    static let identifier = "DeckCardBackView"
    
    @IBOutlet var textLabel:UILabel?
    
    static func Card() -> DeckCardBackView {
        let card = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as! DeckCardBackView
       
        return card
    }
    
    
}
