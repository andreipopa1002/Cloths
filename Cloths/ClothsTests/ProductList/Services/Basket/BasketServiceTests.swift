import XCTest
@testable import Cloths

final class BasketServiceTests: XCTestCase {
    private var service: BasketService!
    private var mockedDecodingService: MockDecodingService!

    override func setUp() {
        super.setUp()

        mockedDecodingService = MockDecodingService()
        service = BasketService(decodingService: mockedDecodingService)
    }

    override func tearDown() {
        mockedDecodingService = nil
        service = nil
        super.tearDown()
    }

    func test_WhenAddProductId_ThenRequestHasAcceptHeader() {
        service.add(productId: 0) { _ in }

        XCTAssertEqual(
            mockedDecodingService.spyRequest.map {$0.allHTTPHeaderFields}, [["Accept": "application/json"]]
        )
    }

    func test_WhenAddProductId_ThenRequestHasUrl() {
        let expectedUrlString =  "https://2klqdzs603.execute-api.eu-west-2.amazonaws.com/cloths/cart?product%20ID=123"
        service.add(productId: 123) { _ in }

        XCTAssertEqual(
            mockedDecodingService.spyRequest.map {$0.url?.absoluteString},
            [expectedUrlString]
        )
    }

    func test_GivenSuccess_WhenAddProductId_ThenResultWithMessage() {
        var capturedAddBasketResponse: BasketAddResponse?
        service.add(productId: 0) { result in
            if case .success(let addBasketResponse) = result {
                capturedAddBasketResponse = addBasketResponse
            }
        }

        let completion = mockedDecodingService.spyCompletion as? BasketAddCompletion
        completion?(.success(BasketAddResponse.stub))

        XCTAssertEqual(capturedAddBasketResponse, BasketAddResponse.stub)
    }

    func test_GivenFailure_WhenAddProductId_ThenResultWithSameError() {
        var capturedError: Error?
        service.add(productId: 0) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        let completion = mockedDecodingService.spyCompletion as? BasketAddCompletion
        let stubbedError = DummyError(customDescription: "product list fetch error")
        completion?(.failure(stubbedError))

        XCTAssertEqual(capturedError?.localizedDescription, stubbedError.localizedDescription)
    }
}

private extension BasketAddResponse {
    static var stub: BasketAddResponse {
        BasketAddResponse(message: "bla")
    }
}
