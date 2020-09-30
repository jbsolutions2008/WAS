//
//  ClientProviderAlertController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 19/07/19.
//  Copyright © 2019 GlobeSync Technologies  - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientProviderAlertController: NSObject {
    
    
    // ShowAlert function for displaying alert
    class func displayAlert(alertControllerVC : UIViewController, alertsFor : String, alertTitle : String, alertMessage : String, alertTag : NSInteger, alertActionTitle : String, alertActionStyle : UIAlertAction.Style) {
        
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        //100 - Just Display An Alert
        if alertTag == 100 {
            
            // Initialize Actions
            let okAction = UIAlertAction(title: "Ok", style: alertActionStyle) { (action) -> Void in
                
            }
            
            //Add Actions
            alertController.addAction(okAction)
        }
        
        
        //1001 -  "Are you sure you wish to Log Out?"
        if alertTag == 1001 {
            
            let okAction = UIAlertAction(title: alertActionTitle, style: alertActionStyle) { (action) in
                
              _ =  RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: false)
                
                if let socket = WebSocketManager.sharedInstance.clientproviderRequestSocket {
                    WebSocketManager.sharedInstance.disconnectSocket(socket: socket)
                }
                
                if let socket = WebSocketManager.sharedInstance.clientCommonDataSocket {
                    WebSocketManager.sharedInstance.disconnectSocket(socket: socket)
                }
                
                DispatchQueue.main.async {
                    //Redirect to Home Screen
                    RDGlobalFunction.goBackToMainViewController(currentVC: alertControllerVC)
                }
            }
            
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "NO", style: .default) { (action) in
                
                alertControllerVC.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
        }//1001 - END
        
        
        //Preseent Alert
        DispatchQueue.main.async(execute: { () -> Void in
            alertControllerVC.present(alertController, animated: true, completion: nil)
        })
    }
}
