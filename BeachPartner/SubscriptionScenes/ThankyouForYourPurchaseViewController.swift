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
    var transactionId = String()
    var status = String()
    var amount = Float()
    var isFrom = String()
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        print(isFrom,message)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func loadUI() {
        if status == "SUCCESS"{
            self.imageIcon.image = UIImage(named: "icon_tick")!
            self.thankyouLbl.text = message + "Transaction : " + "\(transactionId)"
            self.priceLbl.text = "$\(amount)"
        }else{
            self.imageIcon.image = UIImage(named: "icon_sad")!
            self.thankyouLbl.text = message
            self.priceLbl.text = status
            self.youHaveBeenChargedLbl.isHidden = true

        }
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        if status == "SUCCESS"{
            self.dismiss(animated: false) {
                if self.isFrom == "Subscription"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismiss"), object: nil)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissAdd-ons"), object: nil)
                }
            }
        }else{
            self.dismiss(animated: false,completion: nil)
        }
    }
    
}
