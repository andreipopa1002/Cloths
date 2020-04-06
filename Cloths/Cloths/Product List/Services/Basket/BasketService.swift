import Foundation

final class BasketService {
    private let decodingService: DecodingServiceInterface

    init(decodingService: DecodingServiceInterface) {
        self.decodingService = decodingService
    }
}

extension BasketService: BasketServiceInterface {
    func getBasket(completion: @escaping BasketGetCompletion) {
        var request = URLRequest(url: URL(string: Environment.baseUrlString + "/cart")!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        getBasket(request: request) { result in
            switch result {
            case .success(let tuple):
                completion(.success(tuple.model ?? [BasketGetResponse]()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func add(productId: Int, completion:@escaping BasketAddCompletion) {
        var urlComponents = URLComponents(string: Environment.baseUrlString + "/cart")!
        urlComponents.queryItems = [URLQueryItem(name: "productId", value: String(productId))]
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        addToBasket(request: request) { result in
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
    func getBasket(request: URLRequest, completion: @escaping DecodingServiceCompletion<[BasketGetResponse]>) {
        decodingService.fetch(request: request, completion: completion)
    }

    func addToBasket(request: URLRequest, completion: @escaping DecodingServiceCompletion<BasketAddResponse>) {
        decodingService.fetch(request: request, completion: completion)
    }
}
