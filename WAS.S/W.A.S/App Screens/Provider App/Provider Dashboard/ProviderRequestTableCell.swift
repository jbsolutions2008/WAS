//
//  ProviderRequestTableCell.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 06/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderRequestTableCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDistance:UILabel!
    //progress view
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnAccept:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
