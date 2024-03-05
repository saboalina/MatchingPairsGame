//
//  GameViewController.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 04.03.2024.
//

import Foundation
import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var cardsCollectiobView: UICollectionView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var youWonLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    var viewModel = CardViewModel()
    
    var game: Game?
    var userName: String = ""
    var isDiscoModeOn = false
    
    var timer: Timer?
    var secondsRemaining = 0
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
         
        self.setInitialView()
    }
    
    //set the ui for the initial view
    func setInitialView() {
        self.game = viewModel.getCurrentGame()
        cardsCollectiobView.reloadData()
        cardsCollectiobView.isHidden = true
        gameNameLabel.text = game?.title
        youWonLabel.isHidden = true
        startResetButton.setTitle("Start Game", for: .normal)
        startResetButton.backgroundColor = game?.cardColor?.toUIColor()
        startResetButton.layer.cornerRadius = 10
        scoreLabel.text = ""

    }
    
    //set the view for the start of the game
    func startGame() {
        self.game = viewModel.getCurrentGame()
        startResetButton.backgroundColor = game?.cardColor?.toUIColor()
        cardsCollectiobView.reloadData()
        gameNameLabel.text = game?.title
        scoreLabel.text = "Score: \(self.getScore())"
        cardsCollectiobView.isHidden = false
        startResetButton.setTitle("Reset Game", for: .normal)
        youWonLabel.isHidden = true
        self.startTimer()
    }
    
    //set the view for the end of the game
    func lostGame() {
        self.youWonLabel.isHidden = false
        self.youWonLabel.text = "You lost!"
        self.cardsCollectiobView.isHidden = true
        self.startResetButton.setTitle("Start GAme", for: .normal)
        startResetButton.backgroundColor = game?.cardColor?.toUIColor()
        timerLabel.text = " 0 : 0"
    }
    
    func getScore() -> Int {
        return viewModel.getScore()
    }
    
    
    func checkForUIChanges() {
        if viewModel.isLevelComplete() {
            
            //user has done the level and has to go to the next one
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.youWonLabel.isHidden = false
                self.youWonLabel.text = "You won!"
                self.cardsCollectiobView.isHidden = true
                self.scoreLabel.text = "Score: \(self.getScore())"
                self.stopTimer()
                
                if self.viewModel.isGameOver() {
                    self.startResetButton.setTitle("Go to LeaderBoard", for: .normal)
                } else {
                    self.startResetButton.setTitle("Start Game", for: .normal)
                }
                
            }
        } else {
            scoreLabel.text = "Score: \(self.getScore())"
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if viewModel.isLevelComplete() && viewModel.getLevel() == 2 {
            viewModel.savePlayerInDB(playerName: userName)
            self.startResetButton.setTitle("Go to LeaderBoard", for: .normal)
            let leaderboardVC = storyboard?.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
                navigationController?.pushViewController(leaderboardVC, animated: true)
        } else {
            viewModel.resetGame()
            self.secondsRemaining = viewModel.getTimeForCurrentGame()
            self.startGame()
        }
    }
        
    func startTimer() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }

        
    @objc func timerTick() {

        timerLabel.text = "\(secondsRemaining) seconds"
        secondsRemaining -= 1

        if secondsRemaining <= 0 {
            timer?.invalidate()
            timer = nil
            self.lostGame()
            print("Timer completed")
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game!.symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
            
            fatalError("Unable to dequeue CardCell")
            
        }
        
        if cell.isShowingFront {
            cell.isShowingFront = false
        }

        let cellIndex = indexPath.item
        cell.setCell(index: cellIndex, game: self.game!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        if viewModel.canFlip(index: indexPath.item) {
            cell.flip()
            viewModel.cardTapped(card: cell, index: indexPath.item)
            self.checkForUIChanges()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemWidth = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isLandscape {
                if viewModel.getLevel() == 0 {
                    let availableWidth = view.frame.width
                    itemWidth = Int(availableWidth / 12)
                } else {
                    let availableWidth = view.frame.width
                    itemWidth = Int(availableWidth / 9)
                }
            } else {
                let paddingSpace = sectionInsets.left * 4
                let availableWidth = view.frame.width - paddingSpace
                itemWidth = Int(availableWidth / 4)
            }
        } else {
            if UIDevice.current.orientation.isLandscape {
                if viewModel.getLevel() == 0 {
                    let availableWidth = view.frame.width
                    itemWidth = Int(availableWidth / 5)
                } else {
                    let availableWidth = view.frame.width
                    itemWidth = Int(availableWidth / 7)
                }
            } else {
                let paddingSpace = sectionInsets.left * 4
                let availableWidth = view.frame.width - paddingSpace
                itemWidth = Int(availableWidth / 4)
            }
        }
        return CGSize(width: itemWidth, height: itemWidth)
    }
        
}
