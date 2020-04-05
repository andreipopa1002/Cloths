import XCTest
@testable import Cloths

final class WishListServiceTests: XCTestCase {
    private var service: WishListService!
    private var mockedSimplePersistence: MockSimplePersistence!

    override func setUp() {
        super.setUp()

        mockedSimplePersistence = MockSimplePersistence()
        service = WishListService(simplePersistence: mockedSimplePersistence)
    }

    override func tearDown() {
        service = nil
        mockedSimplePersistence = nil
    }

    // MARK: - addToWishList(productId)
    func test_GivenFirstPersistedProduct_WhenAddToWishList_ThenSaveProduct() {
        service.addToWishList(productId: 1)
        XCTAssertEqual(mockedSimplePersistence.spySet.map {$0.value} as? [[Int]], [[1]])
    }

    func test_GivenFirstPersistedProduct_WhenAddToWishList_ThenSaveWithKey() {
        service.addToWishList(productId: 1)

        XCTAssertEqual(mockedSimplePersistence.spySet.map {$0.key}, ["cloths.wishList"])
    }

    func test_GivenPreviousSavedProduct_WhenAddToWishList_ThenAppendProduct() {
        mockedSimplePersistence.stubbedArray = [1, 2, 3]
        service.addToWishList(productId: 4)
        XCTAssertEqual(mockedSimplePersistence.spySet.map{$0.value} as? [[Int]], [[1,2,3,4]])
    }

    // MARK: productIdsFromWishList
    func test_GivenProductExist_WhenProductIdFromWishList_ThenReturnProducts() {
        mockedSimplePersistence.stubbedArray = [1, 3, 4]
        XCTAssertEqual(service.productIdsFromWishList(), [1, 3, 4])
    }

    func test_GivenProductExists_WhenProductIdFromWishList_ThenUseKey() {
        _ = service.productIdsFromWishList()
        XCTAssertEqual(mockedSimplePersistence.spyArrayKey, ["cloths.wishList"])
    }

    func test_GivenNoProductsSaved_WhenProductIdFromWishList_ThenReturnEmptyArray() {
        mockedSimplePersistence.stubbedArray = nil
        XCTAssertEqual(service.productIdsFromWishList(), [])
    }
}

private class MockSimplePersistence: SimplePersistenceInterface {
    private(set) var spySet =  [(value: Any?, key: String)]()
    private(set) var spyArrayKey = [String]()
    var stubbedArray: [Any]?

    func set(_ value: Any?, forKey defaultName: String) {
        spySet.append((value, defaultName))
    }

    func array(forKey defaultName: String) -> [Any]? {
        spyArrayKey.append(defaultName)
        return stubbedArray
    }


}
