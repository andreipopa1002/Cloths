import Foundation

struct Product: Decodable, Equatable{
    let id: Int
    let name: String
    let category: String
    let price: String
    let oldPrice: String?
    let stock: Int
}
