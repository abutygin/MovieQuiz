import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - IB Outlets
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties
    private var currentQuestionNumber = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let moviesLoader = MoviesLoader()
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        statisticService = StatisticService()
        showLoadingIndicator()
        questionFactory?.loadData()
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestionNumber += 1
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.showCurrentQuestion()
        }
    }

    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        switch error {
        case MoviesLoader.MoviesLoaderError.apiError(let errorMessage):
            showNetworkError(message: "Ошибка загрузки фильмов: '\(errorMessage)'")
        default:
            showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
        }
    }

    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    // метод конвертации, который принимает моковый вопрос и возвращает модель для экрана вопроса
    private func convert(quizQuestion: QuizQuestion) -> QuizStepModel {
        let questionNumberText = "\(currentQuestionNumber)/10"
        let quizModel = QuizStepModel(
            image: UIImage(data: quizQuestion.image) ?? UIImage(),
            question: quizQuestion.text,
            questionNumber: questionNumberText)
        return quizModel
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход модель вопроса и ничего не возвращает
    private func show(quizStep: QuizStepModel) {
        questionLabel.text = quizStep.question
        moviePosterImageView.image = quizStep.image
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 0
        counterLabel.text = quizStep.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        makeButtons(enabled: false)
        currentQuestion = nil
        drawBoundForAnswerResult(isCorrect: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
           self?.showNextQuestionOrResults()
        }
    }
    
    private func drawBoundForAnswerResult(isCorrect: Bool) {
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 8
        moviePosterImageView.layer.cornerRadius = 20
        if isCorrect {
            moviePosterImageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            moviePosterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    private func makeButtons(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionNumber == questionsAmount {
            let quizResultsViewModel = QuizResultsModel(
                title:  "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть ещё раз")
            show(quizResult: quizResultsViewModel)
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showCurrentQuestion() {
        guard let currentQuestion else {
            return
        }
        makeButtons(enabled: true)
        let quizStepModel = convert(quizQuestion: currentQuestion)
        show(quizStep: quizStepModel)
    }
    
    private func show(quizResult: QuizResultsModel) {
        let alertMessage: String
        if let statisticService {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
            let messageLines = [
                quizResult.text,
                "Количество сыгранных квизов: \(statisticService.gamesCount)",
                "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))",
                "Средняя точность: \(accuracy)%"
            ]
            alertMessage = messageLines.joined(separator: "\n")
        } else {
            alertMessage = quizResult.text
        }

        let alertModel = AlertModel(
            title: quizResult.title,
            message: alertMessage,
            buttonText: quizResult.buttonText,
            completion: { [weak self] in
                guard let self else {
                    return
                }
                self.playOneMore()
            }
        )
        alertPresenter.show(in: self, model: alertModel)
    }

    private func playOneMore() {
        currentQuestionNumber = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }

            self.currentQuestionNumber = 0
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }
        alertPresenter.show(in: self, model: model)
    }
}
