//
//  ProviderWalletViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 11/10/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderWalletViewController: UIViewController {

    @IBOutlet weak var viewEarnings : UIView!
    @IBOutlet weak var lblEarning : UILabel!
    
    @IBOutlet weak var btnPayment : UIButton!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent!.title = "Wallet"
//        (self.parent as! ProviderTabBarController).btnEdit.tintColor = .clear
//        (self.parent as! ProviderTabBarController).btnNearbyPlace.tintColor = .clear
        (self.parent as! ProviderTabBarController).navigationItem.rightBarButtonItems = [(self.parent as! ProviderTabBarController).btnMore]
        getProviderEarning()

    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: self.viewEarnings, cornerRad: 0, borderWidth: 1, borderColor: RDDataEngineClass.accentShadeColor)
        RDGlobalFunction.setCornerRadius(any: self.btnPayment, cornerRad: 0, borderWidth: 1, borderColor: .black)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnPaymentPressed() {
        requestImmediatePayment()
    }
    
    
    //MARK: WebService
    func getProviderEarning() {
        
        UtilityClass.showActivityIndicator()
        
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int )
        let getProviderEarningStr = PROVIDERGETEARNINGS + "?ProviderId=\(userID)"
        
        let providerIdParam  = [:] as [String : Any]
     
        ClientProviderAPIManager.sharedInstance.getProviderEarnings(selectedVC: self, providerParameters: providerIdParam, getEarningsAPI: getProviderEarningStr) { (responseObject, success) in
            if success {
                UtilityClass.removeActivityIndicator()
                self.lblEarning.text = "$ \(responseObject["TotalTripCharges"] as? Int ?? 0)"
            }
        }
    }
    
    func requestImmediatePayment() {
           
           UtilityClass.showActivityIndicator()
           
           let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int )
           
           let providerIdParam  = ["ProviderId":userID] as [String : Any]
        
    
        ClientProviderAPIManager.sharedInstance.postProviderPaymentRequest(selectedVC: self, providerParameters:providerIdParam , postProviderPaymentRequestDetails: PROVIDERPAYMENTREQUEST) { (responseObject, success) in
            if success {
                UtilityClass.showAlertOnNavigationBarWith(message: responseObject["ErrorSuccessMsg"] as? String, title: "Success", alertType: .success)
            }
        }
       }
    
    //MARK:UIButton Actions
    @IBAction func openZelle() {
        if (UIApplication.shared.canOpenURL(NSURL(string:"https://www.zellepay.com/go/zelle")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                "https://www.zellepay.com/go/zelle")! as URL, options: [:], completionHandler: nil)
            
        }
    }
}


