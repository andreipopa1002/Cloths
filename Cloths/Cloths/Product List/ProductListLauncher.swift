import UIKit

class ProductListLauncher {
    static func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController

        let interactor = ProductListInteractor(service:self.productService())
        let router = ProductRouter(errorViewFactory: ErrorViewControllerFactory())
        let presenter = ProductListPresenter(
            interactor: interactor,
            router: router,
            viewModelBuilder: ProductViewModelBuilder()
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
        let authorizedService = AuthorizedService(
            service: NetworkService(with: URLSession.shared), tokenProvider: APIKeyProvider()
        )
        let decodingService = DecodingService(
            service: authorizedService,
            decoder: JSONDecoder()
        )
        return ProductListService(
            decodingService: decodingService
        )
    }
}


