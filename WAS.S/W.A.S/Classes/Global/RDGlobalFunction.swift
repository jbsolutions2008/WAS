//
//  RDGlobalFunction.swift
//  BBall Shot Analyser
//
//  Created by Renish Dadhaniya on 25/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit



class RDGlobalFunction: NSObject {
    
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let lastWindow: UIWindow = UIApplication.shared.windows.last!
    static let rootViewController = (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
    static let MAIN_SCREEN = UIScreen.main
    static let MainScreenBounds:CGRect = MAIN_SCREEN.bounds
    
    static let allCountries : Array =  [
//                                        ["AF","Afghanistan","93"],
//                                        ["AX","Aland Islands","358"],
//                                        ["AL","Albania","355"],
//                                        ["DZ","Algeria","213"],
//                                        ["AS","American Samoa","1"],
//                                        ["AD","Andorra","376"],
//                                        ["AO","Angola","244"],
//                                        ["AI","Anguilla","1"],
//                                        ["AQ","Antarctica","672"],
//                                        ["AG","Antigua and Barbuda","1"],
//                                        ["AR","Argentina","54"],
//                                        ["AM","Armenia","374"],
//                                        ["AW","Aruba","297"],
//                                        ["AU","Australia","61"],
//                                        ["AT","Austria","43"],
//                                        ["AZ","Azerbaijan","994"],
//                                        ["BS","Bahamas","1"],
//                                        ["BH","Bahrain","973"],
//                                        ["BD","Bangladesh","880"],
//                                        ["BB","Barbados","1"],
//                                        ["BY","Belarus","375"],
//                                        ["BE","Belgium","32"],
//                                        ["BZ","Belize","501"],
//                                        ["BJ","Benin","229"],
//                                        ["BM","Bermuda","1"],
//                                        ["BT","Bhutan","975"],
//                                        ["BO","Bolivia","591"],
//                                        ["BA","Bosnia and Herzegovina","387"],
//                                        ["BW","Botswana","267"],
//                                        ["BV","Bouvet Island","47"],
//                                        ["BQ","BQ","599"],
//                                        ["BR","Brazil","55"],
//                                        ["IO","British Indian Ocean Territory","246"],
//                                        ["VG","British Virgin Islands","1"],
//                                        ["BN","Brunei Darussalam","673"],
//                                        ["BG","Bulgaria","359"],
//                                        ["BF","Burkina Faso","226"],
//                                        ["BI","Burundi","257"],
//                                        ["KH","Cambodia","855"],
//                                        ["CM","Cameroon","237"],
//                                        ["CA","Canada","1"],
//                                        ["CV","Cape Verde","238"],
//                                        ["KY","Cayman Islands","345"],
//                                        ["CF","Central African Republic","236"],
//                                        ["TD","Chad","235"],
//                                        ["CL","Chile","56"],
//                                        ["CN","China","86"],
//                                        ["CX","Christmas Island","61"],
//                                        ["CC","Cocos (Keeling) Islands","61"],
//                                        ["CO","Colombia","57"],
//                                        ["KM","Comoros","269"],
//                                        ["CG","Congo (Brazzaville)","242"],
//                                        ["CD","Congo, Democratic Republic of the","243"],
//                                        ["CK","Cook Islands","682"],
//                                        ["CR","Costa Rica","506"],
//                                        ["CI","Côte d'Ivoire","225"],
//                                        ["HR","Croatia","385"],
//                                        ["CU","Cuba","53"],
//                                        ["CW","Curacao","599"],
//                                        ["CY","Cyprus","537"],
//                                        ["CZ","Czech Republic","420"],
//                                        ["DK","Denmark","45"],
//                                        ["DJ","Djibouti","253"],
//                                        ["DM","Dominica","1"],
//                                        ["DO","Dominican Republic","1"],
//                                        ["EC","Ecuador","593"],
//                                        ["EG","Egypt","20"],
//                                        ["SV","El Salvador","503"],
//                                        ["GQ","Equatorial Guinea","240"],
//                                        ["ER","Eritrea","291"],
//                                        ["EE","Estonia","372"],
//                                        ["ET","Ethiopia","251"],
//                                        ["FK","Falkland Islands (Malvinas)","500"],
//                                        ["FO","Faroe Islands","298"],
//                                        ["FJ","Fiji","679"],
//                                        ["FI","Finland","358"],
//                                        ["FR","France","33"],
//                                        ["GF","French Guiana","594"],
//                                        ["PF","French Polynesia","689"],
//                                        ["TF","French Southern Territories","689"],
//                                        ["GA","Gabon","241"],
//                                        ["GM","Gambia","220"],
//                                        ["GE","Georgia","995"],
//                                        ["DE","Germany","49"],
//                                        ["GH","Ghana","233"],
//                                        ["GI","Gibraltar","350"],
//                                        ["GR","Greece","30"],
//                                        ["GL","Greenland","299"],
//                                        ["GD","Grenada","1"],
//                                        ["GP","Guadeloupe","590"],
//                                        ["GU","Guam","1"],
//                                        ["GT","Guatemala","502"],
//                                        ["GG","Guernsey","44"],
//                                        ["GN","Guinea","224"],
//                                        ["GW","Guinea-Bissau","245"],
//                                        ["GY","Guyana","595"],
//                                        ["HT","Haiti","509"],
//                                        ["VA","Holy See (Vatican City State)","379"],
//                                        ["HN","Honduras","504"],
//                                        ["HK","Hong Kong, Special Administrative Region of China","852"],
//                                        ["HU","Hungary","36"],
//                                        ["IS","Iceland","354"],
                                        ["IN","India","91"],
//                                        ["ID","Indonesia","62"],
//                                        ["IR","Iran, Islamic Republic of","98"],
//                                        ["IQ","Iraq","964"],
//                                        ["IE","Ireland","353"],
//                                        ["IM","Isle of Man","44"],
//                                        ["IL","Israel","972"],
//                                        ["IT","Italy","39"],
//                                        ["JM","Jamaica","1"],
//                                        ["JP","Japan","81"],
//                                        ["JE","Jersey","44"],
//                                        ["JO","Jordan","962"],
//                                        ["KZ","Kazakhstan","77"],
//                                        ["KE","Kenya","254"],
//                                        ["KI","Kiribati","686"],
//                                        ["KP","Korea, Democratic People's Republic of","850"],
//                                        ["KR","Korea, Republic of","82"],
//                                        ["KW","Kuwait","965"],
//                                        ["KG","Kyrgyzstan","996"],
//                                        ["LA","Lao PDR","856"],
//                                        ["LV","Latvia","371"],
//                                        ["LB","Lebanon","961"],
//                                        ["LS","Lesotho","266"],
//                                        ["LR","Liberia","231"],
//                                        ["LY","Libya","218"],
//                                        ["LI","Liechtenstein","423"],
//                                        ["LT","Lithuania","370"],
//                                        ["LU","Luxembourg","352"],
//                                        ["MO","Macao, Special Administrative Region of China","853"],
//                                        ["MK","Macedonia, Republic of","389"],
//                                        ["MG","Madagascar","261"],
//                                        ["MW","Malawi","265"],
//                                        ["MY","Malaysia","60"],
//                                        ["MV","Maldives","960"],
//                                        ["ML","Mali","223"],
//                                        ["MT","Malta","356"],
//                                        ["MH","Marshall Islands","692"],
//                                        ["MQ","Martinique","596"],
//                                        ["MR","Mauritania","222"],
//                                        ["MU","Mauritius","230"],
//                                        ["YT","Mayotte","262"],
//                                        ["MX","Mexico","52"],
//                                        ["FM","Micronesia, Federated States of","691"],
//                                        ["MD","Moldova","373"],
//                                        ["MC","Monaco","377"],
//                                        ["MN","Mongolia","976"],
//                                        ["ME","Montenegro","382"],
//                                        ["MS","Montserrat","1"],
//                                        ["MA","Morocco","212"],
//                                        ["MZ","Mozambique","258"],
//                                        ["MM","Myanmar","95"],
//                                        ["NA","Namibia","264"],
//                                        ["NR","Nauru","674"],
//                                        ["NP","Nepal","977"],
//                                        ["NL","Netherlands","31"],
//                                        ["AN","Netherlands Antilles","599"],
//                                        ["NC","New Caledonia","687"],
//                                        ["NZ","New Zealand","64"],
//                                        ["NI","Nicaragua","505"],
//                                        ["NE","Niger","227"],
//                                        ["NG","Nigeria","234"],
//                                        ["NU","Niue","683"],
//                                        ["NF","Norfolk Island","672"],
//                                        ["MP","Northern Mariana Islands","1"],
//                                        ["NO","Norway","47"],
//                                        ["OM","Oman","968"],
//                                        ["PK","Pakistan","92"],
//                                        ["PW","Palau","680"],
//                                        ["PS","Palestinian Territory, Occupied","970"],
//                                        ["PA","Panama","507"],
//                                        ["PG","Papua New Guinea","675"],
//                                        ["PY","Paraguay","595"],
//                                        ["PE","Peru","51"],
//                                        ["PH","Philippines","63"],
//                                        ["PN","Pitcairn","872"],
//                                        ["PL","Poland","48"],
//                                        ["PT","Portugal","351"],
//                                        ["PR","Puerto Rico","1"],
//                                        ["QA","Qatar","974"],
//                                        ["RE","Réunion","262"],
//                                        ["RO","Romania","40"],
//                                        ["RU","Russian Federation","7"],
//                                        ["RW","Rwanda","250"],
//                                        ["SH","Saint Helena","290"],
//                                        ["KN","Saint Kitts and Nevis","1"],
//                                        ["LC","Saint Lucia","1"],
//                                        ["PM","Saint Pierre and Miquelon","508"],
//                                        ["VC","Saint Vincent and Grenadines","1"],
//                                        ["BL","Saint-Barthélemy","590"],
//                                        ["MF","Saint-Martin (French part)","590"],
//                                        ["WS","Samoa","685"],
//                                        ["SM","San Marino","378"],
//                                        ["ST","Sao Tome and Principe","239"],
//                                        ["SA","Saudi Arabia","966"],
//                                        ["SN","Senegal","221"],
//                                        ["RS","Serbia","381"],
//                                        ["SC","Seychelles","248"],
//                                        ["SL","Sierra Leone","232"],
//                                        ["SG","Singapore","65"],
//                                        ["SX","Sint Maarten","1"],
//                                        ["SK","Slovakia","421"],
//                                        ["SI","Slovenia","386"],
//                                        ["SB","Solomon Islands","677"],
//                                        ["SO","Somalia","252"],
//                                        ["ZA","South Africa","27"],
//                                        ["GS","South Georgia and the South Sandwich Islands","500"],
//                                        ["SS​","South Sudan","211"],
//                                        ["ES","Spain","34"],
//                                        ["LK","Sri Lanka","94"],
//                                        ["SD","Sudan","249"],
//                                        ["SR","Suriname","597"],
//                                        ["SJ","Svalbard and Jan Mayen Islands","47"],
//                                        ["SZ","Swaziland","268"],
//                                        ["SE","Sweden","46"],
//                                        ["CH","Switzerland","41"],
//                                        ["SY","Syrian Arab Republic (Syria)","963"],
//                                        ["TW","Taiwan, Republic of China","886"],
//                                        ["TJ","Tajikistan","992"],
//                                        ["TZ","Tanzania, United Republic of","255"],
//                                        ["TH","Thailand","66"],
//                                        ["TL","Timor-Leste","670"],
//                                        ["TG","Togo","228"],
//                                        ["TK","Tokelau","690"],
//                                        ["TO","Tonga","676"],
//                                        ["TT","Trinidad and Tobago","1"],
//                                        ["TN","Tunisia","216"],
//                                        ["TR","Turkey","90"],
//                                        ["TM","Turkmenistan","993"],
//                                        ["TC","Turks and Caicos Islands","1"],
//                                        ["TV","Tuvalu","688"],
//                                        ["UG","Uganda","256"],
//                                        ["UA","Ukraine","380"],
//                                        ["AE","United Arab Emirates","971"],
//                                        ["GB","United Kingdom","44"],
                                        ["US","United States of America","1"]
        //,["UY","Uruguay","598"],
//                                        ["UZ","Uzbekistan","998"],
//                                        ["VU","Vanuatu","678"],
//                                        ["VE","Venezuela (Bolivarian Republic of)","58"],
//                                        ["VN","Viet Nam","84"],
//                                        ["VI","Virgin Islands, US","1"],
//                                        ["WF","Wallis and Futuna Islands","681"],
//                                        ["EH","Western Sahara","212"],
//                                        ["YE","Yemen","967"],
//                                        ["ZM","Zambia","260"],
//                                        ["ZW","Zimbabwe","263"]
    ]
   
    //Universal Story
    static let universalStory = UIStoryboard(name: "Main", bundle: Bundle.main)
    //Client Story
    static let clientStory = UIStoryboard(name: "Client", bundle: Bundle.main)
    //Provider Story
    static let providerStory = UIStoryboard(name: "Provider", bundle: Bundle.main)
    
    
    
    //Load plist File
    class func loadPlistDataFile() -> NSDictionary {
        
        var infoDict: NSDictionary = NSDictionary()
        
        if let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist"){
            infoDict = NSDictionary(contentsOfFile: plistPath)!
        }
        return infoDict
    }
    
    
    //Store Value in Default
    class func setValueInUserDefault(iSDefaultValue : String, iSDefaultKey: String){
        UserDefaults.standard.set(iSDefaultValue, forKey: iSDefaultKey)
        UserDefaults.standard.synchronize()
    }
    //Return Value from Default
    class func getValueFromUserDefault(iSDefaultKey: String) -> String{
        return UserDefaults.standard.value(forKey: iSDefaultKey) as? String ?? ""
    }
    
