//
//  ViewController.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 18/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pokemonShadow: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var pokemonManager = PokemonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "¿Quién es este Pokémon?"
        scoreLabel.text = "Puntaje: 0"
        messageLabel.isHidden = true
        createButtons()
        pokemonManager.fetchPokemon()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let buttonContent = sender.title(for: .normal) {
            print(sender.titleLabel?.text)
        } else {
            print("Button title not set")
        }
    }
    
    func createButtons() {
        for button in answerButtons{
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 10.0
        }
    }
    
}

