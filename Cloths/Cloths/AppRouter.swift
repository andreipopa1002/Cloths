import Foundation
import UIKit

final class AppRouter: NSObject {
    let navigationController: UINavigationController

    override init() {
        navigationController = UINavigationController(rootViewController: ProductListLauncher.viewController())

        super.init()
        navigationController.delegate = self
    }

    @objc func didTapWishList() {

    }

    @objc func didTapBasket() {
        
    }

}

extension AppRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let wishListButton = UIBarButtonItem(title: "Wish List", style: .plain, target: self, action: #selector(AppRouter.didTapWishList))
        viewController.navigationItem.setLeftBarButton(wishListButton, animated: false)

        let basketButton = UIBarButtonItem(title: "Basket", style: .plain, target: self, action: #selector(AppRouter.didTapBasket))
        viewController.navigationItem.setRightBarButton(basketButton, animated: false)
    }
}
