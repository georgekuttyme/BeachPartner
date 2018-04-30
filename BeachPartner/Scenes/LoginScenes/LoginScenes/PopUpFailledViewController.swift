//
//  PopUpFailledViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 15/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class PopUpFailledViewController: UIViewController {

    @IBAction func closeBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        self.popUpFailedDelegate?.closeClicked()
    }
    @IBAction func returnSignInCLicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        self.popUpFailedDelegate?.returnSignInClicked()
    }
    weak var popUpFailedDelegate: PopUpThanksDelegate?

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
