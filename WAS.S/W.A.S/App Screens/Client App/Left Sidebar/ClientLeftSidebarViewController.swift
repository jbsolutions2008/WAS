//
//  ClientLeftSidebarViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 24/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientLeftSidebarViewController: UIViewController {
    
    @IBOutlet weak var aTableView: UITableView!
    
    //Cleint Left Side Menu Options
//    let clientMenuNameAry = ["Dashboard", "Extra Equipments", "Wallet" , "Notification","Profile" ,"Settings", "Log Out"]
//    let clientMenuImagesAry = ["dashboardIcon", "extraEquipmentsIcon", "walletIcon" , "notificationIcon","profileIcon" ,"settingsIcon", "logOutIcon"]
    
    let clientMenuNameAry = ["Dashboard", "Payment" ,"Profile","Trips","Support","Log Out"]
    let clientMenuImagesAry = ["dashboardIcon", "walletIcon","profileIcon","tripIcon","logOutIcon"]
    
    var checkedIndexPath : IndexPath!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.aTableView.frame = CGRect(x: 0, y: (self.aTableView.frame.origin.y - 20), width: (RDGlobalFunction.sideBarWidthSizeAccordingToScreen()), height: (self.aTableView.frame.size.height + 20))
        
        self.aTableView.tableFooterView = UIView()
        self.aTableView.tableFooterView?.backgroundColor = UIColor.white
        self.aTableView.contentInsetAdjustmentBehavior = .automatic
        
        //Received Notification for Refresh/Update profile locally
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadDataOfTheView(_:)), name:NSNotification.Name(rawValue: "RefreshViewAndReloadData"), object: nil)
        
        //Received Notification For Reset Index path Image issues
        NotificationCenter.default.addObserver(self, selector: #selector(self.ResetIndexPathForMenuBar(_:)), name: NSNotification.Name(rawValue: "ResetMenuBarCellIndexPath"), object: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.aTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.addShadowView()
    }
    
    
    //Received Notification For Reset Index path Image issues
    @objc func ResetIndexPathForMenuBar(_ notification: Notification) {
        
        let userInfo:Dictionary <String, AnyObject> = notification.userInfo as! Dictionary<String, AnyObject>
        
        self.checkedIndexPath = userInfo["selectedIndexPath"] as? IndexPath
        
        self.aTableView.reloadData()
    }
    
    
    //Received Notification for Refresh/Update profile locally
    @objc func ReloadDataOfTheView(_ notification: Notification){
        
        self.aTableView.reloadData()
    }
    
    deinit {
        
        //Received Notification for Refresh/Update profile locally
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RefreshViewAndReloadData"), object: nil)
        
        //Received Notification For Reset Index path Image issues
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ResetMenuBarCellIndexPath"), object: nil)
        
        // NSNotificationCenter.defaultCenter().removeObserver(self) - All
    }
}

