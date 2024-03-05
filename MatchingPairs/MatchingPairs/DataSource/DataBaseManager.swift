//
//  DataBaseManager.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 05.03.2024.
//

import Foundation
import UIKit
import CoreData


class DataBaseManager {
    
    static let shared = DataBaseManager()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var players: [Player] = []
    
    func getData() -> [Player]{
        
        //get data but sort it descending by score
        let request = Player.fetchRequest() as NSFetchRequest<Player>
        let sort = NSSortDescriptor(key: "score", ascending: false)
        request.sortDescriptors = [sort]
        self.players = try! context.fetch(request)
        return self.players
    }
    
    //add a player to the database
    func addPlayer(name: String, score: Int) {
        
        let newPlayer = Player(context: self.context)
        newPlayer.name = name
        newPlayer.score = Int16(score)
        
        do {
            try self.context.save()
        } catch {
            
        }
    }
}
