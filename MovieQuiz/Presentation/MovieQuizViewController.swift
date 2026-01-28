import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    // MARK: - IB Outlets
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }

    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func show(quizStep: QuizStepModel) {
        makeButtons(enabled: true)
        questionLabel.text = quizStep.question
        moviePosterImageView.image = UIImage(data: quizStep.imageData) ?? UIImage()
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 0
        counterLabel.text = quizStep.questionNumber
    }
    
    func highlightScreenForAnswerResult(isCorrect: Bool) {
        makeButtons(enabled: false)
        drawBoundForAnswerResult(isCorrect: isCorrect)
    }

    func drawBoundForAnswerResult(isCorrect: Bool) {
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 8
        moviePosterImageView.layer.cornerRadius = 20
        if isCorrect {
            moviePosterImageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            moviePosterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    func makeButtons(enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func show(quizResult: QuizResultsModel) {
        let message = presenter.makeResultsMessage()
        let alertModel = AlertModel(
            title: quizResult.title,
            message: message,
            buttonText: quizResult.buttonText,
            completion: { [weak self] in
                guard let self else {
                    return
                }
                self.presenter.restartGame()
            }
        )
        alertPresenter.show(in: self, model: alertModel)
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.reloadQuestions()
        }
        alertPresenter.show(in: self, model: model)
    }
}
