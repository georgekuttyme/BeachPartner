//
//  UIViewController+Alert.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 26/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
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
        UserDefaults.standard.set("", forKey: "locationInitial")
        UserDefaults.standard.set("", forKey: "ageCategory")
        UserDefaults.standard.set("", forKey: "minAge")
        UserDefaults.standard.set("", forKey: "maxAge")
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

