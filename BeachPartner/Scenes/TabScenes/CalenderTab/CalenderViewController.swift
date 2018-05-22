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
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var button1 : UIBarButtonItem!
    
    @IBAction func calSegSelection(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            filterButton.isEnabled = true
            filterButton.tintColor = .white
            self.loadMasterCalendar()
        }
            
        else if sender.selectedSegmentIndex == 1{
            filterButton.isEnabled = false
            filterButton.tintColor = .clear
            self.loadMyCalendar()
        }
        
    }
    @objc func action() {
        dropDown.show()
    }
    func rightBarBtn(){
        button1 = UIBarButtonItem(image: UIImage(named: "menudot"), style: .plain, target: self, action: #selector(action))
        self.navigationItem.rightBarButtonItem  = button1
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

    override func viewWillAppear(_ animated: Bool) {
          self.navigationController!.navigationBar.topItem!.title = "Calendar"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarBtn()
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MasterCalComponent")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.calenderContainerView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        setDropDwonMenu()
    }
    func setDropDwonMenu()  {
        
        self.dropDown.anchorView = self.button1
        self.dropDown.dataSource =  ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
        self.dropDown.width = 150
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
                self.navigationController?.pushViewController(identifier, animated: true)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
            }
                
            else if(item == "Logout"){
                let refreshAlert = UIAlertController(title: "Logout", message: "Do you really want to logout from Beach Partner?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.timoutLogoutAction()
                    
                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
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
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "FilterViewSegue" {
            
            let targetVC = segue.destination as! FilterViewController
            targetVC.delegate = self
        }
     }
}

extension CalenderViewController: FilterViewControllerDelegate {
    
    func didApplyFilter(params: [String : String]) {
        let activeVC = currentViewController as! MasterCalViewController
        activeVC.filterParams = params
    }
}

