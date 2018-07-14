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

    let beachPartnerAppId = 1397972399  // 1327790446
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate: AppUpdateViewControllerDelegate?
    var mandatoryUpdate = false
    var updateMessage = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if mandatoryUpdate {
            cancelButton.isHidden = true
            titleLabel.text = "UPDATE REQUIRED"
        //    messageLabel.text = "This version of the app is no longer supported. Please update Beach Partner to continue"
        }
        else {
            titleLabel.text = "NEW VERSION AVAILABLE"
        //    messageLabel.text = "There is a newer version available for download! Please update the app by visiting the AppStore"
        }
        messageLabel.text = updateMessage
    }

    
    @IBAction func didTapUpdateButton(_ sender: Any) {
        
       // let urlStr = "itms://itunes.apple.com/us/app/apple-store/id\(beachPartnerAppId)?mt=8"
        let urlStr = "https://itunes.apple.com/us/app/id\(beachPartnerAppId)"
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
