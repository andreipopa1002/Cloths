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
        view?.didFetch(
            productList: viewModelBuilder.viewModel(from: products)
        )
    }

    func didFailed(error: Error) {
        router.present(error: error)
    }
}
