import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func show(viewModel: AlertModel)
}

final class AlertPresenter {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertPresenterDelegate {
    func show(viewModel: AlertModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: viewModel.buttonText, style: .default) { _ in
            viewModel.buttonAction()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true)
    }
}
