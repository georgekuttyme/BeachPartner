//
//  CalendarViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 16/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import DropDown

class CalenderViewController: UIViewController {
    let dropDown = DropDown()
    
@IBOutlet weak var menuBtn: UIBarButtonItem!
    
    
    weak var currentViewController: UIViewController?

    @IBOutlet weak var calenderContainerView: UIView!
    
    @IBOutlet weak var calendarSegmentView: UISegmentedControl!
    
    
    
    @IBAction func calSegSelection(sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0{
                self.loadMasterCalendar()
            }
                
            else if sender.selectedSegmentIndex == 1{
                self.loadMyCalendar()
            }
        
    }
    
    
    func loadMasterCalendar(){
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MasterCalComponent")as! MasterCalViewController
//        newViewController.selSenderDataModel = self.senderDataModel
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    func loadMyCalendar(){
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCalComponent")as! MyCalViewController
//        newViewController.selSenderDataModel = self.senderDataModel
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        dropDown.show()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dropDown.anchorView = self.menuBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.dropDown.dataSource = ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        
        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
        self.dropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                self.performSegue(withIdentifier: "editprofilesegue", sender: self)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
            }
            else if(item == "Logout"){
                self.timoutLogoutAction()
            }
            else if (item == "Help"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                self.present(vc, animated: true, completion: nil)
            }
            else if( item == "Feedback") {
                
                UIApplication.shared.openURL(URL(string: "https://www.beachpartner.com/feedback.html")!)
            }
            else if( item == "About Us") {
                
                UIApplication.shared.openURL(URL(string: "https://www.beachpartner.com/about_us.html")!)
            }
            else if (item == "Settings"){
                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
                controller.SettingsType = "profileSettings"
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(controller, animated: true)
            }
          
            else {
                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "CommmonWebViewController") as! CommmonWebViewController
                controller.contentType = item
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
        self.dropDown.selectRow(0)
        
        
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MasterCalComponent")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.calenderContainerView)
        
//        stepSegmentView.setTitle("Step 1", forSegmentAt: 0)
//        stepSegmentView.setTitle("Step 2", forSegmentAt: 1)
        
        
        
        
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

    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.calenderContainerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
    
    
}
