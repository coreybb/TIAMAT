import UIKit

protocol ErrorAlertPresenting where Self: UIViewController {
    func presentErrorAlert(title: String, message: String, okHandler: (() -> Void)?)
}


extension ErrorAlertPresenting {
    
    func presentErrorAlert(
        title: String = "Error",
        message: String = "Something went wrong. Please check your connection and try again later",
        okHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            okHandler?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
