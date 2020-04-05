import Foundation
import UIKit

@objc protocol WishListScreenDelegate: AnyObject {
    func wishListDidTapClose()
}

final class WishListScreen: NSObject {
    weak var delegate: WishListScreenDelegate?

    override init() { }

    func screen() -> UINavigationController {
        let nav = UINavigationController(rootViewController: WishListhFactory().viewController())
        nav.delegate = self
        return nav
    }
}

extension WishListScreen: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: delegate, action: #selector(delegate?.wishListDidTapClose))
        viewController.navigationItem.setRightBarButton(closeButton, animated: true)
        viewController.title = "Wish List"
    }
}
