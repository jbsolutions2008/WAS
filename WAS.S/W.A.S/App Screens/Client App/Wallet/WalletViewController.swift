//
//  WalletViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 10/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    var cardList : [StripeCard] = []
    var selectedIndex = -1
    var userStripeId = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedIndex = RDGlobalFunction.getIntFromUserDefault(iSDefaultKey: RDDataEngineClass.userCardSelected)
        self.cardList.removeAll()
        getStripeCardList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if cardList.count == 0 {
            RDGlobalFunction.setIntInUserDefault(iSDefaultValue: -1, iSDefaultKey: RDDataEngineClass.userCardSelected)
            RDGlobalFunction.setIntInUserDefault(iSDefaultValue: -1, iSDefaultKey: RDDataEngineClass.userStripeId)
        } else {
            RDGlobalFunction.setIntInUserDefault(iSDefaultValue: selectedIndex, iSDefaultKey: RDDataEngineClass.userCardSelected)
            RDGlobalFunction.setIntInUserDefault(iSDefaultValue: userStripeId, iSDefaultKey: RDDataEngineClass.userStripeId)
        }
        RDGlobalFunction.setIntInUserDefault(iSDefaultValue: cardList.count, iSDefaultKey: RDDataEngineClass.userCardCount)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnAddCardPressed() {
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//        self.navigationController?.pushViewController(addCardViewController, animated: true)
        
        let addCardViewController: AddCardViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        self.navigationController?.pushViewController(addCardViewController, animated: true)
        
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:WebService
    func getStripeCardList()  {
        
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int )
        let param = ["ClientId" : userID]
        
        ClientProviderAPIManager.sharedInstance.getStripeCardList(selectedVC: self, requestParameters: param, cardListAPI: CLIENTCARDLIST) { (responseObject, success) in
            if success {
                
                
                let  arr = responseObject["SourceCardList"] as! NSArray
                
                self.cardList.removeAll()
                for item in arr {
                    self.cardList.append(StripeCard.init(dict: item as! [String : AnyObject]))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteCardWithAPI(index:IndexPath) {
        UtilityClass.showActivityIndicator()
        
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int )
        let param = ["ClientId" : userID, "ClientStripeCustomerSourceId" : cardList[index.row].ClientStripeCustomerSourceId]
        
        ClientProviderAPIManager.sharedInstance.deleteCardFromCustomer(selectedVC: self, requestParameters: param, deleteCardAPI:DELETECLIENTCARD) { (responseObject, success) in
            if success {
              
                UtilityClass.removeActivityIndicator()
                self.tableView.beginUpdates()
                self.cardList.remove(at: index.row)
                self.tableView.deleteRows(at: [index], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    
    
//    func getWeatherData() {
//        ClientProviderAPIManager.sharedInstance.getWeatherData(currentVC: self, lat: "\(Location.coordinate.latitude)", lng: "\(Location.coordinate.longitude)", headers:[:] , Alert: true) { (responseObject, success) in
//            if success {
//
//
//                let  arr = responseObject["SourceCardList"] as! NSArray
//
//                self.forecastArr.removeAll()
//                for item in arr {
//                    self.forecastArr.append(Forecast.init(dict: item as! [String : AnyObject]))
//                }
//
//                self.tableView.reloadData()
//            }
//        }
//    }
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CardListTableCell
        cell.lblCardText.text = "\(cardList[indexPath.row].Brand) ending with \(cardList[indexPath.row].last4)"
        if  cardList[indexPath.row].ClientStripeCustomerSourceId == selectedIndex {
            cell.imgCheckmark.isHidden = false
        } else {
            cell.imgCheckmark.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = cardList[indexPath.row].ClientStripeCustomerSourceId
        userStripeId = cardList[indexPath.row].ClientStripeCustomerId
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if (editingStyle == .delete) {
            if cardList[indexPath.row].ClientStripeCustomerSourceId == selectedIndex {
                if cardList.count == 1 {
                    selectedIndex = -1
                    userStripeId = -1
                } else {
                    selectedIndex = cardList[indexPath.row-1].ClientStripeCustomerSourceId
                    userStripeId = cardList[indexPath.row-1].ClientStripeCustomerId
                    
                }
            }
            
            deleteCardWithAPI(index: indexPath)
            
        }
    }
}