    //store Int in Default
    class func setIntInUserDefault(iSDefaultValue : Int, iSDefaultKey: String){
        UserDefaults.standard.set(iSDefaultValue, forKey: iSDefaultKey)
        UserDefaults.standard.synchronize()
    }
    
    //Return Int from Default
    class func getIntFromUserDefault(iSDefaultKey: String) -> Int{
        return UserDefaults.standard.value(forKey: iSDefaultKey) as? Int ?? -1
    }
    

    //Store Bool Key and Value in Default
    class func setBoolValueInUserDefault(iSDefaultValue : Bool, iSDefaultKey: String){
        UserDefaults.standard.set(iSDefaultValue, forKey: iSDefaultKey)
        UserDefaults.standard.synchronize()
    }
    //Return Bool Key From Default
    class func getBoolValueFromUserDefault(iSDefaultKey: String) -> Bool {
        return UserDefaults.standard.value(forKey: iSDefaultKey) as? Bool ?? false
    }

    
    //Store Dictionary in UserDefault
    class func setObjectInUserDefault(iSDefaultValue : NSDictionary, iSDefaultKey: String) {
        UserDefaults.standard.set(iSDefaultValue, forKey: iSDefaultKey)
        UserDefaults.standard.synchronize()
    }
    //Store Dictionary in UserDefault
    class func getObjectFromUserDefault(iSDefaultKey: String) -> NSDictionary {
        return UserDefaults.standard.value(forKey: iSDefaultKey) as! NSDictionary
    }

    
    //Store Mediicne In Array
    class func setArrayInUserDefault(iSArrayValue : NSArray, iSDefaultKey: String) {
        UserDefaults.standard.set(iSArrayValue, forKey: iSDefaultKey)
        UserDefaults.standard.synchronize()
    }
    //Store Dictionary in UserDefault
    class func getArrayFromUserDefault(iSDefaultKey: String) -> NSArray {
        return UserDefaults.standard.value(forKey: iSDefaultKey) as! NSArray
    }
    
    
    
