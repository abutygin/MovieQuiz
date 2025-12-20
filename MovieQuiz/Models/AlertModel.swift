//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 15.12.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
