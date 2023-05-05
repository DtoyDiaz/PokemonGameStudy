//
//  ViewController.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 18/04/23.
//

import UIKit
import AlamofireImage

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
    var correctAnswer: String  = " "
    var correctAnswerImage: String = " "
    
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
        let userAnswer = sender.title(for: .normal)!
        if game.checkAnswer(userAnswer, correctAnswer){
            messageLabel.text = "Sí, es un \(userAnswer)"
            scoreLabel.text = "Puntaje: \(game.score)"
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
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
        correctAnswerImage = image.imageURL
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let url = URL(string: self.correctAnswerImage),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                let shadowImage = self.applyThresholdFilter(image: image, threshold: 0)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pokemonShadow.image = shadowImage
                }
            }
        }
    }
    
    func didFailWithErrorImage(error: Error) {
        print(error)
    }
    func applyThresholdFilter(image: UIImage, threshold: CGFloat) -> UIImage? {

        let context = CIContext()
        let ciImage = CIImage(image: image)
        let grayFilter = CIFilter(name: "CIPhotoEffectMono")
        grayFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let grayImage = grayFilter?.outputImage,
              let cgImage = context.createCGImage(grayImage, from: grayImage.extent) else {
                  return nil
                  
              }

        // Aplicar la umbralización a la imagen en escala de grises

        let thresholdFilter = CIFilter(name: "CIColorMatrix")
        thresholdFilter?.setDefaults()
        thresholdFilter?.setValue(CIVector(x: threshold, y: 0, z: 0, w: 0), forKey: "inputRVector")
        thresholdFilter?.setValue(CIVector(x: 0, y: threshold, z: 0, w: 0), forKey: "inputGVector")
        thresholdFilter?.setValue(CIVector(x: 0, y: 0, z: threshold, w: 0), forKey: "inputBVector")
        thresholdFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
        thresholdFilter?.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
        thresholdFilter?.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)

        guard let outputImage = thresholdFilter?.outputImage else {
            return nil
        }

        // Convertir la imagen resultante en una imagen de UIImage

        let finalImage = UIImage(ciImage: outputImage)
        return finalImage

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
