//
//  StartTripViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 27/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import CoreLocation
import Cosmos

class StartTripViewController: UIViewController {

    @IBOutlet weak var btnAction : UIButton!
    @IBOutlet weak var lblFare : UILabel!
    @IBOutlet weak var btnSubmitRating : UIButton!
    
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var scrlView : UIScrollView!
    @IBOutlet weak var vwRatings : UIView!
    
    @IBOutlet weak var lblHours : UILabel!
    @IBOutlet weak var lblMin : UILabel!
    @IBOutlet weak var lblSec : UILabel!
    
    @IBOutlet weak var starRating : CosmosView!
    @IBOutlet weak var txtReview : UITextField!
    
    var isTripStarted = false
    var currLatitude = ""
    var currLongitude = ""
    var currentRequest : [String : Any] = [:]
    
    var timer = Timer()
    var tripStartDate : Date!
    
  @IBOutlet weak  var bottomToActionButton : NSLayoutConstraint!
  @IBOutlet weak  var bottomToRatingView : NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.btnAction.isEnabled = false
        if RDGlobalFunction.appDelegate.doesRequestExist {
            // TripStartTime
            let tripStartTime = (currentRequest["TripStartTime"] as! Int)/1000
            self.tripStartDate = Date(timeIntervalSinceNow: TimeInterval(-tripStartTime))
            changeUIWhenTripStarts()
            
        }
        ClientProviderLocationManager.sharedInstance.delegate = self
        ClientProviderLocationManager.sharedInstance.startUpdatingLocation()
        designInterFace()
    }
    
   
    func designInterFace() {
        
        self.btnSubmitRating.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        RDGlobalFunction.setCornerRadius(any: self.btnSubmitRating, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        self.btnAction.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        RDGlobalFunction.setCornerRadius(any: self.btnAction, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
        bottomToActionButton.priority = .defaultHigh
        bottomToRatingView.priority = .defaultLow
        
    }
    
    //MARK:UIButton Actions
    @IBAction func btnActionPressed() {
        UtilityClass.showActivityIndicator()
        
        if !isTripStarted {
            
//            let dictParam = ["ClientId" : currentRequest["ClientId"]!, "TripId" : currentRequest["TripId"]!, "ProviderId" : currentRequest["ProviderId"]!,"StartTripLatitude" : self.currLatitude,"StartTripLongitude" : self.currLongitude,"StatusCode":Numeric_TripStatus.started, "EquipmentCharge":0] as [String : Any]
            
            let dictParam = ["ClientId" : currentRequest["ClientId"]!, "TripId" : currentRequest["TripId"]!, "ProviderId" : currentRequest["ProviderId"]!,"StartTripLatitude" : "23.038458","StartTripLongitude" : "72.563000","StatusCode":Numeric_TripStatus.started, "EquipmentCharge":0] as [String : Any]
            
            ClientProviderAPIManager.sharedInstance.postStartEndTrip(selectedVC: self, tripParameters:dictParam , postStartEndTripUrl:PROVIDERTRIPSTARTEND ) { (responseOject, success) in
                 UtilityClass.removeActivityIndicator()
                if success {
                    self.tripStartDate = Date()
                    self.changeUIWhenTripStarts()
                }
            }
        } else {
            
//            let dictParam = ["ClientId" : currentRequest["ClientId"]!, "TripId" : currentRequest["TripId"]!, "ProviderId" : currentRequest["ProviderId"]!,"EndTripLatitude" : self.currLatitude,"EndTripLongitude" : self.currLongitude,"StatusCode":Numeric_TripStatus.ended] as [String : Any]
            
            let dictParam = ["ClientId" : currentRequest["ClientId"]!, "TripId" : currentRequest["TripId"]!, "ProviderId" : currentRequest["ProviderId"]!,"EndTripLatitude" : "23.038458","EndTripLongitude" : "72.563000","StatusCode":Numeric_TripStatus.ended] as [String : Any]
            
            ClientProviderAPIManager.sharedInstance.postStartEndTrip(selectedVC: self, tripParameters:dictParam , postStartEndTripUrl:PROVIDERTRIPSTARTEND ) { (responseOject, success) in
               
                UtilityClass.removeActivityIndicator()
                if success {
                    
                    self.btnAction.isHidden = true
                    self.lblFare.isHidden = false
                    self.lblFare.text = "Your Trip fare is only $\(responseOject["TripChargeAmount"]! ?? "0")."
                    self.timer.invalidate()
                    
                    self.bottomToRatingView.priority = .defaultHigh
                    self.bottomToActionButton.priority = .defaultLow
                    self.vwRatings.isHidden = false
                    
                }
            }
        }
    }
    
    @IBAction func submitReviewPressed() {
//        if txtReview.text == "" {
//            UtilityClass.showAlertOnNavigationBarWith(message: "Please enter your review", title: "Error", alertType: .failure)
//        } else {
            self.submitReview()
       // }
    }
    
    //MARK:WebService
    func submitReview() {
        UtilityClass.showActivityIndicator()
        
        let param = ["ClientId" : currentRequest["ClientId"]!,"ProviderId" : currentRequest["ProviderId"]!,"TripId": currentRequest["TripId"]!,"ReviewComment":txtReview.text!,"Rattings":"\(starRating.rating)","UserTypeCode":Numeric_Usercode.provider]
        
        ClientProviderAPIManager.sharedInstance.postTripReview(selectedVC: self, reviewParameters: param, postTripReview:SUBMITREVIEW ) { (responseObject, success) in
            
            UtilityClass.removeActivityIndicator()
            self.navigationController?.popViewController(animated: true)
            if success {
                UtilityClass.showAlertOnNavigationBarWith(message: "Review Submitted successfully", title: "Success", alertType: .success)
            }
        }
    }
    
    //MARK:Other Methods
    @objc func timerAction() {
       let timeElapsed = Date().timeIntervalSince1970 - self.tripStartDate.timeIntervalSince1970
        
        lblMin.text = timeElapsed.stringFromTimeInterval().1
        lblHours.text = timeElapsed.stringFromTimeInterval().0
        lblSec.text = timeElapsed.stringFromTimeInterval().2
    }
    
    func changeUIWhenTripStarts() {
        self.isTripStarted = true
        self.btnAction.setTitle("End Trip", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
}


extension StartTripViewController : LocationServiceDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        
        currLatitude = "\(currentLocation.coordinate.latitude)"
        currLongitude = "\(currentLocation.coordinate.longitude)"
        self.btnAction.isEnabled = true
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        print("Error \(error)")
    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> (String,String,String) {
        
        let time = NSInteger(self)
        
     //   let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return (String(format:"%0.2d",hours),String(format:"%0.2d",minutes),String(format:"%0.2d",seconds))
     //   return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