extension ClientLeftSidebarViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (UIScreen.main.bounds.size.width == 320) {
            return 200
        }else if (UIScreen.main.bounds.size.width == 375) {
            return 230
        }else{
            return 250
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(UIScreen.main.bounds.size.width == 320) {
            return 50
        }else{
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! SideBarHeaderTableViewCell
        
        //Name
        
        headerCell.userNameLbl.text = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: "Name") as? String
        headerCell.userDetailsLbl.text =  (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: "MobileNumber") as? String ?? "") + "\n" + (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: "Email") as? String ?? "")
        
        var profileStr = ""
        
        if !profileStr.hasPrefix("https"){
            
            if profileStr.hasPrefix("http") { //profileStr.contains("http")
                
                DispatchQueue.global(qos: .userInteractive).async {
                    
                    DispatchQueue.main.async{
                        
                        profileStr = "https" + profileStr.dropFirst(4)
                        
                        let profilePicURL : URL = URL(string: profileStr)!
                        
                        headerCell.profileIV.af_setImage(withURL: profilePicURL, placeholderImage: UIImage(named: "AppIcon_Images"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
                        
                    }
                }
            }
            
        }else{
            
            let profilePicURL : URL = URL(string: profileStr)!
            
            headerCell.profileIV.af_setImage(withURL: profilePicURL, placeholderImage: UIImage(named: "AppIcon_Images"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
            
        }
        return headerCell
    }
    
    
    //Side Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.clientMenuNameAry.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! SideBarDataTableViewCell
        
        if indexPath.row == (self.clientMenuNameAry.count-1){
            cell.contentView.backgroundColor = RDDataEngineClass.secondaryColor
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
        cell.titleLbl.text = self.clientMenuNameAry[indexPath.row]
        
//        cell.iconIV.image = UIImage(named: self.clientMenuImagesAry[indexPath.row])
//        cell.iconIV.image = cell.iconIV.image!.withRenderingMode(.alwaysTemplate)
        
        
        if (checkedIndexPath == nil) && (indexPath.row == 0) {
            
            checkedIndexPath = indexPath
            
            cell.titleLbl.textColor = RDDataEngineClass.primaryShadeColor
//            cell.iconIV.tintColor = RDDataEngineClass.primaryShadeColor
        }
        
        if ((indexPath as NSIndexPath).compare(self.checkedIndexPath) == ComparisonResult.orderedSame) {
            
            cell.titleLbl.textColor = RDDataEngineClass.primaryShadeColor
//            cell.iconIV.tintColor = RDDataEngineClass.primaryShadeColor
            
        } else {
            
            cell.titleLbl.textColor = UIColor.darkGray
//            cell.iconIV.tintColor = UIColor.darkGray
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // self.checkedIndexPath = indexPath
        
        
        DispatchQueue.main.async {
            
            if indexPath.row == 5 {
                
                ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "Log Out?", alertTitle: "Log Out?", alertMessage: "Are you sure you wish to Log Out?", alertTag: 1001, alertActionTitle: "YES", alertActionStyle: .destructive)
                
            }else{
                
                
                
                if indexPath.row == 0 {
                    let dashboardVC: ClientDashboardViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientDashboardVC") as! ClientDashboardViewController
                    self.navigationController?.pushViewController(dashboardVC, animated: true)
                }else if indexPath.row == 1 {
                    let walletVC: WalletViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    self.navigationController?.pushViewController(walletVC, animated: true)
                }else if indexPath.row == 2 {
                    let walletVC: ClientProfileViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientProfileViewController") as! ClientProfileViewController
                    self.navigationController?.pushViewController(walletVC, animated: true)
                }else if indexPath.row == 3 {
                   let tripVC: ClientTripListViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientTripListViewController") as! ClientTripListViewController
                   self.navigationController?.pushViewController(tripVC, animated: true)
                }else if indexPath.row == 4 {
                    let supportVC = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
                    self.navigationController?.pushViewController(supportVC, animated: true)
                }else if indexPath.row == 5 {
                    
                }
               self.dismiss(animated: true, completion: nil)
            }
        }
        
            
        
//        DispatchQueue.main.async {
//
//            if indexPath.row == 6 {
//
//                ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "Log Out?", alertTitle: "Log Out?", alertMessage: "Are you sure you wish to Log Out?", alertTag: 1001, alertActionTitle: "YES", alertActionStyle: .destructive)
//
//            } else if indexPath.row == 1 {
//               // self.dismiss(animated: true, completion: nil)
//                let nvc = self.navigationController?.presentingViewController as! UINavigationController
//
//                for vc in nvc.viewControllers {
//                    if vc is ProviderWeatherViewController {
//                        nvc.popToViewController(vc, animated: false)
//                    } else {
//                        let VC: ProviderWeatherViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderWeatherViewController") as! ProviderWeatherViewController
//
//                        nvc.pushViewController(VC, animated: false)
//                    }
//                }
//
//            } else if indexPath.row == 0 {
//                let nvc = self.navigationController?.presentingViewController as! UINavigationController
//
//                for vc in nvc.viewControllers {
//                    if vc is ClientDashboardViewController {
//                       nvc.popToViewController(vc, animated: false)
//                    } else {
//                        let VC: ClientDashboardViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientDashboardVC") as! ClientDashboardViewController
//
//                        nvc.pushViewController(VC, animated: false)
//                    }
//                }
//
//            } else {
//
//                self.dismiss(animated: true, completion: nil)
//
//            }
//
//        }
    
    }
    
}
