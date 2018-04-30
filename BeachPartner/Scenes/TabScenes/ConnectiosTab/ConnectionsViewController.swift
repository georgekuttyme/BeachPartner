//
//  ConnectionsViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 18/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//


import UIKit
import DropDown
class ConnectionsViewController : UIViewController{
    
        let dropDown = DropDown()
   private var arrayImage = [AnyHashable]()
        var count: Int = 0
    private var i: Int = 0
    
    var isExpanded = false


    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
        dropDown.show()
    }
    
    
    weak var currentViewController: UIViewController?
    
    @IBOutlet weak var connectionsContainerView: UIView!
    
    @IBOutlet weak var connectionSegmentView: UISegmentedControl!
    
    
    
    @IBAction func connSegSelection(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            self.loadAthleteView()
        }
            
        else if sender.selectedSegmentIndex == 1{
            self.loadCoachView()
        }
        
    }
    
    
    func loadAthleteView(){
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "AthleteComponent")as! AthleteViewController
        //        newViewController.selSenderDataModel = self.senderDataModel
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    func loadCoachView(){
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "CoachComponent")as! CoachViewController
        //        newViewController.selSenderDataModel = self.senderDataModel
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    

        override func viewDidLoad() {
        super.viewDidLoad()
       
        arrayImage = ["", "", ""]
        count = 0
        
       self.dropDown.anchorView = self.menuBtn
            self.dropDown.dataSource =  ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
     self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
            self.dropDown.width = 150
 
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
                else if (item == "Settings"){
                    let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
                    controller.SettingsType = "profileSettings"
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController!.navigationBar.topItem!.title = ""
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else if (item == "Help"){
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                    self.present(vc, animated: true, completion: nil)
                }
                else if( item == "About Us") {
                    
                    UIApplication.shared.openURL(URL(string: "https://www.beachpartner.com/about_us.html")!)
                }
                else if( item == "Feedback") {
                    
                    UIApplication.shared.openURL(URL(string: "https://www.beachpartner.com/feedback.html")!)
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
            
            
            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AthleteComponent")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.connectionsContainerView)

    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController!.navigationBar.topItem!.title = "Connections"
       // self.title = "Connections"
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
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.connectionsContainerView!)
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


