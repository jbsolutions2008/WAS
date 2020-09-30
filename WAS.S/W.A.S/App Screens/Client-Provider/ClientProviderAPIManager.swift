//
//  ClientProviderAPIManager.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 25/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

typealias responseHandler = (_ responseObject: AnyObject, _ success: Bool) -> Void
typealias authResponseHandler = (_ verificationCode:String, _ error:Error?) -> Void
typealias directionResponseHandler = (_ routeArray:String, _ success:Bool) -> Void
typealias placeSearchResponseHandler = (_ placeArray:Array<Any>, _ success:Bool) -> Void
typealias distanceMatrixResponseHandler = (_ durationValues:[String:AnyObject], _ success:Bool) -> Void

// - - - - - - - - - - -  - - - - - - - - - - - Client API LIST  - - - - - - - - - - - - - - - - - - - - - -

//Register API
let REGISTERCLIENTAPI = "ClientAPI/RegisterClient"
let LOGINCLIENTAPI = "ClientAPI/LoginClient"
let VERIFYCLIENTAPI = "ClientAPI/ClientVerifyVerificationCode"
let FORGOTPASSWORDCLIENTAPI = "ClientAPI/ClientForgotPassword"
let RESETPASSWORDCLIENTAPI = "ClientAPI/ClientResetPassword"
let CLIENTGETPROFILEINFOAPI = "ClientAPI/ClientDetailGet"
let CLIENTVERIFYAPI = "ClientAPI/ClientVerify"
let CLIENTREQUESTFORSERVICE = "ProviderAPI/ClientRequestedForService"
let CLIENTCARDLIST = "ClientAPI/ClientStripeCustomerSourceList"
let CLIENTCARDADD = "ClientAPI/ClientStripeCustomerSourceCreate"
let DELETECLIENTCARD = "ClientAPI/ClientStripeCustomerSourceDelete"
let CLIENTDETAIL = "ClientAPI/ClientProfileDetailView?"
let CLIENTPROFILEUPDATE = "ClientAPI/ClientProfileDetailsUpdate"
let CLIENTPROFILEIMAGEUPDATE = "ClientAPI/ClientProfilePicUpdate"
let CLIENTTRIPSELFIEUPLOAD = "TripAPI/UploadSelfiDuringTrip"
let SUBMITREVIEW = "TripAPI/ClientProviderRatings"
let CLIENTTRIPLIST = "TripAPI/ClientTripListing"
let TIPTRANSACTION = "TripAPI/TripTipTransaction"
let CHECKTRIPEXIST = "TripAPI/ClientProviderTripStatusCheck"


// - - - - - - - - - - -  - - - - - - - - - - - PROVIDER API LIST  - - - - - - - - - - - - - - - - - - - -
//Register API
let REGISTERPROVIDERAPI = "providerAPI/RegisterProvider"
let LOGINPROVIDERAPI = "ProviderAPI/LoginProvider"
let VERIFYPROVIDERAPI = "ProviderAPI/ProviderVerifyVerificationCode"
let FORGOTPASSWORDPROVIDERAPI = "ProviderAPI/ProviderForgotPassword"
let RESETPASSWORDPROVIDERAPI = "ProviderAPI/ProviderResetPassword"
let PROVIDERGETPROFILEINFOAPI = "ProviderAPI/ProviderDetailGet"
let PROVIDERPOSTIDAPI = "ProviderAPI/ProviderKYCDetailsSave"
let PROVIDERKITAPI = "ProviderAPI/ProductKitList"
let PROVIDERKITSIZEAPI = "ProviderAPI/ProductKitSizeList"
let PROVIDERVERIFYAPI = "ProviderAPI/ProviderVerify"
let PROVIDERKITSAVE = "ProviderAPI/ProviderProductKitSave"
let ONLINEPROVIDERLIST = "ProviderAPI/OnlineProviderList"
let PROVIDERDETAIL = "ProviderAPI/ProviderDetailView?"
let PROVIDERPROFILEUPDATE = "ProviderAPI/ProviderProfileDetailsUpdate"
let PROVIDERPROFILEIMAGEUPDATE = "ProviderAPI/ProviderProfilePicUpdate"
let PROVIDERTRIPSELFIEVIEW = "TripAPI/ViewSelfiDuringTrip?"
let PROVIDERTRIPSTARTEND = "TripAPI/TripStartEnd"
let PROVIDERGETEARNINGS = "ProviderAPI/ProviderEarningsGet"
let PROVIDERGETTRIPS = "ProviderAPI/ProviderTripChargesHistoryList"
let PROVIDERPAYMENTREQUEST = "ProviderAPI/ProviderInstantPaymentRequest"

