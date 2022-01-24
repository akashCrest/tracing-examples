//
//  CartVC.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import Foundation
import UIKit
import Network

class CartVC  : UIViewController{
    
    @IBOutlet weak var viewPriceInfo: UIView!
    @IBOutlet weak var btnCheckOut: RoundedCornerButton!
    
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var topMostConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnEmptyCart: UIButton!
    
    
    @IBOutlet weak var lblshippingCost: UILabel!
    
    @IBOutlet weak var lblShippingCostPrice: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    @IBOutlet weak var lblTotalCostPrice: UILabel!
    
    
    var cartViewModel = CartVM()
    var selectedProducts = [pickedProduct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBlueHeader(title: "RUM Mobile Demo", isRightButtonHidden: false, isBackButtonHidden: true)
        viewPriceInfo.addShadow()
        btnCheckOut.addTextSpacing()
        setTopConstraint()
        cartViewModel.callCartAPI {
            self.showCartInformation()
        }
    }
    func setTopConstraint(){
        if UIDevice.current.hasNotch {
            topMostConstraint.constant = 50
        }
        else{
            topMostConstraint.constant = 20
        }
    }
    func showCartInformation(){
        
        selectedProducts = sharedCart.cartItems!
        
        var itemCount = 0
        
        var totalCost : Float = 0
        for eachItem in selectedProducts {
            let priceString = "\(eachItem.product.priceUsd?.units?.description ?? "00").\(eachItem.product.priceUsd?.nanos?.description.substring(to: 2) ?? "00")"
            totalCost = totalCost + (Float(priceString) ?? 1) * Float(eachItem.quantity)
            
            itemCount += eachItem.quantity
        }
        
        lblTotalCostPrice.text = "\(Constants.DefaultCurrencyCode) \(totalCost)"
        
        lblCartCount.text = "\(itemCount) item(s) in your cart"
        sharedCart.setItemsCountAsBadge()  // set item count as badge
        
        tblCart.reloadData()
    }
    
    //MARK: - Button Action
    @IBAction func btnCheckOutClicked(_ sender: Any) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "CheckOutVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEmptyCartClicked(_ sender: Any) {
        cartViewModel.emptyCart()
        gotoHomeTab(andRemoveBadge: true, andShowProductDetail: false, withProduct: nil)
    }
    
    /**
     *description: Go to the home/first tab of Tabbar. This change the root navigation controller's top view controller.
     *Parameter andRemoveBadge: Decide whether to remove the badge icon from the cart icon or not.
     *Parameter andShowProductDetail: This flag decides whether it redirects to the prodcut details page or not after navigating to the Home/Product listing screen.
     *Parameter withProduct: Optional parameter used when it needs to redirect user to product details page based on 'andShowProductDetail' flag value.
    */
    func gotoHomeTab(andRemoveBadge:Bool,andShowProductDetail:Bool,withProduct:ProductList?){
        // go to product list screen.
        let tabContoller = window?.rootViewController as? SlideAnimatedTabbarController
        tabContoller?.animateToTab(toIndex: 0, completionHandler: {success in
            if andShowProductDetail == true && withProduct != nil {
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                let product = withProduct
                vc.product = product
                let navController = tabContoller?.selectedViewController as? UINavigationController
                if navController?.visibleViewController is ProductListVC {
                    navController?.pushViewController(vc, animated: false)
                }
                else if navController?.visibleViewController is ProductDetailVC {
                    navController?.popViewController(animated: false)
                    navController?.pushViewController(vc, animated: false)
                }
            }
        })
        
        if andRemoveBadge == true {
            tabContoller?.tabBar.removeBadge(fromIndex: 1)
        }
       
    }
    
}
extension CartVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableCell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartTableCell
       
      // cell.lblName?.text = "Demo"
        let product = self.selectedProducts[indexPath.row]
        cell.lblName.text = product.product.name
        cell.lblName.addTextSpacing(spacing: 4.5)
        cell.lblProductID.text = "SKU: \(product.product.id)"
        cell.lblQuantity.text = "Quantity: \(product.quantity)"
        
        cell.lblPrice.text =  "\(product.product.priceUsd?.currencyCode ?? Constants.DefaultCurrencyCode) \(product.product.priceUsd?.units?.description ?? "00").\(product.product.priceUsd?.nanos?.description.substring(to: 2) ?? "00")"
        
        cell.productImg.image = UIImage.init(named: product.product.picture)
        cell.productImg.contentMode = .scaleAspectFill
       
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.selectedProducts[indexPath.row]
        gotoHomeTab(andRemoveBadge: false, andShowProductDetail: true, withProduct: product.product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
