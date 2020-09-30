//
//  UtilityClass.swift
//  InHup
//
//  Created by Renish Dadhaniya on 10/10/18.
//  Copyright © 2018 GlobeSyncTechnologies - Renish Dadhaniya. All rights reserved.
//


import UIKit
import Reachability
import NVActivityIndicatorView
import JDropDownAlert
import AssetsLibrary
import Photos
import MobileCoreServices


enum JDropAlertType {
    case success
    case failure
}

enum ProviderStatus : String {
    case connected = "connected"
    case disconnected = "disconnected"
}


var imagePickerCompletionHandler : ((_ chosenImage : UIImage,_ url: URL) -> Void)?
var pick = UIImagePickerController()


@objc class UtilityClass: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    class var sharedInstance: UtilityClass {
        struct Static {
            static let instance = UtilityClass()
        }
        return Static.instance
    }

    
    static var alert: JDropDownAlert? = nil
    class func showAlertOnNavigationBarWith(message: String?, title: String?, alertType: JDropAlertType){
        UtilityClass.removeActivityIndicator()
        if alert == nil{
            alert = JDropDownAlert(position: .top)
            alert?.titleFont = UIFont.boldSystemFont(ofSize: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-2))
            alert?.messageFont = UIFont.systemFont(ofSize: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        }
        
        alert?.alertWith(title!, message: message, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: alertType == .success ? RDDataEngineClass.appGreenColor : UIColor.red)
        alert?.didTapBlock = {
            print("Top View Did Tapped")
        }
        
    }
    
    
    // MARK :  Check InternetConectivity
    class func isInternetConnectedWith(isAlert: Bool) -> Bool {
        let reachability: Reachability = Reachability.init(hostname: API_PREFIX)!
        //let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        
        if reachability.connection == .none && isAlert{//!reachability.isReachable && isAlert
//            UtilityClass.showAlertOnNavigationBarWith(message: NSLocalizedString("Please check your Internet Connection.", tableName: nil, bundle: GlobalFunctions.getLanguageBundlePath()!, comment: ""), title: "", alertType: .failure)
            UtilityClass.showAlertOnNavigationBarWith(message: "Please check your Internet Connection.", title: "", alertType: .failure)
            UtilityClass.removeActivityIndicator()
        }

        return reachability.connection != .none
    }
    
    
    // MARK : Activity Indicatior
    @objc class func removeActivityIndicator() -> Void{
        activityView?.isHidden = true
        activityView?.removeFromSuperview()
        activityIndicatorView?.stopAnimating()
    }
    
    
    static var activityView: UIView? = nil
    static var activityIndicatorView: NVActivityIndicatorView? = nil ;
    
    class func showActivityIndicator() {
        
        if activityView == nil {
            activityView = UIView(frame: RDGlobalFunction.MAIN_SCREEN.bounds)
            activityView?.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.28)
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballRotateChase, color: RDDataEngineClass.secondaryShadeColor, padding: 50)
            activityIndicatorView?.center = (RDGlobalFunction.appDelegate.window?.center)!
            activityView?.addSubview(activityIndicatorView!)
        }
        RDGlobalFunction.appDelegate.window?.addSubview(activityView!)
        activityIndicatorView?.startAnimating()
        activityView?.isHidden = false
    }
    
    
    class func showAlertWithMessage(message: String?, title: String?, confirmButtonTitle: String?, notConfirmButtonTitle: String?, alertType : UIAlertController.Style, isShowCancel: Bool, callback : @escaping (_ isConfirmed: Bool) -> (Void)) -> (Void){
      
        let alert : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: alertType)
        
        if isShowCancel {
            let cancelButton : UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            }
            alert.addAction(cancelButton)
        }
        
        if confirmButtonTitle?.isEmpty == false {
            let yesButton : UIAlertAction = UIAlertAction.init(title: confirmButtonTitle, style: .default) { (action) in
                callback(true)
            }
            alert.addAction(yesButton)
        }
        
        if notConfirmButtonTitle?.isEmpty == false {
            let thirdButton : UIAlertAction = UIAlertAction.init(title: notConfirmButtonTitle, style: .default) { (action) in
                callback(false)
            }
            alert.addAction(thirdButton)
        }
        
        self.presentViewCoontroller(vc: alert)
    }
    
    
    class func presentViewCoontroller(vc: UIViewController) -> Void {
        DispatchQueue.main.async {
            let viewController: UIViewController = (RDGlobalFunction.appDelegate.window?.rootViewController)!
            viewController.popoverPresentationController?.sourceView = RDGlobalFunction.appDelegate.window?.rootViewController?.view
            
            if (viewController.presentedViewController != nil)  {
                viewController.presentedViewController?.present(vc, animated: true, completion: nil)
            } else {
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    func caputurePhoto() -> Void {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            UtilityClass.showAlertOnNavigationBarWith(message: "Device has no camera", title: "", alertType: .failure)
            return
        }
        AVCaptureDevice.requestAccess(for:AVMediaType.video) { (granted) in
            if granted {
                pick.sourceType = .camera
                pick.delegate = self
                UtilityClass.presentViewCoontroller(vc: pick)
            } else {
                UtilityClass.showAlertOnNavigationBarWith(message: "Please go to Settings and enable the camera for this app to use this feature.", title: "", alertType: .failure)
            }
        }
    }
    
    
    func selectPhoto(compeltionHandler: @escaping (_ pickedImage : UIImage,_ url: URL) -> (Void)) -> Void {
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                DispatchQueue.main.async{
                    imagePickerCompletionHandler = compeltionHandler
                    pick.sourceType = .photoLibrary
                    pick.allowsEditing = true
                    pick.delegate = self
                    pick.mediaTypes = [kUTTypeImage as String]
                    UtilityClass.presentViewCoontroller(vc: pick)
                }
            }
        })
    }
    
    
    
}
