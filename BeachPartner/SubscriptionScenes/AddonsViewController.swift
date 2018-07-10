//
//  AddonsViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 01/06/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class AddonsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var trailingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var leadingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var topSpaceSubTitle: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    var profileBoostmode = false
    
    var addonPlans = [SubscriptionPlanModel]()
    var selectedReadMoreIndex = -1
    var selectedIndex = -1
    var readMoreButtonTitle: String = "Read more"
    var readMoreClicked:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        getAllAddonPlans()
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        proceedBtn.isEnabled = false
        proceedBtn.alpha = 0.5
    }
    
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
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapProceedButton(_ sender: UIButton) {
        
        
    }
    
    @objc private func showPlanDetails(sender: UIButton) {
        readMoreClicked = !readMoreClicked
        selectedReadMoreIndex = sender.tag-1000
        tableView.reloadData()
    }

    
    @objc private func selectPlan(sender: UIButton) {
        proceedBtn.isEnabled = true
        proceedBtn.alpha = 1.0
        selectedIndex = sender.tag
        tableView.reloadData()
    }
}

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
        readMoreButtonTitle = (indexPath.row == selectedReadMoreIndex) ? "less" : "Read more"
        if(readMoreButtonTitle == "less" && !self.readMoreClicked ){
            readMoreButtonTitle = "Read more"
        }
        
        cell.radioButton.setImage(image, for: .normal)
        
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

