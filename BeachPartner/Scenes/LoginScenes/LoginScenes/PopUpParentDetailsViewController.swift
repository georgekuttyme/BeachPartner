//
//  PopUpParentDetailsViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 15/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class PopUpParentDetailsViewController: UIViewController {

    @IBOutlet weak var firstnameTxt: FloatingText!
    
    @IBOutlet weak var lastNameTxt: FloatingText!
    
    @IBOutlet weak var phNoTxt: FloatingText!
    @IBOutlet weak var emailTxt: FloatingText!
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.popUpParentDelegate?.parentDataSaved()
    }
    @IBAction func btnClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.popUpParentDelegate?.parentDetailsClosed()
    }
    weak var popUpParentDelegate: PopUpParentDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
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
