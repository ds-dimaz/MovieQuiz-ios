import Foundation
import UIKit

final class MovieQuizPresenter {
    
    weak var viewController: MovieQuizViewController?
    
    var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
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
