//
//  ProviderProductKitViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 06/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

let buttonSize = 30
var margin = 10

class ProviderProductKitViewController: UIViewController {
    
    var currentProviderId = 0
    var productKitList : [ProductKit] = []
    var productImageList = ["umbrella","rain-coat","shoes"]
    
    @IBOutlet weak var lblUploadCard: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var tableKit : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        designInterFace()
        self.getKit()
        tableKit.tableFooterView = UIView()
    }
    
    func designInterFace() {
        
        self.lblUploadCard.font = self.lblUploadCard.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()))
        
        self.btnNext.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        RDGlobalFunction.setCornerRadius(any: self.btnNext, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
    }
    
    override func viewDidLayoutSubviews() {
        
        RDGlobalFunction.setCornerRadius(any: self.btn1, cornerRad: btn1.frame.height/2, borderWidth: 0, borderColor: .clear)
        
        RDGlobalFunction.setCornerRadius(any: self.btn2, cornerRad: btn2.frame.height/2, borderWidth: 0, borderColor: .clear)
        
    }
    
    
    //MARK:UIButton Actions
    @IBAction func btnSizePressed(sender:UIButton) {
        let buttonPosition = sender.convert(CGPoint.init(x: 5.0, y: 5.0), to:self.tableKit)
        let indexPath = self.tableKit.indexPathForRow(at:buttonPosition)
        
        var sizes = productKitList[(indexPath?.row)!].sizes
        for (index,var size) in sizes.enumerated() {
            if size.ProductKitSizeId == sender.tag {
                size.isSelected = !size.isSelected
                sizes[index] = size
            } else {
                size.isSelected = false
                sizes[index] = size
            }
        }
        
        productKitList[(indexPath?.row)!].sizes = sizes
        tableKit.reloadData()
        
    }
    
    @IBAction func btnNextPressed() {
        for kit in productKitList {
            let arr = kit.sizes
            if (arr.filter{$0.isSelected}).count == 0 {
                UtilityClass.showAlertOnNavigationBarWith(message:"Select any one of sizes for all products" , title: "Alert", alertType: .failure)
                return
            }
        }
        
        uploadKitSize()
    }
    
    //MARK:WebService
    func getKit() {
        
        UtilityClass.showActivityIndicator()
            
        let providerIdParam  = [:] as [String : Any]
            
        ClientProviderAPIManager.sharedInstance.getProviderKit(selectedVC: self, providerKitParameters: providerIdParam, getProviderKit:PROVIDERKITAPI) { (responseObject, success) in
            
                if success{
                    
                    for item in (responseObject as! NSArray) {
                        self.productKitList.append(ProductKit.init(dict: item as! [String:AnyObject]))
                    }
                    
                    self.getKitSize()
                    
                }
//                else{
//
//                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
//
//                }
            }
    }
    
    func getKitSize() {
        
        UtilityClass.showActivityIndicator()
        
        let providerIdParam  = [:] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.getProviderKitSize(selectedVC: self, providerKitParameters: providerIdParam, getProviderKitSize: PROVIDERKITSIZEAPI) { (responseObject, success) in
            
            if success{
                
                var arr : [ProductSize] = []
                
                for item in (responseObject as! NSArray) {
                    arr.append(ProductSize.init(dict: item as! [String:AnyObject]))
                }
                
                for (index,var item) in self.productKitList.enumerated() {
                    let sizeList = arr.filter{$0.ProductKitId == item.ProductKitId}
                    item.sizes = sizeList
                    self.productKitList[index] = item
                }
                self.tableKit.reloadData()
                UtilityClass.removeActivityIndicator()
                
            }
//            else{
//
//                UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
//
//            }
        }
    }
    
    func uploadKitSize() {
        
        UtilityClass.showActivityIndicator()
        var arrSelectedSize:[Int] = []
        
        for kit in productKitList {
           let arr = kit.sizes
           arrSelectedSize.append(arr.filter{$0.isSelected}.map{$0.ProductKitSizeId}[0])
        }
        
        
        let providerKitParam  = ["ProductKitSizeIDs":arrSelectedSize, "ProviderId" : RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId)!] as [String : Any]
        
        
        ClientProviderAPIManager.sharedInstance.postProviderKitSize(selectedVC: self, providerKitParameters:providerKitParam , postProviderKitAPI: PROVIDERKITSAVE) { (responseObject, success) in
            if success {
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    let clientSignInVC : ClientSignInViewController = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "ClientSignInVC") as! ClientSignInViewController
                    self.present(clientSignInVC, animated: true, completion: nil)
                    
                  //  RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    
//                    if RDDataEngineClass.setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue: true) == true{
//                        //Open Client Dashboard Screen
//                        RDGlobalFunction.moveForwardToProviderDashboardViewController(currentVC: self, animated: true)
//                    }
                } else {
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Error", alertType: .failure)
                }
            }
