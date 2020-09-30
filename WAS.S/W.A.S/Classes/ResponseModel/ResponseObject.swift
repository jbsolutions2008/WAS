//
//  ResponseObject.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 06/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import Foundation

struct ProductKit {
    let ProductKitId : Int
    let Name : String
    var Quantity : String
    var sizes : [ProductSize]
    
    init(dict:[String:AnyObject]) {
        self.ProductKitId = dict["ProductKitId"] as? Int ?? 0
        self.Name = dict["Name"] as? String ?? ""
        self.Quantity = dict["qty"] as? String ?? ""
        self.sizes = []
    }

}

struct ProductSize {
     let ProductKitSizeId : Int
     let Size : String
     let ProductKitId : Int
     var isSelected : Bool
    
    init(dict:[String:AnyObject]) {
        self.ProductKitSizeId = dict["ProductKitSizeId"] as? Int ?? 0
        self.Size = dict["Size"] as? String ?? ""
        self.ProductKitId = dict["ProductKitId"] as? Int ?? 0
        self.isSelected = dict["isSelected"] as? Bool ?? false
    }
}


struct Forecast {
    
    let date : Double
    let humidity : String
    let speed : String
    let temperature : String
    let weather : Weather
    
    init(dict:[String:AnyObject]) {
        self.date = dict["dt"] as? Double ?? 0.0
        
        self.humidity = (dict["humidity"] as? NSNumber)?.stringValue ?? ""
        self.speed = (dict["speed"] as? NSNumber)?.stringValue ?? ""
        if let val = (dict["temp"] as! [String : Any])["day"] as? NSNumber {
            let rounded = val.doubleValue.rounded(.toNearestOrAwayFromZero)
            
            self.temperature = "\(Int(rounded))"
        } else {
            self.temperature = ""
        }
        self.weather = Weather.init(dict: (dict["weather"] as! Array)[0])
    }
}


struct Weather {
    
    let desc : String
    let icon : String
    let main : String
    
    init(dict:[String:AnyObject]) {
        self.desc = dict["description"] as? String ?? ""
        self.icon = "http://openweathermap.org/img/wn/\(dict["icon"]!).png" 
        //icon URL 10d@2x.png
        self.main = dict["main"] as? String ?? ""
        
    }
}

struct Provider {
    
    let ProviderId : Int
    let Latitude : String
    let Longitude : String
    let status : String
    
    init(dict:[String:AnyObject]) {
        self.ProviderId = dict["ProviderId"] as? Int ?? 0
        self.Latitude = dict["Latitude"] as? String ?? ""
        //icon URL 10d@2x.png
        self.Longitude = dict["Longitude"] as? String ?? ""
        self.status = dict["Status"] as? String ?? ProviderStatus.connected.rawValue
    }
}

struct StripeCard {
    
    let CustomerId : String
    let ClientStripeCustomerSourceId : Int
    let ClientStripeCustomerId : Int
    let SourceId : String
    let SourceToken : String
    let last4 : String
    let Brand : String
    
    init(dict:[String:AnyObject]) {
        self.CustomerId = dict["CustomerId"] as? String ?? ""
        self.SourceId = dict["SourceId"] as? String ?? ""
        self.SourceToken = dict["SourceToken"] as? String ?? ""
        self.last4 = dict["last4"] as? String ?? ""
        self.Brand = dict["Brand"] as? String ?? ""
        self.ClientStripeCustomerSourceId = dict["ClientStripeCustomerSourceId"] as? Int ?? 0
        self.ClientStripeCustomerId = dict["ClientStripeCustomerId"] as? Int ?? 0
        
    }
}

struct TripList {
    
    let TripId : String
    let TotalTripAmount : Int
    let TripTimestamp : Double
    let StarRatings : Int
    
    let TripCharges : Int
    let TipAmount : Int
    
    
    init(dict:[String:AnyObject]) {
        self.TripId = dict["TripId"] as? String ?? ""
        self.TotalTripAmount = dict["TotalTripAmount"] as? Int ?? 0
        self.TripTimestamp = dict["TripTimestamp"] as? Double ?? 0.0
        self.StarRatings = dict["StarRatings"] as? Int ?? 0
        
        self.TripCharges = dict["TripCharges"] as? Int ?? 0
        self.TipAmount = dict["TipAmount"] as? Int ?? 0
        
    }
}