    static let miniRequiredCharacterForPassword = "Min. 8 characters required"
    
    /* This function is used for Email Address validation Field */
    class func isValidEmail(_ emailStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailCheck.evaluate(with: emailStr)
        return result
    }
    
    
    /* This function is used for Mobile Number validation Field */
    class func iSValidContactNumber(_ numberStr:String) -> Bool {
        
        let numberRegEx = "^\\(?([0-9]{3})\\)?[-.]?([0-9]{3})[-.]?([0-9]{4})$"
        let numberCheck = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let result = numberCheck.evaluate(with: numberStr)
        return result
    }
    
    class func checkPasswordHasSufficientComplexity( text : String) -> Bool{
        
        let textStr = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        let numberRegEx =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
//        let numberCheck = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
//        let result = numberCheck.evaluate(with: textStr)
//        return result
        
        if textStr.count <= 7 {
            return false
        }else{
            return true
        }

    }
    
    
    //Make Global Function for Size of Button Whole Class
    class func fontSizeAccordingToDeviceResolution() -> Float {
        
        if UIScreen.main.bounds.size.width == 320 {
            return 20.0
        }else if UIScreen.main.bounds.size.width == 375 {
            return 22.0
        }else {
            return 23.0
        }
        
    }
    
    
    class func sideBarWidthSizeAccordingToScreen() -> CGFloat {
        
