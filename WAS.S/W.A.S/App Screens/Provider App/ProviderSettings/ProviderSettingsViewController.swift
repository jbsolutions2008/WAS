//
//  ProviderSettingsViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 16/11/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class ProviderSettingsViewController: UIViewController {
    
    let arrList = ["Trip List","Support"]
    let arrImageList = ["trip_list","support"]
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.init()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent!.title = "Setting"
        //        (self.parent as! ProviderTabBarController).btnEdit.tintColor = .clear
        //        (self.parent as! ProviderTabBarController).btnNearbyPlace.tintColor = .clear
        (self.parent as! ProviderTabBarController).navigationItem.rightBarButtonItems = [(self.parent as! ProviderTabBarController).btnMore]
    }
}

extension ProviderSettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PlaceTableViewCell
        cell.lblName.text = arrList[indexPath.row]
        cell.imgView.image = UIImage.init(named: arrImageList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 0 {
            let tripsVC = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "ProviderTripsViewController") as! ProviderTripsViewController
            
            let tabBar = self.tabBarController as! ProviderTabBarController
            tabBar.navigationController?.pushViewController(tripsVC, animated: true)
        } else if indexPath.row == 1 {
            let tripsVC = RDGlobalFunction.providerStory.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            
            let tabBar = self.tabBarController as! ProviderTabBarController
            tabBar.navigationController?.pushViewController(tripsVC, animated: true)
        }
    }
}
