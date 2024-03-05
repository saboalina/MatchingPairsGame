//
//  ThemeManager.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 03.03.2024.
//

import Foundation

class GameManager {
    // MARK: - Variables

    static let shared = GameManager()

    var games: [Game] = []
    
    func getData() {
        let api = API()
        api.fetchGames() { games in
            guard games != nil else { return }
            self.games = games!
        }
    }
    
}
