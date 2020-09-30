//
//  ProviderKitTableCell.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 06/08/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderKitTableCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var imgProduct:UIImageView!
    @IBOutlet weak var txtQty:UITextField!
    @IBOutlet weak var vwSizeContainer:UIView!
    
    @IBOutlet weak var bottomfromFirstLine:NSLayoutConstraint!
    @IBOutlet weak var bottomFromNewLine:NSLayoutConstraint!
    
    @IBOutlet var sizeButtons: [UIButton]!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
