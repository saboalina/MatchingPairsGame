//
//  CardViewModel.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 03.03.2024.
//

import Foundation
import UIKit
import CoreData

class CardViewModel {
    
    var games: [Game] = []
    var currentGameIndex = 0
    var score = 0
    var totalScore = 0

    var tappedCards: [CardCell] = []
    var matchedCardsIndex: [Int] = []
    let secondsPerGame = [60, 60, 30]

    var numberOfAttempts = 0
    var numberOfAttemptsUntilAMatch = 0
    var isStillTime = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let players: [Player] = []
    
    init() {
        self.setGames()
        self.setGame()
    }
    
    func setGame() {
        self.setSymbolsToPlay()
        self.setScore()
        self.setNumerOfMatchedCards()
    }
    
    func setGames() {
        self.games = GameManager.shared.games
        //there are 2 games in the api and i want 3 levels
        let lastGame = self.games[self.games.count - 1]
        self.games.append(lastGame)
        self.totalScore = 0
    }
    
    func setScore() {
        self.score = 0
    }
    
    func setNumerOfMatchedCards() {
        self.matchedCardsIndex = []
    }
    
    func getCurrentGame() -> Game {
        return games[currentGameIndex]
    }
    
    func getTimeForCurrentGame() -> Int {
        return secondsPerGame[currentGameIndex]
    }
    
    func getLevel() -> Int {
        return currentGameIndex
    }
    
    func setSymbolsToPlay() {
        //create the symbols for the cards
        var cardSymbols: [String] = []
        cardSymbols += games[currentGameIndex].symbols
        cardSymbols += games[currentGameIndex].symbols
        cardSymbols.shuffle()
        games[currentGameIndex].symbols = cardSymbols
    }
    
    func getScore() -> Int {
        return score
    }
    
    func resetGame() {
        self.setScore()
        self.setNumerOfMatchedCards()
        games[currentGameIndex].symbols.shuffle()
        self.tappedCards.removeAll()
    }

    func incrementToNextGame() {
        currentGameIndex += 1
    }
    
    //scoring algorithm
    func calculateScore() -> Int {
        
        let tryCount = numberOfAttempts - numberOfAttemptsUntilAMatch
        
        //level 1
        if currentGameIndex == 0 {
            if tryCount == 2 {
                //match the cards on the first try
                return 5
            } else if tryCount == 4 {
                //turned over 2 cards and there was no match and on the third card turned over was a match with one of the first 2
                return 3
            } else {
                //more attempts
                return 1
            }
        } 
        
        //level 2 and 3
        if tryCount == 2 {
            return 7
        } else if tryCount == 4 {
            return 5
        } else {
            return 1
        }
    }
    
    func cardTapped(card: CardCell, index: Int) {
        
        tappedCards.append(card)
        matchedCardsIndex.append(index)
        numberOfAttempts += 1
        
        if tappedCards.count == 2 {
            if self.isAMatch(tappedCards: tappedCards) {
                score += self.calculateScore()
                numberOfAttemptsUntilAMatch = numberOfAttempts
                self.tappedCards.removeAll()
            } else {
                matchedCardsIndex.removeLast()
                matchedCardsIndex.removeLast()
                flipBackTappedCards()
            }
            
        }
        
    }
    
    func flipBackTappedCards() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for card in self.tappedCards {
                card.flip()
            }            
            self.tappedCards.removeAll()
        }
    }
    
    
    func canFlip(index: Int) -> Bool {
        
        var result = true
        for elem in matchedCardsIndex {
            //a match has already been found for that card
            if elem == index {
                result = false
            }
        }
        
        return tappedCards.count < 2 && result
    }
    
    func isAMatch(tappedCards: [CardCell]) -> Bool {
        if tappedCards[0].symbolOfTheCard == tappedCards[1].symbolOfTheCard {
            return true
        }
        return false
    }
    
    
    func isGameOver() -> Bool {
        return isLevelComplete() && getLevel() == 2
    }
    
    func savePlayerInDB(playerName: String) {
        DataBaseManager.shared.addPlayer(name: playerName, score: totalScore)
    }
    
    func isLevelComplete() -> Bool {
        let currentGame = self.getCurrentGame()
        if matchedCardsIndex.count == currentGame.symbols.count {
            if currentGameIndex < 2 {
                totalScore += score
                self.incrementToNextGame()
                setGame()
            }
            return true
        }
        return false
    }
    
}
