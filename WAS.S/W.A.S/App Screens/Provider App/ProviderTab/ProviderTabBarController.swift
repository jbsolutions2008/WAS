//
//  ProviderTabBarController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 03/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderTabBarController: UITabBarController {

    @IBOutlet  var btnEdit : UIBarButtonItem!
    @IBOutlet  var btnMore : UIBarButtonItem!
    @IBOutlet  var btnNearbyPlace : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
    }
    
    func setupAppearance() {
        self.tabBar.barTintColor = RDDataEngineClass.primaryColor
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.barStyle = .default
    
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-10))!], for: .normal)
       
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: RDDataEngineClass.robotoFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-10))!], for: .selected)
    }
    

    //MARK : Button Actions
    @IBAction func btnMorePressed() {
        let alert = UIAlertController.init(title: "", message: "Do you want to Logout?", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Logout", style: .destructive) { (action) -> Void in
            _ =  RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: false)
            
            if let socket = WebSocketManager.sharedInstance.clientproviderRequestSocket {
                WebSocketManager.sharedInstance.disconnectSocket(socket: socket)
            }
            
            if let socket = WebSocketManager.sharedInstance.providerConnectionSocket {
                WebSocketManager.sharedInstance.disconnectSocket(socket: socket)
            }
            
            DispatchQueue.main.async {
                //Redirect to Home Screen
                RDGlobalFunction.goBackToMainViewController(currentVC: self)
            }
        }
        
        let buyAction = UIAlertAction(title: "Buy Extra Equipments", style: .default) { (action) -> Void in
           
            guard let url = URL(string: "https://weatheraccommodation.com/shop/") else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        //Add Actions
        alert.addAction(buyAction)
        alert.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancelAction)
        
        
        //Preseent Alert
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func btnEditPressed() {
        let editProfile = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "EditProviderProfileViewController") as! EditProviderProfileViewController
        editProfile.dictProfile = (self.viewControllers![2] as! ProviderProfileViewController).dictProfile
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    @IBAction func btnRedirectToPlacesScreenPressed() {
        let editProfile = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderNearByPlaceListViewController") as! ProviderNearByPlaceListViewController
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
}
