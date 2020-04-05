import Foundation
import UIKit

@objc protocol ProductListScreenDelegate: AnyObject {
    func didTapWishList()
    func didTapBasket()
}

final class ProductListScreen: NSObject {
    let productListFactory = ProductListFactory()
    weak var delegate: ProductListScreenDelegate?

    func screen() -> UINavigationController {
        let nav = UINavigationController(rootViewController: productListFactory.viewController())
        nav.delegate = self
        return nav
    }
}

extension ProductListScreen: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let wishListButton = UIBarButtonItem(title: "Wish List", style: .plain, target: delegate, action: #selector(delegate?.didTapWishList))
        viewController.navigationItem.setLeftBarButton(wishListButton, animated: false)

        let basketButton = UIBarButtonItem(title: "Basket", style: .plain, target: delegate, action: #selector(delegate?.didTapBasket))
        viewController.navigationItem.setRightBarButton(basketButton, animated: false)
        viewController.title = "Product List"
    }
}
