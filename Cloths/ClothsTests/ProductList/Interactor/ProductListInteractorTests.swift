import XCTest
@testable import Cloths

final class ProductListInteractorTests: XCTestCase {
    private var interactor: ProductListInteractor!
    private var mockedService: MockProductService!
    private var mockedOutput: MockInteractorOutput!

    override func setUp() {
        super.setUp()

        mockedService = MockProductService()
        mockedOutput = MockInteractorOutput()
        interactor = ProductListInteractor(service: mockedService)
        interactor.output = mockedOutput
    }

    override func tearDown() {
        mockedService = nil
        interactor = nil

        super.tearDown()
    }

    func test_GivenSuccess_WhenGetProducts_ThenOutputWithProducts() {
        interactor.getProductList()
        mockedService.spyCompletion?(.success([.stub]))
        XCTAssertEqual(mockedOutput.spyDidFetch, [[.stub]])
    }

    func test_GivenFailure_WhenGetProducts_ThenOutputWithError() {
        interactor.getProductList()
        mockedService.spyCompletion?(.failure(DummyError(customDescription: "failed to fetch products")))
        XCTAssertEqual(
            mockedOutput.spyDidFailed.map{ $0.localizedDescription},
            ["failed to fetch products"])
    }

    func test_OutputIsWeak() {
        var output: ProductListInteractorOutputInterface? = MockInteractorOutput()
        interactor.output = output
        output = nil
        XCTAssertNil(interactor.output)
    }
}

private class MockProductService: ProductListServiceInterface {
    private(set) var spyCompletion: ProductListCompletion?

    func fetchProductList(completion: @escaping ProductListCompletion) {
        spyCompletion = completion
    }
}

private class MockInteractorOutput: ProductListInteractorOutputInterface {
    private(set) var spyDidFetch = [[Product]]()
    private(set) var spyDidFailed = [Error]()

    func didFetched(products: [Product]) {
        spyDidFetch.append(products)
    }

    func didFailed(error: Error) {
        spyDidFailed.append(error)
    }


}
