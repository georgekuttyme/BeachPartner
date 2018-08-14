//
//  yourSubscriptionWillExpireViewController.swift
//  BeachPartner
//
//  Created by Admin on 14/08/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class yourSubscriptionWillExpireViewController: UIViewController {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var yourSubscriptionExpireLbl: UILabel!
    @IBOutlet weak var doYouWantMakePaymentLbl: UILabel!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
