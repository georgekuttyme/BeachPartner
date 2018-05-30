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
    
    var currentPlan: SubscriptionType?
    var selectedPlan: SubscriptionType?
    
    var selectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedPlan = currentPlan
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapProceedButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        
        vc.subscriptionType = selectedPlan?.rawValue
        
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func selectPlan(sender: UIButton) {
        
        selectedIndex = sender.tag
        
        switch selectedIndex {
            
        case 0:
            selectedPlan = SubscriptionType.Free
        case 1:
            selectedPlan = SubscriptionType.Lite
        case 2:
            selectedPlan = SubscriptionType.Standard
        case 3:
            selectedPlan = SubscriptionType.Recruiting
        default:
            selectedPlan = nil
        }
        tableView.reloadData()
    }
    
}

extension SubscriptionTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTypeTableViewCell", for: indexPath) as? SubscriptionTypeTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
        switch indexPath.row {
        
        case 0:
            cell.subscriptionTypeLabel.text = SubscriptionType.Free.rawValue
            cell.priceLabel.text = "$0.00 /month"
        case 1:
            cell.subscriptionTypeLabel.text = SubscriptionType.Lite.rawValue
            cell.priceLabel.text = "$4.99 /month"
        case 2:
            cell.subscriptionTypeLabel.text = SubscriptionType.Standard.rawValue
            cell.priceLabel.text = "$14.99 /month"
        case 3:
            cell.subscriptionTypeLabel.text = SubscriptionType.Recruiting.rawValue
            cell.priceLabel.text = "$29.99 /month"
        default:
            cell.subscriptionTypeLabel.text = ""
            cell.priceLabel.text = ""
        }
        
        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
        cell.radioButton.setImage(image, for: .normal)
        
        cell.radioButton.tag = indexPath.row
        cell.radioButton.addTarget(self, action: #selector(selectPlan), for: .touchUpInside)
        
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
