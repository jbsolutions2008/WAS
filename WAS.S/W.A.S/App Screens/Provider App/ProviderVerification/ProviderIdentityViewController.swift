//
//  ProviderIdentityViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 05/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum AttachmentType: String{
    case camera, photoLibrary
}

enum SelectingSide {
    case Front,Back,Selfie
}

class ProviderIdentityViewController: UIViewController {
    
    @IBOutlet weak var headerBGIV: UIImageView!
    @IBOutlet weak var logoIV: UIImageView!
   
    @IBOutlet weak var lblUploadCard: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
   
    @IBOutlet weak var lblFrontSide: UILabel!
    @IBOutlet weak var lblBackSide: UILabel!
    @IBOutlet weak var lblSelfie: UILabel!
    
    @IBOutlet weak var lbluploadFront: UILabel!
    @IBOutlet weak var lbluploadBack: UILabel!
    @IBOutlet weak var lbluploadSelfie: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var imgFrontSide: UIImageView!
    @IBOutlet weak var imgBackSide: UIImageView!
    @IBOutlet weak var imgSelfie: UIImageView!
    
    @IBOutlet weak var vwSelfieInfo: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    
    var currentSelectingSide = SelectingSide.Front
    var isFrontSelected = false
    var isBackSelected = false
    var isSelfieSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designInterFace()
    }
    

    func designInterFace() {
        
        self.lblUploadCard.font = self.lblUploadCard.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()))
        vwSelfieInfo.backgroundColor = UIColor.black.withAlphaComponent(0.8)
      
        self.lblFrontSide.font = self.lblFrontSide.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-5))
        self.lblBackSide.font = self.lblBackSide.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-5))
        self.lblSelfie.font = self.lblSelfie.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-5))
        
        self.lbluploadFront.font = self.lbluploadFront.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-8))
        self.lbluploadBack.font = self.lbluploadBack.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-8))
        self.lbluploadSelfie.font = self.lbluploadSelfie.font.withSize(CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-8))
        
        self.btnNext.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        RDGlobalFunction.setCornerRadius(any: self.btnNext, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
    }
    
    override func viewDidLayoutSubviews() {
        
        RDGlobalFunction.setCornerRadius(any: self.btn1, cornerRad: btn1.frame.height/2, borderWidth: 0, borderColor: .clear)
        
        RDGlobalFunction.setCornerRadius(any: self.btn2, cornerRad: btn2.frame.height/2, borderWidth: 0, borderColor: .clear)
        
        RDGlobalFunction.setCornerRadius(any: self.btnInfo, cornerRad: btnInfo.frame.height/2, borderWidth: 0, borderColor: .clear)
       
    }
    
    //MARK:UIButton Actions
    @IBAction func btnInfoPressed(_sender:UIButton) {
        vwSelfieInfo.isHidden = false
    }
    
    @IBAction func btnOpenImageSelectionPressed(_sender:UIButton) {
            if _sender.tag == 1000 {
                currentSelectingSide = SelectingSide.Front
            } else if _sender.tag == 1002 {
                currentSelectingSide = SelectingSide.Selfie
            } else {
                currentSelectingSide = SelectingSide.Back
            }
            displayActionSheetForImagePicker(alertTag: _sender.tag)
    }
    
    @IBAction func btnNextPressed() {
        
            if !isFrontSelected  {
                
                UtilityClass.showAlertOnNavigationBarWith(message:"Please select front side of your id card." , title: "Error", alertType: .failure)
            } else if !isBackSelected {
                
                UtilityClass.showAlertOnNavigationBarWith(message:"Please select back side of your id card." , title: "Error", alertType: .failure)
            }
            else if !isSelfieSelected {
                
                UtilityClass.showAlertOnNavigationBarWith(message:"Please capture selfie of your id card." , title: "Error", alertType: .failure)
            }
            else {
                self.uploadImages()
            }
    
    }
    
    //MARK:Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vwSelfieInfo.isHidden = true
    }
    
    func displayActionSheetForImagePicker(alertTag : NSInteger) {
        var message = ""
        
        if alertTag == 1000 {
            message = "Upload front side of Id"
        } else if alertTag == 1002 {
            message = "Upload selfie with your id"
        } else {
            message = "Upload back side of Id"
        }
        
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
            // Initialize Actions
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .camera)
            }
            //Add Actions
            alertController.addAction(cameraAction)
            
            let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.authorisationStatus(attachmentTypeEnum: .photoLibrary)
            }
            
            alertController.addAction(galleryAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
        
        //Preseent Alert
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType){//, vc: UIViewController
        
        if attachmentTypeEnum == AttachmentType.camera {
            
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
            
        }else if attachmentTypeEnum == AttachmentType.photoLibrary{
            
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status{
                
            case .authorized:
                
                if attachmentTypeEnum == AttachmentType.photoLibrary{
                    self.openGallery()
                }
                
            case .denied, .restricted:
                
                ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "Photo Access Denied", alertTitle: "Photo Access Denied", alertMessage: "Photo Access Denied for the Weather Accomodation application. Please enable access from your phone settings.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        // photo library access given
                        self.openGallery()
                    }
                })
                
            default:
                break
            }
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            if currentSelectingSide == .Selfie {
                myPickerController.cameraDevice = .front
            }
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
     func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpeg(.medium)
        return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //MARK:WebService
    func uploadImages() {
       
        UtilityClass.showActivityIndicator()
     
        let providerIdParam  = ["FrontIdCardImgBase64" : convertImageToBase64(image: imgFrontSide.image!), "BackIdCardImgBase64" : convertImageToBase64(image: imgBackSide.image!), "SelfieIdCardImgBase64" :convertImageToBase64(image: imgSelfie.image!), "ProviderId" : RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ProviderId)!] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.postProviderIdentityCards(selectedVC: self, providerIdCardParameters: providerIdParam, postProviderIdAPI: PROVIDERPOSTIDAPI) { (responseObject, success) in
            
            if success{
                
                if (responseObject.object(forKey: "Success") as! Int) == SUCCESSCODE {
                    //go to second step
                    let vc : ProviderProductKitViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderProductKitViewController") as! ProviderProductKitViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }else{
                    
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject.object(forKey: "ErrorSuccessMsg") as? String, title: "Error", alertType: .failure)
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

extension ProviderIdentityViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //GET IMAGE from PHOTO ALBUM
        if let selectedImage = info[.originalImage] as? UIImage {
            
            if let selectImageData = selectedImage.jpeg(.medium) {
                
                let imgSizeInMB : Float = (Float(selectImageData.count/1024/1024))
                
                if imgSizeInMB >= 1.45 {//1.5 Size Limit
                    
                    ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "File Size Limit", alertTitle: "1.5 MB File size limit", alertMessage: "The attached file size limit is 1.5 MB.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
                }else{
                    if currentSelectingSide == .Front {
                        isFrontSelected = true
                        imgFrontSide.contentMode = .scaleToFill
                        imgFrontSide.image = UIImage.init(data: selectImageData)
                    } else if currentSelectingSide == .Back{
                        isBackSelected = true
                        imgBackSide.contentMode = .scaleToFill
                        imgBackSide.image = UIImage.init(data: selectImageData)
                    } else {
                        isSelfieSelected = true
                        imgSelfie.contentMode = .scaleToFill
                        imgSelfie.image = UIImage.init(data: selectImageData)
                    }
                }
            }
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
