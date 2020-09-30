//
//  SideBarDataTableViewCell.swift
//  RhythmCor
//
//  Created by Bhavesh Jain iMac on 18/09/18.
//  Copyright © 2018 GlobeSyncTechnologies - Renish Dadhaniya. All rights reserved.
//

import UIKit

class SideBarDataTableViewCell: UITableViewCell {

    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLbl.font = UIFont(name: RDDataEngineClass.montserratFontSemiBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-2))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