        if UIScreen.main.bounds.size.width == 320 {
            return 250.0
        }else if UIScreen.main.bounds.size.width == 375 {
            return 280.0
        }else {
            return 320.0
        }
        
    }
    
    
   class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    //Relpace blank to Null
    class func removeNullFromDict (dict : NSMutableDictionary) -> NSMutableDictionary {
        
        let dic = dict;
        
        for (key, value) in dict {
            
            let val : NSObject = value as! NSObject;
            
            if(val.isEqual(NSNull()) || val.isEqual("(null)") || val.isEqual("<null>") || val.isEqual("null")){ //|| val.isEqual("nil") || val.isEqual("Nil")
                dic.setValue("", forKey: (key as? String)!)
            }else{
                dic.setValue(value, forKey: key as! String)
            }
            
        }
        
        return dic;
    }
    
    
    class func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let _ = dateFormatterGet.date(from: dateString) {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            return true
        } else {
            // Invalid date
            return false
        }
    }
    
    
    class func convertAnyDataToJSONString(dataObject : Any) -> String{
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dataObject, options: [])
        return String(data: jsonData!, encoding: String.Encoding.utf8)!

    }
    
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    class func makeCall(phoneNumber: String)  {
        
        let phoneUrl = URL(string: "telprompt://\(phoneNumber)")
        let phoneFallbackUrl = URL(string: "tel://\(phoneNumber)")
        if(phoneUrl != nil && UIApplication.shared.canOpenURL(phoneUrl!)) {
            UIApplication.shared.open(phoneUrl!, options:[:]) { (success) in
                if(!success) {
                    // Show an error message: Failed opening the url
                }
            }
        } else if(phoneFallbackUrl != nil && UIApplication.shared.canOpenURL(phoneFallbackUrl!)) {
            UIApplication.shared.open(phoneFallbackUrl!, options:[:]) { (success) in
                if(!success) {
                    // Show an error message: Failed opening the url
                }
            }
        } else {
            // Show an error message: Your device can not do phone calls.
        }
    }
    
    //Generate QR Code
    class func generateQRCode(from string: String) -> UIImage? {

        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            //Color change
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter!.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            colorFilter!.setValue(CIColor(red: 1, green: 0, blue: 0), forKey: "inputColor0")
            
            let qrCodeImage = colorFilter!.outputImage?.transformed(by: transform)

            let size = qrCodeImage!.extent.integral
            let output = CGSize(width: 300, height: 300)
            let matrix = CGAffineTransform(scaleX: output.width / size.width, y: output.height / size.height)
            UIGraphicsBeginImageContextWithOptions(output, false, 0)
            defer { UIGraphicsEndImageContext() }
            UIImage(ciImage: qrCodeImage!.transformed(by: matrix))
            .draw(in: CGRect(origin: .zero, size: output))
            return UIGraphicsGetImageFromCurrentImageContext()
            
        }
        
        return nil
        
    }
    
    
    
    //check url and return as per requirement
