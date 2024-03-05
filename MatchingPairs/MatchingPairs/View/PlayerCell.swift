//
//  PlayerCell.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 05.03.2024.
//

import Foundation
import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func setCell(player: Player) {
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
        
    }
    
    
}
