import Foundation
import UIKit

@objc protocol BasketScreenDelegate {
    func basketDidTapClose()
}

final class BasketScreen: NSObject {
    weak var delegate: BasketScreenDelegate?

    override init() { }

    func screen() -> UIViewController {
        let nav = UINavigationController(rootViewController: BasketFactory().viewController())
        nav.delegate = self
        return nav
    }
}

extension BasketScreen: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: delegate, action: #selector(delegate?.basketDidTapClose))
        viewController.navigationItem.setRightBarButton(closeButton, animated: true)
        viewController.title = "Basket"
    }
}
