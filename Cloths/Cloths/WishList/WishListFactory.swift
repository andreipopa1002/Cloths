import Foundation
import UIKit

final class WishListhFactory {
    func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController
        let serviceFactory = ServiceFactory()

        let interactor = WishListInteractor(
            wishListService: WishListService(simplePersistence: UserDefaults.standard),
            productListService: serviceFactory.productService(), basketService: serviceFactory.basketService()
        )
        let router = ProductRouter(errorViewFactory: ErrorViewControllerFactory())
        let presenter = ProductListPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: ProductViewModelBuilder(interactor: interactor, configuration: .addToBasket)
        )

        view.presenter = presenter
        presenter.view = view
        interactor.output = presenter
        router.view = view

        return view
    }
}
