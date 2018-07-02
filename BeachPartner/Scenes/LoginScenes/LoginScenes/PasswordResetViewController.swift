//
//  PasswordResetViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 28/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import Toast_Swift
class PasswordResetViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var keyTxtFld: FloatingText!
    @IBOutlet var newPwdTxtFld: FloatingText!
    @IBOutlet var confirmPwdTxtFld: FloatingText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
        self.keyTxtFld.delegate = self
        self.newPwdTxtFld.delegate = self
        self.confirmPwdTxtFld.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        
        validateTxtFld()
    }
 
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        validateTxtFld()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == keyTxtFld {
            newPwdTxtFld.becomeFirstResponder()
        }
        else if textField == newPwdTxtFld {
            confirmPwdTxtFld.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: validations for text fields
    
    func validateTxtFld() {
        
        
        let sucessValidation = 3
        var currentValidation = 0
        
        
        if keyTxtFld.isEmpty() {
            keyTxtFld.shake()
            keyTxtFld.errorText = "Please enter a valid code"
            keyTxtFld.showError()
            
        }
        else if (keyTxtFld.text?.count) != 6 {
            keyTxtFld.shake()
            keyTxtFld.errorText = "Please enter a valid code"
            keyTxtFld.showError()
        }
        else{
            keyTxtFld.hideError()
            currentValidation += 1
        }
        
        if newPwdTxtFld.isEmpty() {
            newPwdTxtFld.shake()
            newPwdTxtFld.errorText = "Please enter a valid password"
            newPwdTxtFld.showError()
        }
        else {
            if (newPwdTxtFld.text?.hasPrefix(" "))!{
                newPwdTxtFld.shake()
                newPwdTxtFld.errorText = "Can’t start with whitespaces"
                newPwdTxtFld.showError()
            }
            else if (newPwdTxtFld.text?.hasSuffix(" "))! {
                newPwdTxtFld.shake()
                newPwdTxtFld.errorText = "Can’t end with whitespaces"
                newPwdTxtFld.showError()
            }
            else {
                newPwdTxtFld.hideError()
            }
            
            if (newPwdTxtFld.text?.count)! >= 8 {
                if (newPwdTxtFld.text?.hasPrefix(" "))!{
                    newPwdTxtFld.shake()
                    newPwdTxtFld.errorText = "Can’t start with whitespaces"
                    newPwdTxtFld.showError()
                }
                else if (newPwdTxtFld.text?.hasSuffix(" "))! {
                    newPwdTxtFld.shake()
                    newPwdTxtFld.errorText = "Can’t end with whitespaces"
                    newPwdTxtFld.showError()
                }
                else {
                    newPwdTxtFld.hideError()
                    currentValidation += 1
                }
            }
            else {
                newPwdTxtFld.shake()
                newPwdTxtFld.errorText = "Minimum eight characters required"
                newPwdTxtFld.showError()
            }
        }
        
        if confirmPwdTxtFld.isEmpty() {
            confirmPwdTxtFld.shake()
            confirmPwdTxtFld.errorText = "Please confirm your password"
            confirmPwdTxtFld.showError()
        }else{
            if (confirmPwdTxtFld.text?.hasPrefix(" "))!{
                confirmPwdTxtFld.shake()
                confirmPwdTxtFld.errorText = "Can’t start with whitespaces"
                confirmPwdTxtFld.showError()
            }
            else if (confirmPwdTxtFld.text?.hasSuffix(" "))! {
                confirmPwdTxtFld.shake()
                confirmPwdTxtFld.errorText = "Can’t end with whitespaces"
                confirmPwdTxtFld.showError()
            }
            if(confirmPwdTxtFld.text == newPwdTxtFld.text){
                confirmPwdTxtFld.hideError()
                currentValidation += 1
            }
            else{
                confirmPwdTxtFld.errorText = "Password mismatch "
                confirmPwdTxtFld.showError()
            }
            
        }
       
        if sucessValidation == currentValidation {
            
            APIManager.callServer.finishPasswordReset(key: keyTxtFld.text!, newPassword: newPwdTxtFld.text! ,sucessResult: { (responseModel) in
                print(responseModel as Any)
                guard let loginModel = responseModel as? ForgotPassResponceModel else {
                    return
                }
                
                if loginModel.status == 0 {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup-ForgotPassword"), object: nil, userInfo: ["type":"PasswordChanged"])
                }
                else{
                    DispatchQueue.main.async {
                        self.keyTxtFld.shake()
                        self.keyTxtFld.errorText = "Invalid reset code"
                        self.keyTxtFld.showError()
                        }
                    }
                ActivityIndicatorView.hiding()
            }, errorResult: { (error) in
                
                guard let errorString  = error else {
                    return
                }
                ActivityIndicatorView.hiding()
                self.alert(message: errorString)
            })
    }

    }
}


