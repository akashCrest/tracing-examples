//
//  ProductList.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper


class ProductList: Mappable {
    var id : String = ""
    var description: String = ""
    var picture: String = ""
    var name : String = ""
    var priceUsd : productPrice?
    var categories : [String] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        picture         <- map["picture"]
        name            <- map["name"]
        priceUsd        <- map["priceUsd"]
        id              <- map["id"]
        description     <- map["description"]
        categories      <- map["categories"]
    }
}

class productPrice : Mappable {
    
    var currencyCode : String?
    var units : Int?
    var nanos : Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        currencyCode    <- map["currencyCode"]
        units           <- map["units"]
        nanos           <- map["nanos"]
    }
}


