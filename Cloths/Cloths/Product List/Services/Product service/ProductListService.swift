import Foundation

typealias ProductListCompletion = (Result<[Product], Error>) -> ()

protocol ProductListServiceInterface {
    func fetchProductList(completion:@escaping ProductListCompletion)
}

final class ProductListService {
    private let decodingService: DecodingServiceInterface

    init(decodingService: DecodingServiceInterface) {
        self.decodingService = decodingService
    }
}

extension ProductListService: ProductListServiceInterface {
    func fetchProductList(completion:@escaping ProductListCompletion) {
        var request = URLRequest(url: URL(string: Environment.baseUrlString + "/products")!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        decodingService.fetch(request: request,completion: completion)
    }
}
