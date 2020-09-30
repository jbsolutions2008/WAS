//
//  ProviderNearByPlaceListViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 11/10/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import CoreLocation

class ProviderNearByPlaceListViewController: UIViewController {
    let arrKeyword = ["Church","Museum","Amusemnet Park","Art Gallery","Movie Theatre","Zoo"]

    @IBOutlet weak var tableView:UITableView!
    var arrPlaces : [[String : AnyObject]] = [[:]]
    var currentCategory = 1
    @IBOutlet weak var scrlView:UIScrollView!
    
    var latitude = ""
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
        UtilityClass.showActivityIndicator()
        ClientProviderLocationManager.sharedInstance.delegate = self
        ClientProviderLocationManager.sharedInstance.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        for subView in scrlView.subviews {
            if  !(subView.isKind(of: UIButton.self)) {
                if subView.tag == currentCategory {
                    RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0, borderColor: .clear)
                } else {
                    RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0.5, borderColor: .gray)
                }
            }
        }
        print(scrlView.contentSize)
    }
    
    
    // MARK: - UIButton Actions
    @IBAction func btnCategoryChangePressed(sender : UIButton) {
        if  currentCategory != sender.tag {
            for subView in scrlView.subviews {
                if  subView.tag == sender.tag {
                    if subView is UIButton {
                        (subView as! UIButton).isSelected = true
                    } else {
                        subView.backgroundColor = RDDataEngineClass.primaryColor
                        RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0, borderColor: .clear)
                    }
                } else if subView.tag == currentCategory {
                    if subView is UIButton {
                        (subView as! UIButton).isSelected = false
                    } else {
                        subView.backgroundColor = .white
                        RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0.5, borderColor: .gray)
                    }
                }
            }
            currentCategory = sender.tag
            self.arrPlaces.removeAll()
            searchNearbyPlaceByKeyword()
        }
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:WebService
    func searchNearbyPlaceByKeyword() {
        
        UtilityClass.showActivityIndicator()
        let params = ["lat":self.latitude,"long":self.longitude,"keyword":arrKeyword[currentCategory-1]]
        
        ClientProviderAPIManager.sharedInstance.getNearbyPlaces(currentVC: self, parameter:params as [String : AnyObject], Alert: true) { (resultsArray, success) in
           // if success {
                UtilityClass.removeActivityIndicator()
                self.arrPlaces = resultsArray as! [[String : AnyObject]]
                self.tableView.reloadData()
          //  }
        }
    }
}


extension ProviderNearByPlaceListViewController : LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        
        self.latitude = "\(currentLocation.coordinate.latitude)"
        self.longitude = "\(currentLocation.coordinate.longitude)"
        if self.latitude != "" {
            searchNearbyPlaceByKeyword()
        }
        ClientProviderLocationManager.sharedInstance.delegate = nil
       // ClientProviderLocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}

extension ProviderNearByPlaceListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PlaceTableViewCell
        cell.lblName.text = arrPlaces[indexPath.row]["name"] as? String
        cell.lblAddress.text = arrPlaces[indexPath.row]["vicinity"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictLocation = (arrPlaces[indexPath.row]["geometry"] as! [String:AnyObject])["location"] as! [String:AnyObject]
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(dictLocation["lat"]!),\(dictLocation["lng"]!)&directionsmode=walking")! as URL, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(NSURL(string:
                "http://maps.apple.com/?saddr=&daddr=\(dictLocation["lat"]!),\(dictLocation["lng"]!)&directionsmode=walking")! as URL, options: [:], completionHandler: nil)
        }
    }
}
