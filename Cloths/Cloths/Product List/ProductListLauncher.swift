import UIKit

class ProductListLauncher {
    static func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController

        let interactor = ProductListInteractor(
            productListService:self.productService(),
            basketService: self.basketService(),
            wishListService: WishListService(simplePersistence: UserDefaults.standard)
        )
        let router = ProductRouter(errorViewFactory: ErrorViewControllerFactory())
        let presenter = ProductListPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: ProductViewModelBuilder(interactor: interactor)
        )

        view.presenter = presenter
        presenter.view = view
        interactor.output = presenter
        router.view = view

        return view
    }
}

private extension ProductListLauncher {
    static func productService() -> ProductListService {
        return ProductListService(
            decodingService: decodingAuthorizedService()
        )
    }

    static func basketService() -> BasketService {
        BasketService(decodingService: decodingAuthorizedService())
    }

    static func decodingAuthorizedService() -> DecodingService {
        let authorizedService = AuthorizedService(
            service: NetworkService(with: URLSession.shared), tokenProvider: APIKeyProvider()
        )
        return DecodingService(
            service: authorizedService,
            decoder: JSONDecoder()
        )
    }
}


