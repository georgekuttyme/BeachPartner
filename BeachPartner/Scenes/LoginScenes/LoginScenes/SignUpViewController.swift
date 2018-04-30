//
//  SignUpViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import DropDown
class SignUpViewController: UIViewController, PopUpOneDelegate, PopUpParentDelegate, PopUpThanksDelegate{
    
    // MARK: - PopUpThanksDelegate
    
    func returnSignInClicked() {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func neverGotEmailClicked() {
        self.performSegue(withIdentifier: "popup4segue", sender: self)
    }
    
    func closeClicked() {
        
    }
    
    
    // MARK: - PopUpParentDelegate
    
    func parentDataSaved() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-Action"), object: nil, userInfo: ["type":"PaymentYes"])
    }
    func parentDetailsClosed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-Action"), object: nil, userInfo: ["type":"linkParentNo"])
    }
    
    // MARK: - PopUpOneDelegate
    func paymentYesClicked() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-Action"), object: nil, userInfo: ["type":"PaymentYes"])
    }
    
    func paymentNoClicked() {
        
    }
    
    func linkParentYesClicked() {
        self.performSegue(withIdentifier: "popup2segue", sender: self)
    }
    
    func linkParentNoClicked() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-Action"), object: nil, userInfo: ["type":"linkParentNo"])
    }
    
    
    @IBOutlet weak var registerbutton: UIButton!
    
    @IBAction func registerClicked(_ sender: Any){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "validate"), object: nil)
        
        //        self.performSegue(withIdentifier: "popup1segue", sender: self)
    }
    
    @IBAction func Loginclicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    let statedropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(registrationCompete(notification:)), name:NSNotification.Name(rawValue: "registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(minorDateChoosed(notification:)), name:NSNotification.Name(rawValue: "minorPopUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(statelistSelection(notification:)), name:NSNotification.Name(rawValue: "dropdownState"), object: nil)
       
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    @objc func statelistSelection(notification: NSNotification){
        statedropDown.show()
    }
    @objc func registrationCompete(notification: NSNotification){
        self.performSegue(withIdentifier: "popup3segue", sender: self)
    }
    
    
    @objc func minorDateChoosed(notification: NSNotification){
        self.performSegue(withIdentifier: "popup1segue", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popup1segue" {
            
            if let popUpOneVC = segue.destination as? PopUpOneViewController {
                popUpOneVC.popUpOneDelegate = self
            }
            
            
        }else if(segue.identifier == "popup2segue" )
        {
            if let popUpTwoVC = segue.destination as? PopUpParentDetailsViewController {
                popUpTwoVC.popUpParentDelegate = self
                
            }
        }
        else if(segue.identifier == "popup3segue" )
        {
            if let popUpThreeVC = segue.destination as? PopUpThanksViewController {
                popUpThreeVC.popUpThanksDelegeate = self
                
            }
        }
        else if(segue.identifier == "popup4segue" )
        {
            if let popUpFourVC = segue.destination as? PopUpFailledViewController {
                popUpFourVC.popUpFailedDelegate = self
                
            }
        }
        
    }
    
    
    
}

