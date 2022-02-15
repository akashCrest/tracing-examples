//
//  URLConfigurationVC.swift
//  RUM Mobile Demo App
//
//  Created by Akash Patel on 06/01/22.
//

import Foundation
import UIKit
import OpenTelemetryApi
import OpenTelemetrySdk
import SplunkOtel
import SplunkOtelCrashReporting

class URLConfigurationVC : UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnDelayedLogin: UIButton!
    @IBOutlet weak var txtURL: DesignableUITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    @IBOutlet weak var imgGlobe: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnSubmit.addTextSpacing()
        btnDelayedLogin.addTextSpacing()
        //        lblTitle.textColor = config.commonScreenBgColor
        //        let image = UIImage(named: "worldwide")?.withRenderingMode(.alwaysTemplate)
        //        imgGlobe.tintColor = .lightGray
        //        imgGlobe.image = image
        
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.appBaseURL)
        UserDefaults.standard.synchronize()
        
        self.lblErrorMessage.isHidden = true
        self.txtURL.text = "http://pmrum.o11ystore.com/"
    }
    
    func setSubmitButtonStatus(){
        if txtURL.text?.isEmpty ?? true {
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.backgroundColor = config.disableButtonBgColor
            btnDelayedLogin.isUserInteractionEnabled = false
            btnDelayedLogin.backgroundColor = config.disableButtonBgColor
        }
        else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.backgroundColor =  config.commonScreenBgColor
            btnDelayedLogin.isUserInteractionEnabled = true
            btnDelayedLogin.backgroundColor = config.commonScreenBgColor
        }
        
    }
    
    func validateInputs() -> Bool {
        
        var urlToCheck = self.txtURL.text
        
        if urlToCheck?.last == "/" {
            urlToCheck?.removeLast()
        }
        
        if urlToCheck?.count == 0 {
            self.txtURL.layer.borderColor = UIColor.red.cgColor
            self.lblErrorMessage.isHidden = false
            self.lblErrorMessage.text = StringConstants.noURLMsg
            return false
        }
        else if urlToCheck?.isValidUrl() == false {
            self.txtURL.layer.borderColor = UIColor.red.cgColor
            self.lblErrorMessage.isHidden = false
            self.lblErrorMessage.text = StringConstants.urlIsNotProperMsg
            return false
        }
        else{
            self.lblErrorMessage.isHidden = true
        }
        
        return true
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if self.validateInputs() {
            var urlToCheck = self.txtURL.text
            
            if urlToCheck?.last != "/" {
                urlToCheck = urlToCheck?.appending("/")
            }
            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarController")
            Configuration().rootAPIUrl = urlToCheck ?? ""
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
            RumEventHelper.shared.trackCustomRumEventFor(.timeToReady)
        }
    }
    
    @IBAction func btnDelayedLoginClicked(_ sender : UIButton) {
        
        if validateInputs() {
            RumEventHelper.shared.startSpanWith(spanName: RumEventHelper.RumCustomEvent.timeToReady.rawValue, shouldCreateWorkflow: true, parentSpan: nil, attributes: nil) { timeToReadySpan in
                StaticEventsVM().slowApiResponse(4) {
                    StaticEventsVM().slowApiResponse(4) {
                        
                        APProgressHUD.shared.showProgressHUD(nil)
                        
                        self.addDelayedSpan(2) {
                            timeToReadySpan?.end()
                            APProgressHUD.shared.dismissProgressHUD()
                            var urlToCheck = self.txtURL.text
                            
                            if urlToCheck?.last != "/" {
                                urlToCheck = urlToCheck?.appending("/")
                            }
                            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarController")
                            Configuration().rootAPIUrl = urlToCheck ?? ""
                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: -
    
    func addDelayedSpan(_ count : Int, completion : @escaping ()->Void) {
        if count > 0, let activeSpan = OpenTelemetry.instance.contextProvider.activeSpan {
            RumEventHelper.shared.startSpanWith(spanName: "dashboard_list_favorite_load_time", parentSpan: activeSpan, attributes: nil) { parentSpan in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    parentSpan?.end()
                    
                    RumEventHelper.shared.startSpanWith(spanName: "dashboard_list_custom_load_time", parentSpan: parentSpan, attributes: nil) { childSpan in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            childSpan?.end()
                            
                            self.addDelayedSpan(count - 1, completion: completion)
                        }
                    }
                }
            }
        } else {
            completion()
        }
    }
    
    
    func createParentSpan(_ parent : Span, _ completion: @escaping ()->Void) {
        let tracer = OpenTelemetry.instance.tracerProvider.get(instrumentationName: "splunk-ios", instrumentationVersion: "0.5.1")
        let parentSpan = tracer.spanBuilder(spanName: "dashboard_list_favorite_load_time").setParent(parent).startSpan()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            parentSpan.end()
            self.createChildSpan(parentSpan) {
                completion()
            }
        }
    }
    
    func createChildSpan(_ parent : Span, _ completion: @escaping ()->Void) {
        let tracer = OpenTelemetry.instance.tracerProvider.get(instrumentationName: "splunk-ios", instrumentationVersion: "0.5.1")
        let childSpan = tracer.spanBuilder(spanName: "dashboard_list_custom_load_time").setParent(parent).startSpan()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            childSpan.end()
            completion()
        }
    }
}

extension URLConfigurationVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setSubmitButtonStatus()
        }
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if !self.lblErrorMessage.isHidden && updatedText.isValidUrl() {
                self.txtURL.layer.borderColor = UIColor.black.cgColor
                self.lblErrorMessage.isHidden = true
            }
            
        }
        
        return true
    }
}
