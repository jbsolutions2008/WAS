//
//  ExtraEquipmentViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 21/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ExtraEquipmentViewController: UIViewController {

    var currentProviderId = 0
    var productKitList : [ProductKit] = []
    var productImageList = ["umbrella","rain-coat","shoes"]
    var productPriceList = ["9.99","5","5"]
    
    @IBOutlet weak var lblUploadCard: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var tableKit : UITableView!
    
    @IBOutlet weak var viewPopup : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Extra Equipments"
        designInterFace()
        self.getKit()
        tableKit.tableFooterView = UIView()
    }
    
    func designInterFace() {
        
      
        self.viewPopup.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.btnNext.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: btnNext, cornerRad: 0, borderWidth: 1, borderColor: .black)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.viewPopup.isHidden = true
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
       
        var strProducts = "selected"
        var arrSelected : [ProductKit] = []
        
        var isAdded = false
        
        for (index,kit) in productKitList.enumerated() {
            isAdded = false
            let arr = kit.sizes
            if (arr.filter{$0.isSelected}).count > 0 {
                if kit.Quantity != "" {
                    if Int(kit.Quantity)! <= 0 {
                        UtilityClass.showAlertOnNavigationBarWith(message:"Enter number of equipments for selected product" , title: "Alert", alertType: .failure)
                        return
                    } else {
                        if !isAdded {
                            isAdded = true
                            strProducts = strProducts.appending("\(Int(kit.Quantity)!) \(kit.Name) ")
                            RDGlobalFunction.appDelegate.extraCharge += Double(kit.Quantity)!*Double(productPriceList[index])!
                            arrSelected.append(kit)
                            
                        }
                    }
                } else {
                    UtilityClass.showAlertOnNavigationBarWith(message:"Enter number of equipments for selected product" , title: "Alert", alertType: .failure)
                    return
                }
            }
            
            if kit.Quantity != "" {
                if Int(kit.Quantity)! > 0 {
                    if (arr.filter{$0.isSelected}).count == 0 {
                        UtilityClass.showAlertOnNavigationBarWith(message:"Choose any one of sizes for selected product" , title: "Alert", alertType: .failure)
                        return
                    } else {
                        if !isAdded {
                            isAdded = true
                            strProducts = strProducts.appending("\(Int(kit.Quantity)!) \(kit.Name) ")
                            arrSelected.append(kit)
                        }
                    }
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        if arrSelected.count != 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RDDataEngineClass.ExtraEquipments), object: nil, userInfo: ["products":arrSelected])
        }
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSizeChartPressed() {
        self.viewPopup.isHidden = false
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
//            else{
//
//                UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: RDDataEngineClass.BTAError, alertType: .failure)
//
//            }
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
}



extension ExtraEquipmentViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productKitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderKitTableCell
        cell.lblName.text = "\(productKitList[indexPath.row].Name): $\(productPriceList[indexPath.row])"
        cell.imgProduct.image = UIImage.init(named:productImageList[indexPath.row])
        cell.txtQty.tag = indexPath.row
        cell.txtQty.text = productKitList[indexPath.row].Quantity
        
        var newLine = false
        
        
        for (index,sizes) in productKitList[indexPath.row].sizes.enumerated() {
            
            let btn = cell.sizeButtons[index]
            //   btn.addTarget(self, action: #selector(btnSizePressed(sender:)), for: .touchUpInside)
            btn.configure(title: sizes.Size, tag: sizes.ProductKitSizeId)
            btn.isHidden = false
            
            if index > 2 {
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

extension ExtraEquipmentViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let newLength = textField.text!.count + string.count - range.length
        return newLength <= 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var productKit = productKitList[textField.tag]
        productKit.Quantity = textField.text!
        productKitList[textField.tag] = productKit
    }
}
