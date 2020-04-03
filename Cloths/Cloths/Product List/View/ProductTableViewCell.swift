import Foundation
import UIKit

struct ProductViewModel: Equatable {
    let name: String
    let price: String
    let oldPrice: String?
}

final class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!

    func setup(viewModel: ProductViewModel) {
        productLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        oldPriceLabel.text = viewModel.oldPrice
    }
}