//    class func chekProfileURL(url: String) -> String {
//        if url.isValidForUrl() {
//            return url
//        } else {
//            return PIC_PREFIX+url
//        }
//    }
    
    class func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    //Set Radius to the View
    class func setCornerRadius(any: UIView, cornerRad: CGFloat, borderWidth: CGFloat, borderColor: UIColor){
        any.clipsToBounds = true
        any.layer.masksToBounds = true
        any.layer.cornerRadius = cornerRad
        any.layer.borderColor = borderColor.cgColor
        any.layer.borderWidth = borderWidth
    }
    
    
    //Function for Attributes
    class func setAttributes(color: UIColor, font: UIFont) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
    }
    
    
    class func documentPathWithFileName(fileName : String!) -> URL{
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        return fileURL
    }
    
    
    //Check null
    static func CheckNullString(value : AnyObject) -> String {
        var str = String.init(format: "%ld", value as! CVarArg)
        if let v = value as? NSString{
            str = v as String;
        }else if let v = value as? NSNumber{
            str = v.stringValue
        }else if let v = value as? Double{
            str = String.init(format: "%ld", v);
        }else if let v = value as? Int{
            str = String.init(format: "%ld", v);
        }
        else if value is NSNull{
            str = "";
        }
        else{
            str = ""
        }
        return str;
    }
    
    
    //to get date and time
    class func getDateAndTime(date: String, dateCode: Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if self.isValidDate(dateString: date) {
            let dateDate = dateFormatter.date(from: date)
            switch dateCode {
            case 1:
                let dateFor1 = DateFormatter()
                dateFor1.dateFormat = "EEE, dd MMM"
                let newDate = dateFor1.string(from: dateDate!)
                return newDate
            case 2:
                let dateFor2 = DateFormatter()
                dateFor2.dateFormat = "hh:mm a"
                let newTime = dateFor2.string(from: dateDate!)
                return newTime
            case 3:
                let dateFor3 = DateFormatter()
                dateFor3.dateFormat = "HH:mm:ss"
                let time = dateFor3.string(from: dateDate!)
                return time
            case 4:
                let dateFor4 = DateFormatter()
                dateFor4.dateFormat = "dd"
                let day = dateFor4.string(from: dateDate!)
                return day
            case 5:
                let dateFor5 = DateFormatter()
                dateFor5.dateFormat = "yyyy-MM-dd"
                let date = dateFor5.string(from: dateDate!)
                return date
            case 6:
                let dateFor6 = DateFormatter()
                dateFor6.dateFormat = "EEE, MMM dd"
                let newDate = dateFor6.string(from: dateDate!)
                return newDate
            case 7:
                let dateFor6 = DateFormatter()
                dateFor6.dateFormat = "dd MMM"
                let newDate = dateFor6.string(from: dateDate!)
                return newDate
            case 8:
                let dateFor7 = DateFormatter()
                dateFor7.dateFormat = "dd MMM yyyy"
                let newDate = dateFor7.string(from: dateDate!)
                return newDate
            case 9:
                let dateFor8 = DateFormatter()
                dateFor8.dateFormat = "MMM dd, yyyy"
                let newDate = dateFor8.string(from: dateDate!)
                return newDate
            default:
                return ""
            }
        } else {
            return ""
        }
    }
    
    
    //get day from date
    class func getDayOfWeekString(today:String)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return nil
        }
    }
    
    
    
   class func dateStringFromUnixTime(unixTime: Double) -> String {
        
        let date = Date.init(timeIntervalSince1970: unixTime)
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "dd/MM/yyyy"
        return dateformatter.string(from: date)
    }
    
    class func timeStringFromUnixTime(unixTime: Double) -> String {
     //   let date = Date.init(timeIntervalSince1970: unixTime)
        let  date = Date.init(timeIntervalSinceReferenceDate: unixTime)
        
        let date1 = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()+5400))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
       // dateformatter.timeZone =  TimeZone(secondsFromGMT: 0)
        return dateformatter.string(from:date1)
    }
    
    class func dayStringFromTime(unixTime: Double,isShort:Bool) -> String {
        let date = Date.init(timeIntervalSince1970: unixTime)
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.current
      
        if isShort {
             dateformatter.dateFormat = "EEE"
        } else {
             dateformatter.dateFormat = "EEEE"
        }
       
       
        return dateformatter.string(from: date)
    }
    
    
    //to calculate difference between dates
    class func calculateDifferenceBetweenDates(fromDate: String, tag: Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: fromDate)
        let now = Date()
        if tag == 1 {
            return self.timeAgoSinceDate(date!, currentDate: now, numericDates: true, tag: tag)
        } else {
            return self.timeAgoSinceDate(date!, currentDate: now, numericDates: false, tag: tag)
        }
    }
    
    
    //calculate time of post
    class func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool, tag: Int) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        switch tag {
        case 1: //Remindar
            if date >= currentDate {
//                self.remindarBGColor = self.mainAppColor
                if (components.year! >= 2) {
                    return "\(components.year!) years"
                } else if (components.year! >= 1){
                    if (numericDates){
                        return "1 Year"
                    } else {
                        return ""
                    }
                } else if (components.month! >= 2) {
                    return "\(components.month!) months"
                } else if (components.month! >= 1){
                    if (numericDates){
                        return "1 Month"
                    } else {
                        return ""
                    }
                } else if (components.weekOfYear! >= 2) {
                    return "\(components.weekOfYear!) weeks"
                } else if (components.weekOfYear! >= 1){
                    if (numericDates){
                        return "1 Week"
                    } else {
                        return ""
                    }
                } else if (components.day! >= 2) {
                    return "\(components.day!) days"
                } else if (components.day! >= 1){
                    if (numericDates){
                        return "1 Day"
                    } else {
                        return "Tomorrow"
                    }
                } else if (components.hour! >= 2) {
                    return "\(components.hour!) hrs"
                } else if (components.hour! >= 1){
                    if (numericDates){
                        return "1 HR"
                    } else {
                        return "An Hour"
                    }
                } else if (components.minute! >= 2) {
                    return "\(components.minute!) min"
                } else if (components.minute! >= 1){
                    if (numericDates){
                        return "1 Min"
                    } else {
                        return "A Minute ago"
                    }
                } else if (components.second! >= 3) {
                    return "\(components.second!) secs"
                } else {
                    return "Just Now"
                }
            } else {
//                self.remindarBGColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                if (components.year! >= 2) {
                    return "\(components.year!) years ago"
                } else if (components.year! >= 1){
                    if (numericDates){
                        return "1 Year"
                    } else {
                        return "Last Year"
                    }
                } else if (components.month! >= 2) {
                    return "\(components.month!) months ago"
                } else if (components.month! >= 1){
                    if (numericDates){
                        return "1 Month Ago"
                    } else {
                        return "Last Month"
                    }
                } else if (components.weekOfYear! >= 2) {
                    return "\(components.weekOfYear!) weeks ago"
                } else if (components.weekOfYear! >= 1){
                    if (numericDates){
                        return "1 Week Ago"
                    } else {
                        return "Last Week"
                    }
                } else if (components.day! >= 2) {
                    return "\(components.day!) days ago"
                } else if (components.day! >= 1){
                    if (numericDates){
                        return "1 Day Ago"
                    } else {
                        return "Yesterday"
                    }
                } else if (components.hour! >= 2) {
                    return "\(components.hour!) hrs ago"
                } else if (components.hour! >= 1){
                    if (numericDates){
                        return "1 HR Ago"
                    } else {
                        return "An Hour Ago"
                    }
                } else if (components.minute! >= 2) {
                    return "\(components.minute!) min ago"
                } else if (components.minute! >= 1){
                    if (numericDates){
                        return "1 Min Ago"
                    } else {
                        return "A Minute Ago"
                    }
                } else if (components.second! >= 3) {
                    return "\(components.second!) Secs Ago"
                } else {
                    return "Just Now"
                }
            }
        case 2: //to do list post
            if (components.year! >= 2) {
                return "\(components.year!) Years Ago"
            } else if (components.year! >= 1){
                if (numericDates){
                    return "1 Year Ago"
                } else {
                    return "Last Year"
                }
            } else if (components.month! >= 2) {
                return "\(components.month!) months ago"
            } else if (components.month! >= 1){
                if (numericDates){
                    return "1 Month Ago"
                } else {
                    return "Last Month"
                }
            } else if (components.weekOfYear! >= 2) {
                return "\(components.weekOfYear!) weeks ago"
            } else if (components.weekOfYear! >= 1){
                if (numericDates){
                    return "1 Week Ago"
                } else {
                    return "Last Week"
                }
            } else if (components.day! >= 2) {
                return "\(components.day!) days ago"
            } else if (components.day! >= 1){
                if (numericDates){
                    return "1 Day Ago"
                } else {
                    return "Yesterday"
                }
            } else if (components.hour! >= 2) {
                return "\(components.hour!) hours ago"
            } else if (components.hour! >= 1){
                if (numericDates){
                    return "1 Hour Ago"
                } else {
                    return "An Hour Ago"
                }
            } else if (components.minute! >= 2) {
                return "\(components.minute!) min ago"
            } else if (components.minute! >= 1){
                if (numericDates){
                    return "1 Min Ago"
                } else {
                    return "a Minute Ago"
                }
            } else if (components.second! >= 3) {
                return "\(components.second!) secs ago"
            } else {
                return "Just Now"
            }
        default:
            return ""
        }
    }
    

    //check url and return as per requirement
    class func chekProfileURL(url: String) -> String {
        if url.isValidForUrl() {
            return url
        } else {
            return ""
        }
    }
    
    class func scheduleNotification(notificationType: String,notificationBody: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = notificationBody
        content.sound = UNNotificationSound.default
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = notificationType
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    
    //Sign Out and Go Back to Main View Controller
    class func goBackToMainViewController(currentVC : UIViewController) {
        //Clear flag
        
        //GlobalFunctions.setDefaultNavigationBar()
        let mainIntialVC = RDGlobalFunction.universalStory.instantiateInitialViewController() //instantiateViewController(withIdentifier: "MainVC")
        currentVC.dismiss(animated: true) { () -> Void in
            UIApplication.shared.keyWindow?.rootViewController = mainIntialVC
        }
    }

    
    //Open Client Dashboard Screen
    class func moveForwardToClientDashboardViewController(currentVC : UIViewController,animated:Bool){
        
        let clientDashboardNavigationVC: ClientDashboardNavigationController = RDGlobalFunction.clientStory.instantiateViewController(withIdentifier: "ClientDashboardNavigationVC") as! ClientDashboardNavigationController
        
        clientDashboardNavigationVC.modalPresentationStyle = .fullScreen
        
        if animated {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            currentVC.view.window?.layer.add(transition, forKey: nil)
        }
        currentVC.present(clientDashboardNavigationVC, animated: false)
    }
    
    
    //Open Provider Dashboard Screen
    class func moveForwardToProviderDashboardViewController(currentVC : UIViewController,animated:Bool){
        
        let providerDashboardNavigationVC: ProviderNavigationViewController = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderNavigationVC") as! ProviderNavigationViewController
        providerDashboardNavigationVC.modalPresentationStyle = .fullScreen
        
        if animated {
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            currentVC.view.window?.layer.add(transition, forKey: nil)
        }
        currentVC.present(providerDashboardNavigationVC, animated: false)
    }
    
    class func image(_ originalImage: UIImage?, scaledTo size: CGSize) -> UIImage? {
        //avoid redundant drawing
        if (originalImage?.size.equalTo(size))! {
            return originalImage
        }
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
        
        //draw
        originalImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        //capture resultant image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return image
        return image
        
    }
}





