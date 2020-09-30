//
//  CardListTableCell.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 20/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class CardListTableCell: UITableViewCell {

    @IBOutlet weak var imgCard : UIImageView!
    @IBOutlet weak var lblCardText : UILabel!
    @IBOutlet weak var imgCheckmark : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
