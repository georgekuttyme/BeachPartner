//
//  UIViewController+Alert.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func loadViewControllerFromStoryBoard(identifier:String,name:String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
    func timoutLogoutAction(){
         UserDefaults.standard.set("0", forKey: "isLoggedIn")
//        let userName = UserDefaults.standard.string(forKey: "email")
//        let password = UserDefaults.standard.string(forKey: "password")
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
//        UserDefaults.standard.set(userName, forKey: "email")
//        UserDefaults.standard.set(password, forKey: "password")
        let mainStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginscene") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor(rgb: 0xFA6503)
    }

    func loadNavigationControllerFromStoryBoard(identifier:String,name:String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller:UINavigationController = storyboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        return controller
    }
    
}

