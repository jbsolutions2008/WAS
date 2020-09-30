//
//  ForgotpasswordViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 23/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class ForgotpasswordViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var headerView: Triangle!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var forgotPasswordLbl: UILabel!
    @IBOutlet weak var forgotPasswordBottomLineVI: UIView!
    
    @IBOutlet weak var insturctLbl: UILabel!
    @IBOutlet weak var emailMobileTF: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var countryIDSelected = "1"
    
    var pickerVI: UIPickerView = UIPickerView()

    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.designInterFace()
        
    }
    
    
    func designInterFace() {
        
        self.forgotPasswordLbl.font = self.forgotPasswordLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        
        self.insturctLbl.font = self.insturctLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-6))
        
        self.customizeTextField(textfield: self.emailMobileTF)
        self.customizeTextField(textfield: self.countryTF)
        
        self.sendBtn.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.sendBtn, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        
    }
    
    
    func customizeTextField(textfield : SkyFloatingLabelTextField){
        
        textfield.font = UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-4)
        textfield.titleFont = UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution())-8)!
        textfield.titleFormatter = { $0 }
        self.countryTF.text = "+\(self.countryIDSelected)"
        
    }
    
    
    //Send Button
    @IBAction func sendButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if countryTF.text == "" && countryTF.text == "+"  {
            countryTF.becomeFirstResponder()
        }
        
       else if (!RDGlobalFunction.isValidEmail(self.emailMobileTF.text!) && !RDGlobalFunction.iSValidContactNumber(self.emailMobileTF.text!)) {
            
            self.emailMobileTF.errorMessage = "Invalid Mobile"
            self.emailMobileTF.becomeFirstResponder()
            
        } else {//DO VERIFY
            
            let clientProviderForgotPasswordParam :  Parameters = ["EmailMobileNumber" : "\(self.countryTF.text!)\(self.emailMobileTF.text!)"]

            if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){

                //CLIENT APP WS
                self.callingForgotPasswordWS(forgotPasswordAPI: FORGOTPASSWORDCLIENTAPI, forgotPasswordParameter: clientProviderForgotPasswordParam)

            }else if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp ){

                //PROVIDER APP WS
                self.callingForgotPasswordWS(forgotPasswordAPI: FORGOTPASSWORDPROVIDERAPI, forgotPasswordParameter: clientProviderForgotPasswordParam)
            }
            
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
    
    //LogIn User - Client - Provider
    func callingForgotPasswordWS(forgotPasswordAPI : String, forgotPasswordParameter :  Parameters) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.forgotPassword(selectedVC: self,forgotPasswordParameters: forgotPasswordParameter, forgotPAsswordAPI: forgotPasswordAPI) { (responseObject, success) in
            
            if success{
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    print("Forgot Password Response : \(responseObject)")
                    
                     RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    
                   UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Verification Code Sent", alertType: .success)
                    
                    ClientProviderAPIManager.sharedInstance.verifyPhonenumberWithFirebase(phone: "\(self.countryTF.text!)\(self.emailMobileTF.text!)", callback: { (verificationID, error) in
                        if let error = error {
                            UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
                            return
                        }
                        RDGlobalFunction.setValueInUserDefault(iSDefaultValue: verificationID, iSDefaultKey: "authVerificationID")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.openVerifyOTPNumberScreen()
                        })
                    })
                    
                }else{
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
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
    
    
    //Verify OTP Screen
    func openVerifyOTPNumberScreen() {
        
        self.view.endEditing(true)
        
        let verifyOTPVC : VerifyOTPViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPViewController
        verifyOTPVC.iSForGotPassword = true
        self.present(verifyOTPVC, animated: true, completion: nil)
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
        
        if textField == self.emailMobileTF {
            
            self.emailMobileTF.errorMessage = ""
            return newLength <= 10
            
        }
        
        return true
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
}

extension ForgotpasswordViewController : UIPickerViewDelegate,UIPickerViewDataSource {
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
