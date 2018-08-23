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
    var remainingDays: Int = 0
    var titleString :NSString = ""
    weak var delegate: CompletionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadUI(){

        titleString = "Your subscription will expire \(self.remainingDays) days from now" as NSString
        let range = (titleString).range(of: "\(self.remainingDays) days")
        let attribute = NSMutableAttributedString.init(string: titleString as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor as NSAttributedStringKey, value: UIColor.red, range:range)
        self.yourSubscriptionExpireLbl.text = titleString as String
        self.doYouWantMakePaymentLbl.text = "Do you want to make a payment and continue your subscription?"
    }

    @IBAction func yesBtnClicked(_ sender: Any) {
        self.dismiss(animated: true){
           self.delegate?.actionCompleted(isCompleted: true)
        }
        
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