//            else {
//                UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Error", alertType: .failure)
//            }
        }
    }
}

extension UIButton {
    
    func configure(title:String,tag:Int) {
        self.tag = tag
        self.titleLabel?.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-11))
        self.setTitleColor(.black, for: .normal)
        
        RDGlobalFunction.setCornerRadius(any: self, cornerRad: 0, borderWidth: 0.5, borderColor: RDDataEngineClass.primaryColor)
        self.setTitle(title, for: .normal)
        
    }
    
}

extension ProviderProductKitViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productKitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderKitTableCell
        cell.lblName.text = productKitList[indexPath.row].Name
        cell.imgProduct.image = UIImage.init(named:productImageList[indexPath.row])
        var newLine = false
        
        
        for (index,sizes) in productKitList[indexPath.row].sizes.enumerated() {
            
            let btn = cell.sizeButtons[index]
         //   btn.addTarget(self, action: #selector(btnSizePressed(sender:)), for: .touchUpInside)
            btn.configure(title: sizes.Size, tag: sizes.ProductKitSizeId)
            btn.isHidden = false
            
            if index > 4 {
                newLine = true
            }
            
            if sizes.isSelected {
                btn.backgroundColor = RDDataEngineClass.primaryColor
            } else {
                btn.backgroundColor = .clear
            }
 
            
//            let btn = UIButton.init()
//            if index == 0 {
//                margin = 0
//            } else {
//                margin = 10
//            }
//
//            var  originX  = 0
//            var  originY  = 0
//
//            if newLine {
//                originY = buttonSize + 10
//                margin = 10
//                originX = (margin+buttonSize)*(index-newLineFrom)
//            } else {
//                let width = cell.vwSizeContainer.frame.width
//
//                originX  = (margin+buttonSize)*index
//                if  originX + buttonSize > Int(width) {
//                    originX = 0
//                    originY = buttonSize + 10
//                    newLine = true
//                    newLineFrom = index
//                }
//            }
//
//            btn.configure(originX:(margin+buttonSize)*index, originY: originY, title: sizes.Size, tag: sizes.ProductKitSizeId)
//            if sizes.isSelected {
//                btn.backgroundColor = RDDataEngineClass.primaryColor
//            } else {
//                btn.backgroundColor = .clear
//            }
//
//            btn.addTarget(self, action: #selector(btnSizePressed(sender:)), for: .touchUpInside)
//            cell.vwSizeContainer.addSubview(btn)
        }
        
        let hideButtons = cell.sizeButtons[productKitList[indexPath.row].sizes.count..<cell.sizeButtons.count]
        hideButtons.forEach { $0.isHidden = true }
        
        if  newLine {
            cell.bottomfromFirstLine.priority = .defaultLow
            cell.bottomFromNewLine.priority = .defaultHigh
        } else {
            cell.bottomfromFirstLine.priority = .defaultHigh
            cell.bottomFromNewLine.priority = .defaultLow
        }
      
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
       
        return cell
    }
}
