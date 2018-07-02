//
//  ForgotPasswordViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 24/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailField: FloatingText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate=self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        let email = emailField.text
        if (email?.isValidEmailAddress())!{
            makeForgotPasswordRequest()
            self.view.endEditing(true)
        }
        else{
            if emailField.isEmpty() {
                emailField.shake()
                emailField.errorText = "Email cannot be blank"
                emailField.showError()
            }else{
                if let email = emailField.text {
                    if email.isValidEmailAddress() {
                    }else{
                        emailField.shake()
                        emailField.errorText = "Enter a valid email"
                        emailField.showError()
                    }
                }
            }
        }        
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        // cancel button action
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        emailField.placeholder = ""
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
        func makeForgotPasswordRequest(){
            
        guard let email = emailField.text else {
            return
        }
        APIManager.callServer.forgotPasswordEmailSent(email: email, sucessResult: { (response) in
            guard let loginModel = response as? ForgotPassResponceModel else{
                return
            }

            if loginModel.status == 0 {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-ForgotPassword"), object: nil, userInfo: ["type":"newPassword"])
            }
            else{
                DispatchQueue.main.async {
                    self.emailField.shake()
                    self.emailField.errorText = "Email id not found"
                    self.emailField.showError()
                }
            }
        }, errorResult: {(error) in
            
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
    }

    func changePasswordRequest(){
        
        let password = "11111111"
        APIManager.callServer.changePassword(password: password, sucessResult: { (response) in
            guard let loginModel = response as? GeneralResponse else{
                return
            }
            print("      %%%",loginModel.success)
            
        }, errorResult: {(error) in
            
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
    }
}
