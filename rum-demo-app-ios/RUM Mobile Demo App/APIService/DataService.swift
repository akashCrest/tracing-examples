//
//  File.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SplunkOtel
import OpenTelemetrySdk
import OpenTelemetryApi



class DataService{
    
    // MARK: - Singleton
    static let shared = DataService()
    
    // MARK: - Generic Request
    public static func request<T: Mappable>(_ urlString: String,
                                            method: HTTPMethod,
                                            params: Parameters?,
                                            type: T.Type,
                                            completion: @escaping (T?, String?,Int) -> Void){
        
        
        APProgressHUD.shared.showProgressHUD(nil)
        _ = AF.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).response { (response : AFDataResponse<Data?>) in
            
            APProgressHUD.shared.dismissProgressHUD()
            if response.response?.statusCode ?? 0 != 200 {
                let errorMessage = String.init(format: StringConstants.unableToResolveHost, urlString)
                completion(nil, errorMessage , 0)
            } else {
                completion(nil, nil , 200)
            }
            }
    }
    
    
}

enum ApiName: String{
    case ProductList = ""
    case AddToCart = "AddToCart"
    case CheckOut = "cart/checkout"
    case Payment = "Payment"
    case ProductDetails = "product/"
    case Cart = "cart"
}
func getURL(for apiname: String)-> String{
    //return "\(config.rootAPIUrl)/\(apiname)"
    return "\(config.rootAPIUrl)\(apiname)"
}


