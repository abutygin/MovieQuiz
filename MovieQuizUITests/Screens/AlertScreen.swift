//
//  AlertScreen.swift
//  MovieQuizUITests
//
//  Created by ALEXANDER BUTYGIN on 28.01.2026.
//

import XCTest

final class AlertScreen {
    let app = XCUIApplication()
    private lazy var rootElement = app.alerts.firstMatch
    private lazy var titleLabel = app.alerts.staticTexts.firstMatch
    private lazy var alertButton = app.alerts.buttons.firstMatch

    func isShowing() -> Bool {
        return rootElement.exists
    }
    
    func waitForShowing() {
        XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: rootElement)], timeout: 1.0)
    }

    func getTitle() -> String {
        return titleLabel.label
    }

    func tapButton() {
        alertButton.tap()
    }

    func getButtonText() -> String {
        return alertButton.label
    }
}
