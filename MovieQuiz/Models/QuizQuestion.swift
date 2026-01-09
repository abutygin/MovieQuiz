//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 13.12.2025.
//

import Foundation

struct QuizQuestion {
    let image: Data
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
