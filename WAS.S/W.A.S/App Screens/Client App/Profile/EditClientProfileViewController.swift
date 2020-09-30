//
//  EditClientProfileViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 17/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AVFoundation
import Photos

class EditClientProfileViewController: UIViewController {

    @IBOutlet weak var txtName : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtEmail : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtAddress : SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtNumber : SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var btnSubmit : UIButton!
    @IBOutlet weak var imgProfile : UIImageView!
   
    var dictProfile : [String : Any] = [:]
    var hasChangedProfile : Bool = false
    var hasChangedDetail : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designInterFace()
        txtName.iconType = .image
        
        self.txtName.text = dictProfile["Name"] as? String
        
        self.txtNumber.text = dictProfile["MobileNumber"] as? String
        
        self.txtEmail.text = dictProfile["Email"] as? String
        self.txtAddress.text = dictProfile["Address"] as? String
        self.imgProfile.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + (dictProfile["ProfileImg"] as? String)!), placeholderImage: #imageLiteral(resourceName: "logo"))
    }
    
    func designInterFace() {
        
        self.btnSubmit.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        RDGlobalFunction.setCornerRadius(any: self.btnSubmit, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: self.imgProfile, cornerRad: self.imgProfile.frame.height/2, borderWidth: 0, borderColor: .clear)
    }
    
    //MARK:Image Selection
    func displayActionSheetForImagePicker() {
        
        
        // Initialize Alert Controller
        let alertController = UIAlertController(title: nil, message: "Upload Profile Picture", preferredStyle: .actionSheet)
        
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
        
        if attachmentTypeEnum == AttachmentType.camera{
            
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
            myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let myPickerController = UIImagePickerController()
            myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
            
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpeg(.medium)
        return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnSubmitPressed() {
        if (self.txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 4 {
            
            self.txtName.errorMessage = "Min. 4 characters required"
            self.txtName.becomeFirstResponder()
            
        }else if !RDGlobalFunction.isValidEmail(self.txtEmail.text!) {
            
            self.txtEmail.errorMessage = "Invalid Email"
            self.txtEmail.becomeFirstResponder()
            
        }else{
            if hasChangedDetail {
                updateProfileDetails()
            } else if hasChangedProfile {
                UtilityClass.showActivityIndicator()
                updateProfileImage()
            }
        }
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfileChangePressed() {
        displayActionSheetForImagePicker()
    }
    
    //MARK:WebService
    func updateProfileDetails() {
        
        UtilityClass.showActivityIndicator()
        let clientParam  = ["Name":txtName.text!,"Email":txtEmail.text!,"Address":txtAddress.text!, "ClientId" : RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId)!] as [String : Any]
        
        ClientProviderAPIManager.sharedInstance.postClientProfileUpdate(selectedVC: self, clientParameters: clientParam, postClientDetails: CLIENTPROFILEUPDATE) { (responseObject, success) in
            if success {
                if self.hasChangedProfile {
                    self.updateProfileImage()
                } else {
                    UtilityClass.removeActivityIndicator()
                    self.navigationController?.popViewController(animated:  true)
                }
            }
        }
    }
    
    func updateProfileImage() {
        
        let clientParam  = ["ProfileImg":convertImageToBase64(image: imgProfile.image!), "ClientId" : RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef).value(forKey: UserProfileKey.ClientId)!] as [String : Any]
        //
        
        ClientProviderAPIManager.sharedInstance.postClientProfileImageUpdate(selectedVC: self, clientParameters:clientParam , postClientImageDetails: CLIENTPROFILEIMAGEUPDATE) { (responseObject, success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EditClientProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //GET IMAGE from PHOTO ALBUM
        if let selectedImage = info[.originalImage] as? UIImage {
            
            if let selectImageData = selectedImage.jpeg(.medium) {
                
                let imgSizeInMB : Float = (Float(selectImageData.count/1024/1024))
                
                if imgSizeInMB >= 1.45 {//1.5 Size Limit
                    
                    ClientProviderAlertController.displayAlert(alertControllerVC: self, alertsFor: "File Size Limit", alertTitle: "1.5 MB File size limit", alertMessage: "The attached file size limit is 1.5 MB.", alertTag: 100, alertActionTitle: "OK", alertActionStyle: .cancel)
                }else{
                    hasChangedProfile = true
                    imgProfile.image = UIImage.init(data: selectImageData)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditClientProfileViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != txtNumber {
            hasChangedDetail = true
        }
    }
}
