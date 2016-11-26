//
//  DeckCollectionViewController.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 9/23/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

let cards = ["あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ"]


class DeckCollectionViewController: UIViewController {
    
    //#MARK: IB Outlets
    @IBOutlet var cardsCV:UICollectionView?
    
    //#MARK: Properties
    
    var layout = DeckCollectionViewLayout()
    var deck:[CardObject] = []
    
    //#MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCV!.register(DeckCardCell.nib, forCellWithReuseIdentifier: DeckCardCell.identifier)
        cardsCV!.delegate = self
        cardsCV!.dataSource = self
        cardsCV!.collectionViewLayout = layout
        
        var i = 0
        for c  in cards {
           let card = CardObject(front: "front \(i)", back: c)
            deck.append(card)
            i = i+1
        }
    }
    
    
   
}

extension DeckCollectionViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog(String(indexPath.item))
    }
}

extension DeckCollectionViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeckCardCell.identifier, for: indexPath as IndexPath) as! DeckCardCell
        let card = deck[indexPath.row]
        cell.card = card
//        frontCell.cardName.text = cards[indexPath.item]
        
        return cell
    }
}
