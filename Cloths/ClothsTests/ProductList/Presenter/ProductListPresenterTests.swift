import XCTest
@testable import Cloths

final class ProductListPresenterTests: XCTestCase {
    private var presenter: ProductListPresenter!
    private var mockedInteractor: MockProductListInteractor!
    private var mockedRouter: MockProductListRouter!
    private var mockedViewModelBuilder: MockViewModelBuilder!
    private var mockedView: MockProductListView!

    override func setUp() {
        super.setUp()

        mockedInteractor = MockProductListInteractor()
        mockedRouter = MockProductListRouter()
        mockedViewModelBuilder = MockViewModelBuilder()
        mockedView = MockProductListView()
        presenter = ProductListPresenter(
            interactor: mockedInteractor,
            router: mockedRouter,
            viewModelBuilder: mockedViewModelBuilder
        )
        presenter.view = mockedView
    }

    override func tearDown() {
        mockedInteractor = nil
        mockedRouter = nil
        mockedViewModelBuilder = nil
        mockedView = nil
        presenter = nil

        super.tearDown()
    }

    // MARK: - onViewDidLoad
    func test_WhenOnViewDidLoad_ThenInteractorGetproductList() {
        presenter.onViewDidLoad()
        XCTAssertEqual(mockedInteractor.spyGetProductListCallCount, 1)
    }

    // MARK: - didFailed
    func test_WhenDidFailed_ThenRouterWithError() {
        mockedRouter.expectation = expectation(description: "main thread expectation")
        presenter.didFailed(error: DummyError(customDescription: "did failed"))
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(
                self.mockedRouter.spyPresentError.map {$0.localizedDescription},
                ["did failed"]
            )
        }
    }

    // MARK: - didFetch
    func test_WhenDidFetched_ThenViewModelBuilderReceivedsProducts() {
        mockedView.expectation = expectation(description: "main thread expectation")
        let products = [Product.stub]

        presenter.didFetched(products: products)

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedViewModelBuilder.spyViewModelProductList, [products])
        }
    }

    func test_WhenDidFetched_ThenViewReceivesViewModelFromBuilder() {
        mockedView.expectation = expectation(description: "main thread expectation")
        let stubbedViewModel = [ProductListViewModel.stub]
        mockedViewModelBuilder.stubbedViewModel = stubbedViewModel

        presenter.didFetched(products: [Product.stub])

        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(self.mockedView.spyDidFetchProductList, [stubbedViewModel])
        }
    }
}

private class MockProductListInteractor: ProductListInteractorInterface {
    private(set) var spyGetProductListCallCount = 0

    func getProductList() {
        spyGetProductListCallCount += 1
    }
}

private class MockProductListRouter: ProductRouterInterface {
    var expectation: XCTestExpectation?
    private(set) var spyPresentError = [Error]()

    func present(error: Error) {
        spyPresentError.append(error)
        expectation?.fulfill()
    }
}

private class MockViewModelBuilder: ProductViewModelBuilderInterface {
    private(set) var spyViewModelProductList = [[Product]]()
    var stubbedViewModel = [ProductListViewModel]()

    func viewModel(from productList: [Product]) -> [ProductListViewModel] {
        spyViewModelProductList.append(productList)
        return stubbedViewModel
    }
}

private class MockProductListView: ProductListViewInterface {
    var expectation: XCTestExpectation?
    private(set) var spyDidFetchProductList = [[ProductListViewModel]]()

    func didFetch(productList: [ProductListViewModel]) {
        spyDidFetchProductList.append(productList)
        expectation?.fulfill()
    }
}

private extension ProductListViewModel {
    static var stub: ProductListViewModel {
        ProductListViewModel(category: "cat1", products: [])
    }
}
