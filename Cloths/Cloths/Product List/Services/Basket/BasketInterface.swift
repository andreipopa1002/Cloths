import Foundation

struct BasketAddResponse: Decodable, Equatable {
    let message: String
}
enum BasketAddError: Error, Equatable {
    case notInStock, noProductWithProductId, unknown
    case authorizedError(AuthorizedServiceError)
}
typealias BasketAddResult = Result<Void, BasketAddError>
typealias BasketAddCompletion = (BasketAddResult) -> ()

struct BasketGetResponse: Decodable, Equatable {
    let id: Int
    let productId: Int
}

typealias BasketGetResult = Result<[BasketGetResponse], AuthorizedServiceError>
typealias BasketGetCompletion = (BasketGetResult) -> ()

protocol BasketServiceInterface {
    func add(productId: Int, completion:@escaping BasketAddCompletion)
    func getBasket(completion: @escaping BasketGetCompletion)
}
