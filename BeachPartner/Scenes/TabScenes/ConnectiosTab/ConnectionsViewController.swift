//
//  ConnectionsViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 18/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//


import UIKit

class ConnectionsViewController : BeachPartnerViewController,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    
    
    
    
//    unfilteredNFLTeams connectedUsers
    var searchController : UISearchController!
    var rightBarButtonItem: UIBarButtonItem!
    var activesearchBar: UISearchBar!
    var filteredNFLTeams: [String]?
    func updateSearchResults(for searchController: UISearchController) {
       
    }
    var searchBtn = UIBarButtonItem()
    @IBOutlet weak var segmentControl: UISegmentedControl!

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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.isHidden = true
        self.searchBtn.tintColor = UIColor.white
        self.searchBtn.isEnabled = true
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Connections"
   
    }

        override func viewDidLoad() {
        super.viewDidLoad()
            
            let searchImage  = UIImage(named: "search")!
            searchBtn  = UIBarButtonItem(image: searchImage ,  style: .plain, target: self, action:#selector(searchBtnClicked(_:)))
            
            navigationItem.rightBarButtonItems = [menuBarButtonItem, searchBtn]
            
            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AthleteComponent")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.connectionsContainerView)

    }
    
    
    @objc func searchBtnClicked(_ sender: AnyObject){
      
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.searchBtn.tintColor = UIColor.clear
        self.searchBtn.isEnabled = false
        self.becomeFirstResponder()
        self.searchController.searchBar.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
         self.navigationController!.navigationBar.topItem!.title = "Connections"
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


