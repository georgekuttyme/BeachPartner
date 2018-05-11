//
//  InvitePartnerViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 30/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//

import UIKit
import DropDown
import XLPagerTabStrip

class InvitePartnerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Connections")
    }
    
    
//    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
//    var customViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myteamHeight: NSLayoutConstraint!
//    @IBOutlet weak var tabBtnsView: UIView!
//    @IBOutlet weak var connectionsBtn: UIButton!
//    @IBOutlet weak var connectionsView: UIView!
    
    @IBOutlet weak var bottomview: UIView!
    
    @IBOutlet weak var partnerTableVIew: UITableView!
    @IBOutlet weak var myteamtableView: UITableView!
//    @IBOutlet weak var findPartnerBtn: UIButton!
//    @IBOutlet weak var findPartnerView: UIView!
    
    let dropDown = DropDown()
    private var arrayImage = [AnyHashable]()
    private var i: Int = 0
    
    var isExpanded = false
    var count: Int = 0
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
        dropDown.show()
    }
    
//    var imageSrc: [UIImage] = [
//        UIImage(named: "image_2")!,
//        UIImage(named: "image_3")!,UIImage(named: "image_2")!,
//        UIImage(named: "image_3")!,UIImage(named: "image_2")!,
//        UIImage(named: "image_3")!,UIImage(named: "image_2")!,
//        UIImage(named: "image_3")!,UIImage(named: "image_2")!]
    let name = ["Alivia Orvieto","Marti McLaurin","Liz Held","Alivia Orvieto","Marti McLaurin","Liz Held","Alivia Orvieto","Marti McLaurin","Liz Held"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return name.count
    }
    
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        startPosition = touch?.location(in: self.myteamtableView)
        originalHeight = myteamHeight.constant
    }
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
       
        let endPosition = touch?.location(in: self.myteamtableView)
        let difference = endPosition!.y - startPosition!.y
        
        print("screen size : ",(UIScreen.main.bounds.height/2) + 80 , " diff : ", (originalHeight - difference) )
        if((UIScreen.main.bounds.height/2) - 80 > (originalHeight - difference) ){
        myteamHeight.constant = originalHeight - difference
            
            if(myteamHeight.constant > 100 ){
//                self.bottomview.isHidden = false
            }
            else{
//                self.bottomview.isHidden = true

            }
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = Dummy.data[indexPath.row]
        
        if(tableView == self.myteamtableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyteamCell", for: indexPath) as? MyteamCell
            cell?.nameLbl.text = data.name
            
            if let imageUrl = URL(string: data.imageUrl) {
                cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
                cell?.profileImage.sd_setShowActivityIndicatorView(true)
                cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_placeHolder"))
            }
            
            cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
            cell?.profileImage.clipsToBounds = true
            cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
//            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
            cell?.profileImage.layer.borderWidth = 1.5
            return cell!
        }
       
        
        if(tableView == self.partnerTableVIew){
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePartnerCell", for: indexPath) as? InvitePartnerCell
            cell?.nameLbl.text = data.name
            
            if let imageUrl = URL(string: data.imageUrl) {
                cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
                cell?.profileImage.sd_setShowActivityIndicatorView(true)
                cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_placeHolder"))
            }

            cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
            cell?.profileImage.clipsToBounds = true
//            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
             cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
            cell?.profileImage.layer.borderWidth = 1.5
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyteamCell", for: indexPath) as? MyteamCell
//        cell?.nameLbl.text = name[indexPath.row]
//        let n = Int(arc4random_uniform(42))
//        cell?.profileImage.image = imageSrc[ n % 3 ]
//        cell?.profileImage.layer.cornerRadius = (cell?.imageView?.frame.size.width)!/2
//        cell?.profileImage.clipsToBounds = true
//        cell?.profileImage.layer.borderColor = UIColor.lightGray.cgColor
//        cell?.profileImage.layer.borderWidth = 1
        return cell!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomview.isHidden = true
//        self.findPartnerView.isHidden = true
        // Do any additional setup after loading the view.
        self.dropDown.anchorView = self.menuBtn
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
            else if( item == "About Us") {
                
                UIApplication.shared.openURL(URL(string: "https://www.beachpartner.com/about_us.html")!)
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
    
   
    }

    

