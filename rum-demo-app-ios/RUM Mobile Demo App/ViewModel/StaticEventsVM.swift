//
//  StaticEventsVM.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 17/01/22.
//

import UIKit
import Foundation

class StaticEventsVM {
    
    // MARK: - Properties
    private var staticevent: StaticEvents?{
        didSet {
            self.didFinishFetch?()
        }
    }
    var responsecode: Int = 0
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: - Network call
    /**
     *description: API call for specific error codes of response.
     *Parameter withcode: The error code of expected from the API response code.
    */
    func staticEvent(withcode : Int, completion: (()->Void)? = nil) {
        var URL = ""
        if withcode == 400{
            URL = "\(Configuration().rootAPIUrl)/cart/checkouts"
        }
        else{
            URL = "https://mock.codes/500"
        }
        
        DataService.request( URL , method: .get, params:[:], type: StaticEvents.self) { (staticevent, error , responsecode) in
                self.responsecode = responsecode
                self.staticevent = staticevent
                self.error = error as? Error
                completion?()
        }
        
       
    }
    // MARK: - Slow Api response
    /**
     *description: API call for cart.
    */
    func slowApiResponse(completion: (()->Void)? = nil){
        //Change value(seconds) for slow response
        let delay = 5
        DataService.request( "https://run.mocky.io/v3/a8d9f55d-f6dc-4f3a-9ac4-3b7b787555cc?mocky-delay=\(delay)s" , method: .get, params:[:], type: StaticEvents.self) { (staticevent, error , responsecode) in
                completion?()
                self.responsecode = responsecode
                self.staticevent = staticevent
                self.error = error as? Error
        }
    }
    
    //MARK: - Crash the app
    /**
     Crash the app forcefully
     */
    
    func crashApp() {
        let null = UnsafePointer<UInt8>(bitPattern: 0)
        _ = null!.pointee
    }
    
    //MARK: - Freeze the app
    /**
     Freeze the user intercation of  the app for specified seconds. This will add one transparent view on the root window and will block the user actions on the screen below it.
     */
    func freezeApp() {
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
            let blockerView = UIView.init(frame: appDel.window?.frame ?? .zero)
            appDel.window?.addSubview(blockerView)
            
            //Freeze time is 5.0 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                blockerView.removeFromSuperview()
            }
        }
    }
}
