//
//  BPfinderViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import DropDown
import XLPagerTabStrip

class BPfinderViewController: BeachPartnerViewController, BpFinderDelegate, IndicatorInfoProvider {
    var selectedCardType:String!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title:"Find Partner")
    }
    
    func playButtonPressed(searchList:[SearchUserModel]) {        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentBPcardsNew") as! BPCardsVC
        newViewController.delegate = self
        if self.selectedCardType == "invitePartner" {
         newViewController.selectedType = selectedCardType
        }
        else{
         newViewController.selectedType = "Search"
        }
        newViewController.selectedIndex = 0
        newViewController.searchUsers = searchList
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
   
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!

    
    weak var currentViewController: UIViewController?
//    let dropDown = DropDown()
    
//    @IBAction func menuBtnClicked(_ sender: Any) {
//        dropDown.show()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addMenuDropDown()
    }

    override func viewWillAppear(_ animated: Bool) {
        let image : UIImage = UIImage(named: "BP.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView

        if currentViewController is SettingsViewController {
            return
        }
        showSettingsView()
//        let locationSettings = UserDefaults.standard.string(forKey: "LocationSettings") ?? "0"
//        if locationSettings == "0" {
//            UserDefaults.standard.set("0", forKey: "LocationSettings")
//            showSettingsView()
//        }
//        UserDefaults.standard.set("0", forKey: "LocationSettings")
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
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
    
    override func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func showSettingsView() {
        let newViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentSettings")as! SettingsViewController
        newViewController.SettingsType = "SearchSettings"
        newViewController.bpDelegate = self
        self.currentViewController = newViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
    }
    
//    func addMenuDropDown() {
//        self.dropDown.anchorView = self.menuBtn // UIView or UIBarButtonItem
//        // The list of items to display. Can be changed dynamically
//        //        self.dropDown.direction = .bottom
//        self.dropDown.dataSource = ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
//
//        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
//        self.dropDown.width = 150
//        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
//        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item:",item," at index:",index)
//            if(item == "My Profile"){
//                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
//                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
//                let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
//                self.navigationController?.pushViewController(identifier, animated: true)
//                self.tabBarController?.tabBar.isHidden = false
//                self.navigationController!.navigationBar.topItem!.title = ""
//                self.navigationController?.isNavigationBarHidden = false
//            }
//
//            else if(item == "Logout"){
//                let refreshAlert = UIAlertController(title: "Logout", message: "Do you really want to logout from Beach Partner?", preferredStyle: UIAlertControllerStyle.alert)
//
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//
//                    self.timoutLogoutAction()
//
//                }))
//                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                    print("Handle Cancel Logic here")
//                }))
//
//                self.present(refreshAlert, animated: true, completion: nil)
//            }
//            else if (item == "Settings"){
//                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
//                controller.SettingsType = "profileSettings"
//                self.tabBarController?.tabBar.isHidden = false
//                self.navigationController!.navigationBar.topItem!.title = ""
//                self.navigationController?.isNavigationBarHidden = false
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//            else if (item == "Help"){
//                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
//                self.present(vc, animated: true, completion: nil)
//            }
//            else {
//                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "CommmonWebViewController") as! CommmonWebViewController
//                vc.titleText = item
//                self.tabBarController?.tabBar.isHidden = false
//                self.navigationController!.navigationBar.topItem!.title = ""
//                self.navigationController?.isNavigationBarHidden = false
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//        self.dropDown.selectRow(0)
//    }
}

extension BPfinderViewController: BPCardsVCDelegate {
    
    func resumeSwipeGame() {
        showSettingsView()
    }
}
