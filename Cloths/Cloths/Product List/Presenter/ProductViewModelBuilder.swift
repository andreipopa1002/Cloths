import Foundation

protocol ProductViewModelBuilderInterface {
    func viewModel(from productList: [Product]) -> [ProductListViewModel]
}

final class ProductViewModelBuilder: ProductViewModelBuilderInterface {
    func viewModel(from productList: [Product]) -> [ProductListViewModel] {
        let sortedSections = Set(productList.map {$0.category}).sorted()
        var productListViewModel = [ProductListViewModel]()

        sortedSections.forEach { section in
            let productsForSection = productList.filter { $0.category == section }
            productListViewModel.append(
                ProductListViewModel(
                    category: section,
                    products: productsForSection.map { productViewModel(from: $0) }
                )
            )
        }

        return productListViewModel
    }
}

private extension ProductViewModelBuilder {
    func productViewModel(from product: Product) -> ProductViewModel {
        var oldPrice: String?
        if let price = product.oldPrice {
            oldPrice = "Old price: " + price
        }
        
        return ProductViewModel(
            name: "Product: " + product.name,
            price: "Price: " + product.price,
            oldPrice: oldPrice,
            addToBasketAction: {}
        )
    }
}
