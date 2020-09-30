//
//  AppDelegate.swift
//  W.A.S
//
//  Created by Renish Dadhaniya on 10/10/18.
//  Copyright © 2019 GlobeSync Technologies  - Renish Dadhaniya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Locksmith
import Firebase
import UserNotifications
import GoogleMaps



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    var window: UIWindow?
    var showRequestUI = false
    var doesRequestExist = false
    var clientExistingTrip : [String : AnyObject]!
    var providerExistingTrip : [String : AnyObject]!
    var extraCharge = 0.0
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(10)
        //DIsable Constraint Log
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        //IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        
        //map enable
        GMSServices.provideAPIKey(RDDataEngineClass.Map_API_Key)
        
        //Generate UUID
        self.generateUUIDForApp()
        
        //push setup
        configurePushNotification()
        
        //Stripe setup
        STPPaymentConfiguration.shared().publishableKey =  RDDataEngineClass.Stripe_PublishKey
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("background fetcher called at \(Date())")
        completionHandler(.newData)
//      if let tabBarController = window?.rootViewController as? UITabBarController,
//        let viewControllers = tabBarController.viewControllers
//      {
//        for viewController in viewControllers {
//          if let fetchViewController = viewController as? FetchViewController {
//            fetchViewController.fetch {
//              fetchViewController.updateUI()
//              completionHandler(.newData)
//            }
//          }
//        }
//      }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK:UNUsernotificationDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    //Generate UUID
    func generateUUIDForApp() {
        
        let keyChainID = Locksmith.loadDataForUserAccount(userAccount: Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String)
        
        //Retrive Device Unique UUID
        let retriveuuid = keyChainID?[RDDataEngineClass.deviceAppUUID]
        
        if(retriveuuid == nil){
            
            let uuid = createApplicationDeviceUUID()
            
            do{
                //Store - Device UUID
                let keychainData = [RDDataEngineClass.deviceAppUUID : uuid]
                try Locksmith.saveData(data: keychainData, forUserAccount: Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)
                
            }catch{
                
                //Catch Error - FORCEFULLY Terminate Application
                exit(0)
                
            }
        }
    }
    
    func configurePushNotification() {
      
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    //Create UUID
    func createApplicationDeviceUUID() -> String{
        
        let DeviceUUID = NSUUID().uuidString
        return DeviceUUID
    }
    
    //MARK:FIRMessaging Delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if response.notification.request.identifier == NotificationType.ProviderRequstReceived {
            //provider dashboard show request UI
            showRequestUI = true
            
            if let nvc = self.window?.rootViewController?.presentedViewController {
                if nvc is UINavigationController {
                    let nvc = self.window?.rootViewController?.presentedViewController as! UINavigationController
                    let tabvc = nvc.viewControllers.first as! ProviderTabBarController
                    tabvc.selectedIndex = 0
                }
            }
            
        } else if response.notification.request.identifier == NotificationType.ClientAcceptRequest {
            //client show bottom sheet
        } else if response.notification.request.identifier == NotificationType.ClientReachRequest {
            //redirect to trip
        }
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
}

