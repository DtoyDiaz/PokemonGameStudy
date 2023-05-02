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
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()
    
    var randomFourPokemon: [PokemonModel] = []{
        didSet {
            setButtonTitles()
        }
    }
    var correctAnswer: String  = ""
    var correctAnswerImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "¿Quién es este Pokémon?"
        messageLabel.text  = " "
        pokemonManager.delegate = self
        imageManager.delegate = self
        
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
    
    func setButtonTitles() {
        for (index, button) in answerButtons.enumerated() {
            DispatchQueue.main.async { [self] in
                button.setTitle(randomFourPokemon[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
    
}

extension ViewController: PokemonManagerDelegate{
    func didUpdatePokemon(pokemon: [PokemonModel]) {
        randomFourPokemon = pokemon.choose(4)
        
        let index = Int.random(in: 0...3)
        let imageData = randomFourPokemon[index].imageURL
        correctAnswer = randomFourPokemon[index].name
        
        imageManager.fetchImage(url: imageData)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: ImageManagerDelegate {
    func didUpdateImage(image: ImageModel) {
        print(image.imageURL)
    }
    
    func didFailWithErrorImage(error: Error) {
        print(error)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection{
    func choose(_ n: Int) -> Array<Element>{
        Array(shuffled().prefix(n))
    }
}


