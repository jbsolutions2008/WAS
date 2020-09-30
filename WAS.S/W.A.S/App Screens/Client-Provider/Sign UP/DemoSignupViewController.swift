//
//  DemoSignupViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 07/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class DemoSignupViewController: UIViewController {

    @IBOutlet weak var txtMobile:UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnSubmitPressed() {
        PhoneAuthProvider.provider().verifyPhoneNumber(txtMobile.text!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                UtilityClass.showAlertOnNavigationBarWith(message: error.localizedDescription, title: "Error", alertType: .failure)
                return
            }
            RDGlobalFunction.setValueInUserDefault(iSDefaultValue: verificationID!, iSDefaultKey: "authVerificationID")
            self.openVerifyOTPNumberScreen()
        }
    }
    
    func openVerifyOTPNumberScreen() {
        
        self.view.endEditing(true)
        
        let verifyOTPVC : VerifyOTPViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPViewController
        verifyOTPVC.iSForGotPassword = false
        self.present(verifyOTPVC, animated: true, completion: nil)
        
    }
    
    

}
