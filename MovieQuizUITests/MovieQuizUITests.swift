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
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10", "Проверка номера вопроса")
    }

    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10", "Проверка номера вопроса")
    }

    func testQuizResultAlert() {
        sleep(3)

        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        let resultAlert = app.alerts.firstMatch
        XCTAssertTrue(resultAlert.exists, "Должен появиться алерт результата квиза")
        let alertTitleLabel = resultAlert.staticTexts.firstMatch
        XCTAssertEqual("Этот раунд окончен!", alertTitleLabel.label, "Проверка заголовка алерта")
        let alertButton = resultAlert.buttons.firstMatch
        XCTAssertEqual("Сыграть ещё раз", alertButton.label, "Проверка текста кнопки алерта")
    }

    func testQuizResultAlertButton() {
        sleep(3)

        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        let resultAlert = app.alerts.firstMatch
        XCTAssertTrue(resultAlert.exists, "Должен появиться алерт результата квиза")

        let alertButton = resultAlert.buttons.firstMatch
        alertButton.tap()
        sleep(1)
        XCTAssertFalse(resultAlert.exists, "Должен скрыться алерт результата квиза")
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10", "Счетчик вопросов должен перейти в начальное состояние")
    }
}
