import Foundation

protocol ProductListInteractorOutputInterface: AnyObject {
    func didFetched(products: [Product])
    func didFailed(error: Error)
}

protocol ProductListInteractorInterface {
    func getProductList()
}

final class ProductListInteractor {
    private let service: ProductListServiceInterface
    weak var output: ProductListInteractorOutputInterface?

    init(service: ProductListServiceInterface) {
        self.service = service
    }
}

extension ProductListInteractor: ProductListInteractorInterface {
    func getProductList() {
        service.fetchProductList { [weak self] result in
            switch result {
            case .success(let products):
                self?.output?.didFetched(products: products)
            case .failure(let error):
                self?.output?.didFailed(error: error)
            }
        }
    }
}
