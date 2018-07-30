//
//  AddonsViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 01/06/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class AddonsViewController: UIViewController {
//    var plan =
    var profileBoostmode = false
    var readMoreClicked:Bool = false
    var selectedReadMoreIndex = -1
    var selectedIndex = -1
    var readMoreButtonTitle: String = "Read more"
    var addonPlans = [SubscriptionPlanModel]()
    var transactionId:String = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var trailingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var leadingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var topSpaceSubTitle: NSLayoutConstraint!
 
// MARK: -- View Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomization()
        getAllAddonPlans()
        
    }
    
    private func viewCustomization(){

        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenSize = UIScreen.main.bounds.size;
            if screenSize.height == 568.0{
                trailingPremiumImage.constant = -3
                leadingPremiumImage.constant = -3
                topSpaceSubTitle.constant = 2
            }
            else{
                trailingPremiumImage.constant = 0
                leadingPremiumImage.constant = 0
                topSpaceSubTitle.constant = 8
            }
        }
        
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        proceedBtn.isEnabled = false
        proceedBtn.alpha = 0.5
    }

// MARK: -- Fetch Data
    
    private func getAllAddonPlans() {
        
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getAllAddonPlans(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
                print("Rep model does not match")
                return
            }
            if self.profileBoostmode == true {
                
                let addOnPlan = subscriptionPlansModel.subscriptionPlans.filter({ (plan) -> Bool in
                    return Bool(plan.code == AddOnType.ProfileBoost)
                })
                
                if let plan = addOnPlan.first {
                    self.addonPlans.append(plan)
                }
            }
            else {
                self.addonPlans = subscriptionPlansModel.subscriptionPlans
            }
            
            self.tableView.reloadData()
            
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    // MARK:- Payment services
    
    func requestForSubscribe(planId:Int, amount:Int)  {
        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.requestForPaymentPaln(planId: planId, amount: amount, sucessResult: { (responseModel) in
            
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
    
    func sendRequestPaymentResponse(nonce: String, amount: String) {
        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.PaymentResponse(nonce: nonce, transactionId: self.transactionId, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let paymentDetailsModel = responseModel as? PaymentModel else {
                print("Rep model does not match")
                return
            }
            if paymentDetailsModel.status == "SUCCESS"
            {
                let refreshAlert = UIAlertController(title: "Payment Success", message: "Successfully changed your plan.Please Log out for switch current plan", preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (action: UIAlertAction!) in
                    self.timoutLogoutAction()
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
            
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }

    
// MARK: -- Button Actions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapProceedButton(_ sender: UIButton) {
        guard let plan:SubscriptionPlanModel? = addonPlans[selectedIndex] else {
            return
        }
        print(addonPlans[selectedIndex],selectedIndex)
        requestForSubscribe(planId: (plan?.id)!, amount: Int((plan?.monthlycharge)!))
    }
    
    @objc private func showPlanDetails(sender: UIButton) {
        if selectedReadMoreIndex == sender.tag-1000 {
            readMoreClicked = !readMoreClicked
            selectedReadMoreIndex = sender.tag-1000
            tableView.reloadData()
        }
        else{
            readMoreClicked = false
            selectedReadMoreIndex = sender.tag-1000
            tableView.reloadData()
            readMoreClicked = !readMoreClicked
            tableView.reloadData()
        }
    }
    
    @objc private func selectPlan(sender: UIButton) {
        proceedBtn.isEnabled = true
        proceedBtn.alpha = 1.0
        selectedIndex = sender.tag
        tableView.reloadData()
    }
}

// MARK: -- Tableview Properties

extension AddonsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addonPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddonTableViewCell", for: indexPath) as? AddonTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
        let plan = addonPlans[indexPath.row]
        cell.subscriptionTypeLabel.text = plan.name
    //    cell.subscriptionTypeLabel.adjustsFontSizeToFitWidth = true
        cell.priceLabel.text = "$\(plan.monthlycharge)" + "/day"
        cell.descriptionLabel.text = plan.description
        
        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
        readMoreButtonTitle = (indexPath.row == selectedReadMoreIndex) ? "Read less" : "Read more"
        if(readMoreButtonTitle == "Read less" && !self.readMoreClicked ){
            readMoreButtonTitle = "Read more"
        }
        
        if readMoreButtonTitle == "Read more"{
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = UITableViewAutomaticDimension
            cell.descriptionLabel.numberOfLines = 2
            cell.descriptionLabel.lineBreakMode = .byTruncatingTail
        }
        else{
            cell.descriptionLabel.numberOfLines = 0
            tableView.estimatedRowHeight = 250.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        
        cell.readMore.setTitle(readMoreButtonTitle, for: .normal)
        cell.readMore.tag = indexPath.row+1000
        cell.readMore.addTarget(self, action: #selector(showPlanDetails), for: .touchUpInside)
        
        cell.radioButton.setImage(image, for: .normal)
        cell.radioButton.tag = indexPath.row
        cell.radioButton.addTarget(self, action: #selector(selectPlan), for: .touchUpInside)
        
        if Subscription.current.statusOfAddOn(addOnId: plan.code) {
            cell.statusLabel.text = "Active"
            cell.radioButton.isHidden = true
        }
        else {
            cell.statusLabel.text = ""
            cell.radioButton.isHidden = false
        }
        
        return cell
    }
}


class AddonTableViewCell : UITableViewCell {
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}

