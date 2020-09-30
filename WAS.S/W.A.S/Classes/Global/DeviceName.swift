//
//  DeviceName.swift
//
//
//  Created by Renish Dadhaniya on 25/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

class DeviceName: NSObject {
    
  class var modelName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        
        switch identifier {
        
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone9,1","iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2","iPhone9,4":
            return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2","iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":
            return "iPhone X"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4":
            return "iPhone XS Max"
        case "iPhone11,6":
            return "iPhone XS max China"
        case "iPhone11,8":
            return "iPhone XR"
            
        case "iPad1,1":
            return "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9"
        case "iPad6,11", "iPad6,12":
            return "iPad 5th Generation"
        case "iPad7,1", "iPad7,2":
            return "iPad Pro 12.9"
        case "iPad7,3", "iPad7,4":
            return "iPad Pro 10.5"
            
        case "Watch1,1", "Watch1,2":
            return "Apple Watch 38mm"
        case "Watch2,3":
            return "Apple Watch Series 2 38mm"
        case "Watch2,4":
            return "Apple Watch Series 2 42mm"
        case "Watch2,6":
            return "Apple Watch Series 1 38mm"
        case "Watch2,7":
            return "Apple Watch Series 1 42mm"
        case "Watch3,1":
            return "Apple Watch Series 3 38mm (GPS+Cellular)"
        case "Watch3,2":
            return "Apple Watch Series 3 42mm (GPS)"
        case "Watch3,3":
            return "Apple Watch Series 3 38mm (GPS)"
        case "Watch4,1":
            return "Apple Watch Series 4 40mm (GPS)"
        case "Watch4,2":
            return "Apple Watch Series 4 44mm (GPS)"
        case "Watch4,3":
            return "Apple Watch Series 4 40mm (GPS+Cellular)"
        case "Watch4,4":
            return "Apple Watch Series 4 44mm (GPS+Cellular)"
       
        case "iPod1,1":
            return "iPod Touch"
        case "iPod2,1":
            return "iPod Touch Second Generation"
        case "iPod3,1":
            return "iPod Touch Third Generation"
        case "iPod4,1":
            return "iPod Touch Fourth Generation"
        case "iPod5,1":
            return "iPod Touch 5"
        case "iPod7,1":
            return "iPod Touch 6th Generation"
        case "AppleTV5,3":
            return "Apple TV"
        case "i386", "x86_64":
            return "Simulator"
        default:
            return identifier
        }
    }
}



