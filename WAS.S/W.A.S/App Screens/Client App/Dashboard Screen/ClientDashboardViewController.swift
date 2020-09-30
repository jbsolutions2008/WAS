//
//  ClientDashboardViewController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 23/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import GoogleMaps
import Starscream


class ClientDashboardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var leftClientSidebar : ClientLeftSidebarViewController?
    
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    var indexPathRS: IndexPath = IndexPath(row: 0, section: 0)
    var isReloadView: Bool = true
    var arrOnlineProviders : [Provider] = []
    var arrMarkers : [GMSMarker] = []
    var clientLocation : CLLocation!
    var clientMarker : GMSMarker!
    var tripPath : GMSPolyline!
    
    var counter = RDDataEngineClass.requestTimerCounter
    var timer = Timer()
    var distanceTimer = Timer()
    var currentRequest : [String : Any] = [:]
    var locationUpdates : String = ""
    var initialETA : Int = 0
    var isFirst : Bool = true
    
    @IBOutlet weak var lblKitItems: UILabel!
    @IBOutlet weak var btnBuyExtra: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var mapBottomToKitView: NSLayoutConstraint!
    @IBOutlet weak var mapBottomToDisabled: NSLayoutConstraint!
    @IBOutlet weak var viewDisable: UIView!
    @IBOutlet weak var btnSelfie: UIButton!
    
    var umbrellaCount = 1
    var raincoatCount = 1
    var shoesCount = 1
    
    
    
    
   // var locationManager: CLLocationManager = CLLocationManager()
   
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Dashboard"
        designInterface()
        
        ClientProviderLocationManager.sharedInstance.delegate = self
        ClientProviderLocationManager.sharedInstance.startUpdatingLocation()
      //  configureLocationManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSelectedProducts(_:)), name: NSNotification.Name(rawValue: RDDataEngineClass.ExtraEquipments), object: nil)
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(self.pingReceived(_:)), name: NSNotification.Name(rawValue: RDDataEngineClass.ReceivedClientPing), object: nil)
        
        DispatchQueue.main.async {
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            
            let userID = (RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int)
            let getClientProfileStr = CLIENTGETPROFILEINFOAPI + "?ClientId=\(userID)"
            
            self.getClientProfileUserInformationAPI(clientProfileInfoget: getClientProfileStr)
        }
    }
    
    func checkIfTripExists() {
        if RDGlobalFunction.appDelegate.doesRequestExist {
            self.currentRequest = RDGlobalFunction.appDelegate.clientExistingTrip
            WebSocketManager.sharedInstance.connectClientProviderRequestSocket(with:CLIENTPROVIDERCONNECTION + "ClientId=\(RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int)")
            if RDGlobalFunction.appDelegate.clientExistingTrip["StatusCode"] as? Int == Int(Numeric_TripStatus.accepted) {
                self.openBottomSheet()
            } else {
                let vc = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientTripViewController") as! ClientTripViewController
                vc.currentRequest = self.currentRequest
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
    
    
//    func configureLocationManager() {
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//
//
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        } else {
//            ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "", alertTitle: "Disabled GPS", alertMessage: "You have disabled location services.Please enable it in the settings.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
//        }
//    }
    
  
    //MARK:Other Methods
    func designInterface() {
        btnBuyExtra.titleLabel?.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-7))
        viewDisable.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.btnRequest.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        setKitItemsWithTextAndFont()
        RDGlobalFunction.setCornerRadius(any: btnRequest, cornerRad: 0, borderWidth: 1, borderColor: .black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if clientMarker != nil {
            clientMarker.map = nil
           // tripPath.map = nil
            
            for (index,onlineProvider) in self.arrOnlineProviders.enumerated() {
                if onlineProvider.ProviderId == currentRequest["ProviderId"] as! Int {
                    self.arrMarkers[index].snippet = ""
                    self.mapView.selectedMarker = self.arrMarkers[index]
                }
            }
        }
    }
    
    func  setKitItemsWithTextAndFont() {
        
        
        let totalItems = umbrellaCount + shoesCount + raincoatCount
        let itemCount = "= \(umbrellaCount) x U + \(shoesCount) x S + \(raincoatCount) x RCot ="
        
        let str = "Kit \(itemCount) \(totalItems)"
        let range = (str as NSString).range(of: "\(totalItems)")
        let range1 = (str as NSString).range(of: "Kit")
        let range2 = (str as NSString).range(of: itemCount)
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-7))!, range: range)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-7))!, range: range1)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: RDDataEngineClass.montserratFontDefault, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-7))!, range: range2)
        lblKitItems.attributedText = attributedString
    }
    
    func image(_ originalImage: UIImage?, scaledTo size: CGSize) -> UIImage? {
        //avoid redundant drawing
        if (originalImage?.size.equalTo(size))! {
            return originalImage
        }
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
        
        //draw
        originalImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        //capture resultant image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return image
        return image
    }
    
    func isProviderInsideReachableArea(providerLocation:CLLocation) -> Bool {
        let distance = clientLocation.distance(from: providerLocation)
        
        //true if provider is inside 1 mile(1 mile = 1609 meters)
        return distance <= 1609.344
    }
    
    func openBottomSheet()  {
        let vc = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "TripProviderDetailViewController") as! TripProviderDetailViewController
        vc.currentRequest = self.currentRequest
        vc.providerETA = self.initialETA
        vc.clientLocation = self.clientLocation
        vc.delegate = self
        
        let popupController = STPopupController(rootViewController: vc)
        popupController.style = .bottomSheet
        popupController.present(in: self)
        self.timerAction()
    }
    
    //MARK: handle notification
    @objc func showSelectedProducts(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let products = dict["products"] as? Array<ProductKit> {
                if (products.filter{$0.Name.contains("Umbrella")}).count > 0 {
                    umbrellaCount += Int((products.filter{$0.Name.contains("Umbrella")})[0].Quantity)!
                }
                
                if (products.filter{$0.Name.contains("Rain Coat")}).count > 0 {
                    raincoatCount += Int(products.filter{$0.Name.contains("Rain Coat")}[0].Quantity)!
                }
                
                if (products.filter{$0.Name.contains("Shoes")}).count > 0 {
                    shoesCount += Int(products.filter{$0.Name.contains("Shoes")}[0].Quantity)!
                }
                setKitItemsWithTextAndFont()
            }
        }
    }
    
    //MARK: Socket Responses
    func pingReceived(text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(dict!)
                let provider = Provider.init(dict: dict! as [String : AnyObject])
                
                if provider.status == ProviderStatus.connected.rawValue {
                    if (arrOnlineProviders.filter{$0.ProviderId == provider.ProviderId}).count == 0 {
                        let location = CLLocation(latitude: Double(provider.Latitude)! , longitude: Double(provider.Longitude)!)
                        
                        if self.isProviderInsideReachableArea(providerLocation: location) {
                            let marker = GMSMarker(position:location.coordinate)
                            marker.icon = self.image(#imageLiteral(resourceName: "map-marker-small"), scaledTo:CGSize(width: 35.0, height: 35.0))
                            marker.map = self.mapView
                            self.arrMarkers.append(marker)
                            self.arrOnlineProviders.append(provider)
                        }
                    }
                } else {
                    if (arrOnlineProviders.filter{$0.ProviderId == provider.ProviderId}).count > 0 {
                        for (index,onlineProvider) in arrOnlineProviders.enumerated() {
                            if onlineProvider.ProviderId == provider.ProviderId {
                                self.arrMarkers[index].map = nil
                                self.arrOnlineProviders.remove(at: index)
                                self.arrMarkers.remove(at: index)
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func callDistanceMatrixAPI(providerDetail : String) {
        if let data = providerDetail.data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                let param = ["org_lat":dict!["Latitude"],"org_long":dict!["Longitude"],"dest_lat":"\(self.clientLocation.coordinate.latitude)","dest_long":"\(self.clientLocation.coordinate.longitude)"]
                
                ClientProviderAPIManager.sharedInstance.callDistanceMatrixAPIForClient(currentVC: self, parameter: param as [String : AnyObject], Alert: true) { (distanceValues, success) in
                    if success {
                        
                        var providerId = 0
                        
                        if dict!["RequestType"] as! String != Request_Status.Location_Updated {
                            
                            self.initialETA = (distanceValues["duration"] as! [String: AnyObject])["value"] as! Int
                            self.openBottomSheet()
                            if self.clientMarker == nil {
                                self.clientMarker = GMSMarker.init()
                            }
                            self.clientMarker.position = self.clientLocation.coordinate
                            self.clientMarker.icon = #imageLiteral(resourceName: "client_marker")
                            self.clientMarker.map = self.mapView
                            
                            self.timerAction()
                            providerId = dict!["ProviderId"] as! Int
                        } else {
                            providerId = Int(dict!["ProviderId"] as! String)!
                        }
                        
                        for (index,onlineProvider) in self.arrOnlineProviders.enumerated() {
                            if onlineProvider.ProviderId == providerId {
//                                self.arrMarkers[index].map = nil
//                                self.arrOnlineProviders.remove(at: index)
//                                self.arrMarkers.remove(at: index)
                                self.arrMarkers[index].snippet = "ETA \((distanceValues["duration"] as! [String: AnyObject])["text"] as? String ?? "0")"
                                self.mapView.selectedMarker = self.arrMarkers[index]
                            }
                        }
                    }
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    
//    func callDistanceAPI(providerDetail : String) {
//        if let data = providerDetail.data(using: .utf8) {
//            do {
//                let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                print(dict!)
//                let param = ["org_lat":dict!["Latitude"],"org_long":dict!["Longitude"],"dest_lat":"\(self.clientLocation.coordinate.latitude)","dest_long":"\(self.clientLocation.coordinate.longitude)"]
//
//          //      let param = ["org_lat":dict!["Latitude"],"org_long":dict!["Longitude"],"dest_lat":"23.039812","dest_long":" 72.565046"]
//
//
//                ClientProviderAPIManager.sharedInstance.getDirections(currentVC: self, parameter: param as [String : AnyObject], Alert: true) { (routeArray, success) in
//                    if success {
//                        DispatchQueue.main.async {
//
//                            let path = GMSPath.init(fromEncodedPath: routeArray)
//                            if self.tripPath == nil {
//                                self.tripPath = GMSPolyline.init()
//                            }
//                            self.tripPath.path = path
//                            self.tripPath.strokeWidth = 3.0
//                            self.tripPath.strokeColor = RDDataEngineClass.primaryColor
//                            self.tripPath.map = self.mapView
//
//                            if self.clientMarker == nil {
//                                self.clientMarker = GMSMarker.init()
//                            }
//                            self.clientMarker.position = self.clientLocation.coordinate
//                            self.clientMarker.icon = #imageLiteral(resourceName: "client_marker")
//                            self.clientMarker.map = self.mapView
//
//                            self.timerAction()
//                            let bounds = GMSCoordinateBounds(path: path!)
//                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
//
//
//
//                        }
//                    }
//                }
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
    //MARK:Other Methods
    @objc func timerAction() {
        self.viewDisable.isHidden = true
        self.mapBottomToKitView.priority = .defaultHigh
        self.mapBottomToDisabled.priority = .defaultLow
        self.view.layoutIfNeeded()
    }
    
    @objc func distanceMeasureAction() {
        callDistanceMatrixAPI(providerDetail: self.locationUpdates)
    }

        
        
//        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=AIzaSyAUR_6Ko7rDP5J5HH1NiapEMUVAdImSQGs")
//
//        //OR if you want to use latitude and longitude for source and destination
//        let url = NSURL(string: "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\("17.521100"),\("78.452854")&destination=\("15.1393932"),\("76.9214428")")
//
//        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
//
//
//                if data != nil {
//                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]
//                    //                        print(dic)
//
//                    let status = dic["status"] as! String
//                    var routesArray:String!
//                    if status == "OK" {
//                        routesArray = (((dic["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as? String
//                    }
//
//                    DispatchQueue.main.async {
//                        let path = GMSPath.init(fromEncodedPath: routesArray!)
//                        let singleLine = GMSPolyline.init(path: path)
//                        singleLine.strokeWidth = 6.0
//                        singleLine.strokeColor = .blue
//                        singleLine.map = self.mapView
//                    }
//
//                }
//    }
    
    
    
    //MARK:UIButton Actions
    @IBAction func leftSideBarMenuButttonAction(_ sender: UIBarButtonItem) {
        
        if self.leftClientSidebar  == nil {

            self.leftClientSidebar = self.storyboard?.instantiateViewController(withIdentifier: "ClientLeftSidebarVC") as? ClientLeftSidebarViewController
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self.leftClientSidebar!)
            
            //added after deprecation
            menuLeftNavigationController.statusBarEndAlpha = 0
            menuLeftNavigationController.menuWidth = RDGlobalFunction.sideBarWidthSizeAccordingToScreen()
            menuLeftNavigationController.presentationStyle = .menuSlideIn
            
            menuLeftNavigationController.presentationStyle.onTopShadowColor = .lightGray
            menuLeftNavigationController.presentationStyle.onTopShadowOffset = CGSize(width: 2.0, height: 2.0)
            menuLeftNavigationController.presentationStyle.onTopShadowRadius = 5.0
            menuLeftNavigationController.presentationStyle.onTopShadowOpacity = 1.0
            //
        
            menuLeftNavigationController.leftSide = true
            menuLeftNavigationController.pushStyle = .preserveAndHideBackButton
            SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        }
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func buyExtraEquipments(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExtraEquipmentViewController") as! ExtraEquipmentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendRequest(_ sender: UIButton) {
        
//        let vc = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientTripViewController") as! ClientTripViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if RDGlobalFunction.getIntFromUserDefault(iSDefaultKey: RDDataEngineClass.userCardSelected) == -1 {
            if RDGlobalFunction.getIntFromUserDefault(iSDefaultKey: RDDataEngineClass.userCardCount) == 0 {
                let addcardVC: AddCardViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
                self.navigationController?.pushViewController(addcardVC, animated: true)
            } else {
                let walletVC: WalletViewController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                self.navigationController?.pushViewController(walletVC, animated: true)
            }

        } else if arrOnlineProviders.count == 0 {
            UtilityClass.showAlertOnNavigationBarWith(message: "No online providers available", title: "Alert", alertType: .failure)
            return
        } else if self.clientLocation == nil {
            UtilityClass.showAlertOnNavigationBarWith(message: "Location unavailable", title: "Alert", alertType: .failure)
        } else {
            postRequest()
        }
        
    }
    
    @IBAction func cancelRequest(_ sender: UIButton) {
        cancelRequestThroughWS()
    }
    
    @IBAction func openFrontCamera(_ sender: UIButton) {
        
    }
    
    //MARK:WebService
    func getClientProfileUserInformationAPI(clientProfileInfoget : String) {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.getClientProfileDetailInformation(selectedVC: self,clientProfileParameters: [:], getClientProfileAPI: clientProfileInfoget) { (responseObject, success) in
            
            if success{
                
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
    
    func getOnlineProviderList() {
        
        UtilityClass.showActivityIndicator()
        
        ClientProviderAPIManager.sharedInstance.getOnlineProviderList(selectedVC: self, getOnlineProviderListAPI: ONLINEPROVIDERLIST) { (responseObject, success) in
            if success {
                let arr = responseObject["OnlineProviderList"] as! NSArray
               
                for item in arr {
                    let provider = Provider.init(dict: item as!  [String : AnyObject])
                    
                    let location = CLLocation(latitude: Double(provider.Latitude)! , longitude: Double(provider.Longitude)!)
                    
                    if self.isProviderInsideReachableArea(providerLocation: location) {
                        let marker = GMSMarker(position:location.coordinate)
                        marker.icon = self.image(#imageLiteral(resourceName: "map-marker-small"), scaledTo:CGSize(width: 35.0, height: 35.0))
                        
                        marker.map = self.mapView
                        self.arrMarkers.append(marker)
                        self.arrOnlineProviders.append(provider)
                    }
                }
                
//                let getClientProfileStr = CLIENTGETPROFILEINFOAPI + "?ClientId=\(userID)"
//
//                self.getClientProfileUserInformationAPI(clientProfileInfoget: getClientProfileStr)
                WebSocketManager.sharedInstance.connectToGettingStatusUpdatesFromClient(with: GETONLINEPROVIDERSTATUS)
                WebSocketManager.sharedInstance.delegate = self
                self.checkIfTripExists()
            }
            UtilityClass.removeActivityIndicator()
        }
    }
    
    
    func postRequest() {
        
        if clientMarker != nil {
            clientMarker.map = nil
           // tripPath.map = nil
            
            for (index,onlineProvider) in self.arrOnlineProviders.enumerated() {
                if onlineProvider.ProviderId == currentRequest["ProviderId"] as! Int {
                    self.arrMarkers[index].snippet = ""
                    self.mapView.selectedMarker = self.arrMarkers[index]
                }
            }
        }
        
      
        UtilityClass.showActivityIndicator()
     //   {"ClientData":{"ClientId":24,"latitude":23.036564,"longitude":72.5602278},"ProviderIds":[16]}
        let userID = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int
        
        let dict1 = ["ClientId" : userID, "latitude" : "\(self.clientLocation.coordinate.latitude)", "longitude" : "\(self.clientLocation.coordinate.longitude)"] as [String : Any]
        
      
        let dict = ["ClientStripeCustomerId":RDGlobalFunction.getIntFromUserDefault(iSDefaultKey: RDDataEngineClass.userStripeId),"ClientStripeCustomerSourceId":RDGlobalFunction.getIntFromUserDefault(iSDefaultKey: RDDataEngineClass.userCardSelected),"Umbrella": self.umbrellaCount-1,"Coat":self.raincoatCount-1,"Shoes":self.shoesCount-1,"EquipmentCharge":RDGlobalFunction.appDelegate.extraCharge,"ClientData":dict1,"ProviderIds":self.arrOnlineProviders.map{$0.ProviderId},"RequestStatus":Request_Status.Requested] as [String : Any]
        print(dict)

        ClientProviderAPIManager.sharedInstance.postRequest(selectedVC: self, requestParameters: dict, postRequestAPI: CLIENTREQUESTFORSERVICE) {(responseObject, success) in
        
            if success {
                WebSocketManager.sharedInstance.connectClientProviderRequestSocket(with:CLIENTPROVIDERCONNECTION + "ClientId=\(userID)")
                self.viewDisable.isHidden = false
                self.mapBottomToKitView.priority = .defaultLow
                self.mapBottomToDisabled.priority = .defaultHigh
                self.view.layoutIfNeeded()
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.counter), target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
            }
            UtilityClass.removeActivityIndicator()
        }
    }
    
    func cancelRequestThroughWS() {
        
        if clientMarker != nil {
            clientMarker.map = nil
            //tripPath.map = nil
        }
        
        RDGlobalFunction.appDelegate.extraCharge = 0.0
        UtilityClass.showActivityIndicator()
        //   {"ClientData":{"ClientId":24,"latitude":23.036564,"longitude":72.5602278},"ProviderIds":[16]}
        let userID = RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int
        
        let dict = ["ClientId" : userID, "latitude" : "\(self.clientLocation.coordinate.latitude)", "longitude" : "\(self.clientLocation.coordinate.longitude)"] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.postRequest(selectedVC: self, requestParameters: ["ClientData" : dict, "ProviderIds" : self.arrOnlineProviders.map{$0.ProviderId},"RequestStatus":Request_Status.Cancelled,"Umbrella":0,"Coat":0,"Shoes":0,"EquipmentCharge":0], postRequestAPI: CLIENTREQUESTFORSERVICE) { (responseObject, success) in
            if success {
                WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int)\",\"Latitude\":\"\(self.clientLocation.coordinate.latitude)\",\"Longitude\":\"\(self.clientLocation.coordinate.longitude)\",\"isClientRequest\":\"\(true)\",\"RequestStatus\":\"\(Request_Status.Cancelled)\"}")
              //  WebSocketManager.sharedInstance.connectClientProviderRequestSocket(with:CLIENTPROVIDERCONNECTION + "ClientId=\(userID)")
                self.timerAction()
            }
            UtilityClass.removeActivityIndicator()
        }
    }
}

extension ClientDashboardViewController : LocationServiceDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        clientLocation = currentLocation
     
        if isFirst {
            
            getOnlineProviderList()
            isFirst = false
            
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom:17.0)
                   self.mapView?.animate(to: camera)
        }
       
        if WebSocketManager.sharedInstance.clientCommonDataSocket != nil {
            WebSocketManager.sharedInstance.clientCommonDataSocket.write(ping: Data())
        }
    }
    
   
    func tracingLocationDidFailWithError(error: Error) {
         print("Error \(error)")
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        let camera = GMSCameraPosition.camera(withLatitude: (userLocation.coordinate.latitude), longitude: (userLocation.coordinate.longitude), zoom: 17.0)
//
//        self.mapView?.animate(to: camera)
//
//         manager.stopUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse:
//            locationManager.startUpdatingLocation()
//        case .denied,.restricted:
//            locationManager.stopUpdatingLocation()
//            ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "", alertTitle: "Access Denied", alertMessage: "You have denied access for using location services.Please enable it in the settings.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
//        case .notDetermined :
//            locationManager.requestWhenInUseAuthorization()
//        default:
//            print("default")
//         }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error \(error)")
//    }
    
}

extension ClientDashboardViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker tapped")
        return true
    }
}

extension ClientDashboardViewController : SocketConnectionDelegate {
    
    //"isClientRequest":true,"RequestStatus":"cancelled"
    
    func onConnect(socket: WebSocketClient) {
//        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
//
//            if !RDGlobalFunction.appDelegate.doesRequestExist {
//                WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId) as! Int)\",\"Latitude\":\"\(self.clientLocation.coordinate.latitude)\",\"Longitude\":\"\(self.clientLocation.coordinate.longitude)\",\"isClientRequest\":\"\(true)\",\"RequestStatus\":\"\(Request_Status.Requested)\"}")
//            }
//        }
    }
    
    func onDisconnect(socket: WebSocketClient, error: Error?) {
        if (error as? WSError)?.code == 57 {
          //  requestSocketToChangeStatusOrLocation()
        }
    }
    
    func onMessage(socket: WebSocketClient, text: String) {
        //show UI
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientCommonDataSocket {
            pingReceived(text: text)
        } else if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
            
            if let data = text.data(using: .utf8) {
                do {
                    let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let user = dict!["RequestType"], user as! String == Trip_Status.Accepted {
                        
                        currentRequest = dict!
                        callDistanceMatrixAPI(providerDetail: text)
                        self.distanceTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.distanceMeasureAction), userInfo: nil, repeats: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ClientDashboardViewController : ProviderDetailDelegate {
    func onReceivingLocationUpdate(locationUpdates: String) {
        self.locationUpdates = locationUpdates
    }
}

