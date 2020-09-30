//
//  ClientDashboardNavigationController.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 23/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientDashboardNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.titleTextAttributes = RDGlobalFunction.setAttributes(color: .white, font: UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()))!)
        
//        let dic = GlobalFunctions.getInformation(InfoStr: "responseDic") as! NSDictionary
//        GlobalFunctions.setNavigationBar(themeID: (dic.value(forKey: "theme_id") as! NSString).integerValue)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.navigationBar.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: 60))
        
        UINavigationBar.appearance().tintColor = RDDataEngineClass.primaryColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()))!]
        UINavigationBar.appearance().barTintColor = RDDataEngineClass.primaryColor
        UINavigationBar.appearance().isTranslucent = false
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
