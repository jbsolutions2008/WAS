//
//  ClientSignUpViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 17/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Locksmith
import Foundation
import Alamofire
import Firebase


class ClientSignUpViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var headerView: Triangle!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var signUpLbl: UILabel!
    @IBOutlet weak var signUpBottomLineVI: UIView!

    @IBOutlet weak var fullNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTF: SkyFloatingLabelTextField!
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    
    var countryIDSelected = "1"
    
    var pickerVI: UIPickerView = UIPickerView()
    
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designInterFace()
        
    }
    
    
    func designInterFace() {
                
        self.signUpLbl.font = self.signUpLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        
        self.customizeTextField(textfield: self.fullNameTF)
        self.customizeTextField(textfield: self.emailTF)
        self.customizeTextField(textfield: self.mobileTF)
        self.customizeTextField(textfield: self.passwordTF)
        self.customizeTextField(textfield: self.countryTF)
        
        self.signupBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.signupBtn, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        self.signupBtn.setTitle("SIGN UP", for: UIControl.State.normal)
        
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

    
    
    //Signup Button
    @IBAction func signupButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (self.fullNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 4 {

            self.fullNameTF.errorMessage = "Min. 4 characters required"
            self.fullNameTF.becomeFirstResponder()

        }else if !RDGlobalFunction.isValidEmail(self.emailTF.text!) {

            self.emailTF.errorMessage = "Invalid Email"
            self.emailTF.becomeFirstResponder()

        }else if countryTF.text == "" && countryTF.text == "+" {
            self.countryTF.becomeFirstResponder()
        }else if !RDGlobalFunction.iSValidContactNumber(self.mobileTF.text!){
        
            self.mobileTF.errorMessage = "Invalid Mobile Number"
            self.mobileTF.becomeFirstResponder()
        
        }else if !(RDGlobalFunction.checkPasswordHasSufficientComplexity(text: self.passwordTF.text!))  {

            self.passwordTF.errorMessage = RDGlobalFunction.miniRequiredCharacterForPassword
            self.passwordTF.becomeFirstResponder()

        }else{

            //Authenticate with server
            self.showHidePasswordBtn.isSelected = true
            self.passwordTF.isSecureTextEntry = true
            

            //Deveice UUID
            let keyChainID = Locksmith.loadDataForUserAccount(userAccount: Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String)
            let deviceGetUUID =  keyChainID?[RDDataEngineClass.deviceAppUUID]!
            //Vendor UUID
            let vendorDeviceID =  UIDevice.current.identifierForVendor?.uuidString
            
            //PUSH NOTIFICATION TOKEN
            let notificationToken = ""
            
            
            if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                
                let clientSignupParam :  Parameters = ["Name" : self.fullNameTF.text!, "Email" : self.emailTF.text!, "MobileNumber" : "\(self.countryTF.text!)\(self.mobileTF.text!)", "Password" : self.passwordTF.text!, "StatusCode" : "3", "deviceIdUUID" : vendorDeviceID!, "DeviceIMEI" : deviceGetUUID!, "DeviceModalName" : DeviceName.modelName , "DeviceBrand": UIDevice.current.systemVersion, "GCMRegistrationID":"", "iOSDeviceToken" : notificationToken]
                
                //CALL - CLIENT APP WS
                self.callingRegisterWS(registerUserAPI: REGISTERCLIENTAPI, signupParameter:clientSignupParam)
                
            }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                
                let providerSignupParam :  Parameters = ["Name" : self.fullNameTF.text!, "Email" : self.emailTF.text!, "MobileNumber" : "\(self.countryTF.text!)\(self.mobileTF.text!)", "Password" : self.passwordTF.text!, "deviceIdUUID" : vendorDeviceID!, "DeviceIMEI" : deviceGetUUID!, "DeviceModalName" : DeviceName.modelName , "DeviceBrand": UIDevice.current.systemVersion, "GCMRegistrationID":"", "iOSDeviceToken" : notificationToken]
                
                //CALL - PROVIDER APP WS
                self.callingRegisterWS(registerUserAPI: REGISTERPROVIDERAPI, signupParameter:providerSignupParam)
                
            }
        }
    }
    
    
    
    //Register User - Client - Provider
    func callingRegisterWS(registerUserAPI : String, signupParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.doSignUpWith(selectedVC: self,signupParameters: signupParameter, userRegisterAPI: registerUserAPI) { (responseObject, success) in
        
            if success{
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Registration Successfully", alertType: .success)
                    
                    ClientProviderAPIManager.sharedInstance.verifyPhonenumberWithFirebase(phone: "\(self.countryTF.text!)\(self.mobileTF.text!)", callback: { (verificationID, error) in
                        if let error = error {
                            UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
                            return
                        }
                        RDGlobalFunction.setValueInUserDefault(iSDefaultValue: verificationID, iSDefaultKey: "authVerificationID")
                        self.openVerifyOTPNumberScreen()
                    })
                }else{
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Registration Failed", alertType: .failure)
                }
                
                UtilityClass.removeActivityIndicator()
                
            }
//            else{
//                
//                 UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
//                
//            }
            
        }
    }
    

    //Verify OTP Screen
    func openVerifyOTPNumberScreen() {
        
        self.view.endEditing(true)
        
        let verifyOTPVC : VerifyOTPViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPViewController
        verifyOTPVC.iSForGotPassword = false
        self.present(verifyOTPVC, animated: true, completion: nil)
    }

    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func doneButtonDatePickerAction(_ sender:UIButton){
        
        self.view.endEditing(true)
        self.countryTF.text = "+\(self.countryIDSelected)"
    }
    
    //Cancel button Action
    @objc func cancelButtonDatePickerAction(_ sender: UIButton){
        
        self.view.endEditing(true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
        
        if textField == self.fullNameTF {
            
            self.fullNameTF.errorMessage = ""
            return newLength <= 30
            
        }else if textField == self.emailTF {
            
            self.emailTF.errorMessage = ""
            return newLength <= 50
            
        }else if textField == self.mobileTF {
            
            self.mobileTF.errorMessage = ""
            
            let currentString: NSString = self.mobileTF.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            let aSet = CharacterSet(charactersIn:"+-0123456789").inverted
            let compSepByCharInSet = newString.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            return (newString.length <= 14 && newString as String == numberFiltered)
            
        }else if textField == self.passwordTF {
            
            self.passwordTF.errorMessage = ""
            return newLength <= 16
            
        }
        
        return true
    }
  
}

extension ClientSignUpViewController : UIPickerViewDelegate,UIPickerViewDataSource {
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



