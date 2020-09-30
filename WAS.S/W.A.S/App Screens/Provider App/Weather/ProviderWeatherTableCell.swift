//
//  ProviderKitTableCell.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 06/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderWeatherTableCell: UITableViewCell {

    @IBOutlet weak var lblDay:UILabel!
    @IBOutlet weak var imgWeather:UIImageView!
    
    @IBOutlet weak var lblTemperature:UILabel!
    @IBOutlet weak var lblWeather:UILabel!
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
