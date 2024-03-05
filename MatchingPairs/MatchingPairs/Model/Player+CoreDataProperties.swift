//
//  Player+CoreDataProperties.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 05.03.2024.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Int16

}

extension Player : Identifiable {

}