//Date Function
extension Date {
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    
    var setDateToStartHourOfTheDay : Date? {
        var startComp: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:self)
        startComp.hour = 0
        startComp.minute = 0
        startComp.second = 0
        startComp.timeZone = TimeZone.current
        
        return Calendar.current.date(from: startComp)!
    }
    
    var setDateToEndHourOfTheDay : Date? {
        var endComp: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from:self)
        endComp.hour = 23
        endComp.minute = 59
        endComp.second = 59
        endComp.timeZone = TimeZone.current
        
        return Calendar.current.date(from: endComp)!
    }
    
    
    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }
    
    private func getTimeAgoSinceNow() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year ago" : "\(interval)" + " years ago"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month ago" : "\(interval)" + " months ago"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day ago" : "\(interval)" + " days ago"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour ago" : "\(interval)" + " hours ago"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute ago" : "\(interval)" + " minutes ago"
        }
        
        return "a moment ago"
    }
    
    
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    
    //Get Minutes Interval between Two Dates
    func getMinuteIntervalDifferenceBetweenTwoDate(startDate : Date, endDate : Date) -> Int {
        
        let minuteInterval = Calendar.current.dateComponents([.minute], from: startDate, to: endDate).minute!
        
        return minuteInterval
    }
    
    
    
}


