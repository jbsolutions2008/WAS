//
//  ClientTripListViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 09/10/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientTripListViewController: UIViewController {

    
    var tripList : [TripList] = []
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTripList()
        
    }
    
    //MARK:UIButton Actions
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:WebService
    func getTripList() {
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int )
        let param = ["ClientId" : userID]
        
        ClientProviderAPIManager.sharedInstance.customerTripList(selectedVC: self, requestParameters: param, tripListAPI: CLIENTTRIPLIST) { (responseObject, success) in
            if success {
                let arr = responseObject["ClientTrip"] as! NSArray
                
                for item in arr {
                    self.tripList.append(TripList.init(dict: item as! [String : AnyObject]))
                }
                self.tableView.reloadData()
                
            }
        }
    }
}

extension ClientTripListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TripListTableCell
        cell.lblDate.text = RDGlobalFunction.dateStringFromUnixTime(unixTime: tripList[indexPath.row].TripTimestamp)
        cell.lblTime.text = RDGlobalFunction.timeStringFromUnixTime(unixTime: tripList[indexPath.row].TripTimestamp)
        cell.ratings.rating = Double(tripList[indexPath.row].StarRatings)
        cell.lblTripCharge.text = "Charge: $ \(tripList[indexPath.row].TotalTripAmount)"
        cell.selectionStyle = .none
      //  cell.ratings.rating = 
        return cell
        
    }
}
