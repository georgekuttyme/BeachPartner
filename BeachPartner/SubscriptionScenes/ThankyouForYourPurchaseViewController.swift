//
//  ThankyouForYourPurchaseViewController.swift
//  BeachPartner
//
//  Created by Admin on 14/08/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class ThankyouForYourPurchaseViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var youHaveBeenChargedLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var thankyouLbl: UILabel!
    
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
