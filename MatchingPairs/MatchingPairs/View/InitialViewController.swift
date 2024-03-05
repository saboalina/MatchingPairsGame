//
//  ViewController.swift
//  MatchingPairs
//
//  Created by Alina Sabo Brandus on 03.03.2024.
//

import UIKit

class InitialViewController: UIViewController {
        
    @IBOutlet weak var nameTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.shared.getData()
        nameTextfield.overrideUserInterfaceStyle = .light
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
    
        guard let name = nameTextfield.text, !name.isEmpty else {
            showAlert(message: "Please enter your name to start the game.")
            return
        }
        
        let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.userName = name
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    
    func showAlert(message: String) {
            
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}


