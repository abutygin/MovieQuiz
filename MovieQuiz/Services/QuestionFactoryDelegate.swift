//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 15.12.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
