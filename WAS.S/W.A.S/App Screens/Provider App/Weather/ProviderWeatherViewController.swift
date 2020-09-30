//
//  ProviderWeatherViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 13/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SideMenu
import GoogleMaps

class ProviderWeatherViewController: UIViewController {

    @IBOutlet weak var lblWind:UILabel!
    @IBOutlet weak var lblHumidity:UILabel!
    @IBOutlet weak var lblDay:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var imgWeather:UIImageView!
    @IBOutlet weak var lblCity:UILabel!
    @IBOutlet weak var lblWeatherCondition:UILabel!
    @IBOutlet weak var lbltemperature:UILabel!
    
    @IBOutlet weak var tableView:UITableView!
    
    var forecastArr : [Forecast] = []
   
    
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        tableView.tableFooterView = UIView.init()
        
//        let fmt = DateFormatter()
//        weekDays = fmt.weekdaySymbols
//        shortweekDays =  fmt.shortWeekdaySymbols
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UtilityClass.showActivityIndicator()
        ClientProviderLocationManager.sharedInstance.delegate = self
        ClientProviderLocationManager.sharedInstance.startUpdatingLocation()
        self.parent!.title = "Weather"
//        (self.parent as! ProviderTabBarController).btnEdit.tintColor = .clear
//        (self.parent as! ProviderTabBarController).btnNearbyPlace.tintColor = .white
        
        (self.parent as! ProviderTabBarController).navigationItem.rightBarButtonItems = [(self.parent as! ProviderTabBarController).btnMore,(self.parent as! ProviderTabBarController).btnNearbyPlace]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //  ClientProviderLocationManager.sharedInstance.delegate = nil
    }
            
        
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
        //self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    
    //Other Methods
    func setWeatherDetails(index:Int) {
        self.lblDay.text = RDGlobalFunction.dayStringFromTime(unixTime: forecastArr[index].date, isShort: false)
        self.lblDate.text = RDGlobalFunction.dateStringFromUnixTime(unixTime: forecastArr[index].date)
        self.lblWind.text =  String(format: "Wind %.2f km/h",Float(forecastArr[index].speed)!)
        self.lblHumidity.text = "\(forecastArr[index].humidity)%"
        self.lblWeatherCondition.text = forecastArr[index].weather.desc
        self.lbltemperature.text = "\(forecastArr[index].temperature)°"
        self.imgWeather.sd_setImage(with: URL(string: forecastArr[index].weather.icon), placeholderImage: #imageLiteral(resourceName: "logo"))
    }
    
    //MARK:WebService
    func getWeatherData(of Location : CLLocation) {
        ClientProviderAPIManager.sharedInstance.getWeatherData(currentVC: self, lat: "\(Location.coordinate.latitude)", lng: "\(Location.coordinate.longitude)", headers:[:] , Alert: true) { (responseObject, success) in
            if success {
                
                self.lblCity.text = ((responseObject["city"] as! [String : Any])["name"]! as? String)?.uppercased()
                let  arr = responseObject["list"] as! NSArray
                
                self.forecastArr.removeAll()
                for item in arr {
                    self.forecastArr.append(Forecast.init(dict: item as! [String : AnyObject]))
                }
                self.setWeatherDetails(index: 0)
                self.tableView.reloadData()
                UtilityClass.removeActivityIndicator()
            }
        }
    }
}


extension ProviderWeatherViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderWeatherTableCell
        cell.selectionStyle = .none
        cell.lblDay.text = RDGlobalFunction.dayStringFromTime(unixTime: forecastArr[indexPath.row].date, isShort: true)
        cell.lblTemperature.text = "\(forecastArr[indexPath.row].temperature) °F"
        cell.lblWeather.text = forecastArr[indexPath.row].weather.main
        cell.imgWeather.sd_setImage(with: URL(string: forecastArr[indexPath.row].weather.icon), placeholderImage: #imageLiteral(resourceName: "logo"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setWeatherDetails(index: indexPath.row)
    }
}

extension ProviderWeatherViewController : LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        getWeatherData(of: currentLocation)
        ClientProviderLocationManager.sharedInstance.delegate = nil
        
      //  ClientProviderLocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
    
}
