//
//  InviteParentViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
class InviteParentViewController: ButtonBarPagerTabStripViewController {
    
    
    var event: GetEventRespModel?
    
    //    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*   settings.style.buttonBarBackgroundColor = UIColor(rgb: 0x20307F)
         settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0x20307F)
         settings.style.selectedBarBackgroundColor = UIColor(rgb: 0x20307F)
         
         settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
         settings.style.selectedBarHeight = 2.0
         settings.style.buttonBarMinimumLineSpacing = 0
         
         settings.style.buttonBarItemTitleColor = .white
         settings.style.buttonBarItemsShouldFillAvailiableWidth = true
         
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0
         
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
         guard changeCurrentIndex == true else { return }
         oldCell?.label.textColor = .white
         newCell?.label.textColor = .white
         
         }
         */
        
        let menuButton = UIButton(type: UIButtonType.system)
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        menuButton.addTarget(self, action: #selector(openMenu), for:    .touchUpInside)
        menuButton.setImage(UIImage(named: "menudot"), for: UIControlState())
        let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItems = [menuBarButtonItem]
        
        self.dropDown.anchorView = menuButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.dropDown.dataSource = ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        
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
                self.navigationController?.pushViewController(identifier, animated: true)
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
        
        
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = UIColor(rgb: 0x20307F)
        settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0x20307F)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "CalenderTab", bundle: nil).instantiateViewController(withIdentifier: "invitePartner") as! InvitePartnerViewController
        child_1.event = self.event
        let child_2 = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "partnerFinder")
        return [child_1, child_2]
    }
    
    @objc func openMenu() {
        dropDown.show()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
