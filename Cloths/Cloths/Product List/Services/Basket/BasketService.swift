import Foundation

struct BasketAddResponse: Decodable, Equatable {
    let message: String
}

typealias BasketAddCompletion = (Result<BasketAddResponse, Error>) -> ()

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
        urlComponents.queryItems = [URLQueryItem(name: "product ID", value: String(productId))]
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        decodingService.fetch(request: request, completion: completion)
    }
}
