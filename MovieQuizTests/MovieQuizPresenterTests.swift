//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by ALEXANDER BUTYGIN on 21.01.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quizStep: QuizStepModel) {}
    func show(quizResult: QuizResultsModel) {}
    func highlightScreenForAnswerResult(isCorrect: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(imageData: emptyData, text: "Question Text", correctAnswer: true)
        let quizStepModel = sut.convert(quizQuestion: question)

        XCTAssertEqual(quizStepModel.imageData, emptyData)
        XCTAssertEqual(quizStepModel.question, "Question Text")
        XCTAssertEqual(quizStepModel.questionNumber, "1/10")
    }
}
