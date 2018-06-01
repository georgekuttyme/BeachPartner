//
//  AddonsViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 01/06/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class AddonsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddonsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddonTableViewCell", for: indexPath) as? AddonTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
//        let plan = subscriptionPlans[indexPath.row]
//        cell.subscriptionTypeLabel.text = plan.name
//        cell.priceLabel.text = "$\(plan.monthlycharge) /month"
//        cell.descriptionLabel.text = plan.description
//        
//        let image = (indexPath.row == selectedIndex) ? UIImage(named:"rb_active") : UIImage(named:"rb")
//        cell.radioButton.setImage(image, for: .normal)
//        
//        cell.radioButton.tag = indexPath.row
//        cell.radioButton.addTarget(self, action: #selector(selectPlan), for: .touchUpInside)
//        
//        cell.readmoreButton.tag = indexPath.row
//        cell.readmoreButton.addTarget(self, action: #selector(showPlanDetails), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}


class AddonTableViewCell : UITableViewCell {
    
}

