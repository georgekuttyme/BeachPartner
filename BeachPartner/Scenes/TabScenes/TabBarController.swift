//
//  TabBarController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 02/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

//    @IBOutlet weak var tabbarmsenu: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.selectedIndex = 2
        self.selectedIndex = 0
    }

    override func viewDidAppear(_ animated: Bool) {
//        self.selectedIndex = 0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
