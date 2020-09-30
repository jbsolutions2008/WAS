//
//  SupportViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 19/11/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

let placeholderText = "Tell us about your query in detail..."

class SupportViewController : UIViewController {

    @IBOutlet weak var txtTitle : UITextField!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var btnSubmit : UIButton!
    
    @IBOutlet weak var viewBg : UIView!
    @IBOutlet weak var viewBorder : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtDescription.textContainerInset = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        txtDescription.text = placeholderText
        txtDescription.textColor = .lightGray
        
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: txtDescription, cornerRad: 8.0, borderWidth: 1.0, borderColor: .lightGray)
        RDGlobalFunction.setCornerRadius(any: self.btnSubmit, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        RDGlobalFunction.setCornerRadius(any: self.viewBg, cornerRad: self.viewBg.frame.height/2, borderWidth: 0, borderColor: UIColor.clear)
        RDGlobalFunction.setCornerRadius(any: self.viewBorder, cornerRad: self.viewBorder.frame.height/2, borderWidth: 0.5, borderColor: UIColor(red: 250, green: 250, blue: 250))
    }
    
    //MARK:UIButton Actions
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitPressed() {
        if txtTitle.text == "" {
            UtilityClass.showAlertOnNavigationBarWith(message: "Please enter query title", title: "Error", alertType: .failure)
        } else if txtDescription.text == placeholderText && txtDescription.textColor == .lightGray {
            UtilityClass.showAlertOnNavigationBarWith(message: "Please enter query detail", title: "Error", alertType: .failure)
        } else {
            submitSupport()
        }
    }
    
    //MARK: WebService
    func submitSupport() {
        
        UtilityClass.showActivityIndicator()
        var userId = 0
        var userType = "0"
        
        if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp) {
            userId = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int
            userType = Numeric_Usercode.client
        } else {
            userId = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int
            userType = Numeric_Usercode.provider
        }
       
        let params : [String : Any] = ["UserId":userId,"UserTypeCode":userType,"Title":txtTitle.text!,"Description":txtDescription.text!]
      
        ClientProviderAPIManager.sharedInstance.postClientProviderSupportQuery(selectedVC: self, parameters: params, postDetails: SUPPORTAPI ) { (responseObject, success) in
            
            UtilityClass.removeActivityIndicator()
            if success {
                self.txtTitle.text = ""
                self.txtDescription.text = placeholderText
                self.txtDescription.textColor = .lightGray
                
                UtilityClass.showAlertOnNavigationBarWith(message: responseObject["ErrorSuccessMsg"] as? String, title: "success", alertType:.success)
            }
        }
    }
}

extension SupportViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == placeholderText && textView.textColor == .lightGray) {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
