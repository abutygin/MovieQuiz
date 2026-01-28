//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 08.01.2026.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting

    enum MoviesLoaderError: Error {
        case apiError(String)
    }

    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies: MostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if mostPopularMovies.errorMessage.isEmpty {
                        handler(.success(mostPopularMovies))
                    } else {
                        handler(.failure(MoviesLoaderError.apiError(mostPopularMovies.errorMessage)))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
