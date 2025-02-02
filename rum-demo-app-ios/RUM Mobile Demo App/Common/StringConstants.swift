//
//  StringConstants.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import Foundation

struct StringConstants{
    
    //MARK : - alert messages
    static let alertTitle  = "RUM Demo".localized()
    
    static let noURLMsg = "Please enter URL.".localized()
    static let urlIsNotProperMsg = "Entered URL is not valid. Please try again with valid URL.".localized()
    static let gotoSettingMsg = "Please go to Settings and turn on the permissions".localized()
    
    
    static let slowNetworkMsg = "No internet connection".localized()
    static let unableToResolveHost = "Unable to resolve host \"%@\": No address associated with hostname".localized()
    static let CommonErrorMsg =  "Something went wrong, please try again".localized()
    static let paymentFailed = "Payment Failed"
    static let paymentFailedDueToCC = "The provided credit card number is invalid, resulting in payment failure."
    static let paymentFailedDueToLocation = "We are apologise for inconvenience, but we cannot accept Payment in France."
    static let noInternetMessage = "There was a problem connecting to the server, please checked your network connection, and then try again."
    static let noInternetTitle = "Network issue"
    static let confirmEmptyCart = "Are you sure you want to empty your cart?"
}
