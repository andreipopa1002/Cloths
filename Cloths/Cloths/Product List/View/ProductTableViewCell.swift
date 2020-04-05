import Foundation
import UIKit

struct ProductViewModel: Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        let closureExistance = (lhs.addToBasketAction == nil && rhs.addToBasketAction == nil) || (lhs.addToBasketAction != nil && rhs.addToBasketAction != nil)
        return lhs.name == rhs.name &&
            lhs.oldPrice == rhs.oldPrice &&
            lhs.price == rhs.price &&
            lhs.stockNumber == rhs.stockNumber && closureExistance
    }

    let name: String
    let price: String
    let oldPrice: String?
    let stockNumber: String
    let addToBasketAction: (() -> ())?
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
        addToBasketButton.isHidden = viewModel.addToBasketAction == nil ? true : false
        addToBasketListAction = viewModel.addToBasketAction
    }
    @IBAction func didTapAddToWishListButton(_ sender: Any) {
    }
    @IBAction func didTapAddToBasketButton(_ sender: Any) {
        addToBasketListAction?()
    }
}
