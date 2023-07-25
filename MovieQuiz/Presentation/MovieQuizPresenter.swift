import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private weak var viewController: MovieQuizViewController?
    
    var currentQuestion: QuizQuestion?
    var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var questionFactory: QuestionFactoryProtocol?
    let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let convertedModel = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                               question: model.text,
                                               questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return convertedModel
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.showFinalResults()
        } else {
            self.switchToNextQuestion()
            if self.currentQuestion != nil {
                questionFactory?.requestNextQuestion()
            }
        }
    }
    
    private func isCorrect(_ answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == answer {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }
    
    func yesButtonClicked() {
        isCorrect(true)
    }
    
    func noButtonClicked() {
        isCorrect(false)
    }
}
