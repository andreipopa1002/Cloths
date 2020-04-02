import Foundation
@testable import Cloths

final class MockDecodingService: DecodingServiceInterface {
    private(set) var spyRequest = [URLRequest]()
    private(set) var spyCompletion: Any?

    func fetch<DecodableModel>(request: URLRequest, completion: @escaping (Result<DecodableModel, Error>) -> ()) where DecodableModel : Decodable {
        spyRequest.append(request)
        spyCompletion = completion
    }
}