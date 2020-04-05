import XCTest
@testable import Cloths

final class ProductListInteractorTests: XCTestCase {
    private var interactor: ProductListInteractor!
    private var mockedProductListService: MockProductService!
    private var mockedBasketService: MockBasketService!
    private var mockedWishListService: MockWishListService!
    private var mockedOutput: MockInteractorOutput!

    override func setUp() {
        super.setUp()

        mockedProductListService = MockProductService()
        mockedBasketService = MockBasketService()
        mockedWishListService = MockWishListService()
        mockedOutput = MockInteractorOutput()
        interactor = ProductListInteractor(
            productListService: mockedProductListService,
            basketService: mockedBasketService,
            wishListService: mockedWishListService
        )
        interactor.output = mockedOutput
    }

    override func tearDown() {
        mockedProductListService = nil
        mockedBasketService = nil
        mockedWishListService = nil
        interactor = nil

        super.tearDown()
    }

    // MARK: - getProductList
    func test_GivenSuccess_WhenGetProducts_ThenOutputWithProducts() {
        interactor.getProductList()
        mockedProductListService.spyCompletion?(.success([.stub]))
        XCTAssertEqual(mockedOutput.spyDidFetch, [[.stub]])
    }

    func test_GivenFailure_WhenGetProducts_ThenOutputWithError() {
        interactor.getProductList()
        mockedProductListService.spyCompletion?(.failure(.unauthorized))
        XCTAssertEqual(
            mockedOutput.spyDidFailedFetchingProducts,
            [.unauthorized])
    }

    func test_OutputIsWeak() {
        var output: ProductListInteractorOutputInterface? = MockInteractorOutput()
        interactor.output = output
        output = nil
        XCTAssertNil(interactor.output)
    }

    // MARK: - addToBasket(productId:)
    func test_WhenAddToBasked_ThenBasketServiceWithId() {
        interactor.addToBasket(productId: 123)
        XCTAssertEqual(mockedBasketService.spyAddProductId, [123])
    }

    func test_GivenFailure_WhenAddToBasket_ThenOutputWithError() {
        interactor.addToBasket(productId: 123)
        mockedBasketService.spyAddCompletion?(.failure(.notInStock))
        XCTAssertEqual(mockedOutput.spyDidFailedAddToBasket, [.notInStock])
    }

    // MARK: - addToWishList(productId:)
    func test_WhenAddToWishList_ThenWishListServiceAdd() {
        interactor.addToWishList(productId: 123)
        XCTAssertEqual(mockedWishListService.spyAddToWishList, [123])
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
    private(set) var spyDidFailedFetchingProducts = [AuthorizedServiceError]()
    private(set) var spyDidFailedAddToBasket = [BasketServiceError]()

    func didFetched(products: [Product]) {
        spyDidFetch.append(products)
    }

    func didFailedFetchingProducts(error: AuthorizedServiceError) {
        spyDidFailedFetchingProducts.append(error)
    }

    func didFailedAddToBasket(error: BasketServiceError) {
        spyDidFailedAddToBasket.append(error)
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

private class MockWishListService: WishListServiceInterface {
    private(set) var spyAddToWishList = [Int]()
    var stubbedProductIds: [Int] = []

    func addToWishList(productId: Int) {
        spyAddToWishList.append(productId)
    }

    func productIdsFromWishList() -> [Int] {
        return stubbedProductIds
    }
}
