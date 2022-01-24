//
//  CartVM.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import Foundation
import UIKit

class CartVM{
    // MARK: - Properties
    let cart = Cart.sharedInstance
    
    /**
     *description: Function to add product in cart. This function checks if that item is already added in the cart then it will increase the quantiy of that item instead of duplicating item.
     *Parameter item: model of product which is picked for adding cart action.
    */
    func addItemToCart(item:pickedProduct ){
        var selectedProducts = self.cart.cartItems
        
        // check that item is already in list then update it else add new item.
        let filtered  =  selectedProducts?.filter{$0.product.id == item.product.id}
        if filtered?.count == 0{ //add it
            selectedProducts?.append(item)
        }
        else{  //update it
            filtered?.forEach{$0.quantity += item.quantity}
           
        }
        self.cart.cartItems = selectedProducts
    }
    
    /**
     *description: API call for cart.
     *Parameter productID: The ID of product selected by user.
    */
    func callCartAPI(completion : @escaping ()->Void) {
        DataService.request(getURL(for: ApiName.Cart.rawValue), method: .get, params: nil, type: ProductDetail.self) { productDetail, errorMessage, responseCode in
            
            completion()
        }
    }
    
    /**
     *description: Clear the cart by removing products from the shared instance.
    */
    func emptyCart(){
        self.cart.cartItems?.removeAll()
    }
}
