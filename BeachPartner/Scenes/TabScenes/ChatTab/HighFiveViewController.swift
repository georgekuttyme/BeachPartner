//
//  HighFiveViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 13/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
import DropDown
import Floaty

class HighfiveCell: UITableViewCell {
    
    @IBOutlet weak var highfiveView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var highfiveImage: UIImageView!
    
}
class HighFiveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var isCallHifiview:Bool = false
    var connectedUsers = [ConnectedUserModel]()
    var selectedTabViewController:Int!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var tblHighFiveList: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet var toastLabel: UILabel!
    let dropDown = DropDown()
    var button1 : UIBarButtonItem!
    
    @IBAction func didTapMenuButton(_ sender: Any) {
        dropDown.show()
    }
    
    func rightBarBtn(){
        button1 = UIBarButtonItem(image: UIImage(named: "menudot"), style: .plain, target: self, action: #selector(action))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc func action() {
        dropDown.show()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toastLabel.isHidden = true
        rightBarBtn()
        
        
        self.hideKeyboardWhenTappedAround()
        
        
        let floaty = Floaty()
        floaty.size = 45
        floaty.paddingY = 85
        floaty.buttonColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        floaty.plusColor = UIColor.white
        
        floaty.addItem("", icon: UIImage(named: "highfive")!,handler: { item in
            self.navigationController?.popViewController(animated: false);
            floaty.close()
        })
        floaty.addItem("", icon: UIImage(named: "chat")!,handler: { item in
            let favoritesVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatUsersListViewController") as! ChatUsersListViewController
            self.navigationController?.pushViewController(favoritesVC, animated: false)
            floaty.close()
        })
        self.view.addSubview(floaty)
        selectedTabViewController = 4
        isCallHifiview = true

        // Do any additional setup after loading the view. 55
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "High Five"
        self.getHifiList()
    }
    override func viewDidAppear(_ animated: Bool) {
        setDropDwonMenu()
        if !isCallHifiview {
            isCallHifiview = true
            let newViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HighFiveViewController")as! HighFiveViewController
            self.currentViewController = newViewController
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.view)
        }
       
    }
    
    func getHifiList(){
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUserConnectionList(status:"status=Hifi&showReceived=true",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else{
                return
            }
            
            self.connectedUsers = connectedUserModelArray.connectedUserModel
            print(self.connectedUsers.count)
            if self.connectedUsers.count > 0 {
                self.toastLabel.isHidden = true
            }
            else {
                self.toastLabel.isHidden = false
            }
            self.tblHighFiveList.reloadData()
            ActivityIndicatorView.hiding()
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let connectedUser = self.connectedUsers[indexPath.row].connectedUser
        
        let cell : HighfiveCell = tableView.dequeueReusableCell(withIdentifier: "HighfiveCell", for: indexPath) as! HighfiveCell
        
        cell.notificationLbl.text =  (connectedUser?.firstName) ?? "" + " sent you a High Five"
        cell.highfiveView.layer.borderColor = UIColor.lightGray.cgColor
        cell.highfiveView.layer.borderWidth = 1
        cell.highfiveView.dropShadow()
        cell.timeLbl.text =  (connectedUser?.createdDate) ?? ""
        
        if let imageUrl = URL(string: (connectedUser?.imageUrl) ?? "") {
            cell.profileImage.sd_setIndicatorStyle(.whiteLarge)
            cell.profileImage.sd_setShowActivityIndicatorView(true)
            cell.profileImage.sd_setImage(with: imageUrl, placeholderImage:#imageLiteral(resourceName: "user"))
        }
        
        cell.highfiveImage.image = UIImage(named:"highfive")!
        //      cell.profileImage.image = imageProf[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        isCallHifiview = false
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentBPcardsNew") as! BPCardsVC
        newViewController.selectedIndex = indexPath.row
        newViewController.selectedType = "Hifi"
        newViewController.connectedUsers = self.connectedUsers
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let curentViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController")as! HomeTabViewController
        self.currentViewController = curentViewController
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.view!)
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
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: CGRect(x:self.bounds.origin.x,y:self.bounds.origin.y,width:self.bounds.size.width-37,height:self.bounds.size.height )).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
