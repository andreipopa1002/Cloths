import Foundation

protocol ProductListInteractorOutputInterface: AnyObject {
    func didFetched(products: [Product])
    func didFailedFetchingProducts(error: AuthorizedServiceError)
    func didFailedAddToBasket(error: BasketServiceError)
}

protocol ProductListInteractorInterface {
    func getProductList()
    func addToBasket(productId: Int)
    func addToWishList(productId: Int)
}

final class ProductListInteractor {
    private let productListService: ProductListServiceInterface
    private let basketService: BasketServiceInterface
    private let wishListService: WishListServiceInterface
    weak var output: ProductListInteractorOutputInterface?

    init(
        productListService: ProductListServiceInterface,
        basketService: BasketServiceInterface,
        wishListService: WishListServiceInterface
    ) {
        self.productListService = productListService
        self.basketService = basketService
        self.wishListService = wishListService
    }
}

extension ProductListInteractor: ProductListInteractorInterface {
    func addToWishList(productId: Int) {
        wishListService.addToWishList(productId: productId)
    }

    func getProductList() {
        productListService.fetchProductList { [weak self] result in
            switch result {
            case .success(let products):
                self?.output?.didFetched(products: products)
            case .failure(let error):
                self?.output?.didFailedFetchingProducts(error: error)
            }
        }
    }

    func addToBasket(productId: Int) {
        basketService.add(productId: productId) { [weak self] result in
            if case .failure(let error) = result {
                self?.output?.didFailedAddToBasket(error: error)
            }
        }
    }
}