// - - - - - - - - - - -  - - - - - - - - - - - COMMON API LIST  - - - - - - - - - - - - - - - - - - - - -

let SUPPORTAPI = "CommonAPI/RegisterSupport"



//API MANAGER IMPLEMENTATION
class ClientProviderAPIManager: NSObject {
    
    override init() {
        super.init()
    }
    
    class var sharedInstance: ClientProviderAPIManager {
        
        struct Static {
            static let instance = ClientProviderAPIManager()
        }
        return Static.instance
    }
    
    //MARK:Firebase Authentication
    func verifyPhonenumberWithFirebase(phone:String, callback: @escaping authResponseHandler) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                callback("",error)
                return
            }
            callback(verificationID!,error)
        }
    }
    
    
    //MARK: For Normal API Calling
    func getResponse(currentVC : UIViewController, urlPostfixStr: String, method : HTTPMethod,  parameter : [String : AnyObject], headers: HTTPHeaders, Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        print("url :\(urlPostfixStr)")
        
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)){
            
            Alamofire.request((RDDataEngineClass.ApplicationBaseURL+urlPostfixStr), method: method, parameters: parameter, headers: headers).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        if result is [String:Any] {
                            let JSON = result as! [String : Any]
                            print("Success: \(JSON as AnyObject)")
                            callback(JSON as AnyObject, true)
                        } else {
                            let JSON = result as! NSArray
                            callback(JSON as AnyObject,true)
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    if response.result.value == nil {
                        callback(["ErrorSuccessMsg":"Server Error"] as AnyObject, false)
                    } else {
                        callback(response.result.value as AnyObject, false)
                    }
                    
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                        })
                    }else{
                        
                        if responseCode == 500  {
                            
                        }
                        
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    func getDirections(currentVC : UIViewController,  parameter : [String : AnyObject], Alert : Bool,  callback: @escaping directionResponseHandler) -> Void {
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)) {
            
            let request = "https://maps.googleapis.com/maps/api/directions/json"
            let parameters : [String : String] = ["origin" : "\(parameter["org_lat"]!),\(parameter["org_long"]!)", "destination" : "\(parameter["dest_lat"]!),\(parameter["dest_long"]!)", "key" : RDDataEngineClass.Map_API_Key,"mode":"walking"]
            
            Alamofire.request(request, method: .get, parameters: parameters).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        let dict = result as! [String : AnyObject]
                        
                        let status = dict["status"] as! String
                      
                        var routesArray:String!
                        if status == "OK" {
                            routesArray = (((dict["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as? String
                            callback(routesArray,true)
                        } else {
                            callback("",false)
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    if response.result.value == nil {
                        callback("", false)
                    } else {
                        callback("", false)
                    }
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405) {
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                        })
                    }else{
                        
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    
    func callDistanceMatrixAPIForClient(currentVC : UIViewController,  parameter : [String : AnyObject], Alert : Bool,  callback: @escaping distanceMatrixResponseHandler) -> Void {
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)) {
            
            let request = "https://maps.googleapis.com/maps/api/distancematrix/json"
            let parameters : [String : String] = ["origins" : "\(parameter["org_lat"]!),\(parameter["org_long"]!)", "destinations" : "\(parameter["dest_lat"]!),\(parameter["dest_long"]!)", "key" : RDDataEngineClass.Map_API_Key,"mode":"walking"]
            
            Alamofire.request(request, method: .get, parameters: parameters).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        let dict = result as! [String : AnyObject]
                        
                        let status = dict["status"] as! String
                      
                        var durationValues:[String:AnyObject]
                        if status == "OK" {
                            durationValues = ((((dict["rows"]!as! [Any])[0] as! [String:Any])["elements"] as! [Any])[0] as! [String : AnyObject])
                            callback(durationValues,true)
                        } else {
                            callback([:],false)
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    if response.result.value == nil {
                        callback([:], false)
                    } else {
                        callback([:], false)
                    }
                    
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                            
                        })
                        
                    }else{
                        
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    func getNearbyPlaces(currentVC : UIViewController,  parameter : [String : AnyObject], Alert : Bool,  callback: @escaping placeSearchResponseHandler) -> Void {
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)) {
            
            let request = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
            let parameters : [String : String] = ["location" : "\(parameter["lat"]!),\(parameter["long"]!)", "keyword" : "\(parameter["keyword"]!)","key" : RDDataEngineClass.Map_API_Key,"radius":"4000"]
            
            Alamofire.request(request, method: .get, parameters: parameters).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        let dict = result as! [String : AnyObject]
                        
                        let status = dict["status"] as! String
                      
                        var placeArray:Array<Any>!
                        if status == "OK" {
                            placeArray = dict["results"] as? Array<Any>
                            callback(placeArray,true)
                        } else {
                            callback([],false)
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    if response.result.value == nil {
                        callback([], false)
                    } else {
                        callback([], false)
                    }
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                            
                        })
                    }else{
                        
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                        
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    
    
    
    
    //MARK: Encoding API Calling
    func getResponseWithEncoding(currentVC : UIViewController, url: String, method : HTTPMethod,  parameter : [String : AnyObject], headers: HTTPHeaders, encodingStr : ParameterEncoding, Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        print("Encoding url :\(url)")
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)){
            
            Alamofire.request(url, method: method, parameters: parameter, encoding: encodingStr, headers: headers).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        
                        let JSON = result as! [String : Any]
                        print("Success: \(JSON as AnyObject)")
                        callback(JSON as AnyObject, true)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    callback({} as AnyObject, false)
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                            
                        })
                    }else{
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                        
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    
    func getWeatherData(currentVC : UIViewController,  lat:String,lng:String, headers: HTTPHeaders, Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        
        if (UtilityClass.isInternetConnectedWith(isAlert: Alert)){
            
            Alamofire.request("http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lng)&units=Imperial&APPID=\(RDDataEngineClass.OpenWeatherAPIKey)&cnt=7", method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        if result is [String:Any] {
                            let JSON = result as! [String : Any]
                            print("Success: \(JSON as AnyObject)")
                            callback(JSON as AnyObject, true)
                        } else {
                            let JSON = result as! NSArray
                            callback(JSON as AnyObject,true)
                            
                        }
                        
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    callback({} as AnyObject, false)
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                            
                        })
                        
                    }else{
                        
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    
// - - - - - - - - - - -  - - - - - - - - - - - CLIENT  - - - - - - - - - - - - - - - - - - - - - -
    
   //SIGN UP SCREEN
    func doSignUpWith(selectedVC : UIViewController, signupParameters: Parameters, userRegisterAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: userRegisterAPI, method: .post , parameter: signupParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    
    //SIGN IN SCREEN
    func doSignInWith(selectedVC : UIViewController, signInParameters: Parameters, userLoginAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: userLoginAPI, method: .post , parameter: signInParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //VERIFY OTP SCREEN
    func verifyOTP(selectedVC : UIViewController, verifyOTPParameters: Parameters, verifyOTPAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: verifyOTPAPI, method: .post , parameter: verifyOTPParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //VERIFY USER
    func verifyUser(selectedVC : UIViewController, verifyUserParameters: Parameters, verifyUserAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: verifyUserAPI, method: .post , parameter: verifyUserParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //FORGOT PASSWORD SCREEN
    func forgotPassword(selectedVC : UIViewController, forgotPasswordParameters: Parameters, forgotPAsswordAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: forgotPAsswordAPI, method: .post , parameter: forgotPasswordParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    
    //RESET PASSWORD
    func resetPassword(selectedVC : UIViewController, resetPasswordParameters: Parameters, resetPasswordAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: resetPasswordAPI, method: .post , parameter: resetPasswordParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    
    //GET - Client Details
    func getClientProfileDetailInformation(selectedVC : UIViewController, clientProfileParameters: Parameters, getClientProfileAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getClientProfileAPI, method: .get , parameter: clientProfileParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    
    //GET - Online Provider List
    func getOnlineProviderList(selectedVC : UIViewController, getOnlineProviderListAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getOnlineProviderListAPI, method: .get , parameter: [:] as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //POSt - Request
    func postRequest(selectedVC : UIViewController, requestParameters: Parameters, postRequestAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: postRequestAPI, method: .post , parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //POST - Card List
    func getStripeCardList(selectedVC : UIViewController, requestParameters: Parameters, cardListAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: cardListAPI, method: .post, parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //POST -
    func addCardToCustomer(selectedVC : UIViewController, requestParameters: Parameters, addCardAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: addCardAPI, method: .post, parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //POST - Delete Card
    func deleteCardFromCustomer(selectedVC : UIViewController, requestParameters: Parameters, deleteCardAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: deleteCardAPI, method: .post, parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //POST - post Tip pay
    func postTipAmountAPI(selectedVC : UIViewController, tipParameters: Parameters, postTipAmount : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postTipAmount, method: .post, parameter:tipParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    
    //GET - client details
    func getClientDetails(selectedVC : UIViewController, clientParameters: Parameters, getClientDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: getClientDetails, method: .get, parameter:clientParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    //POST - Client Profile Update
    func postClientProfileUpdate(selectedVC : UIViewController, clientParameters: Parameters, postClientDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postClientDetails, method: .post, parameter:clientParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    //POST - Client profile Image update
    func postClientProfileImageUpdate(selectedVC : UIViewController, clientParameters: Parameters, postClientImageDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postClientImageDetails, method: .post, parameter:clientParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func postClientTripSelfie(selectedVC : UIViewController, clientParameters: Parameters, postClientTripSelfie : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postClientTripSelfie, method: .post, parameter:clientParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func postStartEndTrip(selectedVC : UIViewController, tripParameters: Parameters, postStartEndTripUrl : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postStartEndTripUrl, method: .post, parameter:tripParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func postTripReview(selectedVC : UIViewController, reviewParameters: Parameters, postTripReview : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postTripReview, method: .post, parameter:reviewParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func customerTripList(selectedVC : UIViewController, requestParameters: Parameters, tripListAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: tripListAPI, method: .post, parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    func checkTripExistStatus(selectedVC : UIViewController, requestParameters: Parameters, tripExistAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: tripExistAPI, method: .post, parameter: requestParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
// - - - - - - - - - - -  - - - - - - - - - - - PROVIDER  - - - - - - - - - - - - - - - - - - - - - -
    
    //GET - PROVIDER Details
    func getProviderProfileDetailInformation(selectedVC : UIViewController, providerProfileParameters: Parameters, getProviderProfileAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getProviderProfileAPI, method: .get , parameter: providerProfileParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    func getProviderEarnings(selectedVC : UIViewController, providerParameters: Parameters, getEarningsAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getEarningsAPI, method: .get , parameter: providerParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //GET - Provider Trip List
    func getProviderTrips(selectedVC : UIViewController, providerParameters: Parameters, getTripsAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getTripsAPI, method: .get , parameter: providerParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
    }
    
    //POST - PROVIDER ID
    func postProviderIdentityCards(selectedVC : UIViewController, providerIdCardParameters: Parameters, postProviderIdAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: postProviderIdAPI, method: .post , parameter: providerIdCardParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //POST - KIT SIZE
    func postProviderKitSize(selectedVC : UIViewController, providerKitParameters: Parameters, postProviderKitAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: postProviderKitAPI, method: .post , parameter: providerKitParameters as [String : AnyObject], headers: [:], Alert : true, callback: callback)
        
    }
    
    //GET - Provider Kit
    func getProviderKit(selectedVC : UIViewController, providerKitParameters: Parameters, getProviderKit : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: getProviderKit, method: .get, parameter:providerKitParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func getProviderKitSize(selectedVC : UIViewController, providerKitParameters: Parameters, getProviderKitSize : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: getProviderKitSize, method: .get, parameter:providerKitParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    //GET - Provider Details
    func getProviderDetails(selectedVC : UIViewController, providerParameters: Parameters, getProviderDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: getProviderDetails, method: .get, parameter:providerParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    //POST - Provider Profile Update
    func postProviderProfileUpdate(selectedVC : UIViewController, providerParameters: Parameters, postProviderDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postProviderDetails, method: .post, parameter:providerParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    //POST - Provider profile Image update
    func postProviderProfileImageUpdate(selectedVC : UIViewController, providerParameters: Parameters, postProviderImageDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postProviderImageDetails, method: .post, parameter:providerParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func getClientSelfieDuringTrip(selectedVC : UIViewController, providerParameters: Parameters, viewClientSelfie : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: viewClientSelfie, method: .get, parameter:providerParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    func postProviderPaymentRequest(selectedVC : UIViewController, providerParameters: Parameters, postProviderPaymentRequestDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postProviderPaymentRequestDetails, method: .post, parameter:providerParameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
    
    // - - - - - - - - - - -  - - - - - - - - - - - COMMON  - - - - - - - - - - - - - - - - - - - - - -
    
    //POST - Client Provider Support Query
    func postClientProviderSupportQuery(selectedVC : UIViewController, parameters: Parameters, postDetails : String,callback: @escaping responseHandler) {
        self.getResponse(currentVC: selectedVC, urlPostfixStr: postDetails, method: .post, parameter:parameters as [String : AnyObject] , headers: [:], Alert: true, callback: callback)
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
