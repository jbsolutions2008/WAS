//
//  ProviderProfileViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 03/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Cosmos

class ProviderProfileViewController: UIViewController {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
  
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var starRating : CosmosView!
    @IBOutlet weak var lblPhoneNumber : UILabel!
  
    @IBOutlet weak var lblServiceCount : UILabel!
    @IBOutlet weak var lblYearsCount : UILabel!
    @IBOutlet weak var lblService : UILabel!
    @IBOutlet weak var lblYears : UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
    @IBOutlet weak var vwRoundedService : UIView!
    @IBOutlet weak var vwRoundedComm : UIView!
    @IBOutlet weak var vwRoundedAbove : UIView!
    @IBOutlet weak var vwCompliments : UIView!
    
     var dictProfile : [String : Any] = [:]
   
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: "Name") as? String
    }
    
    override func viewDidLayoutSubviews() {
        vwCompliments.layoutIfNeeded()
        RDGlobalFunction.setCornerRadius(any: self.vwRoundedService, cornerRad: vwRoundedService.frame.height/2, borderWidth: 0, borderColor: .clear)
       
        RDGlobalFunction.setCornerRadius(any: self.vwRoundedComm, cornerRad: vwRoundedComm.frame.height/2, borderWidth: 0, borderColor: .clear)
        
        RDGlobalFunction.setCornerRadius(any: self.vwRoundedAbove, cornerRad: vwRoundedAbove.frame.height/2, borderWidth: 0, borderColor: .clear)
        
        RDGlobalFunction.setCornerRadius(any: self.imgProfile, cornerRad: imgProfile.frame.height/2, borderWidth: 0, borderColor: .clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Profile"
//        (self.parent as! ProviderTabBarController).btnEdit.tintColor = .white
//        (self.parent as! ProviderTabBarController).btnNearbyPlace.tintColor = .clear
        
        (self.parent as! ProviderTabBarController).navigationItem.rightBarButtonItems = [(self.parent as! ProviderTabBarController).btnMore,(self.parent as! ProviderTabBarController).btnEdit]
        getProviderDetails()
    }
    
    func getProviderDetails() {
        
        UtilityClass.showActivityIndicator()
        
        let providerIdParam  = [:] as [String : Any]
     
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int )
        let getProviderProfileStr = PROVIDERDETAIL + "ProviderId=\(userID)"
        
        ClientProviderAPIManager.sharedInstance.getProviderDetails(selectedVC: self, providerParameters: providerIdParam, getProviderDetails: getProviderProfileStr) { (responseObject, success) in
            if success {
                
                self.dictProfile = responseObject as! [String : Any]
                UtilityClass.removeActivityIndicator()
                self.lblName.text = responseObject["Name"] as? String
                self.lblRating.text = "\(responseObject["ReviewRatings"]! ?? "0.0")"
                if let rating = responseObject["ReviewRatings"] {
                    self.starRating.rating = Double(rating as! String)!
                }
                self.lblPhoneNumber.text = responseObject["MobileNumber"] as? String
                self.lblServiceCount.text = "\(responseObject["CompletedServices"]! ?? "0")"
                self.lblYearsCount.text = responseObject["JoinYearsMonth"] as? String
                self.lblEmail.text = responseObject["Email"] as? String
                self.lblAddress.text = responseObject["Address"] as? String
                self.imgProfile.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + (responseObject["ProfileImg"] as? String)!), placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }
    }
}
