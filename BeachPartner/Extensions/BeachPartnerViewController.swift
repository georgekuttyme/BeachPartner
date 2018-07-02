//
//  BeachPartnerViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 30/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import DropDown
class BeachPartnerViewController: UIViewController {
    let dropDown = DropDown()
//    weak var currentViewController: UIViewController?
    
    
    var menuBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let menuButton = UIButton(type: UIButtonType.system)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(openMenu), for:    .touchUpInside)
        menuButton.setImage(UIImage(named: "menudot"), for: UIControlState())
        menuBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItems = [menuBarButtonItem]
        
        self.dropDown.anchorView = menuButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.dropDown.dataSource = ["My Profile","Subscription","Add-ons","Feedback","Settings", "Help","Log Out"]
        
        self.dropDown.bottomOffset = CGPoint(x: 20, y:30)
        self.dropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
                let navController = UINavigationController(rootViewController: identifier)
                self.present(navController, animated: true, completion: nil)
//                self.navigationController?.pushViewController(identifier, animated: true)
//                self.tabBarController?.tabBar.isHidden = false
//                self.navigationController!.navigationBar.topItem!.title = ""
//                self.navigationController?.isNavigationBarHidden = false
            }
            else if(item == "Log Out"){
                
                let refreshAlert = UIAlertController(title: "Log Out", message: "Do you really want to log out from Beach Partner?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                 
                    self.timoutLogoutAction()
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
//                self.timoutLogoutAction()
            }
            else if (item == "Settings"){
                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
                controller.SettingsType = "profileSettings"
                let navController = UINavigationController(rootViewController: controller)
//                self.tabBarController?.tabBar.isHidden = false
//                self.tabBarController!.navigationBar.topItem!.title = ""
//                self.tabBarController?.isNavigationBarHidden = false
                self.present(navController, animated: true, completion: nil)
                
            }
            else if (item == "Help"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                self.present(vc, animated: true, completion: nil)
            }
            else if (item == "Subscription") {
                //Subscription
                let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionTypeViewController") as! SubscriptionTypeViewController
                self.present(vc, animated: true, completion: nil)
            }
            else if (item == "Add-ons") {
                let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddonsViewController") as! AddonsViewController
                self.present(vc, animated: true, completion: nil)
            }
            else {
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CommmonWebViewController") as! CommmonWebViewController
                vc.titleText = item
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.present(vc, animated: true, completion: nil)
            }
        }
        self.dropDown.selectRow(0)
    }
    
    @objc func openMenu() {
        dropDown.show()
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }

}
