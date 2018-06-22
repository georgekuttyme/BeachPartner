//
//  SubscriptionTypeViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 30/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class SubscriptionTypeViewController: UIViewController {
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    static let identifier = "SubscriptionTypeViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var readMoreClicked:Bool = false
    var subscriptionPlans = [SubscriptionPlanModel]()
    
    @IBOutlet weak var proceedBtn: UIButton!
    var selectedIndex = -1
    
    @IBOutlet weak var descriptionBottonConstraint: NSLayoutConstraint!
    var currentPlan: String?
    var benefitCode: String?
    
    var readMoreButtonTitle: String = "Read more"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllSubscriptionPlans()
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        proceedBtn.isEnabled = false
        proceedBtn.alpha = 0.5
        
    }
    
    private func getAllSubscriptionPlans() {
        
        
//        ActivityIndicatorView.addActivityOnView(tableView.superview)
        ActivityIndicatorView.show("Loading...")
        
        
        APIManager.callServer.getAllSubscriptionPlans(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
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
            
            if let plan = addOnPlan.first {
                self.subscriptionPlans.append(plan)
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
        readMoreClicked = !readMoreClicked
        let position: CGPoint = sender.convert(.zero, to: self.tableView)
        let indexPath1 = self.tableView.indexPathForRow(at: position)
        let cell: SubscriptionTypeTableViewCell = tableView.cellForRow(at: indexPath1!)! as!
        SubscriptionTypeTableViewCell
        print(readMoreClicked," ----- ?? ",indexPath1 ?? ""," \n\n -- ",readMoreButtonTitle)
        cell.readmoreButton.setTitle("Less", for: .normal)
        cell.descriptionLabel.numberOfLines = 0
        tableView.estimatedRowHeight = 250.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    @objc private func selectPlan(sender: UIButton) {
        proceedBtn.isEnabled = true
        proceedBtn.alpha = 1.0
        selectedIndex = sender.tag
        tableView.reloadData()
    }
    
}

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
        cell.selectionStyle = .none
        
        let plan = subscriptionPlans[indexPath.row]
        cell.subscriptionTypeLabel.text = plan.name
        cell.subscriptionTypeLabel.adjustsFontSizeToFitWidth = true
        
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
//        cell.descriptionLabel.text = plan.description
        cell.descriptionLabel.text = "Select the height constraint from the Interface builder and take an outlet of it. So, when you want to change the height of the view you can use the below code.France won again, but are still struggling for rhythm, while Argentinas drubbing at the hands of Croatia on Thursday night leaves them on the brink of an early World Cup exit.Can Brazil stamp their authority on the tournament today? We will soon find out."

        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
        readMoreButtonTitle = self.readMoreClicked ? "less" : "Read more"
        print("\n\n\n\n\n",readMoreClicked,"***  ",readMoreButtonTitle,"*** ",indexPath)
        cell.radioButton.setImage(image, for: .normal)
        if readMoreButtonTitle == "Read more"{
            tableView.estimatedRowHeight = 200.0
            tableView.rowHeight = UITableViewAutomaticDimension
            cell.descriptionLabel.numberOfLines = 3
            cell.descriptionLabel.lineBreakMode = .byTruncatingTail
            cell.readmoreButton.setTitle(readMoreButtonTitle, for: .normal)
            cell.readmoreButton.tag = indexPath.row+1000
            
        }
        cell.readmoreButton.addTarget(self, action: #selector(showPlanDetails), for: .touchUpInside)
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
