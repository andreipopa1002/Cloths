import XCTest
@testable import Cloths

final class ProductListServiceTests: XCTestCase {
    private var mockedDecodingService: MockDecodingService!
    private var service: ProductListService!

    override func setUp() {
        super.setUp()

        mockedDecodingService = MockDecodingService()
        service = ProductListService(decodingService: mockedDecodingService)
    }

    override func tearDown() {
        mockedDecodingService = nil
        service = nil

        super.tearDown()
    }

    func test_WhenFetchProductList_ThenRequestHasAcceptHeader() {
        service.fetchProductList { _ in }

        XCTAssertEqual(
            mockedDecodingService.spyRequest.map {$0.allHTTPHeaderFields}, [["Accept": "application/json"]]
        )
    }

    func test_WhenFetchProductList_ThenRequestHasUrl() {
        let expectedUrl = URL(string: "https://2klqdzs603.execute-api.eu-west-2.amazonaws.com/cloths/products")
        service.fetchProductList { _ in }

        XCTAssertEqual(mockedDecodingService.spyRequest.map {$0.url}, [expectedUrl])
    }

    func test_GivenSuccess_WhenFetchProductList_ThenResultWithSameProduct() {
        var capturedProducts: [Product]?
        service.fetchProductList { result in
            if case .success(let products) = result {
                capturedProducts = products
            }
        }

       let completion = mockedDecodingService.spyCompletion as? ProductListCompletion
        completion?(.success([Product.stub]))

        XCTAssertEqual(capturedProducts, [Product.stub])
    }

    func test_GivenFailure_WhenFetchProductList_ThenResultWithSameError() {
        var capturedError: Error?
        service.fetchProductList { result in
            if case .failure(let error) = result {
                capturedError = error
            }
        }

        let completion = mockedDecodingService.spyCompletion as? ProductListCompletion
        let stubbedError = DummyError(customDescription: "product list fetch error")
        completion?(.failure(stubbedError))

        XCTAssertEqual(capturedError?.localizedDescription, stubbedError.localizedDescription)
    }
}
