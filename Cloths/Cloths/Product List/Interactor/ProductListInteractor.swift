import Foundation

protocol ProductListInteractorOutputInterface: AnyObject {
    func didFetched(products: [Product])
    func didFailed(error: Error)
}

protocol ProductListInteractorInterface {
    func getProductList()
}

final class ProductListInteractor {
    private let productListService: ProductListServiceInterface
    private let basketService: BasketServiceInterface
    weak var output: ProductListInteractorOutputInterface?

    init(
        productListService: ProductListServiceInterface,
        basketService: BasketServiceInterface
    ) {
        self.productListService = productListService
        self.basketService = basketService
    }
}

extension ProductListInteractor: ProductListInteractorInterface {
    func getProductList() {
        productListService.fetchProductList { [weak self] result in
            switch result {
            case .success(let products):
                self?.output?.didFetched(products: products)
            case .failure(let error):
                self?.output?.didFailed(error: error)
            }
        }
    }
}
