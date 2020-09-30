//
//  VerifyOTPViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 22/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import Firebase

class VerifyOTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerView: Triangle!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var verifyBottomLineVI: UIView!
    
    
    @IBOutlet weak var verifyNumberLbl: UILabel!
    @IBOutlet weak var insturctLbl: UILabel!
    
    @IBOutlet weak var verifyOTPTF: SkyFloatingLabelTextField!

    @IBOutlet weak var verifydBtn: UIButton!
    @IBOutlet weak var resendCodeBtn: UIButton!
    
    var iSForGotPassword : Bool = false
    
    var counter = RDDataEngineClass.resetTimerCounter
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designInterFace()
        
        //Disable Resend validation code
        self.iSDisableResendValidationCode(iSEnable: false)
        
        // start the timer
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        self.resendCodeBtn.setTitle("RESEND CODE IN " + "\(counter)" + " SECONDS" , for: .normal )
        
    }

    
    
    func designInterFace() {
        
        self.verifyLbl.font = self.verifyLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        
        self.customizeTextField(textfield: self.verifyOTPTF)
       
        self.verifyNumberLbl.font = self.verifyNumberLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        self.insturctLbl.font = self.insturctLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-6))
        
        self.verifydBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.verifydBtn, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
       
        self.resendCodeBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-6))
        RDGlobalFunction.setCornerRadius(any: self.resendCodeBtn, cornerRad: 0, borderWidth: 0, borderColor: UIColor.clear)
        
    }
    
    
    func customizeTextField(textfield : SkyFloatingLabelTextField){
        
        textfield.font = UIFont(name: RDDataEngineClass.robotoFontBold , size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-4)
        textfield.titleFont = UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-8)!
        textfield.titleFormatter = { $0 }
        
    }

    
    //Verify Button
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.verifyOTPTF.text?.count == 0 {
            self.verifyOTPTF.errorMessage = "Enter OTP"
            self.verifyOTPTF.becomeFirstResponder()
        } else if (self.verifyOTPTF.text!.count <= 5) {
            
            self.verifyOTPTF.errorMessage = "Invalid OTP"
            self.verifyOTPTF.becomeFirstResponder()
            
        }else {//DO SVERIFY
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: "authVerificationID"),
                verificationCode: verifyOTPTF.text!)
            
            let getUserInfo =  RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
            
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
                    return
                }
                
                if self.iSForGotPassword {
                    self.openChangedPasswordScreen()
                } else {
                    if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                        
                        let userID = getUserInfo.value(forKey: UserProfileKey.ClientId) as! Int
                        let verifyUserParam :  Parameters = ["ClientId" : userID , "IsVerified" : true]
                        //Remember User And Redirect on Dashboard
                        
                        self.verifyUserThroughWS(verifyuserAPI: CLIENTVERIFYAPI, verifyUserParameter: verifyUserParam)
                        
                    }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                        
                        let userID = getUserInfo.value(forKey: UserProfileKey.ProviderId) as! Int
                        let verifyUserParam :  Parameters = ["ProviderId" : userID , "IsVerified" : true]
                        
                        self.verifyUserThroughWS(verifyuserAPI: PROVIDERVERIFYAPI, verifyUserParameter: verifyUserParam)
                    }
                }
            }
            
            

            
            //CLIENT-Provider VERIFY OTP WS
//            let verifyOTParam :  Parameters = ["Id" : userID , "VerificationCode" : self.verifyOTPTF.text!]
//
//            if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
//
//                //self.verifyOTPThroughWS(verifyOTPAPI: VERIFYCLIENTAPI, verifyOTPParameter: verifyOTParam)
//
//            }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
//
 //               self.verifyOTPThroughWS(verifyOTPAPI: VERIFYPROVIDERAPI, verifyOTPParameter: verifyOTParam)
