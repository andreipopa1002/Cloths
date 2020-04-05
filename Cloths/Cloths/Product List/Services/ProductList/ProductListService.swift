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

        fetchProductList(request: request) { result in
            switch result {
            case .success(let tuple):
                completion(.success(tuple.model ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProductListService {
    func fetchProductList(request: URLRequest, completion: @escaping DecodingServiceCompletion<[Product]>) {
        decodingService.fetch(request: request, completion: completion)
    }
}
