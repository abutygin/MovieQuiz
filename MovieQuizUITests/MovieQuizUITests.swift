//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by ALEXANDER BUTYGIN on 21.01.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {try super.setUpWithError()
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() {
        let quizScreen = QuizScreen()
        quizScreen.waitForLoading()
        let firstPosterData = quizScreen.getImageData()

        quizScreen.tapYesButton()
        quizScreen.waitForButtonIsHittable()
        let secondPosterData = quizScreen.getImageData()

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexText = quizScreen.getIndexText()
        XCTAssertEqual(indexText, "2/10", "Проверка номера вопроса")
    }

    func testNoButton() {
        let quizScreen = QuizScreen()
        quizScreen.waitForLoading()
        let firstPosterData = quizScreen.getImageData()

        quizScreen.tapNoButton()
        quizScreen.waitForButtonIsHittable()
        let secondPosterData = quizScreen.getImageData()

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexText = quizScreen.getIndexText()
        XCTAssertEqual(indexText, "2/10", "Проверка номера вопроса")
    }

    func testQuizResultAlert() {
        let quizScreen = QuizScreen()
        quizScreen.waitForLoading()
        for _ in 0..<10 {
            quizScreen.waitForButtonIsHittable()
            quizScreen.tapNoButton()
            quizScreen.waitForButtonIsNotHittable()
        }
        let alertScreen = AlertScreen()
        alertScreen.waitForShowing()
        XCTAssertEqual("Этот раунд окончен!", alertScreen.getTitle(), "Проверка заголовка алерта")
        XCTAssertEqual("Сыграть ещё раз", alertScreen.getButtonText(), "Проверка текста кнопки алерта")
    }

    func testQuizResultAlertButton() {
        let quizScreen = QuizScreen()
        quizScreen.waitForLoading()
        for _ in 0..<10 {
            quizScreen.waitForButtonIsHittable()
            quizScreen.tapNoButton()
            quizScreen.waitForButtonIsNotHittable()
        }
        let alertScreen = AlertScreen()
        alertScreen.waitForShowing()
        alertScreen.tapButton()
        quizScreen.waitForLoading()
        XCTAssertFalse(alertScreen.isShowing(), "Должен скрыться алерт результата квиза")
        XCTAssertEqual(quizScreen.getIndexText(), "1/10", "Счетчик вопросов должен перейти в начальное состояние")
    }
}