//
//            }
        }
    }
    
    
    //VERIFY OTP
    func verifyOTPThroughWS(verifyOTPAPI : String, verifyOTPParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.verifyOTP(selectedVC: self,verifyOTPParameters: verifyOTPParameter, verifyOTPAPI: verifyOTPAPI) { (responseObject, success) in
            
            if success{
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    //IS VERIFIED
                    if (responseObject.object(forKey: "IsVerified") as! Int) == SUCCESSCODE {
                        
                        
                        RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                        
                        if !self.iSForGotPassword{
                            
                            if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                            
                                //Remember User And Redirect on Dashboard
                                if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true{
                                    //Open Client Dashboard Screen
                                    RDGlobalFunction.moveForwardToClientDashboardViewController(currentVC: self, animated: true)
                                }
                                
                            }else if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                            
                                if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true{
                                   
                                    //Open Provider Dashboard Screen
                                    RDGlobalFunction.moveForwardToProviderDashboardViewController(currentVC : self, animated: true)
                                }
                                
                                
                                
                            }
                            
                        }else{//Update Password
                            
                            self.openChangedPasswordScreen()
                        }
                        
                        
                    }else{
                        
                        UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Verification Failed", alertType: .failure)
                        
                    }
                     
                    
                }else{
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Verification Failed", alertType: .failure)
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
    
    
    func verifyUserThroughWS(verifyuserAPI : String, verifyUserParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.verifyUser(selectedVC: self, verifyUserParameters: verifyUserParameter, verifyUserAPI: verifyuserAPI) { (responseObject, success) in
                
                if success{
                    
                    if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                        
                        
                            RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                            
                            
                                if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                                    
                                    //Remember User And Redirect on Dashboard
                                    if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true{
                                        //Open Client Dashboard Screen
                                        RDGlobalFunction.moveForwardToClientDashboardViewController(currentVC: self, animated: true)
                                    }
                                    
                                }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                                    
//                                    //Open Provider Dashboard Screen
//                                    RDGlobalFunction.moveForwardToProviderDashboardViewController(currentVC : self)
                                    
                                    self.view.endEditing(true)
                                    
                                    let providerIdentityVC : ProviderIdentityViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderIdentityViewController") as! ProviderIdentityViewController
                                    self.present(providerIdentityVC, animated: true, completion: nil)
                                    
                                }
                                
                    }else{
                        
                        UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Verification Failed", alertType: .failure)
                    }
                    
                    UtilityClass.removeActivityIndicator()
                    
                }
//                else{
//                    
//                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
//                    
//                }
            }
    }
    
    
    //Open Changed Password Screen
    func openChangedPasswordScreen(){
        
        let clientProviderChangesPasswordVC: ClientProviderChangesPasswordViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ClientProviderChangesPasswordVC") as! ClientProviderChangesPasswordViewController
        self.present(clientProviderChangesPasswordVC, animated: false)
        
        
    }
    
    
    //Disable Resend validation code
    func iSDisableResendValidationCode(iSEnable :  Bool) {
        
        self.resendCodeBtn.isEnabled = iSEnable
        
        if iSEnable{
            self.resendCodeBtn.alpha = 1.0
        }else{
            self.resendCodeBtn.alpha = 0.5
        }
    }
    
    
    // called every time interval from the timer
    @IBAction func btnResendPressed() {
       let getUserInfo =  RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
        ClientProviderAPIManager.sharedInstance.verifyPhonenumberWithFirebase(phone:getUserInfo.value(forKey: UserProfileKey.Phone) as! String) { (verificationId, error) in
            if let error = error {
                UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
            }
            
            UtilityClass.showAlertOnNavigationBarWith(message: "OTP has been sent.", title: "Success", alertType: .success)
            RDGlobalFunction.setValueInUserDefault(iSDefaultValue: verificationId, iSDefaultKey: "authVerificationID")
            self.iSDisableResendValidationCode(iSEnable: false)
            
            self.resendCodeBtn.setTitle("RESEND VALIDATION CODE" , for: .normal )
        }
    }
    
    @objc func timerAction() {
        
        counter -= 1
        if counter == 0 {
            
            self.iSDisableResendValidationCode(iSEnable: true)
            
            self.resendCodeBtn.setTitle("RESEND VALIDATION CODE" , for: .normal )
            self.timer.invalidate()
            
        }else{
            
            self.resendCodeBtn.setTitle("RESEND CODE IN " + "\(counter)" + " SECONDS" , for: .normal )
            
            //Disable Resend validation code
            self.iSDisableResendValidationCode(iSEnable: false)
            
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //TEXT FIELD DELEGATE
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
       textField.resignFirstResponder()
        // Do not add a line break
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.count + string.count - range.length
        
        if textField == self.verifyOTPTF {
            
            self.verifyOTPTF.errorMessage = ""
            return newLength <= 6
            
        }
        return true
    }
    
   
}
