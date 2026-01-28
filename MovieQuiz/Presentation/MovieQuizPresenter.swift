//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by ALEXANDER BUTYGIN on 20.01.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    func convert(quizQuestion: QuizQuestion) -> QuizStepModel {
        let questionNumberText = "\(currentQuestionIndex + 1)/\(questionsAmount)"

        let quizModel = QuizStepModel(
            imageData: quizQuestion.imageData,
            question: quizQuestion.text,
            questionNumber: questionNumberText)
        return quizModel
    }

    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func reloadQuestions() {
        questionFactory?.loadData()
        viewController?.showLoadingIndicator()
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func yesButtonClicked() {
        didAnswer(isYes: true)
    }

    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    private func showCurrentQuestion() {
        guard let currentQuestion else {
            return
        }
        let quizStepModel = convert(quizQuestion: currentQuestion)
        viewController?.show(quizStep: quizStepModel)
    }

    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let quizResultsViewModel = QuizResultsModel(
                title:  "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(self.questionsAmount)",
                buttonText: "Сыграть ещё раз")
            viewController?.show(quizResult: quizResultsViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    func makeResultsMessage() -> String {
        let resultFirstString = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        guard let statisticService else {
            return resultFirstString
        }
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let messageLines = [
            resultFirstString,
            "Количество сыгранных квизов: \(statisticService.gamesCount)",
            "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))",
            "Средняя точность: \(accuracy)%"
        ]
        let resultMessage = messageLines.joined(separator: "\n")
        return resultMessage
    }

    private func proceedWithAnswerResult(isCorrect: Bool) {
        viewController?.highlightScreenForAnswerResult(isCorrect: isCorrect)
        didAnswer(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.showCurrentQuestion()
        }
    }

    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        switch error {
        case MoviesLoader.MoviesLoaderError.apiError(let errorMessage):
            viewController?.showNetworkError(message: "Ошибка загрузки фильмов: '\(errorMessage)'")
        default:
            viewController?.showNetworkError(message: error.localizedDescription)
        }
    }
}
