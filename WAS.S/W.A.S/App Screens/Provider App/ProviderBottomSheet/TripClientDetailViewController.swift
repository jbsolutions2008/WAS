//
//  TripClientDetailViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 26/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import AVFoundation
import SkyFloatingLabelTextField
import CoreLocation
import Starscream



class TripClientDetailViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var imgClientProfile : UIImageView!
    
    @IBOutlet weak var lblName : UILabel!
   // @IBOutlet weak var lblPhone : UILabel!
    
    @IBOutlet weak var txtOTP : UITextField!
    @IBOutlet weak var lblCancelCharges : UILabel!
    
    var currentRequest : [String : Any] = [:]
    
    var timer = Timer()
    var acceptedDate : Date!
    var reachedDate : Date!
    var isCancellingFirstTime = true
    var clientLocation : CLLocation = CLLocation.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if RDGlobalFunction.appDelegate.doesRequestExist {
            let tripStartTime = (currentRequest["TripStartTime"] as! Int)/1000
            self.acceptedDate = Date(timeIntervalSinceNow: TimeInterval(-tripStartTime))
        } else {
            acceptedDate = Date()
        }
        self.title = "Client Details"
        lblName.text = currentRequest["ClientName"] as? String ?? ""
        WebSocketManager.sharedInstance.delegate = self
    //    lblPhone.text = currentRequest["ClientMobileNumber"] as? String ?? ""
        txtOTP.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        self.imgClientProfile.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + "\(currentRequest["ClientProfileImg"] as? String ?? "")"), placeholderImage: #imageLiteral(resourceName: "client-view-icon"))
        ClientProviderLocationManager.sharedInstance.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        self.viewContainer.layoutIfNeeded()
        viewContainer.sizeToFit()
        self.contentSizeInPopup = viewContainer.frame.size
        RDGlobalFunction.setCornerRadius(any: imgClientProfile, cornerRad: imgClientProfile.frame.height/2, borderWidth: 0, borderColor: .clear)
    }
    
    //MARK:UIButton Actions
    @IBAction func openClientSelfie(_ sender: UIButton) {
        getClientSelfie()
    }
    
    @IBAction func callClient(_ sender: UIButton) {
        RDGlobalFunction.makeCall(phoneNumber: currentRequest["ClientMobileNumber"] as? String ?? "")
    }
    
    @IBAction func cancelRequest(_ sender: UIButton) {
        let timeElapsed = Date().timeIntervalSince1970 - self.acceptedDate.timeIntervalSince1970
        
        if Int(timeElapsed.stringFromTimeInterval().1)! >= 1 {
            if Int((Date().timeIntervalSince1970 - self.reachedDate.timeIntervalSince1970).stringFromTimeInterval().1)! >= 3 {
              
                let alert : UIAlertController = UIAlertController.init(title: "", message: "Please call at least once before cancelling the request", preferredStyle: .alert)
               
               
               let yesButton : UIAlertAction = UIAlertAction.init(title: "Call", style: .default) { (action) in
                   RDGlobalFunction.makeCall(phoneNumber: self.currentRequest["ClientMobileNumber"] as? String ?? "")
               }
               alert.addAction(yesButton)
               
               let NoButton : UIAlertAction = UIAlertAction.init(title:"Cancel", style: .default) { (action) in
                   let vc = RDGlobalFunction.universalStory.instantiateViewController(withIdentifier: "RequestCancelAlertViewController") as! RequestCancelAlertViewController
                   vc.currentRequest = self.currentRequest
                   vc.currentLocation = self.clientLocation
                   vc.modalPresentationStyle = .overCurrentContext
                   self.present(vc, animated: false, completion: nil)
               }
               alert.addAction(NoButton)
               
               self.present(alert, animated: true, completion: nil)
            } else {
                //alert with option of only call
            }
        } else {
            let alert : UIAlertController = UIAlertController.init(title: "", message: "Are you sure you want to cancel this request?", preferredStyle: .alert)
            
            
            let yesButton : UIAlertAction = UIAlertAction.init(title: "YES", style: .default) { (action) in
                self.CancelRequest(with: CancellationReasonCode.NoReason)
            }
            alert.addAction(yesButton)
            
            
            let NoButton : UIAlertAction = UIAlertAction.init(title:"NO", style: .default) { (action) in
                
            }
            alert.addAction(NoButton)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:WebService
    func getClientSelfie() {
        
        let getClientSelfieStr = PROVIDERTRIPSELFIEVIEW + "TripId=\(currentRequest["TripId"]!)&ClientId=\(currentRequest["ClientId"]!)"

        ClientProviderAPIManager.sharedInstance.getClientSelfieDuringTrip(selectedVC: self, providerParameters: [:], viewClientSelfie: getClientSelfieStr) { (responseObject, success) in
            if success {

                if (responseObject as! [String : Any])["Success"] as! Bool {
        
                 //   UtilityClass.showAlertOnNavigationBarWith(message: "Under Development", title: "", alertType: .failure)
                    let vc = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ClientSelfiewViewController") as! ClientSelfiewViewController
                    vc.imgPath = (responseObject["SelfiImgBase64"] as? String)!
                    vc.modalPresentationStyle = .overCurrentContext
                   self.present(vc, animated: false, completion: nil)
                } else {
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject["ErrorSuccessMsg"] as? String, title: "Error!", alertType: .failure)
                }
            }
        }
    }
    
    //MARK:Other Functions
    @objc func timerAction() {
        let timeElapsed = Date().timeIntervalSince1970 - self.acceptedDate.timeIntervalSince1970
        
        if Int(timeElapsed.stringFromTimeInterval().1) == 1 {
            timer.invalidate()
            lblCancelCharges.text = "$5 will be charged for cancellation."
        } else {
            lblCancelCharges.text = "Free cancellation seconds \(60-Int(timeElapsed.stringFromTimeInterval().2)!)"
        }
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // self.imgView.isHidden = true
    }
    
    func CancelRequest(with Reason:String) {
        
        WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(currentRequest["ClientId"]!)\",\"Latitude\":\"\(self.clientLocation.coordinate.latitude)\",\"Longitude\":\"\(self.clientLocation.coordinate.longitude)\",\"TripId\":\"\(currentRequest["TripId"]!)\",\"UserType\":\"provider\",\"ProviderId\":\"\(currentRequest["ProviderId"]!)\",\"CancellationReasonCode\":\"\(Reason)\",\"RequestType\":\"\(Trip_Status.cancelled)\"}")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldEditingChanged() {
        if  txtOTP.text?.count == 4 {
            if txtOTP.text == currentRequest["VerificationCode"] as? String {
                //redirect to other screen
                WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"TripId\":\"\(currentRequest["TripId"]!)\",\"RequestType\":\"\(Request_Status.Reached)\"}")
                
                let startTrip = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "StartTripViewController") as! StartTripViewController
                
                startTrip.currentRequest = self.currentRequest
                RDGlobalFunction.appDelegate.doesRequestExist = false
                
                let tabBar = self.presentingViewController as! ProviderTabBarController
                tabBar.navigationController?.pushViewController(startTrip, animated: true)
                self.dismiss(animated:true, completion: nil)
                
            } else {
                UtilityClass.showAlertOnNavigationBarWith(message: "Invalid OTP", title: "Error", alertType: .failure)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        // Do not add a line break
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.count + string.count - range.length
        
        return newLength <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

extension TripClientDetailViewController : LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
       clientLocation = currentLocation
      //  requestSocketToChangeStatusOrLocation()
      //  ClientProviderLocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}

extension TripClientDetailViewController : SocketConnectionDelegate {
    func onConnect(socket: WebSocketClient) {
        
    }
    
    func onDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func onMessage(socket: WebSocketClient, text: String) {
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
                   
                   if let data = text.data(using: .utf8) {
                       do {
                           let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                           
                            if let user = dict!["RequestType"],user as! String == Trip_Status.cancelled {
                               self.dismiss(animated: true, completion: nil)
                           }
                       } catch {
                           print(error.localizedDescription)
                       }
                   }
               }
    }
}

extension TripClientDetailViewController : ProviderReachDelegate {
    func notifyWhenProviderHasReached() {
        reachedDate = Date()
    }
}
