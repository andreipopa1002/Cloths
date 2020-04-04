import XCTest
@testable import Cloths

final class ProductListInteractorTests: XCTestCase {
    private var interactor: ProductListInteractor!
    private var mockedProductListService: MockProductService!
    private var mockedBasketService: MockBasketService!
    private var mockedOutput: MockInteractorOutput!

    override func setUp() {
        super.setUp()

        mockedProductListService = MockProductService()
        mockedBasketService = MockBasketService()
        mockedOutput = MockInteractorOutput()
        interactor = ProductListInteractor(
            productListService: mockedProductListService,
            basketService: mockedBasketService)
        interactor.output = mockedOutput
    }

    override func tearDown() {
        mockedProductListService = nil
        mockedBasketService = nil
        interactor = nil

        super.tearDown()
    }

    func test_GivenSuccess_WhenGetProducts_ThenOutputWithProducts() {
        interactor.getProductList()
        mockedProductListService.spyCompletion?(.success([.stub]))
        XCTAssertEqual(mockedOutput.spyDidFetch, [[.stub]])
    }

    func test_GivenFailure_WhenGetProducts_ThenOutputWithError() {
        interactor.getProductList()
        mockedProductListService.spyCompletion?(.failure(DummyError(customDescription: "failed to fetch products")))
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

private class MockBasketService: BasketServiceInterface {
    private(set) var spyAddProductId = [Int]()
    private(set) var spyAddCompletion: BasketAddCompletion?

    func add(productId: Int, completion: @escaping BasketAddCompletion) {
        spyAddProductId.append(productId)
        spyAddCompletion = completion
    }
}
