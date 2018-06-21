//
//  AddonsViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 01/06/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class AddonsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var profileBoostmode = false
    
    var addonPlans = [SubscriptionPlanModel]()
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllAddonPlans()
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
    
    @objc private func selectPlan(sender: UIButton) {
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
        cell.subscriptionTypeLabel.adjustsFontSizeToFitWidth = true
        cell.priceLabel.text = "$\(plan.monthlycharge)"
        cell.descriptionLabel.text = plan.description
        
        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}


class AddonTableViewCell : UITableViewCell {
    
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
}

