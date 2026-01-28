//
//  QuizScreen.swift
//  MovieQuizUITests
//
//  Created by ALEXANDER BUTYGIN on 28.01.2026.
//

import XCTest

final class QuizScreen {
    let app = XCUIApplication()
    private lazy var posterImage = app.images["Poster"]
    private lazy var yesButton = app.buttons["Yes"]
    private lazy var noButton = app.buttons["No"]
    private lazy var indexLabel = app.staticTexts["Index"]

    func waitForLoading() {
        XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "isHittable == true"), object: posterImage)], timeout: 10.0)
    }

    func waitForButtonIsHittable() {
        XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "isHittable == true"), object: yesButton)], timeout: 3.0)
    }

    func waitForButtonIsNotHittable() {
        XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "isHittable == false"), object: yesButton)], timeout: 0.5)
    }

    func getImageData() -> Data {
        return posterImage.screenshot().pngRepresentation
    }

    func tapYesButton() {
        yesButton.tap()
    }
    
    func tapNoButton() {
        noButton.tap()
    }

    func getIndexText() -> String {
        return indexLabel.label
    }
}
