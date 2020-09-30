//
//  RDDataEngineClass.swift
//  RhythmCor
//
//  Created by Renish Dadhaniya on 10/10/18.
//  Copyright © 2018 GlobeSyncTechnologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

let APPDEVELOPMENTURL = "http://api.weatheraccommodation.com/api/"//"http://192.168.1.40/WASWebAPI/api/" //DEVELOPMENT
let APPPRODUCTIONRL = "" //PRODUCTION


let APPDEVELOPMENTIMAGEURL = "http://weatheracco.web808.discountasp.net/"
let APPDPRODUCTIONIMAGEURL = "http://weatheracco.web808.discountasp.net/api/"

//Stripe Key
//let STRIPE_TEST_PUBLISHKEY = "pk_test_9J3K3q3rDE2xMKrVH2cX2Yx9"
//let STRIPE_TEST_SECRETKEY = "sk_test_oUKpszzXm48c0RErn3gclI9A"

//Client stripe test key
let STRIPE_TEST_PUBLISHKEY = "pk_test_Jzt8NAK8STtUdsVJLfNABMJD00HbMc6nac"
let STRIPE_TEST_SECRETKEY = "sk_test_SYyBy6JJQMbpvH3LWYzZG4ps00HA30LXFn"

//client stripe publish key
let STRIPE_LIVE_PUBLISHKEY = "pk_live_NS4uz1U0uaT35Nqeq2U654Qw0022dylw5G"

let APPDEVELOPMENTWEBSOCKETURL = "ws://api.weatheraccommodation.com/api/"//"http://192.168.1.40/WASWebAPI/api/" //DEVELOPMENT

let APPPRODUCTIOWEBSOCKETNRL = "" //PRODUCTION

let API_PREFIX = "https://weatheraccommodation.com/"

//App iTunes URl
let appiTunesURlStr = "itms://itunes.apple.com/us/app/rhythmcor-ai/id1439282662?mt=8"

let APPFULLNAME = "Weather Accommodation Services"
let APPSORTNAME = "W.A.S"

let SUCCESSCODE = 1
let NOTVERIFIEDCODE = 2


class RDDataEngineClass: NSObject {
    
    static let clientApp = "Client App"
    static let providerApp = "Provider App"
    
    static let ApplicationBaseURL = APPDEVELOPMENTURL
    static let ApplicationImageBaseURL = APPDEVELOPMENTIMAGEURL
    static let ApplicationWebSocketURL = APPDEVELOPMENTWEBSOCKETURL
    static let Stripe_PublishKey = STRIPE_LIVE_PUBLISHKEY
    static let Stripe_SecretKey = STRIPE_TEST_SECRETKEY
    
    //Response Status Value
    static let iSSuccssValue : NSInteger = 1

    //APP ENVIRONMENT
    static let sandbox = "sandbox"
    static let production = "production"
    
    //FONT NAME
    static let robotoFontDefault : String = "Roboto-Regular"
    static let robotoFontBold : String = "Roboto-Bold"
    static let robotoFontBoldItalic : String = "Roboto-BoldItalic"
    static let robotoFontItalic : String = "Roboto-Italic"
    static let robotoFontMedium : String = "Roboto-Medium"
    
    static let montserratFontDefault : String = "Montserrat-Regular"
    static let montserratFontLight : String = "Montserrat-Light"
    static let montserratFontMedium : String = "Montserrat-Medium"
    static let montserratFontSemiBold : String = "Montserrat-SemiBold"
    static let montserratFontBold : String = "MontserratAlternates-Bold"

    
    //APP THEME COLOR
    static let primaryColor : UIColor = UIColor(red: 78/255, green: 190/255, blue: 214/255, alpha: 1.0)
    static let primaryShadeColor : UIColor = UIColor(red: 51/255, green: 164/255, blue: 189/255, alpha: 1.0)
    static let primaryTintColor : UIColor = UIColor(red: 67/255, green: 198/255, blue: 228/255, alpha: 1.0)
    static let primaryPastelColor : UIColor = UIColor(red: 138/255, green: 228/255, blue: 246/255, alpha: 1.0)

