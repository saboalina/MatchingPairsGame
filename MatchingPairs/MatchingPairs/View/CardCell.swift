//
//  CardCell.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 03.03.2024.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var faceUpView: UIView!
    @IBOutlet weak var faceDownView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    
    var symbolOfTheCard: String?
    var isShowingFront = false
    var index: Int = 0
    var game: Game?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func flip() {
        UIView.transition(from: isShowingFront ? faceUpView : faceDownView,
                          to: isShowingFront ? faceDownView : faceUpView,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews],
                          completion: nil)
        
        isShowingFront.toggle()
    }
    
    func setCell(index: Int, game: Game) {
        
        self.index = index
        self.game = game
        
        faceUpView.isHidden = !isShowingFront
        faceDownView.isHidden = isShowingFront
        
        configureFaceUpView()
        configureFaceDownView()
        
    }
    
    func configureFaceUpView() {
        
        symbolLabel.adjustsFontSizeToFitWidth = true
        symbolLabel.minimumScaleFactor = 0.5
        symbolLabel.text = self.game!.symbols[self.index]
        self.symbolOfTheCard = self.game!.symbols[self.index]
        
        faceUpView.layer.cornerRadius = 10
        faceUpView.layer.borderWidth = 2
        faceUpView.layer.borderColor = (self.game?.cardColor?.toUIColor())?.cgColor
        
    }

    func configureFaceDownView() {
        
        faceDownView.layer.cornerRadius = 10
        faceDownView.backgroundColor = self.game?.cardColor?.toUIColor()
    }
    
}
