//
//  NotesViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 02/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
import DropDown
class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    let dropDown = DropDown()
    private var arrayImage = [AnyHashable]()
    private var i: Int = 0
    
    var noOfCells = 0
    var isExpanded = false
    var count: Int = 0
       @IBOutlet weak var menuBtn: UIBarButtonItem!
    
      @IBOutlet weak var addBtn: UIButton!
     @IBOutlet weak var notesTableview: UITableView!
    @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
        dropDown.show()
    }
    
//      let time = [""]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell
        cell?.timeLabel.text = "Just Now"
        cell?.deleteNotesBtn.addTarget(self, action:#selector(deleteBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        //then make a action method :
        
       
        return cell!
    }
    
    
    @objc func deleteBtnClicked(sender:UIButton!) {
        self.noOfCells = self.noOfCells - 1
        self.notesTableview.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        self.noOfCells = self.noOfCells + 1
        self.notesTableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround() 
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
        
        
        
    }
    func notesClicked(){
        
    }
    
    
    }

    

    
    
    
    
    
    


   


