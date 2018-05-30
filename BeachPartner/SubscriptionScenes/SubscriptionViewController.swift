//
//  SubscriptionViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 30/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

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
    
    func price() -> String {
        switch self {
        case .Lite:
            return "$4.99 /month"
        case .Standard:
            return "$14.99 /month"
        case .Recruiting:
            return "$29.99 /month"
        default: // Free
            return "$0.00 /month"
        }
    }
    
    func features() -> [(String, Bool)] {
        
        switch self {
        case .Lite:
            let array = [("Swipes", true),
                         ("Swipe Visibility", true),
                         ("High - Fives", true),
                         ("Connections", true),
                         ("Chat", true),
                         ("Master calendar", true),
                         ("My Calendar", true),
                         ("My upcoming tournaments", true),
                         ("Event Invitation", true),
                         ("Event Search", true),
                         ("Court notification", true),
                         ("Partner requests", true),
                         ("Blue BP profile boost", false),
                         ("Visibility to players who \"like\" you", false),
                         ("Visibility to coaches who \"like\" you", false),
                         ("Passport search location change", false),
                         ("Undo last swipe option", false)
            ]
            return array
        case .Standard:
            let array = [("Swipes", true),
                         ("Swipe Visibility", true),
                         ("High - Fives", true),
                         ("Connections", true),
                         ("Chat", true),
                         ("Master calendar", true),
                         ("My Calendar", true),
                         ("My upcoming tournaments", true),
                         ("Event Invitation", true),
                         ("Event Search", true),
                         ("Court notification", true),
                         ("Partner requests", true),
                         ("Blue BP profile boost", true),
                         ("Visibility to players who \"like\" you", true),
                         ("Visibility to coaches who \"like\" you", true),
                         ("Passport search location change", false),
                         ("Undo last swipe option", true)
            ]
            return array
        case .Recruiting:
            let array = [("Swipes", true),
                         ("Swipe Visibility", true),
                         ("High - Fives", true),
                         ("Connections", true),
                         ("Chat", true),
                         ("Master calendar", true),
                         ("My Calendar", true),
                         ("My upcoming tournaments", true),
                         ("Event Invitation", true),
                         ("Event Search", true),
                         ("Court notification", true),
                         ("Partner requests", true),
                         ("Blue BP profile boost", true),
                         ("Visibility to players who \"like\" you", true),
                         ("Visibility to coaches who \"like\" you", true),
                         ("Passport search location change", true),
                         ("Undo last swipe option", true)
            ]
            return array
        default: // Free
            let array = [("Swipes", true),
                         ("Swipe Visibility", false),
                         ("High - Fives", true),
                         ("Connections", true),
                         ("Chat", true),
                         ("Master calendar", false),
                         ("My Calendar", true),
                         ("My upcoming tournaments", true),
                         ("Event Invitation", true),
                         ("Event Search", false),
                         ("Court notification", true),
                         ("Partner requests", true),
                         ("Blue BP profile boost", false),
                         ("Visibility to players who \"like\" you", false),
                         ("Visibility to coaches who \"like\" you", false),
                         ("Passport search location change", false),
                         ("Undo last swipe option", false)
            ]
            return array
        }
    }
}


class SubscriptionViewController: UIViewController {

    @IBOutlet weak var subscriptionTypeView: UIView!
    @IBOutlet weak var subsciptionPriceBgView: UIView!
    
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var subscriptionPriceLabel: UILabel!
    @IBOutlet weak var registrationFeeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    var subscriptionType: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if subscriptionType == nil {
            subscriptionType = SubscriptionType.Free.rawValue
        }
        
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        
        guard let subscriptionType = subscriptionType else {
            return
        }
        
        
        switch subscriptionType {
            
        case SubscriptionType.Lite.rawValue:
            subscriptionTypeLabel.text = SubscriptionType.Lite.rawValue
            subscriptionTypeView.backgroundColor = SubscriptionType.Lite.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Lite.color()
            backButton.backgroundColor = SubscriptionType.Lite.color()
            actionButton.backgroundColor = SubscriptionType.Lite.color()
            subscriptionPriceLabel.text =  SubscriptionType.Lite.price()

        case SubscriptionType.Standard.rawValue:
            subscriptionTypeLabel.text = SubscriptionType.Standard.rawValue
            subscriptionTypeView.backgroundColor = SubscriptionType.Standard.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Standard.color()
            backButton.backgroundColor = SubscriptionType.Standard.color()
            actionButton.backgroundColor = SubscriptionType.Standard.color()
            subscriptionPriceLabel.text =  SubscriptionType.Standard.price()

        case SubscriptionType.Recruiting.rawValue:
            subscriptionTypeLabel.text = SubscriptionType.Recruiting.rawValue
            subscriptionTypeView.backgroundColor = SubscriptionType.Recruiting.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Recruiting.color()
            backButton.backgroundColor = SubscriptionType.Recruiting.color()
            actionButton.backgroundColor = SubscriptionType.Recruiting.color()
            subscriptionPriceLabel.text =  SubscriptionType.Recruiting.price()

        default: // Free
            subscriptionTypeLabel.text = SubscriptionType.Free.rawValue
            subscriptionTypeView.backgroundColor = SubscriptionType.Free.color()
            subsciptionPriceBgView.borderColor = SubscriptionType.Free.color()
            backButton.backgroundColor = SubscriptionType.Free.color()
            actionButton.backgroundColor = SubscriptionType.Free.color()
            subscriptionPriceLabel.text =  SubscriptionType.Free.price()
        }
    }
    
    private func setupTableView() {
        
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func didTapActionButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SubscriptionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let subscriptionType = subscriptionType, let count = SubscriptionType(rawValue: subscriptionType)?.features().count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionTableViewCell else {
            fatalError("Cell not found")
        }
        cell.selectionStyle = .none
        
        guard let subscriptionType = subscriptionType, let feature = SubscriptionType(rawValue: subscriptionType)?.features()[indexPath.row] else {
            fatalError("subscriptionType not found")
        }
        
        cell.featueNameLabel.text = feature.0
        cell.additionalDescriptionLabel.text = ""
        cell.statusImageView.image = (feature.1 == true) ? UIImage(named:"tick") : UIImage(named:"wrong")
        
        return cell
    }
}

class SubscriptionTableViewCell : UITableViewCell {
    
    @IBOutlet weak var featueNameLabel: UILabel!
    @IBOutlet weak var additionalDescriptionLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
}



