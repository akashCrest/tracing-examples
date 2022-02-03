//
//  RumEventHelper.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel3 on 25/01/22.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import SplunkOtel
import SplunkOtelCrashReporting

class RumEventHelper {
    
    static let shared = RumEventHelper()
    
    fileprivate let SplunkRumVersionString = "0.5.1"
    fileprivate var tracer : Tracer {
        get {
            return OpenTelemetry.instance.tracerProvider.get(instrumentationName: "splunk-ios", instrumentationVersion: SplunkRumVersionString)
        }
    }
    
    enum RumCustomEvent : String {
        case loggedInAndReady = "LoggedIn_and_Ready"
        case slowAPI = "Slow API"
        case productListLoaded = "Product List Loaded"
        case productViewed = "Product Viewed"
        case cart = "Cart"
        case checkout = "Checkout"
        case payment = "Payment"
        case paymentSuccessful = "Payment Successful"
        case paymentFailed = "Payment Failed"
    }
    
    /**
     Track custom events with addtional attributes to be add with the custom event.
    */
    func trackCustomRumEventFor(_ event : RumCustomEvent, attributes : [String : String]? = nil) {
        
        let span = tracer.spanBuilder(spanName: event.rawValue).startSpan()
        span.setAttribute(key: "workflow.name", value:
                            event.rawValue)
        
        if let attr = attributes {
            for eachkey in Array(attr.keys) {
                span.setAttribute(key: eachkey, value: attr[eachkey] ?? "")
            }
        }
        
        span.end()
    }
    
    /**
     Track errors with custom name
     */
    func addError(_ errorName: String, attributes : [String : String]? = nil) {
        
        let span = tracer.spanBuilder(spanName: errorName).startSpan()
        span.setAttribute(key: "component", value: "error")
        span.setAttribute(key: "error", value: true)
        span.setAttribute(key: "workflow.name", value:
                            errorName)
        span.setAttribute(key: "exception.type", value: errorName)
        
        if let attr = attributes {
            for eachkey in Array(attr.keys) {
                span.setAttribute(key: eachkey, value: attr[eachkey] ?? "")
            }
        }
        
        span.end()
    }
}
