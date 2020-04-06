import Foundation

protocol ProductListPresenterInterface {
    func onViewDidLoad()

}

final class ProductListPresenter {
    private let interactor: ProductListInteractorInterface
    private let router: ProductRouterInterface
    private let viewModelBuilder: ProductViewModelBuilderInterface
    weak var view: ProductListViewInterface?

    init(
        interactor: ProductListInteractorInterface,
        router: ProductRouterInterface,
        viewModelBuilder: ProductViewModelBuilderInterface
    ) {
        self.interactor = interactor
        self.router = router
        self.viewModelBuilder = viewModelBuilder
    }
}

extension ProductListPresenter: ProductListPresenterInterface {
    func onViewDidLoad() {
        interactor.getProductList()
    }
}

extension ProductListPresenter: ProductListInteractorOutputInterface {
    func didFetched(products: [Product]) {
        DispatchQueue.main.async {
            self.view?.didFetch(
                productList: self.viewModelBuilder.viewModel(from: products)
            )
        }
    }

    func didFailedFetchingProducts(error: AuthorizedServiceError) {
        DispatchQueue.main.async {
            self.router.present(error: self.errorFromAuthorization(error: error))
        }
    }

    func didFailedAddToBasket(error: BasketAddError) {
        let descriptiveError: Error
        switch error {
        case .notInStock:
            descriptiveError = DescriptiveError(customDescription: "Product not in stock")
        case .noProductWithProductId:
            descriptiveError = DescriptiveError(customDescription: "This product does not exist")
        case .unknown:
            descriptiveError = DescriptiveError(customDescription: "An error occurred")
        case .authorizedError(let error):
            descriptiveError = errorFromAuthorization(error: error)
        }

        DispatchQueue.main.async {
            self.router.present(error: descriptiveError)
        }
    }
}

private extension ProductListPresenter {
    func errorFromAuthorization(error: AuthorizedServiceError) -> Error {
        let descriptiveError: Error
        switch error {
        case .unauthorized:
            descriptiveError = DescriptiveError(customDescription: "Call not authorized")
        case .networkError(let error):
            descriptiveError = error
        }

        return descriptiveError
    }
}
