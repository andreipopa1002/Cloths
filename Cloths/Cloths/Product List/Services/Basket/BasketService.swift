import Foundation

struct BasketAddResponse: Decodable, Equatable {
    let message: String
}
enum BasketServiceError: Error, Equatable {
    case notInStock, noProductWithProductId, unknown
    case authorizedError(AuthorizedServiceError)
}
typealias BasketAddResult = Result<Void, BasketServiceError>
typealias BasketAddCompletion = (BasketAddResult) -> ()

protocol BasketServiceInterface {
    func add(productId: Int, completion:@escaping BasketAddCompletion)
}

final class BasketService {
    private let decodingService: DecodingServiceInterface

    init(decodingService: DecodingServiceInterface) {
        self.decodingService = decodingService
    }
}

extension BasketService: BasketServiceInterface {
    func add(productId: Int, completion:@escaping BasketAddCompletion) {
        var urlComponents = URLComponents(string: Environment.baseUrlString + "/cart")!
        urlComponents.queryItems = [URLQueryItem(name: "productId", value: String(productId))]
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        fetch(request: request) { result in
            switch result {
            case .success(let tuple):
                if let urlResposne = tuple.response as? HTTPURLResponse{
                    switch urlResposne.statusCode {
                    case 403:
                        completion(.failure(.notInStock))
                    case 404:
                        completion(.failure(.noProductWithProductId))
                    case 201:
                        completion(.success(()))
                    default:
                        completion(.failure(.unknown))
                    }
                }
            case .failure(let error):
                completion(.failure(.authorizedError(error)))
            }
        }
    }
}

private extension BasketService {
    func fetch(request: URLRequest, completion: @escaping DecodingServiceCompletion<BasketAddResponse>) {
        decodingService.fetch(request: request, completion: completion)
    }
}
