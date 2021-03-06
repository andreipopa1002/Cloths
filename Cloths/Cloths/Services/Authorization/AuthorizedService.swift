import Foundation

protocol APIKeyProviderInterface {
    var apiKey: String {get}
}

enum AuthorizedServiceError: Error, Equatable {
    case unauthorized
    case networkError(Error)

    static func == (lhs: AuthorizedServiceError, rhs: AuthorizedServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

typealias AuthorizedResult = Result<(data: Data?, response: URLResponse?), AuthorizedServiceError>
typealias AuthorizedServiceCompletion = (AuthorizedResult) -> ()

protocol AuthorizedServiceInterface {
    func fetch(request: URLRequest, completion: @escaping AuthorizedServiceCompletion)
}

final class AuthorizedService {
    private let service: NetworkServiceInterface
    private let tokenProvider: APIKeyProviderInterface

    init(service: NetworkServiceInterface, tokenProvider: APIKeyProviderInterface) {
        self.service = service
        self.tokenProvider = tokenProvider
    }
}

extension AuthorizedService: AuthorizedServiceInterface {
    func fetch(request: URLRequest, completion: @escaping AuthorizedServiceCompletion) {
        var request = request
        request.addValue(tokenProvider.apiKey, forHTTPHeaderField: "X-API-KEY")
        fetchAuth(request: request) { result in
            switch result {
            case .success(let tuple):
                guard
                    let urlResponse = tuple.response as? HTTPURLResponse,
                    urlResponse.statusCode != 401 else {
                        return completion(.failure(.unauthorized))
                }

                completion(.success(tuple))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}

private extension AuthorizedService {
    func fetchAuth(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        service.fetch(request: request, completion: completion)
    }
}

struct APIKeyProvider: APIKeyProviderInterface {
    var apiKey: String {
        return "DD6E5FD7D0-E7FD-4622-8A19-9EBC602C9D0D"
    }
}
