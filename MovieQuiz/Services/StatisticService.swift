//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 17.12.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 {
            return 0.0
        }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100.0
    }

    var gamesCount: Int {
        get {
            return getIntegerFor(.gamesCount)
        }
        set {
            set(newValue, forKey: .gamesCount)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = getIntegerFor(.bestGameCorrect)
            let total = getIntegerFor(.bestGameTotal)
            let date = getObjectFor(.bestGameDate) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            set(newValue.correct, forKey: .bestGameCorrect)
            set(newValue.total, forKey: .bestGameTotal)
            set(newValue.date, forKey: .bestGameDate)
        }
    }

    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        gamesCount += 1
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        if currentGameResult.isBetterThan(bestGame) {
            bestGame = currentGameResult
        }
    }

    private enum Keys: String, CaseIterable {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }

    private let storage: UserDefaults = .standard

    private var totalCorrectAnswers: Int {
        get {
            return getIntegerFor(.totalCorrectAnswers)
        }
        set {
            set(newValue, forKey: .totalCorrectAnswers)
        }
    }

    private var totalQuestionsAsked: Int {
        get {
            return getIntegerFor(.totalQuestionsAsked)
        }
        set {
            set(newValue, forKey: .totalQuestionsAsked)
        }
    }

    private func getIntegerFor(_ key: Keys) -> Int {
        return storage.integer(forKey: key.rawValue)
    }

    private func getObjectFor(_ key: Keys) -> Any? {
        return storage.object(forKey: key.rawValue)
    }

    private func set(_ value: Int, forKey key: Keys) {
        storage.set(value, forKey: key.rawValue)
    }

    private func set(_ value: Any?, forKey key: Keys) {
        storage.set(value, forKey: key.rawValue)
    }

    func reset() {
        for key in Keys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
}
