import Foundation
import UIKit

final class AppRouter {
    private let productListScreen: ProductListScreen
    private let wishListScreen: WishListScreen
    private let basketScreen: BasketScreen
    private var rootViewController: UINavigationController?

    init() {
        productListScreen = ProductListScreen()
        wishListScreen = WishListScreen()
        basketScreen = BasketScreen()
        productListScreen.delegate = self
        wishListScreen.delegate = self
        basketScreen.delegate = self
    }

    func mainScreen() -> UINavigationController {
        let vc = productListScreen.screen()
        rootViewController = vc
        return vc
    }
}

extension AppRouter: WishListScreenDelegate {
    func wishListDidTapClose() {
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}

extension AppRouter: BasketScreenDelegate {
    func basketDidTapClose() {
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}

extension AppRouter: ProductListScreenDelegate {
    func didTapWishList() {
        rootViewController?.present(wishListScreen.screen(), animated: true, completion: nil)
    }

    func didTapBasket() {
        rootViewController?.present(basketScreen.screen(), animated: true, completion: nil)
    }
}
