//
//  ClientSignInViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 19/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import Firebase

class ClientSignInViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var headerView: Triangle!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var signInLbl: UILabel!
    @IBOutlet weak var signInBottomLineVI: UIView!
    
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTF: SkyFloatingLabelTextField!
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var doNotHaveAnAccountBtn: UIButton!
    
    var countryIDSelected = "1"
    
    var pickerVI: UIPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designInterFace()
        
    }
    
    
    func designInterFace() {
        
        //Static Login
//        self.emailTF.text = "renish.dadhaniya@jbsolutions.in" //Client
//        self.emailTF.text = "team.mobile@jbsolutions.in" //Provider
//        self.passwordTF.text = "12345678"
        
        self.signInLbl.font = self.signInLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        
        self.customizeTextField(textfield: self.emailTF)
        self.customizeTextField(textfield: self.passwordTF)
        self.customizeTextField(textfield: self.countryTF)
        
        self.signInBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.signInBtn, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
//        if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
//            self.signInBtn.setTitle("SIGN IN", for: UIControl.State.normal)
//        }else if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
//            self.signInBtn.setTitle("SIGN IN", for: UIControl.State.normal)
//        }
        self.signInBtn.setTitle("SIGN IN", for: UIControl.State.normal)
        
        self.forgotPasswordBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        let doNotHaveACAtr = NSMutableAttributedString(attributedString: self.doNotHaveAnAccountBtn.titleLabel!.attributedText ?? NSAttributedString(string: ""))
        let fontAlreadyAttribute = [ NSAttributedString.Key.font: UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-2))!]
        doNotHaveACAtr.addAttributes(fontAlreadyAttribute, range: NSRange(location: 0, length: 31))
        self.doNotHaveAnAccountBtn.setAttributedTitle(doNotHaveACAtr, for: .normal)
        
    }
    
    
    func customizeTextField(textfield : SkyFloatingLabelTextField){
        
        textfield.font = UIFont(name: RDDataEngineClass.robotoFontDefault , size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-6)
        textfield.titleFont = UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-8)!
        textfield.titleFormatter = { $0 }
        self.countryTF.text = "+\(self.countryIDSelected)"
        
    }
    
    @IBAction func showHidePasswordButtonAction(_ sender: UIButton) {
        
        if self.showHidePasswordBtn.isSelected {
            
            self.showHidePasswordBtn.isSelected = false
            self.passwordTF.isSecureTextEntry = false
            
        }else{
            
            self.showHidePasswordBtn.isSelected = true
            self.passwordTF.isSecureTextEntry = true
            
        }
    }
    
    @objc func doneButtonDatePickerAction(_ sender:UIButton){
        
            self.view.endEditing(true)
            self.countryTF.text = "+\(self.countryIDSelected)"
    }
    
    //Cancel button Action
    @objc func cancelButtonDatePickerAction(_ sender: UIButton){
        
        self.view.endEditing(true)
    }
    
    
    //Signup Button
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (!RDGlobalFunction.isValidEmail(self.emailTF.text!) && !RDGlobalFunction.iSValidContactNumber(self.emailTF.text!)) {
            
            self.emailTF.errorMessage = "Invalid Email/Mobile"
            self.emailTF.becomeFirstResponder()
            
        }else if !(RDGlobalFunction.checkPasswordHasSufficientComplexity(text: self.passwordTF.text!))  {
            
            self.passwordTF.errorMessage = RDGlobalFunction.miniRequiredCharacterForPassword
            self.passwordTF.becomeFirstResponder()
            
        }else if countryTF.text == "" && countryTF.text == "+" {
            self.countryTF.becomeFirstResponder()
        }else {//DO SIGN IN
            
            //Authenticate with server
            self.showHidePasswordBtn.isSelected = true
            self.passwordTF.isSecureTextEntry = true
            
            let clientProviderSignInParam :  Parameters = ["EmailMobileNumber" : "\(self.countryTF.text!)\(self.emailTF.text!)", "Password" : self.passwordTF.text!]
            
            if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                
                //CLIENT APP WS
                self.callingLoginWS(logInUserAPI: LOGINCLIENTAPI, signInParameter: clientProviderSignInParam)
                
            }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                
                //PROVIDER APP WS
                self.callingLoginWS(logInUserAPI: LOGINPROVIDERAPI, signInParameter: clientProviderSignInParam)
                
            }
        }
    }
    
    
    //LogIn User - Client - Provider
    func callingLoginWS(logInUserAPI : String, signInParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.doSignInWith(selectedVC: self,signInParameters: signInParameter, userLoginAPI: logInUserAPI) { (responseObject, success) in
            
            if success {
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    
                    if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp){
                        //Remember User And Redirect on Dashboard
                        if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true{
                            //Open Client Dashboard Screen
                            RDGlobalFunction.moveForwardToClientDashboardViewController(currentVC: self, animated: true)
                        }
                    }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                        
                        if  (responseObject.object(forKey: "IsProviderKYC") as! Int) == 0 {
                            //go to first step
                            self.view.endEditing(true)
                            
                            let providerIdentityVC : ProviderIdentityViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderIdentityViewController") as! ProviderIdentityViewController
                            self.present(providerIdentityVC, animated: true, completion: nil)
                            
                        } else if (responseObject.object(forKey: "IsProviderProductKit") as! Int) == 0 {
                            //go to second step
                            self.view.endEditing(true)
                            
                            let providerIdentityVC : ProviderProductKitViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderProductKitViewController") as! ProviderProductKitViewController
                            self.present(providerIdentityVC, animated: true, completion: nil)
                        } else {
                            //Open Provider Dashboard Screen
                            if (responseObject.object(forKey: "StatusCode") as! Int) == 3 {
                                if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true {
                                    RDGlobalFunction.moveForwardToProviderDashboardViewController(currentVC : self, animated: true)
                                }
                            } else if (responseObject.object(forKey: "StatusCode") as! Int) == 5 {
                                UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Pending", alertType: .failure)
                            }
                            
                        }
                    }
                } else if (responseObject.object(forKey: "Success") as! Int) == NOTVERIFIEDCODE {
                    
                    ClientProviderAPIManager.sharedInstance.verifyPhonenumberWithFirebase(phone: "\(self.countryTF.text!)\(self.emailTF.text!)", callback: { (verificationId, error) in
                        if let error = error {
                            UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
                            return
                        }
                        
                        RDGlobalFunction.setValueInUserDefault(iSDefaultValue: verificationId, iSDefaultKey: "authVerificationID")
                        
                        let verifyOTPVC : VerifyOTPViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPViewController
                        verifyOTPVC.iSForGotPassword = false
                        self.present(verifyOTPVC, animated: true, completion: nil)
                    })
                } else {
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Login Failed", alertType: .failure)
                }
                UtilityClass.removeActivityIndicator()
            }
            //            else{
            //
            //                UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
            //
            //            }
        }
    }
        
    //Forgot Password
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let forgotPasswordVC : ForgotpasswordViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ForgotpasswordVC") as! ForgotpasswordViewController
        self.present(forgotPasswordVC, animated: true, completion: nil)
        
    }
    
    
    //Do Not Have an Account Button
    @IBAction func doNotHaveAnAccountButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let clientSignupVC : ClientSignUpViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ClientSignUpVC") as! ClientSignUpViewController
        self.present(clientSignupVC, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func textFieldEditing(_ sender: SkyFloatingLabelTextField) {
        
        let pickerView : UIView = UIView()
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 270)
        pickerView.backgroundColor = RDDataEngineClass.lightGrayThemeColor
        
        //Done Button
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 90, y: 10, width: 80, height: 40))
        doneButton.tag = sender.tag
        doneButton.backgroundColor = RDDataEngineClass.blueThemeColor
        doneButton.layer.cornerRadius = 5.0
        doneButton.layer.masksToBounds = true
        doneButton.setTitle("Done", for: UIControl.State.normal)
        doneButton.titleLabel?.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        doneButton.setTitleColor(UIColor.white, for: UIControl.State())
        doneButton.addTarget(self, action: #selector(self.doneButtonDatePickerAction(_:)), for: UIControl.Event.touchUpInside)
        pickerView.addSubview(doneButton)
        
        //Cancel Button
        let cancelButton  = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
        cancelButton.tag = sender.tag
        cancelButton.backgroundColor = RDDataEngineClass.redThemeColor
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle("Cancel", for: UIControl.State())
        cancelButton.setTitle("Cancel", for: UIControl.State.highlighted)
        cancelButton.titleLabel?.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        cancelButton.setTitleColor(UIColor.white, for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(self.cancelButtonDatePickerAction(_:)), for: UIControl.Event.touchUpInside)
        pickerView.addSubview(cancelButton)
        
        sender.inputView = pickerView
            
            self.pickerVI = UIPickerView(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: 220))
            self.pickerVI.tag = sender.tag
            self.pickerVI.backgroundColor = .clear
            self.pickerVI.showsSelectionIndicator = true
            self.pickerVI.delegate = self
            self.pickerVI.dataSource = self
            pickerView.addSubview(self.pickerVI)
            
        
            for i in 0 ..< RDGlobalFunction.allCountries.count {
                    
                if self.countryIDSelected.caseInsensitiveCompare(RDGlobalFunction.allCountries[i][2]) == ComparisonResult.orderedSame {
                    
                    self.pickerVI.selectRow(i, inComponent: 0, animated: false)
                    break
                    }
                    
                }
    }
    
    
    //TEXT FIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.count + string.count - range.length
        
        if textField == self.emailTF {
            
            self.emailTF.errorMessage = ""
            return newLength <= 50
            
        }else if textField == self.passwordTF {
            
            self.passwordTF.errorMessage = ""
            return newLength <= 16
            
        }
        return true
    }
}

extension ClientSignInViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return RDGlobalFunction.allCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "+\(RDGlobalFunction.allCountries[row][2])  \(RDGlobalFunction.allCountries[row][1])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        let selectedCountry : Array = RDGlobalFunction.allCountries[row]
        
        self.countryTF.text = "+" + selectedCountry[2]
        countryIDSelected = selectedCountry[2]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-8))
        label.text =  "+\(RDGlobalFunction.allCountries[row][2])  \(RDGlobalFunction.allCountries[row][1])"
        label.textAlignment = .center
        return label
    }
}
