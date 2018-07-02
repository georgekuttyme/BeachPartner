//
//  PopUpThanksViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 15/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class PopUpThanksViewController: UIViewController {

    @IBAction func closedBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        self.popUpThanksDelegeate?.closeClicked()
    }
    
    @IBAction func neverGotEmailClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        self.popUpThanksDelegeate?.neverGotEmailClicked()
    }
    @IBAction func returnSignInClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
        self.popUpThanksDelegeate?.returnSignInClicked()
    }
    weak var popUpThanksDelegeate: PopUpThanksDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
