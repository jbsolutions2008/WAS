//
//  TripProviderDetailViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 26/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import AVFoundation
import Starscream
import CoreLocation

protocol ProviderDetailDelegate {
    func onReceivingLocationUpdate(locationUpdates:String)
}

class TripProviderDetailViewController: UIViewController {

    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var btnSelfie : UIButton!
    @IBOutlet weak var lblOTP : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblCancelCharges : UILabel!
    @IBOutlet weak var imgProviderProfile : UIImageView!
    var timer = Timer()
    var acceptedDate : Date!
    var clientLocation : CLLocation = CLLocation.init()
    var providerETA = 0
 //   @IBOutlet weak var lblPhone : UILabel!
    
    var currentRequest : [String : Any] = [:]
    var delegate: ProviderDetailDelegate?
    var selectediImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if RDGlobalFunction.appDelegate.doesRequestExist {
            let tripStartTime = (currentRequest["TripStartTime"] as! Int)/1000
            self.acceptedDate = Date(timeIntervalSinceNow: TimeInterval(-tripStartTime))
        } else {
            acceptedDate = Date()
        }
        
        self.title = "Provider Details"
        lblOTP.text = "OTP : \(currentRequest["VerificationCode"] as? String ?? "")"
        lblName.text = currentRequest["ProviderName"] as? String ?? ""
      //  lblPhone.text = currentRequest["ProviderMobileNumber"] as? String ?? ""
        WebSocketManager.sharedInstance.delegate = self
        ClientProviderLocationManager.sharedInstance.delegate = self
        self.imgProviderProfile.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + "\(currentRequest["ProviderProfileImg"] as? String ?? "")"), placeholderImage: #imageLiteral(resourceName: "client-view-icon"))
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        self.viewContainer.layoutIfNeeded()
        viewContainer.sizeToFit()
        self.contentSizeInPopup = viewContainer.frame.size
        RDGlobalFunction.setCornerRadius(any: imgProviderProfile, cornerRad: imgProviderProfile.frame.height/2, borderWidth: 0, borderColor: .clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:UIButton Actions
    @IBAction func openFrontCamera(_ sender: UIButton) {
        authorisationStatus()
    }
    
    @IBAction func callProvider(_ sender: UIButton) {
        RDGlobalFunction.makeCall(phoneNumber: currentRequest["ProviderMobileNumber"] as? String ?? "")
    }
    
    @IBAction func cancelRequest(_ sender: UIButton) {
        let timeElapsed = Date().timeIntervalSince1970 - self.acceptedDate.timeIntervalSince1970
        
        if Int(timeElapsed.stringFromTimeInterval().1)! >= 1 {
           // if Int(Date().timeIntervalSince1970 - self.acceptedDate.timeIntervalSince1970) >= self.providerETA {
                let alert : UIAlertController = UIAlertController.init(title: "", message: "Please call at least once before cancelling the request", preferredStyle: .alert)
                
                
                let yesButton : UIAlertAction = UIAlertAction.init(title: "Call", style: .default) { (action) in
                    RDGlobalFunction.makeCall(phoneNumber: self.currentRequest["ProviderMobileNumber"] as? String ?? "")
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
         //   } else {
                //alert with option of only call
           // }
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
    
    func authorisationStatus() {//, vc: UIViewController
        
            let status = AVCaptureDevice.authorizationStatus(for: .video)
        
            switch status{
                
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
                
            case .denied, .restricted:
                
                ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "Camera Access Denied", alertTitle: "Camera Access Denied", alertMessage: "Camera Access Denied for the Weather Accomodation application. Please enable access from your phone settings.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
                
                return
                
            default:
                break
            }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpeg(.medium)
        return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let myPickerController = UIImagePickerController()
            myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            myPickerController.cameraDevice = .front
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    func CancelRequest(with Reason:String) {
        
        WebSocketManager.sharedInstance.clientproviderRequestSocket.write(string: "{\"ClientId\":\"\(currentRequest["ClientId"]!)\",\"Latitude\":\"\(self.clientLocation.coordinate.latitude)\",\"Longitude\":\"\(self.clientLocation.coordinate.longitude)\",\"TripId\":\"\(currentRequest["TripId"]!)\",\"UserType\":\"client\",\"ProviderId\":\"\(currentRequest["ProviderId"]!)\",\"CancellationReasonCode\":\"\(Reason)\",\"RequestType\":\"\(Trip_Status.cancelled)\"}")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: WebService
    func uploadSelfie(selectedImage : UIImage) {
        
        UtilityClass.showActivityIndicator()
        let clientParam  = ["SelfieImgBase64":convertImageToBase64(image: selectedImage),"TripID":"\(currentRequest["TripId"]!)","ClientId" :currentRequest["ClientId"]!] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.postClientTripSelfie(selectedVC: self, clientParameters:clientParam , postClientTripSelfie: CLIENTTRIPSELFIEUPLOAD) { (responseObject, success) in
            if success {
                UtilityClass.removeActivityIndicator()
            }
        }
    }
}

extension TripProviderDetailViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //GET IMAGE from PHOTO ALBUM
        if let selectedImage = info[.editedImage] as? UIImage {
            
            if let selectImageData = selectedImage.jpeg(.medium) {
                
                let imgSizeInMB : Float = (Float(selectImageData.count/1024/1024))
                
                if imgSizeInMB >= 1.45 {//1.5 Size Limit
                    
                    ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "File Size Limit", alertTitle: "1.5 MB File size limit", alertMessage: "The attached file size limit is 1.5 MB.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
                }else{
                  //  btnSelfie.setBackgroundImage(UIImage.init(data: selectImageData), for: .normal)
                    
                    uploadSelfie(selectedImage:UIImage.init(data: selectImageData)!)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension TripProviderDetailViewController : SocketConnectionDelegate {
    
    //"isClientRequest":true,"RequestStatus":"cancelled"
    
    func onConnect(socket: WebSocketClient) {
        
    }
    
    func onDisconnect(socket: WebSocketClient, error: Error?) {
        if (error as? WSError)?.code == 57 {
            //  requestSocketToChangeStatusOrLocation()
        }
    }
    
    func onMessage(socket: WebSocketClient, text: String) {
        
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
            
            if let data = text.data(using: .utf8) {
                do {
                    let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let user = dict!["RequestType"], user as! String == Request_Status.Reached {
                        let vc = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientTripViewController") as! ClientTripViewController
                        vc.currentRequest = self.currentRequest
                        self.dismiss(animated: true, completion: nil)
                        (self.presentingViewController as! UINavigationController).pushViewController(vc, animated: true)
                    } else if let user = dict!["RequestType"],user as! String == Trip_Status.cancelled {
                        self.dismiss(animated: true, completion: nil)
                    } else if let user = dict!["RequestType"],user as! String == Request_Status.Location_Updated {
                        delegate?.onReceivingLocationUpdate(locationUpdates: text)
                    } else if let user = dict!["RequestType"],user as! String == Request_Status.Started && RDGlobalFunction.appDelegate.doesRequestExist {
                        let vc = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientTripViewController") as! ClientTripViewController
                        RDGlobalFunction.appDelegate.doesRequestExist = false
                        vc.currentRequest = self.currentRequest
                        self.dismiss(animated: true, completion: nil)
                        (self.presentingViewController as! UINavigationController).pushViewController(vc, animated: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension TripProviderDetailViewController : LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        clientLocation = currentLocation
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}
