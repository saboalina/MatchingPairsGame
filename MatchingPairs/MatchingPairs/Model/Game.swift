//
//  Game.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 04.03.2024.
//

import Foundation

struct Game: Codable {
    
    let title: String
    let cardColor: CardColor?
    let cardSymbol: String
    var symbols: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case symbols
    }
}
