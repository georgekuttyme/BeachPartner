//
//  ConnectionsViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 18/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//


import UIKit

class ConnectionsViewController : BeachPartnerViewController {
    
    
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
    

        override func viewDidLoad() {
        super.viewDidLoad()

            self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AthleteComponent")
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.connectionsContainerView)

    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController!.navigationBar.topItem!.title = "Connections"
       // self.title = "Connections"
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


