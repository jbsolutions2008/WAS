//
//  ProviderTripsViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 16/11/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderTripsViewController: UIViewController {
    
    var tripList : [TripList] = []
    @IBOutlet weak var tableView : UITableView!
    var arrColors = [UIColor(red: 125, green: 104, blue: 148), UIColor(red: 96, green: 124, blue: 183), UIColor(red: 168, green: 101, blue: 102), UIColor(red: 33, green: 33, blue: 33)]
    
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
        let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int )
        let getProviderTripsStr = PROVIDERGETTRIPS + "?ProviderId=\(userID)"
        
        ClientProviderAPIManager.sharedInstance.getProviderTrips(selectedVC: self, providerParameters: [:], getTripsAPI: getProviderTripsStr) { (responseObject, success) in
            if success {
                let arr = responseObject["ProviderTripHistoryList"] as! NSArray
                
                for item in arr {
                    self.tripList.append(TripList.init(dict: item as! [String : AnyObject]))
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension ProviderTripsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TripListTableCell
        cell.lblDate.text = RDGlobalFunction.dateStringFromUnixTime(unixTime: tripList[indexPath.row].TripTimestamp)
        cell.lblTime.text = RDGlobalFunction.timeStringFromUnixTime(unixTime: tripList[indexPath.row].TripTimestamp)
        cell.lblTripCharge.text = "Charge: $ \(tripList[indexPath.row].TripCharges)"
        cell.lblTripTip.text = "Tip: $ \(tripList[indexPath.row].TipAmount)"
        cell.layoutIfNeeded()
        RDGlobalFunction.setCornerRadius(any: cell.vwBackground, cornerRad: 5.0, borderWidth: 0, borderColor: .clear)
        cell.vwBackground.backgroundColor = arrColors[(indexPath.row)%arrColors.count]
        cell.selectionStyle = .none
        //  cell.ratings.rating =
        return cell
        
    }
}

extension UIColor {
    convenience init(red:Int,green:Int,blue:Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
    }
}
