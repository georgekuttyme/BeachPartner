//
//  MutualLikesViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 02/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class MutualLikesViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissBtnClicked(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sendMsgBtnClicked(_ sender: Any) {
        dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "send-Message"), object: nil)
        }
    }
    
    @IBAction func findTournamentBtnclicked(_ sender: Any) {
        dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "find-Tournament"), object: nil)
        }
    }
    @IBAction func keepSwiping(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
