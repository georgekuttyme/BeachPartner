//
//  SubscriptionViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 30/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

enum SubscriptionType: String {
    case Free = "FREE"
    case Lite = "LITE"
    case Standard = "STANDARD"
    case Recruiting  = "RECRUITING"
   
    func color() -> UIColor {
        switch self {
        case .Lite:
            return UIColor(red: 90.0/255.0, green: 150.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        case .Standard:
            return UIColor(red: 110.0/255.0, green: 25.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        case .Recruiting:
            return UIColor(red: 25.0/255.0, green: 145.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        default: // Free
            return UIColor(red: 50.0/255.0, green: 140.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        }
    }
}


class SubscriptionViewController: UIViewController {
    
    var subscriptionPlan: SubscriptionPlanModel?
    var transactionId:String = ""
    
    @IBOutlet weak var subscriptionTypeView: UIView!
    @IBOutlet weak var subsciptionPriceBgView: UIView!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var subscriptionPriceLabel: UILabel!
    @IBOutlet weak var registrationFeeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    var totalAmount = Float()
    var paymentModel : GetSummaryPayment?
// MARK: -- View Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(requestForSubscribe(notification:)), name:NSNotification.Name(rawValue: "request-for-payment"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(exitPopup(notification:)), name:NSNotification.Name(rawValue: "dismiss"), object: nil)

    }
    @objc func exitPopup(notification: NSNotification){
        self.dismiss(animated: false){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismiss-action"), object: nil)
        }
    }

    private func setupView() {
        
        guard let subscriptionPlan = subscriptionPlan else {
            return
        }
        
        switch subscriptionPlan.name {
            
        case SubscriptionType.Lite.rawValue:
            subscriptionTypeView.backgroundColor = SubscriptionType.Lite.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Lite.color()
            backButton.backgroundColor = SubscriptionType.Lite.color()
            actionButton.backgroundColor = SubscriptionType.Lite.color()

        case SubscriptionType.Standard.rawValue:
            subscriptionTypeView.backgroundColor = SubscriptionType.Standard.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Standard.color()
            backButton.backgroundColor = SubscriptionType.Standard.color()
            actionButton.backgroundColor = SubscriptionType.Standard.color()

        case SubscriptionType.Recruiting.rawValue:
            subscriptionTypeView.backgroundColor = SubscriptionType.Recruiting.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Recruiting.color()
            backButton.backgroundColor = SubscriptionType.Recruiting.color()
            actionButton.backgroundColor = SubscriptionType.Recruiting.color()

        default: // Free
            subscriptionTypeView.backgroundColor = SubscriptionType.Free.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Free.color()
            backButton.backgroundColor = SubscriptionType.Free.color()
            actionButton.backgroundColor = SubscriptionType.Free.color()
        }
    }
    
    private func loadData() {
        
        guard let subscriptionPlan = subscriptionPlan else {
            return
        }
        subscriptionTypeLabel.text = subscriptionPlan.name
        if subscriptionPlan.name == "FREE"{
           subscriptionPriceLabel.isHidden = true
            subsciptionPriceBgView.isHidden = true
            buyNowBtn.isEnabled = false
            buyNowBtn.isHidden = true
           registrationFeeLabel.text = "$\(subscriptionPlan.registrationFee)"
        }
        else{
            subscriptionPriceLabel.text = "$\(subscriptionPlan.monthlycharge) /month"
            registrationFeeLabel.text = "$\(subscriptionPlan.registrationFee) one-time"
        }
    }
    
    private func setupTableView() {

        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

// MARK:- Payment services
    

    @objc func requestForSubscribe(notification: NSNotification){
        guard let subscriptionPlan = subscriptionPlan else {
            return
        }
        let planId = subscriptionPlan.id
        let amount = subscriptionPlan.monthlycharge
        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.requestForPaymentPaln(planId: planId, amount: Int(amount), sucessResult: { (responseModel) in
           
            ActivityIndicatorView.hiding()
            guard let paymentDetailsModel = responseModel as? PaymentModel else {
                print("Rep model does not match")
                return
            }
             if paymentDetailsModel.status == "SUCCESS"
             {
                self.transactionId = paymentDetailsModel.transactionId
                self.requestForNonce(clientToken: paymentDetailsModel.clientToken, palnAmount: String(amount))
            }

        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }

    }
    
    func sendRequestPaymentResponse(nonce: String, amount: String) {
        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.PaymentResponse(nonce: nonce, transactionId: self.transactionId, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let paymentDetailsModel = responseModel as? PaymentModel else {
                print("Rep model does not match")
                return
            }
            print(paymentDetailsModel)
                self.paymentSuccessPopup(status: paymentDetailsModel.status, transactionId: paymentDetailsModel.transactionId)
      
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    func paymentSuccessPopup(status:String,transactionId:String){
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ThankyouForYourPurchaseViewController") as! ThankyouForYourPurchaseViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.transactionId = transactionId
        vc.status = status
        vc.amount = self.totalAmount
        self.present(vc, animated: true, completion: nil)
    }

    //MARK:- BrainTreeServices
    
    func requestForNonce(clientToken:String,palnAmount:String)  {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientToken, request: request)
        { [unowned self] (controller, result, error) in
            
            if let error = error {
                self.alert(message: error.localizedDescription)
                
            } else if (result?.isCancelled == true) {
                self.alert(message: "Transaction Cancelled")
                
            } else if let nonce = result?.paymentMethod?.nonce {
                self.sendRequestPaymentResponse(nonce: nonce, amount: palnAmount)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    

    
// MARK: -- Button Actions
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        // Add Payment
        guard let subscriptionPlan = subscriptionPlan else {
            return
        }
        getPaymentSummaryInitial(planID: subscriptionPlan.id)
        let charge = subscriptionPlan.monthlycharge
        let regamt = subscriptionPlan.registrationFee
        self.totalAmount = (Float(regamt) + charge)
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func getPaymentSummaryInitial(planID:Int){
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getPaymentSummary(planId:planID,sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let paymentRespModel = responseModel as? GetSummaryPayment else {
                print("Rep model does not match")
                return
            }
            print(paymentRespModel)
            self.paymentModel = paymentRespModel
            ActivityIndicatorView.hiding()
            self.paymentInitialPopup()
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    func paymentInitialPopup(){
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StartandEndDateViewController") as! StartandEndDateViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.paymentModel = self.paymentModel
        vc.isFrom = "Subscription"
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: -- Tableview Properties

extension SubscriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = subscriptionPlan?.benefits.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
        let benefit = subscriptionPlan?.benefits[indexPath.row]
        let test = benefit?.name.trimmingCharacters(in: .newlines)
        cell.featueNameLabel.text =  test
        cell.additionalDescriptionLabel.text = benefit?.userNote
        cell.statusImageView.image = (benefit?.status == "Limited" || benefit?.status == "Available") ? UIImage(named:"tick") : UIImage(named:"wrong")
        
        return cell
    }
}

class SubscriptionTableViewCell : UITableViewCell {
    @IBOutlet weak var featueNameLabel: UILabel!
    @IBOutlet weak var additionalDescriptionLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
}



