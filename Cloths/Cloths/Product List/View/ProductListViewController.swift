import Foundation
import UIKit

struct ProductListViewModel: Equatable {
    let category: String
    let products: [ProductViewModel]
}

protocol ProductListViewInterface: AnyObject {
    func didFetch(productList: [ProductListViewModel])
}

final class ProductListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var productList = [ProductListViewModel]()
}

extension ProductListViewController: ProductListViewInterface {
    func didFetch(productList: [ProductListViewModel]) {
        self.productList = productList
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList[section].products.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        productList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productList[section].category
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? ProductTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(viewModel: productList[indexPath.section].products[indexPath.row])
        return cell
    }
}
