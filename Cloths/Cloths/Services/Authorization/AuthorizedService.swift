import Foundation

protocol APIKeyProviderInterface {
    var apiKey: String {get}
}

final class AuthorizedService {
    private let service: NetworkServiceInterface
    private let tokenProvider: APIKeyProviderInterface

    init(service: NetworkServiceInterface, tokenProvider: APIKeyProviderInterface) {
        self.service = service
        self.tokenProvider = tokenProvider
    }
}

extension AuthorizedService: NetworkServiceInterface {
    func fetch(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        var request = request
        request.addValue(tokenProvider.apiKey, forHTTPHeaderField: "X-API-KEY")
        service.fetch(request: request, completion: completion)
    }
}

struct APIKeyProvider: APIKeyProviderInterface {
    var apiKey: String {
        return "DD6E5FD7D0-E7FD-4622-8A19-9EBC602C9D0D"
    }
}
