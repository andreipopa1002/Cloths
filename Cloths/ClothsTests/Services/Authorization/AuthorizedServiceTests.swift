import XCTest
@testable import Cloths

final class AuthorizedServiceTests: XCTestCase {
    private var service: AuthorizedService!
    private var mockedNetworkService: MockNetworkService!
    private var mockedTokenProvider: MockAPIKeyProvider!
    private let urlRequest = URLRequest(url: URL(string: "www.g.g")!)

    override func setUp() {
        super.setUp()

        mockedNetworkService = MockNetworkService()
        mockedTokenProvider = MockAPIKeyProvider()
        service = AuthorizedService(
            service: mockedNetworkService,
            tokenProvider: mockedTokenProvider
        )
    }

    override func tearDown() {
        mockedNetworkService = nil
        mockedTokenProvider = nil
        service = nil

        super.tearDown()
    }

    func test_WhenFetch_ThenAppendAuthHeader() {
        service.fetch(request: urlRequest, completion: { _ in })
        let headers = mockedNetworkService
            .spyRequest
            .compactMap { $0.allHTTPHeaderFields }
        XCTAssertEqual(
            headers,
            [["X-API-KEY": "my api key"]]
        )
    }

    func test_GivenFailure_WhenFetch_ThenCompletionFailsWithSameError() {
        var capturedError: Error?
        service.fetch(request: urlRequest) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }
        mockedNetworkService.spyCompletion?(.failure(DummyError(customDescription: "network failure")))
        XCTAssertEqual(capturedError?.localizedDescription, "network failure")
    }

    func test_GivenSuccess_WhenFetch_ThenCompletionCalledWithSameData() {
        var capturedData: Data?
        service.fetch(request: urlRequest) { result in
            if case .success(let data) = result {
                capturedData = data
            }
        }
        let data = Data()
        mockedNetworkService.spyCompletion?(.success(data))
        XCTAssertEqual(capturedData, data)
    }
}

private class MockAPIKeyProvider: APIKeyProviderInterface {
    var apiKey = "my api key"
}
