//
//  QuizStepModel.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 13.12.2025.
//

import Foundation
//import UIKit

// модель для состояния "Вопрос показан"
struct QuizStepModel {
  // картинка с афишей фильма с типом UIImage
//  let image: UIImage
    let imageData: Data
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
