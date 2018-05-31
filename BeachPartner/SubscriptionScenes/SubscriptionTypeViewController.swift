//
//  SubscriptionTypeViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 30/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class SubscriptionTypeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var subscriptionPlans = [SubscriptionPlanModel]()
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllSubscriptionPlans()
    }
    
    private func getAllSubscriptionPlans() {
        
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getAllSubscriptionPlans(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.subscriptionPlans = subscriptionPlansModel.subscriptionPlans
            self.tableView.reloadData()
            
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapProceedButton(_ sender: UIButton) {
        //Payments
    }
    
    @objc private func showPlanDetails(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        vc.subscriptionPlan = subscriptionPlans[sender.tag]
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func selectPlan(sender: UIButton) {
        selectedIndex = sender.tag
        tableView.reloadData()
    }
    
}

extension SubscriptionTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTypeTableViewCell", for: indexPath) as? SubscriptionTypeTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
        let plan = subscriptionPlans[indexPath.row]
        cell.subscriptionTypeLabel.text = plan.name
        cell.priceLabel.text = "$\(plan.monthlycharge) /month"
        cell.descriptionLabel.text = plan.description
        
        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
        cell.radioButton.setImage(image, for: .normal)
        
        cell.radioButton.tag = indexPath.row
        cell.radioButton.addTarget(self, action: #selector(selectPlan), for: .touchUpInside)
        
        cell.readmoreButton.tag = indexPath.row
        cell.readmoreButton.addTarget(self, action: #selector(showPlanDetails), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

class SubscriptionTypeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var readmoreButton: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
}
