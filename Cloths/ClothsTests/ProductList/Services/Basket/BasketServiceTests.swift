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
        let expectedUrlString =  "https://2klqdzs603.execute-api.eu-west-2.amazonaws.com/cloths/cart?productId=123"
        service.add(productId: 123) { _ in }

        XCTAssertEqual(
            mockedDecodingService.spyRequest.map {$0.url?.absoluteString},
            [expectedUrlString]
        )
    }

    func test_GivenSuccess_WhenAddProductId_ThenSuccess() {
        var capturedAddBasketResult: BasketAddResult?
        service.add(productId: 0) { result in
            capturedAddBasketResult = result
        }

        inferedDecodingCompletion()?(.success((BasketAddResponse.stub, urlResponse(statusCode: 201))))

        guard case .success(()) = capturedAddBasketResult else {
            return XCTFail("expected success")
        }
    }

    func test_Given403_WhenAddProductId_ThenFailureNotInStock() {
        var capturedError: BasketAddError?
        service.add(productId: 0) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        inferedDecodingCompletion()?(.success((nil, urlResponse(statusCode: 403))))

        XCTAssertEqual(capturedError, .notInStock)
    }

    func test_Given404_WhenAddProductId_ThenFailureNoProductWithId() {
        var capturedError: BasketAddError?
        service.add(productId: 0) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        inferedDecodingCompletion()?(.success((nil, urlResponse(statusCode: 404))))

        XCTAssertEqual(capturedError, .noProductWithProductId)
    }

    func test_GivenRandomStatusCode_WhenAddProductId_ThenFailureUnknown() {
        var capturedError: BasketAddError?
        service.add(productId: 0) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        inferedDecodingCompletion()?(.success((nil, urlResponse(statusCode: 123))))

        XCTAssertEqual(capturedError, .unknown)

    }

    func test_GivenAuthorizedError_WhenAddProductId_ThenResultWithSameError() {
        var capturedError: BasketAddError?
        service.add(productId: 0) { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        let stubbedError = DescriptiveError(customDescription: "product list fetch error")
        inferedDecodingCompletion()?(.failure(.networkError(stubbedError)))

        XCTAssertEqual(capturedError, BasketAddError.authorizedError(.networkError(stubbedError)))
    }
}

private extension BasketServiceTests {
    func inferedDecodingCompletion() -> DecodingServiceCompletion<BasketAddResponse>? {
        mockedDecodingService.spyCompletion as? DecodingServiceCompletion<BasketAddResponse>
    }

    func urlResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "www.g.g")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

private extension BasketAddResponse {
    static var stub: BasketAddResponse {
        BasketAddResponse(message: "bla")
    }
}
