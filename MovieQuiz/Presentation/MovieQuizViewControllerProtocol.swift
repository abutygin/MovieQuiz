//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 21.01.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quizStep: QuizStepModel)
    func show(quizResult: QuizResultsModel)
    func highlightScreenForAnswerResult(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}
