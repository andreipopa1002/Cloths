import XCTest
@testable import Cloths

final class ProductViewModelBuilderTests: XCTestCase {
    private var builder: ProductViewModelBuilder!
    private var mockedInteractor: MockProductListInteractor!

    override func setUp() {
        super.setUp()

        mockedInteractor = MockProductListInteractor()
        builder = ProductViewModelBuilder(interactor: mockedInteractor)
    }

    override func tearDown() {
        mockedInteractor = nil
        builder = nil

        super.tearDown()
    }

    func test_GivenEmptyProducts_WhenViewModel_ThenNoViewModels() {
        let viewModels = builder.viewModel(from: [])
        XCTAssertTrue(viewModels.isEmpty)
    }

    func test_GivenMultipleUnorderedProducts_WhenViewModel_ThenViewModelHas3Categories() {
        let viewModels = builder.viewModel(from: unorderedProducts())
        XCTAssertEqual(viewModels.map {$0.category}, ["cat1", "cat2", "cat3"])
    }

    func test_GivenMultipleUnordoredProducts_WhenViewModel_ThenCat1Has2Products() {
        let expectedViewModels = [
            ProductViewModel(name: "Product: ab", price: "Price: 1", oldPrice: "Old price: 2", stockNumber: "2 in stock", addToBasketAction: {}),
            ProductViewModel(name: "Product: ab2", price: "Price: 3", oldPrice: nil, stockNumber: "2 in stock", addToBasketAction: {})
            ]

        XCTAssertEqual(productViewModels(forCategory: "cat1"), expectedViewModels)
    }

    func test_GivenMultipleUnordoredProducts_WhenViewModel_ThenCat2Has1Product () {
        let expectedViewModels = [ProductViewModel(name: "Product: az", price: "Price: 1", oldPrice: nil, stockNumber: "0 in stock", addToBasketAction: nil)]

        XCTAssertEqual(productViewModels(forCategory: "cat2"), expectedViewModels)
    }

    func test_GivenMultipleUnordoredProducts_WhenViewModel_ThenCat3Has1Product () {
        let expectedViewModels = [ProductViewModel(name: "Product: aa", price: "Price: 1", oldPrice: "Old price: 2", stockNumber: "1 in stock", addToBasketAction: {})]
        XCTAssertEqual(productViewModels(forCategory: "cat3"), expectedViewModels)
    }
}

private extension ProductViewModelBuilderTests {
    func productViewModels(forCategory category: String) -> [ProductViewModel] {
        let viewModels = builder.viewModel(from: unorderedProducts())
        let cat2ViewModels = viewModels.filter {$0.category == category}
        return cat2ViewModels.flatMap {$0.products}
    }

    func unorderedProducts() -> [Product] {
        [Product(id: 1, name: "aa", category: "cat3", price: "1", oldPrice: "2", stock: 1),
         Product(id: 2, name: "ab", category: "cat1", price: "1", oldPrice: "2", stock: 2),
         Product(id: 3, name: "az", category: "cat2", price: "1", oldPrice: nil, stock: 0),
         Product(id: 4, name: "ab2", category: "cat1", price: "3", oldPrice: nil, stock: 2)]
    }
}
