//
//  ClientProfileViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 24/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientProfileViewController: UIViewController {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    
    @IBOutlet weak var lblPhoneNumber : UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
    var dictProfile : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getClientDetails()
    }
    

    //MARK - UIButton Actions
    @IBAction func btnEditPressed() {
        
        let editProfile = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "EditClientProfileViewController") as! EditClientProfileViewController
        editProfile.dictProfile = self.dictProfile
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    @IBAction func btnBackPressed() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:Web Service
    func getClientDetails() {
        
        UtilityClass.showActivityIndicator()
        
        let providerIdParam  = [:] as [String : Any]
        
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int )
        let getClientProfileStr = CLIENTDETAIL + "ClientId=\(userID)"
        
        ClientProviderAPIManager.sharedInstance.getClientDetails(selectedVC: self, clientParameters:providerIdParam , getClientDetails:getClientProfileStr ) { (responseObject, success) in
            
        
            if success {
                
                self.dictProfile = responseObject as! [String : Any]
                UtilityClass.removeActivityIndicator()
                self.lblName.text = responseObject["Name"] as? String
                self.lblPhoneNumber.text = responseObject["MobileNumber"] as? String
                self.lblEmail.text = responseObject["Email"] as? String
                self.lblAddress.text = responseObject["Address"] as? String
                self.imgProfile.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + (responseObject["ProfileImg"] as? String)!), placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }
    }
}
