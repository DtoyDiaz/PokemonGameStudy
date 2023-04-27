//
//  PokemonManager.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 19/04/23.
//

import Foundation

struct PokemonManager{
    
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=905&offset=0"
    
//    Pasos consumir API
    //    1. Create/get URL
    //    2. Create the URLSession
    //    3. Give the session a task
    //    4. start the task
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData =  data {
                    if let pokemon = self.parseJSON(pokemonData: safeData){
                        print(pokemon)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodeData.results?.map{
                PokemonModel(name: $0.name ?? "", imageURL: $0.url ?? "")
            }
            return pokemon
        } catch{
            return nil
        }
    }
}
