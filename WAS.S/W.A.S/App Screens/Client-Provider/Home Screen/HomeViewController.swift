//
//  HomeViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 12/07/19.
//  Copyright © 2019 GlobeSync Technologies  - Renish Dadhaniya. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerBGIV: UIImageView!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var helloBottomLineVI: UIView!
    @IBOutlet weak var iAmLbl: UILabel!
    @IBOutlet weak var clientIV: UIImageView!
    @IBOutlet weak var clientLbl: UILabel!
    @IBOutlet weak var clientBtn: UIButton!
    @IBOutlet weak var clientPrivideLineVI: UIView!
    @IBOutlet weak var providerIV: UIImageView!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var providerBtn: UIButton!
    
    @IBOutlet weak var splashContainerView: UIView!
    
    override func viewDidLoad() {
        
        self.splashContainerView.isHidden = false
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            if RDGlobalFunction.getBoolValueFromUserDefault(iSDefaultKey: RDDataEngineClass.iSUerActivated) {
                if ( RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp) {
                    self.checkClientTripExist()
                } else if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.providerApp) {
                    self.checkProviderTripExist()
                }
            } else {
                self.splashContainerView.isHidden = true
                self.designInterFace()
            }
        })
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func designInterFace() {
        
        self.helloLbl.font = self.helloLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+10))
        self.iAmLbl.font = self.iAmLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+7))
        self.clientLbl.font = self.iAmLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+2))
        self.providerLbl.font = self.iAmLbl.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()+2))
    }

    
    @IBAction func clientProviderButtonAction(_ sender: UIButton) {
        
        if sender == self.clientBtn {
           RDGlobalFunction.setValueInUserDefault(iSDefaultValue: RDDataEngineClass.clientApp, iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef)
        }else if sender == self.providerBtn{
           RDGlobalFunction.setValueInUserDefault(iSDefaultValue: RDDataEngineClass.providerApp, iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef)
        }

        let clientSignInVC : ClientSignInViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ClientSignInVC") as! ClientSignInViewController
        self.present(clientSignInVC, animated: true, completion: nil)
        
    }
    
    //MARK:WEBSERVICE
    func checkProviderTripExist() {
       // UtilityClass.showActivityIndicator()
        
        let params = ["ClientId":"0","ProviderId":RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int,"UserTypeCode":Numeric_Usercode.provider] as [String : Any]
        
        
        ClientProviderAPIManager.sharedInstance.checkTripExistStatus(selectedVC: self, requestParameters: params, tripExistAPI: CHECKTRIPEXIST) { (responseObject, success) in
            //Open Provider Dashboard Screen
               RDGlobalFunction.moveForwardToProviderDashboardViewController(currentVC : self, animated: false)
            
            if success {
                if responseObject["Success"] as! Bool {
                    RDGlobalFunction.appDelegate.doesRequestExist = true
                    RDGlobalFunction.appDelegate.providerExistingTrip = responseObject as? [String : AnyObject]
                }
            }
        }
    }
    
    func checkClientTripExist() {
       // UtilityClass.showActivityIndicator()
        
        let params = ["ClientId":RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int,"ProviderId":"0","UserTypeCode":Numeric_Usercode.client] as [String : Any]
        
        
        ClientProviderAPIManager.sharedInstance.checkTripExistStatus(selectedVC: self, requestParameters: params, tripExistAPI: CHECKTRIPEXIST) { (responseObject, success) in
            //Open Client Dashboard Screen
            RDGlobalFunction.moveForwardToClientDashboardViewController(currentVC: self, animated: false)
            
            if success {
                if responseObject["Success"] as! Bool {
                    RDGlobalFunction.appDelegate.doesRequestExist = true
                    RDGlobalFunction.appDelegate.clientExistingTrip = responseObject as? [String : AnyObject]
                }
            }
        }
    }
}



