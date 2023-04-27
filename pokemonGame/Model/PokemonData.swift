//
//  PokemonData.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 19/04/23.
//
import Foundation

// MARK: - PokemonData
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
