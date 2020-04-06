import Foundation

protocol WishListServiceInterface {
    func addToWishList(productId: Int)
    func productIdsFromWishList() -> [Int]
    func removeFromWishList(productId: Int)
}

protocol SimplePersistenceInterface {
    func set(_ value: Any?, forKey defaultName: String)
    func array(forKey defaultName: String) -> [Any]?
}
extension UserDefaults: SimplePersistenceInterface {}

final class WishListService {
    private let simplePersistence: SimplePersistenceInterface
    private let persistenceKey = "cloths.wishList"

    init(simplePersistence: SimplePersistenceInterface) {
        self.simplePersistence = simplePersistence
    }
}

extension WishListService: WishListServiceInterface {
    func addToWishList(productId: Int) {
        var currentWishList = productIdsFromWishList()
        currentWishList.append(productId)

        simplePersistence.set(currentWishList, forKey: persistenceKey)
    }

    func productIdsFromWishList() -> [Int] {
        let list = simplePersistence.array(forKey: persistenceKey) as? [Int]
        return list ?? []
    }

    func removeFromWishList(productId: Int) {
        let productIds = productIdsFromWishList()
        simplePersistence.set(productIds.filter {$0 != productId}, forKey: persistenceKey)
    }
}
