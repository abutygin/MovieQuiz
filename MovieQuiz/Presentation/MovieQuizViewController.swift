import UIKit

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuestion()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: !questions[currentQuestionIndex].correctAnswer)
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает модель для экрана вопроса
    private func convert(quizQuestion: QuizQuestion) -> QuizStepModel {
        let questionNumberText = "\(currentQuestionIndex + 1)/10"
        let quizModel = QuizStepModel(
            image: UIImage(named: quizQuestion.image) ?? UIImage(),
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
        drawBoundForAnswerResult(isCorrect: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
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
        if currentQuestionIndex == questions.count - 1 {
            let quizResultsViewModel = QuizResultsModel(
                title:  "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/10",
                buttonText: "Сыграть ещё раз")
            show(quizResult: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    
    private func showCurrentQuestion() {
        makeButtons(enabled: true)
        let currentQuestion = questions[currentQuestionIndex]
        let quizStepModel = convert(quizQuestion: currentQuestion)
        show(quizStep: quizStepModel)
    }
    
    private func show(quizResult: QuizResultsModel) {
        let alert = UIAlertController(title: quizResult.title, // заголовок всплывающего окна
                                      message: quizResult.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        let action = UIAlertAction(title: quizResult.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showCurrentQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

struct QuizQuestion {
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}

// модель для состояния "Вопрос показан"
struct QuizStepModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}

// модель для состояния "Результат квиза"
struct QuizResultsModel {
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
}
