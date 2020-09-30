//
//  TripListTableCell.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 09/10/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Cosmos

class TripListTableCell: UITableViewCell {

    @IBOutlet weak var ratings : CosmosView!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblTripCharge : UILabel!
    
    @IBOutlet weak var lblTripTip : UILabel!
    @IBOutlet weak var vwBackground : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
