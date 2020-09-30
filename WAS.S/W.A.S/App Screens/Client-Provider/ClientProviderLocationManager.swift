//
//  ClientProviderLocationManager.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 25/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
}


//API MANAGER IMPLEMENTATION
class ClientProviderLocationManager: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: ClientProviderLocationManager {
        
        struct Static {
            static let instance = ClientProviderLocationManager()
        }
        return Static.instance
    }
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
       //  locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted  {
                UtilityClass.removeActivityIndicator()
                UtilityClass.showAlertWithMessage(message: "You have denied access for using location services.Please enable it in the settings.", title: "Access Denied", confirmButtonTitle: "Ok", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false) { (isConfirm) -> (Void) in
                    
                }
            } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                 self.locationManager?.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            }
            
        } else {
            UtilityClass.showAlertWithMessage(message: "You have disabled location services.Please enable it in the settings.", title: "Disabled GPS", confirmButtonTitle: "Ok", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false){(isConfirm) -> (Void) in
            }
        }
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager!.startUpdatingLocation()
        case .denied,.restricted:
            locationManager!.stopUpdatingLocation()
            
            UtilityClass.showAlertWithMessage(message: "You have denied access for using location services.Please enable it in the settings.", title: "Access Denied", confirmButtonTitle: "Ok", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false) { (isConfirm) -> (Void) in
                
            }
          //  ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "", alertTitle: "Access Denied", alertMessage: "You have denied access for using location services.Please enable it in the settings.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
        case .notDetermined :
            locationManager!.requestWhenInUseAuthorization()
        default:
            print("default")
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
}


