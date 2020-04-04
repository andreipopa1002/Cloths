import Foundation

protocol BasketServiceInterface {

}

final class BasketService: BasketServiceInterface {
    private let decodingService: DecodingServiceInterface

    init(decodingService: DecodingServiceInterface) {
        self.decodingService = decodingService
    }
}
