//
//  SideBarHeaderTableViewCell.swift
//  RhythmCor
//
//  Created by Bhavesh Jain iMac on 18/09/18.
//  Copyright © 2018 GlobeSyncTechnologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

class SideBarHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroungIV: UIImageView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userDetailsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userNameLbl.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()))
       
        self.userDetailsLbl.font = UIFont(name: RDDataEngineClass.montserratFontMedium, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        
        var profileSize : CGFloat  = 140.0
        
        if (UIScreen.main.bounds.size.width == 320) {
            profileSize = 100
        }else if (UIScreen.main.bounds.size.width == 375) {
            profileSize = 120
        }
        
         DispatchQueue.main.async {
         
//            self.profileIV.frame = CGRect(x: self.profileIV.frame.origin.x, y: self.profileIV.frame.origin.y, width: self.profileIV.frame.size.width, height: self.profileIV.frame.size.width)
            self.profileIV.frame = CGRect(x: ((self.frame.size.width-profileSize)/2), y: self.profileIV.frame.origin.y, width: profileSize, height: profileSize)
            self.profileIV.layer.cornerRadius = (self.profileIV.frame.size.width/2)
            self.profileIV.layer.masksToBounds = true
            self.profileIV.clipsToBounds = true
            self.profileIV.layer.borderWidth = 2.0
            self.profileIV.layer.borderColor = UIColor.white.cgColor
            
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    

}