    static let secondaryColor : UIColor = UIColor(red: 250/255, green: 155/255, blue: 35/255, alpha: 1.0)
    static let secondaryShadeColor : UIColor = UIColor(red: 236/255, green: 138/255, blue: 22/255, alpha: 1.0)
    static let secondaryTintColor : UIColor = UIColor(red: 250/255, green: 169/255, blue: 60/255, alpha: 1.0)
    static let secondaryPastelColor : UIColor = UIColor(red: 253/255, green: 189/255, blue: 98/255, alpha: 1.0)
    
    static let accentColor : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    static let accentShadeColor : UIColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0)
    static let accentTintColor : UIColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
    static let accentPastelColor : UIColor = UIColor(red: 201/255, green: 201/255, blue: 205/255, alpha: 1.0)
    
    
    static let appGreenColor : UIColor = UIColor(red: 0, green: 166.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    static let blueThemeColor : UIColor = UIColor(red: 72/255, green: 146/255, blue: 225/255, alpha: 1.0)
    static let redThemeColor : UIColor = UIColor(red: 217/255, green: 57/255, blue: 51/255, alpha: 1.0)
    static let grayThemeColor : UIColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
    static let lightGrayThemeColor : UIColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
    
    //App Identity Key
    static let deviceAppUUID : String = "DeviceAppUUID"
    
    //USER FLAG
    static let userLoginTypeInAppDef : String = "UserLoginTypeInAppDefault" //Which Type of User
    static let userProfileInfoDef : String = "UserProfileInfoAppDefault" //Store User Info
    static let iSUerActivated : String = "iSUserSuccessfullyActivatedInAppDef"
    static let userCardSelected : String = "selectedCard" // Remember card
    static let userCardCount : String = "CardCount" //number of cards
    static let userStripeId : String = "userStripeId" //number of cards
    
    static let userEmailDef : String = "UserEmail"
    
    static let iSUserRegisterBUTNotVerified : String = "iSUserSuccessfullyRegisterBUTNotVerified"
    static let userInfoDef : String = "StoreUserInfoInDefault"
    
    
    //Predifine Contents
    static let loadingStr = "Loading..."
    static let syncingStr = "  Syncing...  "
    static let blanckDataStr = "---"
    
    static let BTAError = "OOPS!"
    
    static let genderAry = ["MALE", "FEMALE", "OTHERS"]
    static let bloodGroupAry = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    
    //Resend Code Timer
    static let resetTimerCounter = 99
    static let requestTimerCounter = 120
    
    //Library Key
    static let Map_API_Key = "AIzaSyAUR_6Ko7rDP5J5HH1NiapEMUVAdImSQGs"
    static let OpenWeatherAPIKey = "8cd0c621e1a35c387fe2605e6eff658f"
    
    //Notification Identifier
    static let ExtraEquipments  = "ExtraEquipments"
    static let ReceivedClientPing  = "ClientPing"
    
    
    
    
    //Store Bool Key and Value in Default for User Active - REMEMBER USER
    class func setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue : Bool) -> Bool{
        UserDefaults.standard.set(iSDefaultValue, forKey: self.iSUerActivated)
        UserDefaults.standard.synchronize()
        
        return UserDefaults.standard.value(forKey: self.iSUerActivated) as? Bool ?? false
    }
  
}//Class End

class UserProfileKey {
    static let Email = "Email"
    static let ProviderId = "ProviderId"
    static let ClientId = "ClientId"
    static let Phone = "MobileNumber"
    static let Name = "Name"
}

struct Trip_Status {
    static let Accepted = "trip_accepted"
    static let cancelled = "trip_cancelled"
    
}

struct Request_Status {
    static let Requested = "requested"
    static let Cancelled = "cancelled"
    static let Reached = "reached"
    static let Started = "Trip_Started"
    static let Ended = "Trip_Ended"
    static let Location_Updated = "location_updated"
}

struct Numeric_TripStatus {
    static let started = "7"
    static let ended = "8"
    static let accepted = "6"
}

struct Numeric_Usercode {
    static let client = "14"
    static let provider = "15"
}

struct NotificationType {
    static let ProviderRequstReceived = "Request Received" //show request UI in provider
    static let ClientAcceptRequest = "Request Accpted" //show bottomsheet in client
    static let ClientReachRequest = "Request Reached" //navigate to trip UI
}

struct CancellationReasonCode {
    static let NoReason = "0"
    static let NoShow = "16"
    static let NoReply = "17"
}


