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

class URLConfigurationVC : UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtURL: UITextField!
    
    @IBOutlet weak var imgGlobe: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnSubmit.addTextSpacing()
        lblTitle.textColor = config.commonScreenBgColor
        let image = UIImage(named: "worldwide")?.withRenderingMode(.alwaysTemplate)
        imgGlobe.tintColor = .lightGray
        imgGlobe.image = image
        
        setSubmitButtonStatus()
    }
    
    func setSubmitButtonStatus(){
        if txtURL.text == "https://"{
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.backgroundColor = config.disableButtonBgColor
        }
        else{
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.backgroundColor =  config.commonScreenBgColor
        }
            
    }
   
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        if txtURL.text?.count == 0 {
            self.presentErrorAlert(title:StringConstants.alertTitle , message: StringConstants.noURLMsg)
        }
        else if txtURL.text?.isValidUrl() == false {
            self.presentErrorAlert(title:StringConstants.alertTitle , message: StringConstants.urlIsNotProperMsg)
        }
        else{
            //valid URL
            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarController")
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
        setSubmitButtonStatus()
        return true
    }
   
   
    
}
