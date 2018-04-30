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

class BPfinderViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, BpFinderDelegate, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title:"Find Partner")
    }
    
    func playButtonPressed(searchList:[SearchUserModel]) {        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentBPcardsNew") as! BPCardsVC
        newViewController.selectedType = "Search"
        newViewController.selectedIndex = 0
        newViewController.searchUsers = searchList
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
        
    }
    
   
    @IBOutlet weak var blueBPCollectionView: UICollectionView!

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    weak var currentViewController: UIViewController?
    @IBOutlet weak var containerView: UIView!
    
//    var imageSrc: [UIImage] = [
//        UIImage(named: "men")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!,UIImage(named: "women")!,
//        UIImage(named: "men")!
//    ]
    
     let dropDown = DropDown()
    @IBAction func menuBtnClicked(_ sender: Any) {
        dropDown.show()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentSettings")as! SettingsViewController
        newViewController.SettingsType = "SearchSettings"
        newViewController.bpDelegate = self
        self.currentViewController = newViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        
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
        
//        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentIndonesia") as! AddIndonesiaReceiverVC
//        newViewController.selectedNation = self.nationListdata[index]
//        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
//        self.currentViewController = newViewController
//
        
        
        let newViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentSettings")as! SettingsViewController
        newViewController.bpDelegate = self
        newViewController.SettingsType = "SearchSettings"
        self.currentViewController = newViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
   
        
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Dummy.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = Dummy.data[indexPath.row]

        
//        if collectionView == self.blueBPCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
        
        if let imageUrl = URL(string: data.imageUrl) {
            cell.imageView.sd_setIndicatorStyle(.whiteLarge)
            cell.imageView.sd_setShowActivityIndicatorView(true)
            cell.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_placeHolder"))
        }
        
        
//            cell.imageView.image = imageSrc[indexPath.row]
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.borderColor = UIColor.blue.cgColor
        cell.imageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0) as! CGColor
            cell.imageView.layer.borderWidth = 1
            return cell
//        }
        
        
        
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
