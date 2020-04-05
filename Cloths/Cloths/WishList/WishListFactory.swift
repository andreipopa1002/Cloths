import Foundation
import UIKit

final class WishListhFactory {
    func viewController() -> UIViewController {
        let view = UIStoryboard.init(name: "Main", bundle: .main)
        .instantiateViewController(identifier: "ProductListViewController") as! ProductListViewController

        return view
    }
}
