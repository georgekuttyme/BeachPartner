//
//  StartandEndDateViewController.swift
//  BeachPartner
//
//  Created by Admin on 14/08/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class StartandEndDateViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var subscriptionLbl: UILabel!
    @IBOutlet weak var subscriptionTypeLbl: UILabel!
    @IBOutlet weak var startAndEndDateView: UIView!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var start_DateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var end_DateLbl: UILabel!
    @IBOutlet weak var registrationFeeLbl: UILabel!
    @IBOutlet weak var registration_FeeLbl: UILabel!
    @IBOutlet weak var subscriptionFeeLbl: UILabel!
    @IBOutlet weak var subscription_FeeLbl: UILabel!
    @IBOutlet weak var amountPaidLbl: UILabel!
    @IBOutlet weak var amount_PaidLbl: UILabel!
    @IBOutlet weak var straightLineview: UIView!
    var paymentModel : GetSummaryPayment?
    var isFrom = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func setupUI(){
        if self.paymentModel?.userRegistered == "NO" && isFrom == "Subscription"{
            self.registration_FeeLbl.text = "$\(self.paymentModel?.regFee ?? 0)"
            self.subscription_FeeLbl.text = "$\(self.paymentModel?.monthlyCharge ?? 0)"
            self.amount_PaidLbl.text = "$\(self.paymentModel?.payableAmount ?? 0)"

        }else{
            self.subscription_FeeLbl.text = "$\(self.paymentModel?.monthlyCharge ?? 0)"
            self.registration_FeeLbl.isHidden = true
            self.amount_PaidLbl.isHidden = true
            self.amountPaidLbl.isHidden = true
            self.registrationFeeLbl.isHidden = true
            self.straightLineview.isHidden = true
        }
        self.start_DateLbl.text = self.paymentModel?.startDate
        self.end_DateLbl.text = self.paymentModel?.endDate
        self.subscriptionTypeLbl.text = self.paymentModel?.planCode
        
    }

    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func proceedBtnClicked(_ sender: Any) {
        dismiss(animated: false) {
            if self.isFrom == "Subscription"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "request-for-payment"), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "requestforpayment"), object: nil)
            }
        }
    }
    
}