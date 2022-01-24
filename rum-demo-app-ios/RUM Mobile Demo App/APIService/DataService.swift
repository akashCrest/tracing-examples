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
import AlamofireObjectMapper
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
        let tracer = OpenTelemetrySDK.instance.tracerProvider.get(instrumentationName:config.RUM_TRACER_NAME )
        let span = tracer.spanBuilder(spanName: "API call").startSpan()
        span.setAttribute(key: "API URL", value: urlString)
        
      
        Alamofire.request(urlString, method: method, parameters: params).responseObject { (response: DataResponse<T>) in
           
            APProgressHUD.shared.dismissProgressHUD()
            completion(nil, nil , 200)
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
    
    
