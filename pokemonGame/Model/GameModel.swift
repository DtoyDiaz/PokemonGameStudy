//
//  GameModel.swift
//  pokemonGame
//
//  Created by Daniel Diaz on 19/04/23.
//

import Foundation

struct GameModel {
    var score = 0
    
//    Revisar Respuesta Correcta
    mutating func checkAnswer(_ userAnswer: String, _ correctAnswer: String) -> Bool {
        if userAnswer.lowercased() == correctAnswer.lowercased() {
            score += 1
            return true
        } else {
            return false
        }
    }
    
//    Obtener score
    func getScore() -> Int{
       return score
    }
    
//    ReiniciarScore
    mutating func setScore(score: Int){
        self.score = score
    }
}
