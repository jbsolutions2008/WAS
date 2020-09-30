//
//  RequestCancelAlertViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 22/10/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import CoreLocation

class RequestCancelAlertViewController: UIViewController {

    var currentRequest : [String:Any]!
    
    @IBOutlet weak var btnShowup : UIButton!
    @IBOutlet weak var vwShowup : UIView!
 
    @IBOutlet weak var btnRespond : UIButton!
    @IBOutlet weak var vwRespond : UIView!
    
    var currentLocation : CLLocation!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClientProviderLocationManager.sharedInstance.delegate = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: vwRespond, cornerRad: vwRespond.frame.height/2, borderWidth: 0.5, borderColor: .gray)
        
        RDGlobalFunction.setCornerRadius(any: vwShowup, cornerRad: vwShowup.frame.height/2, borderWidth: 0.5, borderColor: .clear)
    }
    
    //MARK:Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func CancelRequest(with Reason:String, userType:String) {
        WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(currentRequest["ClientId"]!)\",\"Latitude\":\"\(self.currentLocation.coordinate.latitude)\",\"Longitude\":\"\(self.currentLocation.coordinate.longitude)\",\"TripId\":\"\(currentRequest["TripId"]!)\",\"UserType\":\"\(userType)\",\"ProviderId\":\"\(currentRequest["ProviderId"]!)\",\"CancellationReasonCode\":\"\(Reason)\",\"RequestType\":\"\(Trip_Status.cancelled)\"}")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:UIButton Actions
    @IBAction func btnCallPressed() {
        if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
            RDGlobalFunction.makeCall(phoneNumber: self.currentRequest["ProviderMobileNumber"] as? String ?? "")
        } else {
            RDGlobalFunction.makeCall(phoneNumber: self.currentRequest["ClientMobileNumber"] as? String ?? "")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitPressed() {
       
        var userType = ""
        
        if (RDGlobalFunction.getValueFromUserDefault(iSDefaultKey: RDDataEngineClass.userLoginTypeInAppDef) == RDDataEngineClass.clientApp ){
            userType = "client"
        } else {
            userType = "provider"
        }
        
        CancelRequest(with: btnShowup.isSelected ? CancellationReasonCode.NoShow : CancellationReasonCode.NoReply, userType: userType)
        self.dismiss(animated: true) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnReasonPressed(sender:UIButton) {
        if !sender.isSelected {
            if sender == btnRespond {
                btnRespond.isSelected = true
                btnShowup.isSelected = false
              
                vwRespond.backgroundColor = RDDataEngineClass.primaryColor
                RDGlobalFunction.setCornerRadius(any: vwRespond, cornerRad: vwRespond.frame.height/2, borderWidth: 0, borderColor: .clear)
                
                vwShowup.backgroundColor = .white
                RDGlobalFunction.setCornerRadius(any: vwShowup, cornerRad: vwShowup.frame.height/2, borderWidth: 0.5, borderColor: .gray)
            } else {
                btnRespond.isSelected = false
                btnShowup.isSelected = true
                
                vwShowup.backgroundColor = RDDataEngineClass.primaryColor
                RDGlobalFunction.setCornerRadius(any: vwShowup, cornerRad: vwShowup.frame.height/2, borderWidth: 0, borderColor: .clear)
                
                vwRespond.backgroundColor = .white
                RDGlobalFunction.setCornerRadius(any: vwRespond, cornerRad: vwRespond.frame.height/2, borderWidth: 0.5, borderColor: .gray)
            }
        }
    }
}

extension RequestCancelAlertViewController : LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        print(error)
    }
}
