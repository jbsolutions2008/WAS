//
//  ClientSelfiewViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 30/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ClientSelfiewViewController: UIViewController {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var viewBg : UIView!
    
    var imgPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.imgView.sd_setImage(with: URL(string: RDDataEngineClass.ApplicationImageBaseURL + imgPath), placeholderImage: #imageLiteral(resourceName: "client-view-icon"))

    }
    
    //MARK:UIButton Actions
    @IBAction func btnClosePressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
