import Foundation
import UIKit

class BasketFactory {
    func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController
        let serviceFactory = ServiceFactory()

        let interactor = BasketInteractor(
            basketService: serviceFactory.basketService(),
            productListService: serviceFactory.productService()
        )
        let router = ProductRouter(errorViewFactory: ErrorViewControllerFactory())
        let presenter = ProductListPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: ProductViewModelBuilder(interactor: interactor, configuration: .none)
        )

        view.presenter = presenter
        presenter.view = view
        interactor.output = presenter
        router.view = view

        return view
    }
}
