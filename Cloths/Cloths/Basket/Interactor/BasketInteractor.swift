import Foundation

final class BasketInteractor {
    private let basketService: BasketServiceInterface
    private let productListService: ProductListServiceInterface
    weak var output: ProductListInteractorOutputInterface?

    init(
        basketService: BasketServiceInterface,
        productListService: ProductListServiceInterface
    ) {
        self.basketService = basketService
        self.productListService = productListService
    }
}

extension BasketInteractor: ProductListInteractorInterface {
    func getProductList() {
        basketService.getBasket { [weak self] result in
            switch result {
            case .success(let basketProducts):
                self?.fetchProducts(productIdsFromBasket: basketProducts.map {$0.productId})
            case .failure(let error):
                self?.output?.didFailedFetchingProducts(error: error)
            }
        }
    }

    func addToBasket(productId: Int) { }
    func addToWishList(productId: Int) { }
}

private extension BasketInteractor {
    private func fetchProducts(productIdsFromBasket: [Int]) {
        productListService.fetchProductList() { [weak self] result in
            switch result {
            case .success(let products):
                self?.output?.didFetched(products: products.filter { productIdsFromBasket.contains($0.id) })
            case .failure(let error):
                self?.output?.didFailedFetchingProducts(error: error)
            }
        }
    }
}
