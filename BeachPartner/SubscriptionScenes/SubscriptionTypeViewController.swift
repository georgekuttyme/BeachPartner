//
//  SubscriptionTypeViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 30/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class SubscriptionTypeViewController: UIViewController {
    
    var readMoreClicked:Bool = false
    var selectedIndex = -1
    var selectedReadMoreIndex = -1
    var currentPlan: String?
    var benefitCode: String?
    var readMoreButtonTitle: String = "Read more"
    static let identifier = "SubscriptionTypeViewController"
    var subscriptionPlans = [SubscriptionPlanModel]()


    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var trailingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var leadingPremiumImage: NSLayoutConstraint!
    @IBOutlet weak var topSpaceSubTitle: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var descriptionBottonConstraint: NSLayoutConstraint!

// MARK: -- View Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllSubscriptionPlans()
        viewCustomization()
        NotificationCenter.default.addObserver(self, selector: #selector(exitPopup(notification:)), name:NSNotification.Name(rawValue: "dismiss-action"), object: nil)

    }
    @objc func exitPopup(notification: NSNotification){
        self.dismiss(animated: false){
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
            self.present(secondViewController, animated: true, completion: nil)
        }
    }

    private func viewCustomization(){

        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        proceedBtn.isEnabled = false
        proceedBtn.alpha = 0.5
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
    }
    
// MARK: -- Fetch Data
    private func getAllSubscriptionPlans() {
        
        //        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getAllSubscriptionPlans(sucessResult: { (responseModel) in
            
            
            
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
                ActivityIndicatorView.hiding()
                print("Rep model does not match")
                return
            }
            
            if self.benefitCode == nil {
                self.subscriptionPlans = subscriptionPlansModel.subscriptionPlans
                self.tableView.reloadData()
            }
            else {
                self.subscriptionPlans = subscriptionPlansModel.subscriptionPlans.filter({ (plan) -> Bool in
                    return Bool(plan.benefits.contains(where: { (benefit) -> Bool in
                        return Bool(benefit.code == self.benefitCode && benefit.status == "Available")
                    }))
                })
                
                if self.benefitCode == BenefitType.PassportSearch {
                    self.getAllAddonPlans()
                }
                else {
                    self.tableView.reloadData()
                }
            }
            ActivityIndicatorView.hiding()
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func getAllAddonPlans() {
        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getAllAddonPlans(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
                print("Rep model does not match")
                return
            }
            
            let addOnPlan = subscriptionPlansModel.subscriptionPlans.filter({ (plan) -> Bool in
                return Bool(plan.code == "TEMP_PASSPORT")
            })
            
//            if let plan = addOnPlan.first {
//                self.subscriptionPlans.append(plan)
//            }
            
            self.tableView.reloadData()
            
        }) { (errorMessage) in
            ActivityIndicatorView.hiding()
            guard let errorString  = errorMessage else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
// MARK: -- Button Actions
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapProceedButton(_ sender: UIButton) {
        //Payments
                let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                vc.subscriptionPlan = subscriptionPlans[selectedIndex]
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
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

extension SubscriptionTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionPlans.count
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTypeTableViewCell", for: indexPath) as? SubscriptionTypeTableViewCell else {
            fatalError("Cell not found")
        }
        print ("---> \n\n\n\n ",subscriptionPlans[indexPath.row].name)
        if subscriptionPlans[indexPath.row].name == "FREE"{
            cell.priceLabel.isHidden = true
        }
        else {
            cell.priceLabel.isHidden = false
        }
        cell.selectionStyle = .none
        
        let plan = subscriptionPlans[indexPath.row]
        cell.subscriptionTypeLabel.text = plan.name
       // cell.subscriptionTypeLabel.adjustsFontSizeToFitWidth = true
        print(Subscription.current.activeSubscriptionPlan?.planName)
        if plan.code == Subscription.current.activeSubscriptionPlan?.planName {
            cell.statusLabel.text = "Current Plan"
            cell.radioButton.isHidden = true
        }
        else {
            cell.statusLabel.text = ""
            cell.radioButton.isHidden = false
        }
        
        
        var charge = "$\(plan.monthlycharge)"
        if plan.type == "Subscription" {
            charge += " /month"
        }
        cell.priceLabel.text = charge
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
        
        cell.readmoreButton.setTitle(readMoreButtonTitle, for: .normal)
        cell.readmoreButton.tag = indexPath.row+1000
        cell.readmoreButton.addTarget(self, action: #selector(showPlanDetails), for: .touchUpInside)
        
        cell.radioButton.setImage(image, for: .normal)
        cell.radioButton.tag = indexPath.row
        cell.radioButton.addTarget(self, action: #selector(selectPlan), for: .touchUpInside)
        cell.readmoreButton.isHidden = (plan.type == "Subscription") ? false: true
        
        return cell
    }
    
}

class SubscriptionTypeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var readmoreButton: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
}
