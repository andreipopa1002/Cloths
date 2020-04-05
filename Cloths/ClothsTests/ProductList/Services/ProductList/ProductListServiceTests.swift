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

    func test_GivenSuccessWithProducts_WhenFetchProductList_ThenResultWithSameProduct() {
        var capturedProducts: [Product]?
        service.fetchProductList { result in
            if case .success(let products) = result {
                capturedProducts = products
            }
        }

        let completion = mockedDecodingService.spyCompletion as? DecodingServiceCompletion<[Product]>
        completion?(.success(([Product.stub], nil)))

        XCTAssertEqual(capturedProducts, [Product.stub])
    }

    func test_GivenSuccessWithNotProducts_WhenFetchProductList_ThenResultWithEmptyArray() {
        var capturedProducts: [Product]?
        service.fetchProductList { result in
            if case .success(let products) = result {
                capturedProducts = products
            }
        }

        let completion = mockedDecodingService.spyCompletion as? DecodingServiceCompletion<[Product]>
        completion?(.success((nil, nil)))

        XCTAssertEqual(capturedProducts?.isEmpty, true)
    }

    func test_GivenFailure_WhenFetchProductList_ThenResultWithSameError() {
        var capturedError: Error?
        service.fetchProductList { result in
            if case .failure(let error) = result  {
                capturedError = error
            }
        }

        let completion = mockedDecodingService.spyCompletion as? DecodingServiceCompletion<[Product]>
        let stubbedError = DescriptiveError(customDescription: "product list fetch error")
        completion?(.failure(AuthorizedServiceError.networkError(stubbedError)))

        XCTAssertTrue(capturedError is AuthorizedServiceError)
    }
}
