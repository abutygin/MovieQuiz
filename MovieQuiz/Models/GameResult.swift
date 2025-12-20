//
//  GameResult.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 17.12.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ otherResult: GameResult) -> Bool {
        correct > otherResult.correct
    }
}
