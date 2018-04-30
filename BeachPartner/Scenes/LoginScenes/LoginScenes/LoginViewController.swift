//
//  LoginViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TKSubmitTransitionSwift3


class LoginViewController: UIViewController, UIWebViewDelegate{
    
    let rightButton  = UIButton(type: .custom)
    var iconClick = true
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var emailField: FloatingText!
    @IBOutlet weak var passwordField: FloatingText!
    @IBOutlet weak var errorlabel: UILabel!
    
    @IBOutlet weak var loginWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loggedIn = UserDefaults.standard.string(forKey: "isLoggedIn") ?? "0"
        if loggedIn == "1" {
            let userID = UserDefaults.standard.string(forKey: "bP_token") ?? ""
            if userID == "" {
                self.performSegue(withIdentifier: "tandcsegue", sender: self)
                //      UIApplication.shared.openURL(URL(string: "http://beachpartner.com")!)
            }
        passwordField.delegate = self
        emailField.delegate = self
        
        rightButton.setImage(UIImage(named: "hidepwd"), for: .normal)
        rightButton.frame = CGRect(x:0, y:0, width:40, height:30)
        passwordField.rightViewMode = .always
        passwordField.rightView = rightButton
        
        rightButton.addTarget(self, action:#selector(self.showhidepwdclicked), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPopUpAction(notification:)), name:NSNotification.Name(rawValue: "popup-ForgotPassword"), object: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let loggedIn = UserDefaults.standard.string(forKey: "isLoggedIn") ?? "0"
        if loggedIn != "0" {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
            self.present(secondViewController, animated: false, completion: nil)
        }
    }

    @objc func showhidepwdclicked() {
        if(iconClick == true) {
            self.passwordField.isSecureTextEntry = false
            rightButton.setImage(UIImage(named: "showpwd"), for: .normal)
            iconClick = false
        } else {
            self.passwordField.isSecureTextEntry = true
            rightButton.setImage(UIImage(named: "hidepwd"), for: .normal)
            iconClick = true
        }
        
    }
    

    
    @IBAction func fbLogin(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if(FBSDKAccessToken.current() == nil) {
                    return
                    //                    UserDefaults.standard.set("", forKey: "FBTOKEN")
                }
                else{
                    let fbAccessToken = FBSDKAccessToken.current()?.tokenString ?? ""
                    print(fbAccessToken)
                    UserDefaults.standard.set(fbAccessToken, forKey: "FBTOKEN")
                }
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.loginFb()
                }
            }
        }
    }
    
    func loginFb(){
        
        func startLoading(){
           
            ActivityIndicatorView.show("Loading...")
        }
        func stopLoading(){
           
            ActivityIndicatorView.hiding()
        }
        startLoading()
        APIManager.callServer.forFbLogin( sucessResult: { (responseModel) in
            

            guard let loginModel = responseModel as? LoginRespModel else{
                stopLoading()
                return
            }
            
            
            if(loginModel.idToken != ""){
                
                print("loginModel.idToken :", loginModel.idToken)
                stopLoading()
                
                //                        UserDefaults.standard.set(true, forKey: "Key") //Bool
                //                        UserDefaults.standard.set(1, forKey: "Key")  //Integer
                UserDefaults.standard.set(loginModel.idToken, forKey: "bP_token")
                
                self.getUserInfo()
                
                //                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                //                        let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
                //                        self.present(secondViewController, animated: true, completion: nil)
                
                
            }
        }, errorResult: { (error) in
            stopLoading()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                var fbAccessToken = FBSDKAccessToken.current().tokenString
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    
    

    
    
    func popUpForEmail(){
    
        
        let alert = UIAlertController(title: "Reset Password",
                                      
                                      message: "Enter your email",
                                      
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            
            let textField = alert.textFields![0]
            
            print(textField.text!)
            
            if textField.text != nil{
                
                let email = textField.text
                if (email?.isValidEmail())!{
                    self.makeForgotPasswordRequest(emailField: email!)
                }
                else{
                    textField.shake()
                }
                
                
                
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            
            // textField.autocorrectionType = .default
            
            textField.placeholder = "Please enter your email"
            
            textField.clearButtonMode = .whileEditing
            
        }
        
        alert.addAction(cancel)
        
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func makeForgotPasswordRequest(emailField: String){
        
        let email = emailField;
        
        APIManager.callServer.forgotPasswordEmailSent(email: email, sucessResult: { (response) in
            guard let loginModel = response as? GeneralResponse else{
                return
            }
            print("Sucess email sent!!!",loginModel)
            // sucess code here...
            
            //MARK: Done Button Alert
            
            let alert = UIAlertController(title: "Password Reset",
                                          
                                          message: "An email sent to " + "\(email)" + " to reset password",
                                          
                                          preferredStyle: .alert)
            
            let DoneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
                
                //                let textField = alert.textFields![0]
                
                self.popUpForKeyAndPassword()
            })
            
            alert.addAction(DoneAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }, errorResult: {(error) in
            
            guard let errorString  = error else {
                return
            }
            let alert = UIAlertController(title: "Something Went wrong",
                                          
                                          message: "",
                                          
                                          preferredStyle: .alert)
            
            let DoneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
                
                let textField = alert.textFields![0]
                
                print(textField.text!)
                
            })
            
            alert.addAction(DoneAction)
            
            self.present(alert, animated: true, completion: nil)
            
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
        
    }
    func popUpForKeyAndPassword(){
        let alert = UIAlertController(title: "Password Reset",
                                      
                                      message: "Insert key, password & confirm password",
                                      
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
            // Get TextFields text
            
            let keyTxt = alert.textFields![0]
            
            let passwordTxt = alert.textFields![1]
            
            let confirmPasswordTxt = alert.textFields![2]
            
            print("KEY: \(keyTxt.text!)\nPASSWORD: \(passwordTxt.text!)\nCONFIRMPASSWORD: \(confirmPasswordTxt.text!)")
            
            self.sentNewPassword(keyField: keyTxt.text!,passwordField: passwordTxt.text!)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            
            textField.keyboardAppearance = .default
            
            textField.keyboardType = .default
            
            textField.autocorrectionType = .default
            
            textField.placeholder = "Key"
            
        }
        
        alert.addTextField { (textField: UITextField) in
            
            textField.keyboardAppearance = .default
            
            textField.keyboardType = .default
            
            textField.placeholder = "New password"
            
            textField.isSecureTextEntry = true
            
        }
        
        alert.addTextField { (textField: UITextField) in
            
            textField.keyboardAppearance = .default
            
            textField.keyboardType = .default
            
            textField.placeholder = "Confirm password"
            
            textField.isSecureTextEntry = true
            
        }
        
        alert.addAction(cancel)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func sentNewPassword(keyField:String,passwordField:String){
        
        let keyTxt = keyField
        let password = passwordField
        //                guard let key = value1 else {
        //                    return
        //                }
        //
        //        guard let password = value2 else {
        //            return
        //        }
        
        APIManager.callServer.finishPasswordReset(key: keyTxt, newPassword: password, sucessResult: { (response) in
            guard let loginModel = response as? GeneralResponse else{
                
                return
            }
            print("      %%%",loginModel.success)
            let alert = UIAlertController(title: "Success",
                                          
                                          message: "Password Reset successfully!",
                                          
                                          preferredStyle: .alert)
            
            let DoneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
                //                self.popUpForKeyAndPassword()
            })
            
            alert.addAction(DoneAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }, errorResult: {(error) in
            
            guard let errorString  = error else {
                return
            }
            let alert = UIAlertController(title: "Error",
                                          
                                          message: "Please try after sometime!",
                                          
                                          preferredStyle: .alert)
            
            let DoneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
                //                self.popUpForKeyAndPassword()
            })
            
            alert.addAction(DoneAction)
            
            self.present(alert, animated: true, completion: nil)
            
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
        
    }
    
    
    @IBAction func instaLogin(_ sender: Any) {
       
        
    }
    
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {


        let requestURLString = (request.url?.absoluteString)! as String

        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            
            return false;
        }
        return true
    }

    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
    }

    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //        loginIndicator.isHidden = false
        //       loginIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //      loginIndicator.isHidden = true
        //      loginIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    
    @objc func ForgotPopUpAction(notification: NSNotification){
        let chooseData = notification.userInfo as! [String:String]
        print(chooseData["type"] ?? "")
        if chooseData["type"] == "newPassword" {
        self.performSegue(withIdentifier: "PasswordReset", sender: self)
        }
        else if chooseData["type"] == "newPassword-invalidEmail" {
           self.alert(message:"Invalid Email Id")
        }
        else if chooseData["type"] == "PasswordChanged" {
            self.alert(message:"Password changed successfully")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        emailField.errorText = "Empty!"
        self.makeLoginRequest()
//        self.makeoginWithoutAPi()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

    // MARK: - UITextFieldDelegates
    extension LoginViewController : UITextFieldDelegate {
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            errorlabel.text = ""
            
            if textField == passwordField {
                passwordField.errorText = ""
            }
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == emailField {
                if let text = textField.text {
                    if (textField as? UITextField) != nil {
                        if(text.count > 3 ) {
                            if text.isValidEmailAddress() {
                                emailField.errorText = ""
                                emailField.errorText = ""
                            }else{
                                emailField.errorText = "Invalid email"
                                emailField.showError()
                            }
                        }else {
                            emailField.errorText = ""
                            emailField.hideError()
                        }
                    }
                }
            }else if textField == passwordField {
                if let password = passwordField.text {
                    if password.characters.count < 3 && password.characters.count > 0 {
                        passwordField.errorText = "Invalid password"
                        passwordField.showError()
                    }else{
                        passwordField.errorText = ""
                        passwordField.hideError()
                    }
                }
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if textField == emailField {
                if let text = textField.text {
                    if (textField as? UITextField) != nil {
                        if(text.count > 3 ) {
                            if (text + string).isValidEmailAddress() {
                                emailField.errorText = ""
                                emailField.hideError()
                            }else{
                                emailField.errorText = "Invalid email"
                                emailField.showError()
                            }
                        }else {
                            emailField.errorText = ""
                            emailField.hideError()
                        }
                    }
                }
                return true
            }else if textField == passwordField {
                let currentCharacterCount = textField.text?.characters.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string.characters.count - range.length
                return newLength <= 35
            }
            return true
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            if textField == emailField {
                passwordField.becomeFirstResponder()
            }
            else{
                self.view.endEditing(true)
            }

            return true
        }
        
    }
    // MARK: - WebServiceManagement
    extension LoginViewController : WebServiceManagement {
        // MARK: - Field Validations Methods
        func isAllFieldsAreValid() -> Bool {
           
            if emailField.isEmpty(){
                //            emailField.shake()
                print("emailField.isEmpty")
                emailField.errorText = "Please enter your email."
                emailField.showError()
                return false
            }else{
                if let email = emailField.text {
                    if  email.isValidEmailAddress() == false{
                        emailField.errorText = "Invalid email"
                        emailField.showError()
                        //                    emailField.shake()
                        return false
                    }else{
//                        emailField.errorText = ""
                        if passwordField.isEmpty(){
                            //                        passwordField.shake()
                            passwordField.errorText = "Please enter your password."
                            passwordField.showError()
                            return false
                        }else {
                            if let password = passwordField.text {
                                if password.characters.count < 5 {
                                    passwordField.errorText = "Invalid password"
                                    passwordField.showError()
//                                    passwordField.shake()
                                    return false
                                }else{
                                    emailField.errorText = ""
                                    passwordField.errorText = ""
                                    passwordField.hideError()
                                    emailField.hideError()
                                    return true
                                }
                            }
                        }
                    }
                }
            }
            
            return false
        }
        
        func makeoginWithoutAPi(){
            
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
            self.present(secondViewController, animated: true, completion: nil)
        }
        
        // MARK: - Login API request.
        func makeLoginRequest()  {
            
            let nextMonth = Calendar.current.date(byAdding: .month, value: 5, to: Date())
            print("MONTH  --",nextMonth)

            print("makeLoginRequest ")
            if isAllFieldsAreValid(){
                print("isAllFieldsAreValid ")

                guard let email = emailField.text else {
                    return
                }
                guard let password = passwordField.text else {
                    return
                }
                func startLoading(){
                    //                forgotPasswordButton.alpha = 0.5
                    //                forgotPasswordButton.isEnabled = false
                    //                createAccountButton.alpha = 0.5
                    //                createAccountButton.isEnabled = false
                    passwordField.alpha = 0.5
                    passwordField.isEnabled = false
                    emailField.alpha = 0.5
                    emailField.isEnabled = false
                    //                signInButton.startLoadingAnimation()
                    ActivityIndicatorView.show("Loading...")
                }
                func stopLoading(){
                    //                forgotPasswordButton.alpha = 1.0
                    //                forgotPasswordButton.isEnabled = true
                    //                createAccountButton.alpha = 1.0
                    //                createAccountButton.isEnabled = true
                    passwordField.alpha = 1.0
                    passwordField.isEnabled = true
                    emailField.alpha = 1.0
                    emailField.isEnabled = true
                    //                self.signInButton.returnToOriginalState()
                    //                self.signInButton.layer.cornerRadius = 5.0
                    ActivityIndicatorView.hiding()
                }
                
                
                startLoading()
                APIManager.callServer.forLogin(email: email, password: password, rememberMe: "true", sucessResult: { (responseModel) in
                    
                    
                    
                    guard let loginModel = responseModel as? LoginRespModel else{
                        stopLoading()
                        return
                    }
                    
                                    
                    if(loginModel.idToken != ""){

                        print("loginModel.idToken :", loginModel.idToken)
                         stopLoading()
                        
//                        UserDefaults.standard.set(true, forKey: "Key") //Bool
//                        UserDefaults.standard.set(1, forKey: "Key")  //Integer
                        UserDefaults.standard.set(loginModel.idToken, forKey: "bP_token")
                        UserDefaults.standard.set("1", forKey: "isLoggedIn")
                        self.getUserInfo()
                        
//                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                        let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
//                        self.present(secondViewController, animated: true, completion: nil)
                        
                        
                    }else{
                        //                    self.errorLabel.textColor = UIColor.red
                        self.errorlabel.text = "Invalid username/password."
                        self.passwordField.text = ""
                        //                    self.passwordField.shake()
                        stopLoading()
                    }
                }, errorResult: { (error) in
                    stopLoading()
                    guard let errorString  = error else {
                        return
                    }
                    self.alert(message: errorString)
                })
                
            }
            
            else{
                self.errorlabel.text = "Invalid username/password."
                
            }
        }
        
        
        func getUserInfo(){
//            startLoading()
            APIManager.callServer.getAccountDetails(sucessResult: { (responseModel) in

                guard let accRespModel = responseModel as? AccountRespModel else{
//                    stopLoading()
                    return
                }
                
                if(accRespModel.id != 0){
                    UserDefaults.standard.set(accRespModel.userType, forKey: "userType")
                    print("&&&&&&", accRespModel.userProfile?.cbvaFirstName)
//                    stopLoading()AccountRespModel
                    //                        UserDefaults.standard.set(true, forKey: "Key") //Bool
                    //                        UserDefaults.standard.set(1, forKey: "Key")  //Integer
                    
                    UserDefaults.standard.set(accRespModel.id, forKey: "bP_userId")
                    UserDefaults.standard.set(accRespModel.firstName, forKey: "bP_userName")
                    UserDefaults.standard.set(accRespModel.email, forKey: "email")
                    
                    // Basic Info
                 /*   arrayBasicInfoDetails.append(accRespModel.firstName)
                    arrayBasicInfoDetails.append(accRespModel.lastName)
                    arrayBasicInfoDetails.append(accRespModel.gender)
                    arrayBasicInfoDetails.append("April 16, 2018")
                    arrayBasicInfoDetails.append(accRespModel.city)
                    arrayBasicInfoDetails.append(accRespModel.phoneNumber)

                    // more Info
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.experience)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.courtSidePreference)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.position)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.height)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.tournamentLevelInterest)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.toursPlayed)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.heightTourRatingEarned)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.cbvaPlayerNumber)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.cbvaFirstName)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.cbvaLastName)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.willingnessToTravel)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.highSchoolAttended)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.indoorClubPlayedAt)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.collegeClub)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.collegeBeach)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.collegeIndoor)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.Points)!)
                    arrayMoreInfoDetails.append((accRespModel.userProfile?.Ranking)!) */
                    
                    
                    
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
                    self.present(secondViewController, animated: true, completion: nil)
                    
                    
                }else{
                    //                    self.errorLabel.textColor = UIColor.red
                    self.errorlabel.text = "Something wrong with server."
                    self.passwordField.text = ""
                    //                    self.passwordField.shake()
////                    stopLoading()
                }
            }, errorResult: { (error) in
//                stopLoading()
                guard let errorString  = error else {
                    return
                }
                self.alert(message: errorString)
            })
            
        }
        
        
        
        func addCookie(name:String, value:String){
            let cookieProperties: [HTTPCookiePropertyKey : Any] = [.name : name,
                                                                   .value : value,
                                                                   .domain : "qa1.singx.co",.path : "/singx",.version : "0",.expires : Date().addingTimeInterval(2629743)
            ]
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
            
        }
        
        
        func getCookie(name:String)-> String{
            
            _ = HTTPCookieStorage.shared.cookies
            let cookieJar = HTTPCookieStorage.shared
            
            for cookie in cookieJar.cookies! {
                
                if(cookie.name == name ){
                    
                    return cookie.value
                }
                else{
                    continue
                }
            }
            return ""
        }
        
}

extension LoginViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
