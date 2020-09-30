//
//  ClientProviderChangesPasswordViewController.swift
//  Weather Accommodation
//
//  Created by Renish's iMac on 29/07/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class ClientProviderChangesPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerView: Triangle!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var resetPasswordLbl: UILabel!
    @IBOutlet weak var resetPasswordBottomLineVI: UIView!
    
    @IBOutlet weak var insturctLbl: UILabel!
    
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designInterFace()
        
    }
    

    func designInterFace() {
        
        self.resetPasswordLbl.font = self.resetPasswordLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        
        self.insturctLbl.font = self.insturctLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        self.customizeTextField(textfield: self.passwordTF)
        
        self.doneBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.doneBtn, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
            self.doneBtn.setTitle("DONE", for: UIControl.State.normal)
        }else if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
            self.doneBtn.setTitle("DONE", for: UIControl.State.normal)
        }
        
        self.doneBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
    }
    
    
    func customizeTextField(textfield : SkyFloatingLabelTextField){
        
        textfield.font = UIFont(name: RDDataEngineClass.robotoFontDefault , size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-6)
        textfield.titleFont = UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-8)!
        textfield.titleFormatter = { $0 }
        
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
    
    
    //Done Button
    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
       if !(RDGlobalFunction.checkPasswordHasSufficientComplexity(text: self.passwordTF.text!))  {
            
            self.passwordTF.errorMessage = RDGlobalFunction.miniRequiredCharacterForPassword
            self.passwordTF.becomeFirstResponder()
            
        }else {//DO SIGN IN
            
            //Authenticate with server
            self.showHidePasswordBtn.isSelected = true
            self.passwordTF.isSecureTextEntry = true
        
            let getUserInfo =  RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
            
            if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
                
                //CLIENT APP RESET WS
                let clientProviderResetParam :  Parameters = ["ClientId" : getUserInfo.value(forKey: UserProfileKey.ClientId) as! Int , "Password" : self.passwordTF.text!]
                
                self.resetPasswordThroughWS(resetPasswordAPI: RESETPASSWORDCLIENTAPI, resetPasswordParameter: clientProviderResetParam)
                
            }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){
                
                //PROVIDER APP RESET WS
                
                let clientProviderResetParam :  Parameters = ["ProviderId" : getUserInfo.value(forKey: UserProfileKey.ProviderId) as! Int , "Password" : self.passwordTF.text!]
                self.resetPasswordThroughWS(resetPasswordAPI: RESETPASSWORDPROVIDERAPI, resetPasswordParameter: clientProviderResetParam)
                
            }
            
        }
        
        
    }
    
    
    
    
    //RESET PASSWORD
    func resetPasswordThroughWS(resetPasswordAPI : String, resetPasswordParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.resetPassword(selectedVC: self,resetPasswordParameters: resetPasswordParameter, resetPasswordAPI: resetPasswordAPI) { (responseObject, success) in
            
            print("Reset Password : \(responseObject)")
            
            if success{
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Reset Password Successfully", alertType: .success)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        //Redirect to Home Screen
                        self.view.endEditing(true)
                        
                        let clientSignupVC : ClientSignInViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ClientSignInVC") as! ClientSignInViewController
                        self.present(clientSignupVC, animated: true, completion: nil)
                        
                    })
                    
                }else{
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Reset Password Failed", alertType: .failure)
                    
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
        
        if textField == self.passwordTF {
            
            self.passwordTF.errorMessage = ""
            return newLength <= 16
            
        }
        
        return true
    }
    

}
