//
//  ImageData.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 19/04/23.
//
import Foundation

// MARK: - PokemonData
struct ImageData: Codable {
    let sprites: Sprites?
}

// MARK: - Sprites
class Sprites: Codable {
    let other: Other?
    
    init( other: Other?) {
        self.other = other
    }
}

// MARK: - Other
struct Other: Codable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault, frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
