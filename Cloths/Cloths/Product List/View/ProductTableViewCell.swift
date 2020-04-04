import Foundation
import UIKit

struct ProductViewModel: Equatable {
    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.oldPrice == rhs.oldPrice &&
        lhs.price == rhs.price
    }

    let name: String
    let price: String
    let oldPrice: String?
    let addToBasketAction: () -> ()
}

final class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!

    private var addToWishListAction: (() -> ())?
    private var addToBasketListAction: (() -> ())?

    func setup(viewModel: ProductViewModel) {
        productLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        oldPriceLabel.text = viewModel.oldPrice
        addToBasketListAction = viewModel.addToBasketAction
    }
    @IBAction func didTapAddToWishListButton(_ sender: Any) {
    }
    @IBAction func didTapAddToBasketButton(_ sender: Any) {
        addToBasketListAction?()
    }
}
