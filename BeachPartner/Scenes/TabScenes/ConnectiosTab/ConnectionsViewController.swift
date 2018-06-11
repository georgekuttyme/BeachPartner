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
    var searchBtn = UIBarButtonItem()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var coachVC : CoachViewController?
    weak var currentViewController: UIViewController?
    var atheleteVC : AthleteViewController?
    @IBOutlet weak var connectionsContainerView: UIView!
    
    @IBOutlet weak var connectionSegmentView: UISegmentedControl!
    
    var selectedIndexItem = ""
    
    @IBAction func connSegSelection(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            selectedIndexItem = "athelete"
            self.loadAthleteView()
        }
        else if sender.selectedSegmentIndex == 1{
            selectedIndexItem = "coach"
            self.loadCoachView()
        }
    }
    
    
    func loadAthleteView(){
        atheleteVC?.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: atheleteVC!)
        self.currentViewController = atheleteVC
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            if selectedIndexItem == "athelete"{
                atheleteVC?.filterConnectedusers = (atheleteVC?.connectedUsers)!
                atheleteVC?.collectionView.reloadData()
            }else{
                coachVC?.filterConnectedusers = (coachVC?.connectedUsers)!
                coachVC?.collectionView.reloadData()
            }
        }
    }
    
    func loadCoachView(){
        coachVC?.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: coachVC!)
        self.currentViewController = coachVC
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        self.searchBtn.tintColor = UIColor.white
        self.searchBtn.isEnabled = true
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Connections"
        if selectedIndexItem == "athelete"{
            atheleteVC?.displayType = ""
            atheleteVC?.collectionView.reloadData()
        }else {
            coachVC?.displayType = ""
            coachVC?.collectionView.reloadData()
        }
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        print("\n\n\n",selectedIndexItem)
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            if selectedIndexItem == "athelete"{
                atheleteVC?.atheleteConnectionsSearch(searchItem: searchText)
                atheleteVC?.displayType = "search"
                atheleteVC?.collectionView.reloadData()
            }else{
                coachVC?.coachConnectionsSearch(searchItem: searchText)
                coachVC?.displayType = "search"
                coachVC?.collectionView.reloadData()
            }
            
        } else {

        }
    }

        override func viewDidLoad() {
        super.viewDidLoad()
            
            atheleteVC = (self.storyboard?.instantiateViewController(withIdentifier: "AthleteComponent")as! AthleteViewController)
            coachVC = (self.storyboard?.instantiateViewController(withIdentifier: "CoachComponent")as! CoachViewController)
            
            let searchImage  = UIImage(named: "search")!
            searchBtn  = UIBarButtonItem(image: searchImage ,  style: .plain, target: self, action:#selector(searchBtnClicked(_:)))
            navigationItem.rightBarButtonItems = [menuBarButtonItem, searchBtn]
            

            
            self.currentViewController = atheleteVC
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            selectedIndexItem = "athelete"
            self.addChildViewController(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.connectionsContainerView)

    }
    
    
    @objc func searchBtnClicked(_ sender: AnyObject){
        
        if selectedIndexItem == "athelete"{
            atheleteVC?.displayType = "search"
        }else {
            coachVC?.displayType = "search"
        }
        self.searchController = UISearchController(searchResultsController:  nil)
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = UIColor.clear
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.showsCancelButton = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
//        searchController.searchBar.sizeToFit()

        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.searchBtn.tintColor = UIColor.clear
        self.searchBtn.isEnabled = false
//        self.becomeFirstResponder()
        self.searchController.searchBar.becomeFirstResponder()
       
    }

    override func viewWillAppear(_ animated: Bool) {
         self.navigationController!.navigationBar.topItem!.title = "Connections"
        let searchImage  = UIImage(named: "search")!
        searchBtn  = UIBarButtonItem(image: searchImage ,  style: .plain, target: self, action:#selector(searchBtnClicked(_:)))
        navigationItem.rightBarButtonItems = [menuBarButtonItem, searchBtn]
        if atheleteVC?.displayType == "search" || coachVC?.displayType == "search" {
            self.searchBtn.tintColor = UIColor.white
            self.searchBtn.isEnabled = true
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Connections"
            if selectedIndexItem == "athelete"{
                atheleteVC?.displayType = ""
                atheleteVC?.collectionView.reloadData()
            }else {
                coachVC?.displayType = ""
                coachVC?.collectionView.reloadData()
            }
        }
        
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


