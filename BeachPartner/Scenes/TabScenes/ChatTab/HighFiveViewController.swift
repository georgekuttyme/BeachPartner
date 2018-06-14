//
//  HighFiveViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 13/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
//import DropDown
import Floaty

class HighfiveCell: UITableViewCell {
    
    @IBOutlet weak var highfiveView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var highfiveImage: UIImageView!
    
}
class HighFiveViewController: BeachPartnerViewController,UITableViewDelegate,UITableViewDataSource {
    var isCallHifiview:Bool = false
    var connectedUsers = [ConnectedUserModel]()
    var selectedTabViewController:Int!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var tblHighFiveList: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet var toastLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toastLabel.isHidden = true
        
        
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
                self.toastLabel.textColor = UIColor.gray
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
        let name = (connectedUser?.firstName) ?? "" + " " + (connectedUser?.lastName)! ?? ""
        cell.notificationLbl.text =  name + " sent you a High Five"
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
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.23
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
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
