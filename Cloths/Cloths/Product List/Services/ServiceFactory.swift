import Foundation

final class ServiceFactory {
    func productService() -> ProductListService {
        return ProductListService(decodingService: decodingAuthorizedService())
    }

    func basketService() -> BasketService {
        BasketService(decodingService: decodingAuthorizedService())
    }

    func decodingAuthorizedService() -> DecodingService {
        let authorizedService = AuthorizedService(
            service: NetworkService(with: URLSession.shared), tokenProvider: APIKeyProvider()
        )
        return DecodingService(
            service: authorizedService,
            decoder: JSONDecoder()
        )
    }
}
