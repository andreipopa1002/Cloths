import Foundation

protocol ProductViewModelBuilderInterface {
    func viewModel(from productList: [Product]) -> [ProductListViewModel]
}

final class ProductViewModelBuilder {
    private let interactor: ProductListInteractorInterface!

    init(interactor: ProductListInteractorInterface) {
        self.interactor = interactor
    }
}

extension ProductViewModelBuilder:  ProductViewModelBuilderInterface {
    func viewModel(
        from productList: [Product]) -> [ProductListViewModel] {
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

        var addToBasketAction: (() -> ())?
        if product.stock > 0 {
            addToBasketAction = { [weak self] in
                self?.interactor.addToBasket(productId: product.id)
            }
        }
        
        return ProductViewModel(
            name: "Product: " + product.name,
            price: "Price: " + product.price,
            oldPrice: oldPrice,
            stockNumber: "\(product.stock) in stock",
            addToBasketAction: addToBasketAction
        )
    }
}