//extension UIImageView{
//
//    @IBInspectable var imageColor: UIColor! {
//        set {
//            super.tintColor = newValue
//        }
//        get {
//            return super.tintColor
//        }
//    }
//
//    var imageScaleURL : String {
//        get {
//            return ""
//        } set {
//            self.sd_setImage(with: URL(string: newValue), completed: { (image, error, cacheType, url) in
//                if (image != nil){
//                    DispatchQueue.main.async {
//                        self.image = image
//                    }
//                } else {
//                    DispatchQueue.main.async {
//
//                    }
//                }
//            })
//        }
//    }
//}


class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}


extension String {
    
    func isValidForUrl()->Bool{
        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyFormatting() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: (self as NSString).doubleValue))!
        
        //return NumberFormatter.localizedString(from: NSNumber(value: (self as NSString).doubleValue), number: NumberFormatter.Style.currency)
    }
}


extension UIView {
    func addShadowView(width:CGFloat=2, height:CGFloat=2, Opacidade:Float=0.5, maskToBounds:Bool=false, radius:CGFloat=1){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
}



//Bundle Extension
extension Bundle {
    // Name of the app - title under the icon.
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
}


//Compressed Image Extension
extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1 = self.pngData()
        let data2 = image.pngData()
        return data1 == data2
    }
    
    }

//extension String {
//    var iSValidPassword: Bool {
////        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
//
//        return !isEmpty && range(of: "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$", options: .regularExpression) == nil
//    }
//}


/*
^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$



    ^                         Start anchor
(?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
(?=.*[!@#$&*])            Ensure string has one special case letter.
(?=.*[0-9].*[0-9])        Ensure string has two digits.
(?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
.{8}                      Ensure string is of length 8.
$                         End anchor.

*/

