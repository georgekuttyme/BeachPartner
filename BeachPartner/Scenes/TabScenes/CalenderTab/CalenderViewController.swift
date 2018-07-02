//
//  CalendarViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 16/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class CalenderViewController: BeachPartnerViewController {
    
    @IBOutlet weak var calenderContainerView: UIView!
    @IBOutlet weak var calendarSegmentView: UISegmentedControl!
    
    // MARK:-
    var eventFilterParams: EventFilterParams?

    weak var currentViewController: UIViewController?
    var filterButton : UIBarButtonItem!

    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "MasterCalComponent")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.calenderContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.topItem!.title = "Calendar"
    }
    
    private func setupBarButtons() {
        filterButton = UIBarButtonItem(image: UIImage(named: "ic_filter"), style: .plain, target: self, action: #selector(showFilterView))
        self.navigationItem.rightBarButtonItems = [menuBarButtonItem, filterButton]
    }
    
    // MARK:- Actions
    
    @objc private func showFilterView() {
        
        if Subscription.current.supportForFunctionality(featureId: BenefitType.EventSearch) == false {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
            vc.benefitCode = BenefitType.EventSearch
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "FilterViewSegue", sender: self)
    }
    
    @IBAction func calSegSelection(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            filterButton.isEnabled = true
            filterButton.tintColor = .white
            eventFilterParams = nil
            
            loadMasterCalendar()
        }
        else if sender.selectedSegmentIndex == 1 {
            filterButton.isEnabled = false
            filterButton.tintColor = .clear
            
            loadMyCalendar()
        }
    }
    
    // MARK:- Methods
    
    private func loadMasterCalendar() {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MasterCalComponent")as! MasterCalViewController
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    private func loadMyCalendar() {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCalComponent")as! MyCalViewController
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    private func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FilterViewSegue" {
            let targetVC = segue.destination as! FilterViewController
            targetVC.delegate = self
            
            if let filterParams = eventFilterParams {
                targetVC.filterParams = filterParams
            }
        }
    }
}

extension CalenderViewController: FilterViewControllerDelegate {
    
    func didApplyFilter(filterParams: EventFilterParams) {
        self.eventFilterParams = filterParams
        let activeVC = currentViewController as! MasterCalViewController
        activeVC.filterParams = filterParams
        if activeVC.filterParams == nil{
            filterButton.tintColor = UIColor.white
        }
        filterButton.tintColor = UIColor.cyan
    }
    
    func clearAllFilters() {
        
        self.eventFilterParams = nil
        let activeVC = currentViewController as! MasterCalViewController
        activeVC.filterParams = nil
        
        filterButton.tintColor = .white
    }
}

