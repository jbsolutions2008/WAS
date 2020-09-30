//
//  ProviderDadhboardViewController.swift
//  Weather Accommodation
//
//  Created by Renish's iMac on 30/07/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import GoogleMaps
import Starscream
import UICircularProgressRing

protocol ProviderReachDelegate {
    func notifyWhenProviderHasReached()
}

class ProviderDadhboardViewController: UIViewController, UIGestureRecognizerDelegate {

    var leftClientSidebar : ProviderLeftSidebarViewController?
    
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    var indexPathRS: IndexPath = IndexPath(row: 0, section: 0)
    var isReloadView: Bool = true
    
    @IBOutlet weak var swchStatus:UISwitch!
    @IBOutlet weak var mapView:GMSMapView!
     var clientMarker:GMSMarker!
     var providerMarker:GMSMarker!
     var tripPath:GMSPolyline!
    @IBOutlet weak var lblStatus:UILabel!
    
    @IBOutlet weak var requestView:UIView!
    @IBOutlet weak var lblDistance:UILabel!
    @IBOutlet weak var timerView:UICircularTimerRing!
    
    @IBOutlet weak var btnNavigation:UIButton!
    
    var latitude = ""
    var longitude = ""
    var currentRequest : [String : Any]!
    var currentAcceptedRequest : [String : Any]!
    var timer = Timer()
    var requestDetail  = ""
    var hasProviderReached = false
    var delegate: ProviderReachDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do initial setup
        designInterface()
        
        ClientProviderLocationManager.sharedInstance.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector:#selector(showRequestUIAfterTransitionToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
       
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        DispatchQueue.main.async {
            
            let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int )
            let getProviderProfileStr = PROVIDERGETPROFILEINFOAPI + "?ProviderId=\(userID)"
            
            self.getProviderProfileUserInformationAPI(providerProfileInfoget: getProviderProfileStr)
        }
        checkIfTripExists()
    }
    
    
    
    func designInterface() {
        timerView.style = .ontop
        timerView.fontColor = .clear
        timerView.startAngle = 0.0
        timerView.endAngle = 360.0
        self.lblStatus.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-3))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent!.title = "Dashboard"
        
       
        ClientProviderLocationManager.sharedInstance.delegate = self
     //   WebSocketManager.sharedInstance.delegate = self
