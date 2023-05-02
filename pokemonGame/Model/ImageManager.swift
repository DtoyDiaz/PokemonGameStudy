//
//  ImageManager.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 19/04/23.
//
import Foundation

protocol ImageManagerDelegate {
    func didUpdateImage(image: ImageModel)
    func didFailWithErrorImage(error :  Error)
}

struct ImageManager{
    
    var delegate: ImageManagerDelegate?
    
    func fetchImage(url:String){
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ data, response, error in
                if error != nil {
                    self.delegate?.didFailWithErrorImage(error: error!)
                }
                if let safeData =  data {
                    if let image = self.parseJSON(imageData: safeData){
                        self.delegate?.didUpdateImage(image: image)}
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            let image = decodeData.sprites?.other?.officialArtwork?.frontDefault ?? " "
            return ImageModel(imageURL: image)
        } catch{
            return nil
        }
    }
}
