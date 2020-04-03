import UIKit

protocol ErrorViewControllerFactoryInterface {
    func viewController(forError: Error) -> UIViewController
}


final class ErrorViewControllerFactory: ErrorViewControllerFactoryInterface {
    func viewController(forError error: Error) -> UIViewController {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))

        return alertController
    }
}