//        (self.parent as! ProviderTabBarController).btnEdit.tintColor = .clear
//        (self.parent as! ProviderTabBarController).btnNearbyPlace.tintColor = .clear
        (self.parent as! ProviderTabBarController).navigationItem.rightBarButtonItems = [(self.parent as! ProviderTabBarController).btnMore]
        
        if self.clientMarker != nil {
            self.clientMarker.map = nil
            self.providerMarker.map = nil
            self.tripPath.map = nil
            self.btnNavigation.isHidden = true
            timer.invalidate()
        }
    }
    
    @objc func showRequestUIAfterTransitionToForeground() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
               if delegate.showRequestUI {
                   showRequestUI(requestDetail: requestDetail)
               }
    }
    
    //MARK: UIButton Actions
    @IBAction func leftSideBarMenuButttonAction(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func btnCancelRequest(_ sender: UIButton) {
        self.cancelRequest()
    }
    
    
    @IBAction func btnAcceptRequest(_ sender: UIButton) {
        
        WebSocketManager.sharedInstance.connectClientProviderRequestSocket(with:CLIENTPROVIDERCONNECTION + "ClientId=\(currentRequest["ClientId"]!)")
        requestView.isHidden = true
//        let messageDictionary = [
//            "ClientId":currentRequest["ClientId"]!,
//            "ProviderId":RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int,
//            "Latitude" : self.latitude,
//            "Longitude" : self.longitude,
//            "UserType" : "provider"] as [String : Any]
//        
//        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    }
        
        
    
    //MARK:Other Methods
    func requestSocketToChangeStatusOrLocation() {
        if swchStatus.isOn {
   WebSocketManager.sharedInstance.connectProviderSocket(with:"ProviderAPI/ActivateProvider?ProviderId=\((RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int ))&Latitude=\(latitude)&Longitude=\(longitude)&IsActive=1")
        WebSocketManager.sharedInstance.delegate = self
            
        } else {
         
            WebSocketManager.sharedInstance.disconnectSocket(socket: WebSocketManager.sharedInstance.providerConnectionSocket)
            timer.invalidate()
        }
    }
    
    func openBottomSheet()  {
        let vc = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "TripClientDetailViewController") as! TripClientDetailViewController
        vc.currentRequest = self.currentAcceptedRequest
        vc.clientLocation = CLLocation(latitude: Double(self.latitude)! , longitude: Double(self.longitude)!)
        self.delegate = vc
        let popupController = STPopupController(rootViewController: vc)
        popupController.style = .bottomSheet
        popupController.present(in: self)
    }
    
    func checkIfTripExists() {
        if RDGlobalFunction.appDelegate.doesRequestExist {
            self.currentAcceptedRequest = RDGlobalFunction.appDelegate.providerExistingTrip
           // self.currentRequest = RDGlobalFunction.appDelegate.providerExistingTrip
            WebSocketManager.sharedInstance.connectClientProviderRequestSocket(with:CLIENTPROVIDERCONNECTION + "ClientId=\(currentAcceptedRequest["ClientId"]!)")
           
            if RDGlobalFunction.appDelegate.providerExistingTrip["StatusCode"] as? Int == Int(Numeric_TripStatus.accepted) {
                
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
                self.openBottomSheet()
            } else {
                let startTrip = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "StartTripViewController") as! StartTripViewController
                
                startTrip.currentRequest = self.currentAcceptedRequest
                
                let tabBar = self.tabBarController as! ProviderTabBarController
                tabBar.navigationController?.pushViewController(startTrip, animated: true)
               // self.dismiss(animated:true, completion: nil)
            }
        }
    }
    
    func cancelRequest() {
        self.requestView.isHidden = true
        self.currentRequest = [:]
        
        if self.clientMarker != nil {
            self.clientMarker.map = nil
            self.providerMarker.map = nil
            self.tripPath.map = nil
        }
    }
    
    func callDistanceAPI(providerDetail : String) {
        if let data = providerDetail.data(using: .utf8) {
            do {
                let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(dict!)
                let param = ["dest_lat":currentRequest["latitude"]!,"dest_long":currentRequest["longitude"]!,"org_lat":"\(self.latitude)","org_long":"\(self.longitude)"]
                
                
                ClientProviderAPIManager.sharedInstance.getDirections(currentVC: self, parameter: param as [String : AnyObject], Alert: true) { (routeArray, success) in
                    if success {
                        DispatchQueue.main.async {
                            self.btnNavigation.isHidden = false
                           
                            let path = GMSPath.init(fromEncodedPath: routeArray)
                           
                            if self.tripPath == nil {
                                self.tripPath = GMSPolyline.init()
                            }
                            self.tripPath = GMSPolyline.init(path: path)
                            self.tripPath.strokeWidth = 3.0
                            self.tripPath.strokeColor = RDDataEngineClass.primaryColor
                            self.tripPath.map = self.mapView
                            
                            let current = CLLocation(latitude: Double(self.latitude)! , longitude: Double(self.longitude)!)
                            let client = CLLocation(latitude: Double(self.currentRequest["latitude"]! as! String)! , longitude: Double(self.currentRequest["longitude"]! as! String)!)
                            
                            if self.providerMarker == nil {
                                self.providerMarker = GMSMarker.init()
                            }
                            self.providerMarker.position = current.coordinate
                            self.providerMarker.icon = RDGlobalFunction.image(#imageLiteral(resourceName: "map-marker-small"), scaledTo:CGSize(width: 35.0, height: 35.0))
                            self.providerMarker.map = self.mapView
                            
                            if self.clientMarker == nil {
                                self.clientMarker = GMSMarker.init()
                            }
                            self.clientMarker.position = client.coordinate
                            self.clientMarker.icon = #imageLiteral(resourceName: "client_marker")
                            self.clientMarker.map = self.mapView
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                            
                            self.openBottomSheet()
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func showRequestUI(requestDetail : String)  {
        if let data = requestDetail.data(using: .utf8) {
            do {
                
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                currentRequest = dict!["ClientData"] as? [String : Any]
                
                if let reqStatus = currentRequest["RequestStatus"],reqStatus as! String == Request_Status.Cancelled {
                    self.requestView.isHidden = true
                } else {
                    if requestView.isHidden {
                        timerView.resetTimer()
                        let clientlocation = CLLocation(latitude: Double(currentRequest["latitude"] as! String)! , longitude: Double(currentRequest["longitude"] as! String)!)
                        
                        let ownlocation = CLLocation(latitude: Double(self.latitude)! , longitude: Double(self.longitude)!)
                        let distance = (clientlocation.distance(from: ownlocation))/1000 //in km
                        
                        lblDistance.text = String(format: "%.3f km",distance)
                        timerView.startTimer(to: 120) { state in
                            switch state {
                            case .finished:
                                print("finished")
                                self.requestView.isHidden = true
                            case .continued(let time):
                                print("continued: \(time!)")
                            case .paused(let time):
                                print("paused: \(time!)")
                            }
                        }
                        requestView.isHidden = false
                    }
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
//        if requestView.isHidden {
//            if let data = requestDetail.data(using: .utf8) {
//                do {
//                    if self.clientMarker != nil {
//                        self.clientMarker.map = nil
//                        self.providerMarker.map = nil
//                        self.tripPath.map = nil
//                    }
//
//                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//                    currentRequest = dict!["ClientData"] as? [String : Any]
//                    let clientlocation = CLLocation(latitude: Double(currentRequest["latitude"] as! String)! , longitude: Double(currentRequest["longitude"] as! String)!)
//
//                    let ownlocation = CLLocation(latitude: Double(self.latitude)! , longitude: Double(self.longitude)!)
//                    let distance = (clientlocation.distance(from: ownlocation))/1000 //in km
//
//                    lblDistance.text = String(format: "%.3f km",distance)
//                    timerView.startTimer(to: 120) { state in
//                        switch state {
//                        case .finished:
//                            print("finished")
//                            self.requestView.isHidden = true
//                        case .continued(let time):
//                            print("continued: \(time!)")
//                        case .paused(let time):
//                            print("paused: \(time!)")
//                        }
//                    }
//
//                    requestView.isHidden = false
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
    
    @IBAction func switchValueChanged(sender : UISwitch) {
        if sender.isOn {
            if self.latitude == "" {
                sender.isOn = false
            } else {
                 lblStatus.text = "You are online now"
                requestSocketToChangeStatusOrLocation()
            }
        } else {
            lblStatus.text = "Please switch to be online or offline"
            requestSocketToChangeStatusOrLocation()
        }
        
    }
    
    
    @IBAction func righttSideBarMenuButttonAction(_ sender: UIBarButtonItem) {
        
        let vc = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderWeatherViewController") as! ProviderWeatherViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnNavigationPressed() {
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(currentRequest["latitude"]!),\(currentRequest["longitude"]!)&directionsmode=walking")! as URL, options: [:], completionHandler: nil)
            
        } else {
            
            UIApplication.shared.open(NSURL(string:
                "http://maps.apple.com/?saddr=&daddr=\(currentRequest["latitude"]!),\(currentRequest["longitude"]!)&directionsmode=walking")! as URL, options: [:], completionHandler: nil)
        }
    }
    
   @objc func timerFired() {
//       {
//       ProviderId: 16,
//       ClientId: 24,
//       Latitude: '23.035411',
//       Longitude: '72.629584',
//       UserType: 'client',
//       RequestType: 'location_updated'
//       }
    
    WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(self.currentAcceptedRequest["ClientId"]!)\",\"ProviderId\":\"\(RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int)\",\"Latitude\":\"\(self.latitude)\",\"Longitude\":\"\(self.longitude)\",\"UserType\":\"provider\",\"RequestType\":\"\(Request_Status.Location_Updated)\"}")
    }
    

    
    //MARK:WebService Get provider Profile Information
    func getProviderProfileUserInformationAPI(providerProfileInfoget : String) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.getProviderProfileDetailInformation(selectedVC: self,providerProfileParameters: [:], getProviderProfileAPI: providerProfileInfoget) { (responseObject, success) in
            
            if success {
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    
                    RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: responseObject as! NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    
                }
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

extension ProviderDadhboardViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderRequestTableCell
        return cell
    }
}

extension ProviderDadhboardViewController : LocationServiceDelegate {
   
    func tracingLocation(currentLocation: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        self.latitude = "\(currentLocation.coordinate.latitude)"
        self.longitude = "\(currentLocation.coordinate.longitude)"
       
        if currentRequest != nil {
            let client = CLLocation(latitude: Double(self.currentRequest["latitude"]! as! String)! , longitude: Double(self.currentRequest["longitude"]! as! String)!)
            
            if client.distance(from: currentLocation) <= 10 && !hasProviderReached {
                //provider is reached
                hasProviderReached = true
            }
        }
        
        if WebSocketManager.sharedInstance.providerConnectionSocket != nil && swchStatus.isOn {
            WebSocketManager.sharedInstance.providerConnectionSocket.write(ping: Data())
        }
        
      //  requestSocketToChangeStatusOrLocation()
      //  ClientProviderLocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}

extension ProviderDadhboardViewController : SocketConnectionDelegate {
    
    func onConnect(socket: WebSocketClient) {
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
            WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(currentRequest["ClientId"]!)\",\"ProviderId\":\"\(RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId) as! Int)\",\"Latitude\":\"\(self.latitude)\",\"Longitude\":\"\(self.longitude)\",\"UserType\":\"provider\",\"RequestType\":\"\(Trip_Status.Accepted)\"}")
        } else {

        }
    }
    
    func onDisconnect(socket: WebSocketClient, error: Error?) {
        if (error as NSError?)!.code == 57 {
            requestSocketToChangeStatusOrLocation()
        }
    }
    
    func onMessage(socket: WebSocketClient, text: String) {
        
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.providerConnectionSocket {
            if let data = text.data(using: .utf8) {
            do {
                let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                let dictClient = dict!["ClientData"] as! [String : AnyObject]
                if let user = dictClient["RequestStatus"], user as! String == Request_Status.Requested {
                    if UIApplication.shared.applicationState.rawValue == 2 || (UIApplication.shared.applicationState.rawValue == 0 && (self.parent as! ProviderTabBarController).selectedIndex != 0) {
                        requestDetail = text
                        RDGlobalFunction.scheduleNotification(notificationType: NotificationType.ProviderRequstReceived, notificationBody: "A request has been received")
                    } else {
                       showRequestUI(requestDetail: text)
                    }
                } else if let user = dictClient["RequestStatus"], user as! String == Request_Status.Cancelled {
                    self.cancelRequest()
                } else if let user = dictClient["RequestStatus"], user as! String == Trip_Status.Accepted {
                    self.requestView.isHidden = true
                }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        } else if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
            if let data = text.data(using: .utf8) {
                do {
                    let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let user = dict!["RequestType"], user as! String == Trip_Status.Accepted {
                        currentAcceptedRequest = dict!
                        callDistanceAPI(providerDetail: text)
                        timer.invalidate()
                        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

