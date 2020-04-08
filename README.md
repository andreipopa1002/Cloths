# Cloths
#### Problem
1. Done: As a Customer I can view the products and their category, price, old price for discounted products and availability information. 
2. Done: As a Customer I can add a product to my shopping cart.
3. Done: As a Customer I can add a product to my wishlist.
4. As a Customer I can remove a product from my shopping cart.
5. As a Customer I can view the total price for the products in my shopping cart. 
6. Done: As a Customer I am unable to add Out of Stock products to the shopping cart. 
7. As a Customer I can remove a product from my wishlist.
8. Done: As a Customer I can move a product from my wishlist to the shopping cart.

#### App layout
To achieve the acceptance criteria a set of 3 screens are needed:
  - product list screen -> this will be the main screen with 2 tab bar items on each side one for wish list and one for basket
  - wish list screen 
  - basket screen
 The problem can be simplified and all these screens display a list of products with different options per products:
 - product list scree, options: Add to wish list, Add to basket
 - wish list screen, options: Add to basket, Remove from wish list
 - basket screen, options: Remove from basket
 The same view controller(a product list) can be configured and composed to service all 3 screens in the following way:
 Product list screen: the product list view controller can be imbedded into a navigation controller and two bar buttons buttons added to the nav bar.
 The Wish list screen: the product list view controller can be imbedded into a navigation controller and add one tab bar button to be able to close it. The products displayed will be only the ones added to the wishlist
 The Basket screen: the product list view controller can be imbedded into a navigation controller and add one tab bar button to be able to close it. The products displayed will be the only ones added to the basket. Further more the product list view controller can be imbedded into another view controller that can present the total amount calculation and proceed to payment.
 Wish List persistence is acchieved by using UserDefaults.
 
 #### Architecture
 To implement the Product list view controller I used a VIPER architecture.
 ProductListViewController-> - ProductListPresenter(ProductListViewModelBuilder) -ProductListRouter ->Interactor->Services(WishListService, BasketService, ProductListService)
 By changing the interactor implementation we are able to adjust what product are displayed.
 ViewModelBuilder: this component of the presenter will create a struct hierarchy that will contained all the data and order that the view needs to render. These view models are not the same as MVVM. They are just containers for formatted data that can be rendered.
 ProductListRouter: at this point there is only one routing happening from the product list: when error is presented.
 
 #### Services
 ProductListService and BasketService are based on a set of abstractions on top of URLSession. The abstractions are composed over the follwing service:
- DecodingService: will have a type inferred to decode the json data into
- AuthorizationService: will append the authorization headers to the request, will take a dependency that will provide the authorization key.
- NetworkingService: abstractization over URLSession to achieve testability and use of the Result type.

#### Aspects not implemented:
- string localization
- loading animations for when calls are in progress
- secure storage of the API key

 
