//
//  LeaderBoardViewController.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 05.03.2024.
//

import Foundation
import UIKit
import CoreData
import MyStaticLibrary

class LeaderBoardViewController: UIViewController {
    
    @IBOutlet weak var playersTable: UITableView!
    @IBOutlet weak var leaderBoardView: UIView!
    
    var players: [Player] = []
    var timer: Timer?
    var secondsRemaining = 0
    
    override func viewDidLoad() {
        //get data from database
        self.players = DataBaseManager.shared.getData()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        //change background color using a static library 
        let myStaticLibrary = MyStaticLibrary()
        myStaticLibrary.setRandomColor(to: leaderBoardView)
    }
    
}

extension LeaderBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayerCell
        cell.placeLabel.text = "\(indexPath.item + 1). "
        cell.setCell(player: players[indexPath.item])
        return cell
    }
    
    
}
