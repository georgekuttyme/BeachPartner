//
//  InstagramViewController.swift
//  BeachPartner
//
//  Created by seqato on 23/02/18.
//  Copyright © 2018 seqato. All rights reserved.
//

import UIKit

class InstagramViewController: UIViewController, UIWebViewDelegate{

 
    @IBOutlet var instaLogin: UIWebView!
    
    var loginActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginInsta()
        instaLogin.delegate = self
        
        unSignedRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginInsta(){
        
        APIManager.callServer.forInstaLogin(sucessResult: { (responseModel) in
            guard let loginModel = responseModel as? LoginRespModel else {
                return
            }
            print("loginModel >>>",loginModel)
            self.getUserInfo1()
        },errorResult: {(error) in
            
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }

    func getUserInfo1(){
        APIManager.callServer.getAccountDetails(sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? AccountRespModel else{
                return
            }
            print("AccountRespModel >>> ",accRespModel)
            UserDefaults.standard.set(accRespModel.location , forKey: "locationInitial")
            
                UserDefaults.standard.set(accRespModel.userType, forKey: "userType")
                print("&&&&&&", accRespModel.userProfile ?? " ")
                if accRespModel.userProfile == nil{
                    UserDefaults.standard.set(0, forKey: "NewUser")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "complete-profile-popup"), object: nil)
                }else{
                    UserDefaults.standard.set(1, forKey: "NewUser")
                }
                
                UserDefaults.standard.set(accRespModel.id, forKey: "bP_userId")
                UserDefaults.standard.set(accRespModel.firstName, forKey: "bP_userName")
                
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
                self.present(secondViewController, animated: true, completion: nil)
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
        
    }
    
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        instaLogin.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            let token = requestURLString.substring(from: range.upperBound)
            print("^^^",token)
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            
//            String(requestURLString[range.upperBound])
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
        UserDefaults.standard.set(authToken, forKey: "INSTATOKEN")
//        navigationController?.popViewController(animated: true)
        
        self.loginInsta()
        
//        dismiss(animated: false) {
//            self.loginInsta()
//        }
//        dismiss(animated: true, completion:nil)
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        loginActivityIndicator.isHidden = false
//        loginActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        loginActivityIndicator.isHidden = true
//        loginActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    func loginFb(){
        
        APIManager.callServer.forInstaLogin( sucessResult: { (responseModel) in
            guard let loginModel = responseModel as? LoginRespModel else{
                return
            }
            if(loginModel.idToken != ""){
                UserDefaults.standard.set(loginModel.idToken, forKey: "bP_token")
                self.getUserInfo()
            }
        }, errorResult: { (error) in

            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
        
    }
    func getUserInfo(){

        APIManager.callServer.getAccountDetails(sucessResult: { (responseModel) in
            guard let accRespModel = responseModel as? AccountRespModel else{
                return
            }
            if(accRespModel.id != 0){
                print("&&&&&&", accRespModel.userProfile?.cbvaFirstName ?? "")
                UserDefaults.standard.set(accRespModel.id, forKey: "bP_userId")
                UserDefaults.standard.set(accRespModel.firstName, forKey: "bP_userName")
                UserDefaults.standard.set(accRespModel.email, forKey: "email")
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! TabBarController
                self.present(secondViewController, animated: true, completion: nil)
            }
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
        
    }
    
    

}
