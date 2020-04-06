import Foundation

protocol ProductViewModelBuilderInterface {
    func viewModel(from productList: [Product]) -> [ProductListViewModel]
}

final class ProductViewModelBuilder {
    enum Configuration {
        case addToBasket, addToWishList, all, none
    }
    private let interactor: ProductListInteractorInterface
    private let configuration: Configuration

    init(
        interactor: ProductListInteractorInterface,
        configuration: ProductViewModelBuilder.Configuration = .all
    ) {
        self.interactor = interactor
        self.configuration = configuration
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
        
        return ProductViewModel(
            name: "Product: " + product.name,
            price: "Price: " + product.price,
            oldPrice: oldPrice,
            stockNumber: "\(product.stock) in stock",
            addToBasketAction: addToBasketAction(product: product),
            addToWishListAction: addToWishListAction(product: product)
        )
    }

    func addToBasketAction(product: Product) -> (() -> ())? {
        guard product.stock > 0 else { return nil }

        switch configuration {
        case .addToBasket, .all:
            return { [weak self] in
                self?.interactor.addToBasket(productId: product.id)
            }
        default:
            return nil
        }
    }

    func addToWishListAction(product: Product) -> (() -> ())? {
        switch configuration {
        case .addToWishList, .all:
            return { [weak self] in
                self?.interactor.addToWishList(productId: product.id)
            }
        default:
            return nil
        }
    }
}
