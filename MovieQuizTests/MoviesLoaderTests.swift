//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by ALEXANDER BUTYGIN on 21.01.2026.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertNotNil(error)
                if let error = error as? StubNetworkClient.TestError {
                    XCTAssertEqual(StubNetworkClient.TestError.test, error)
                } else {
                    XCTFail("error '\(error)' has unexpected type")
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
