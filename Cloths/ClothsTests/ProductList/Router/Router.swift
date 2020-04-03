import Foundation
import UIKit

protocol ProductRouterInterface {
    func present(error: Error)
}

final class ProductRouter {
    private let errorViewFactory: ErrorViewControllerFactoryInterface
    weak var view: UIViewController?

    init(errorViewFactory: ErrorViewControllerFactoryInterface) {
        self.errorViewFactory = errorViewFactory
    }
}

extension ProductRouter: ProductRouterInterface {
    func present(error: Error) {
        view?.present(
            errorViewFactory.viewController(forError: error),
            animated: true,
            completion: nil
        )

    }
}


