//
//  AddCardViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 21/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var paymentCardTextField : STPPaymentCardTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        // Setup payment card text field
        paymentCardTextField.delegate = self
        
        // Add payment card text field to view
        view.addSubview(paymentCardTextField)
    }
    
    // MARK: STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        
        self.navigationItem.rightBarButtonItem!.isEnabled = textField.isValid
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDonePressed() {
        
        self.navigationItem.rightBarButtonItem!.isEnabled = false
        
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = paymentCardTextField.expirationMonth
        cardParams.expYear = paymentCardTextField.expirationYear
        cardParams.cvc = paymentCardTextField.cvc
        
        UtilityClass.showActivityIndicator()
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                
                UtilityClass.removeActivityIndicator()
                UtilityClass.showAlertWithMessage(message: error?.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                    if isConfirm {
                        RDGlobalFunction.setIntInUserDefault(iSDefaultValue: 1, iSDefaultKey: RDDataEngineClass.userCardCount)
                    }
                })
                self.navigationItem.rightBarButtonItem!.isEnabled = true
                return
            }
            self.addStripeCard(token: token.tokenId)
        }
    }
    
    func addStripeCard(token : String)  {
        
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int )
        let param = ["ClientId" : userID, "SourceToken" : token] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.addCardToCustomer(selectedVC: self, requestParameters: param, addCardAPI: CLIENTCARDADD) { (responseOject, success) in
            if success {
                UtilityClass.removeActivityIndicator()
               self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationItem.rightBarButtonItem!.isEnabled = true
            }
        }
    }
}
