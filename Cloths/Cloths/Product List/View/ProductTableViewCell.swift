import Foundation
import UIKit

struct ProductViewModel: Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        let addToBasketActionExistence = (lhs.addToBasketAction == nil && rhs.addToBasketAction == nil) || (lhs.addToBasketAction != nil && rhs.addToBasketAction != nil)
        let addToWishListActionExistence = (lhs.addToWishListAction == nil &&  rhs.addToWishListAction == nil) || (lhs.addToWishListAction != nil && rhs.addToWishListAction != nil)
        return lhs.name == rhs.name &&
            lhs.oldPrice == rhs.oldPrice &&
            lhs.price == rhs.price &&
            lhs.stockNumber == rhs.stockNumber &&
            addToBasketActionExistence && addToWishListActionExistence
    }

    let name: String
    let price: String
    let oldPrice: String?
    let stockNumber: String
    let addToBasketAction: (() -> ())?
    let addToWishListAction: (() -> ())?
}

final class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!

    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var addToBasketButton: UIButton!
    private var addToWishListAction: (() -> ())?
    private var addToBasketListAction: (() -> ())?

    func setup(viewModel: ProductViewModel) {
        productLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        oldPriceLabel.text = viewModel.oldPrice
        stockLabel.text = viewModel.stockNumber
        addToBasketListAction = viewModel.addToBasketAction
        addToBasketButton.isHidden = viewModel.addToBasketAction == nil ? true : false
        addToWishListAction = viewModel.addToWishListAction
    }
    @IBAction func didTapAddToWishListButton(_ sender: Any) {
    }
    @IBAction func didTapAddToBasketButton(_ sender: Any) {
        addToBasketListAction?()
    }
}
