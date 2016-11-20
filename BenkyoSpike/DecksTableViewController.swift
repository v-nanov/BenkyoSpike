//
//  DecksViewController.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 9/23/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

let decks = ["Katakana", "Hiragana", "N5"]

class DecksTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell") as! DeckTableViewCell
        let deckName = decks[indexPath.row]
        
        cell.deckNameLabel.text = deckName
        
        return cell
    }

    
}
