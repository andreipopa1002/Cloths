import Foundation

final class WishListInteractor {
    let wishListService: WishListServiceInterface
    let productListService: ProductListServiceInterface
    let basketService: BasketServiceInterface
    weak var output: ProductListInteractorOutputInterface?

    init(
        wishListService: WishListServiceInterface,
        productListService: ProductListServiceInterface,
        basketService: BasketServiceInterface
    ) {
        self.wishListService = wishListService
        self.productListService = productListService
        self.basketService = basketService
    }
}

extension WishListInteractor: ProductListInteractorInterface {
    func getProductList() {
        let wishedProductIds = wishListService.productIdsFromWishList()
        productListService.fetchProductList { [weak self] result in
            switch result {
            case .success(let productList):
                self?.output?.didFetched(products: productList.filter { wishedProductIds.contains($0.id) })
            case .failure(let error):
                self?.output?.didFailedFetchingProducts(error: error)
            }
        }
    }

    func addToBasket(productId: Int) {
        basketService.add(productId: productId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didFailedAddToBasket(error: error)
            case .success:
                self?.wishListService.removeFromWishList(productId: productId)
                self?.getProductList()
            }
        }
    }

    func addToWishList(productId: Int) { }
}
