//
//  AppUpdateViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 12/06/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

protocol AppUpdateViewControllerDelegate {
    
    func didDismissUpdateView()
}

class AppUpdateViewController: UIViewController {

    let beachPartnerAppId = 375380948//Change this ID ############################
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate: AppUpdateViewControllerDelegate?
    var mandatoryUpdate = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if mandatoryUpdate {
            cancelButton.isHidden = true
            titleLabel.text = "UPDATE REQUIRED"
            messageLabel.text = "This version of the app is no longer supported. Please update Beach Partner to continue"
        }
        else {
            titleLabel.text = "UPDATE AVAILABLE"
            messageLabel.text = "There is a newer version available for download! Please update the app by visiting the AppStore"
        }
    }

    
    @IBAction func didTapUpdateButton(_ sender: Any) {
        
        let urlStr = "itms://itunes.apple.com/us/app/apple-store/id\(beachPartnerAppId)?mt=8"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        
        dismiss(animated: true) {
            self.delegate?.didDismissUpdateView()
        }
    }
}
