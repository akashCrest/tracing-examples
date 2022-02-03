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
    @IBOutlet weak var txtURL: DesignableUITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    @IBOutlet weak var imgGlobe: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnSubmit.addTextSpacing()
        //        lblTitle.textColor = config.commonScreenBgColor
        //        let image = UIImage(named: "worldwide")?.withRenderingMode(.alwaysTemplate)
        //        imgGlobe.tintColor = .lightGray
        //        imgGlobe.image = image
        
//        setSubmitButtonStatus()
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.appBaseURL)
        UserDefaults.standard.synchronize()
        
//        self.btnSubmit.isUserInteractionEnabled = false
//        self.btnSubmit.backgroundColor = config.disableButtonBgColor
        self.lblErrorMessage.isHidden = true
        
        self.txtURL.text = "http://pmrum.o11ystore.com/"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RumEventHelper.shared.trackCustomRumEventFor(.loggedInAndReady)
    }
    
    func setSubmitButtonStatus(){
        if txtURL.text?.isEmpty ?? true {
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.backgroundColor = config.disableButtonBgColor
        }
        else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.backgroundColor =  config.commonScreenBgColor
        }
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        var urlToCheck = self.txtURL.text
        
        if urlToCheck?.last == "/" {
            urlToCheck?.removeLast()
        }
        
        if urlToCheck?.count == 0 {
            //            self.presentErrorAlert(title:StringConstants.alertTitle , message: StringConstants.noURLMsg)
            self.txtURL.layer.borderColor = UIColor.red.cgColor
            self.lblErrorMessage.isHidden = false
            self.lblErrorMessage.text = StringConstants.noURLMsg
        }
        else if urlToCheck?.isValidUrl() == false {
            self.txtURL.layer.borderColor = UIColor.red.cgColor
            self.lblErrorMessage.isHidden = false
            self.lblErrorMessage.text = StringConstants.urlIsNotProperMsg
            //            self.presentErrorAlert(title:StringConstants.alertTitle , message: StringConstants.urlIsNotProperMsg)
        }
        else{
            self.lblErrorMessage.isHidden = true
            urlToCheck = urlToCheck?.appending("/")
            //valid URL
            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarController")
            Configuration().rootAPIUrl = urlToCheck ?? ""
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(mainTabBarController)
            
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
