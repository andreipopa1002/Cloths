import XCTest
@testable import Cloths

final class ProductTests: XCTestCase {

    func test_WhenDecode_ThenProducts() {
        let decoder = JSONDecoder()
        let dataJson = fiveProductsStringJson().data(using: .utf8)!
        let products = try? decoder.decode([Product].self, from: dataJson)
        XCTAssertEqual(products, expectedProducts())
    }
}

private extension ProductTests {
    func expectedProducts() -> [Product] {
        return [Product(id: 1, name: "Almond Toe Court Shoes, Patent Black", category: "Women’s Footwear", price: "99.00", oldPrice: nil, stock: 5),
        Product(id: 2, name: "Suede Shoes, Blue", category: "Women’s Footwear", price: "42.00", oldPrice: nil, stock: 4),
        Product(id: 3, name: "Leather Driver Saddle Loafers, Tan", category: "Men’s Footwear", price: "34.00", oldPrice: nil, stock: 12),
        Product(id: 4, name: "Flip Flops, Red", category: "Men’s Footwear", price: "19.00", oldPrice: "20.21", stock: 6)]
    }

    func fiveProductsStringJson() -> String {
        """
        [
        {
        "id":1,
        "name":"Almond Toe Court Shoes, Patent Black",
        "category":"Women’s Footwear",
        "price":"99.00",
        "oldPrice":null,
        "stock":5
        },
        {
        "id":2,
        "name":"Suede Shoes, Blue",
        "category":"Women’s Footwear",
        "price":"42.00",
        "oldPrice":null,
        "stock":4
        },
        {
        "id":3,
        "name":"Leather Driver Saddle Loafers, Tan",
        "category":"Men’s Footwear",
        "price":"34.00",
        "oldPrice":null,
        "stock":12
        },
        {
        "id":4,
        "name":"Flip Flops, Red",
        "category":"Men’s Footwear",
        "price":"19.00",
        "oldPrice":"20.21",
        "stock":6
        }
        ]
        """
    }
}

extension Product {
    static var stub: Product {
        Product(id: 0,
                name: "name",
                category: "category",
                price: "123.32",
                oldPrice: nil,
                stock: 2
        )
    }
}
