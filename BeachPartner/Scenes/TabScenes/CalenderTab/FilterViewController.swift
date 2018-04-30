//
//  FilterViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 07/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
import DropDown

class FilterViewController: UIViewController {

    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var subTypesBtn: UIButton!
    @IBOutlet weak var eventBtn: UIButton!
    
    let eventdropDown = DropDown()
     let subeventsdropDown = DropDown()
     let yeardropDown = DropDown()
     let monthdropDown = DropDown()
     let statedropDown = DropDown()
     let regiondropDown = DropDown()
    
    
    @IBAction func eventBtnClicked(_ sender: Any) {
    eventdropDown.show()
        
    }
    @IBAction func subeventBtnClicked(_ sender: Any) {
        subeventsdropDown.show()
        
    }
    @IBAction func yearBtnClicked(_ sender: Any) {
        yeardropDown.show()
        
    }
    @IBAction func monthBtnClicked(_ sender: Any) {
        monthdropDown.show()
        
    }
    @IBAction func stateBtnClicked(_ sender: Any) {
        statedropDown.show()
        
    }
    @IBAction func regionBtnClicked(_ sender: Any) {
        regiondropDown.show()
        
    }
    @IBAction func cancelCliked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventdropDown.anchorView = self.eventBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.eventdropDown.dataSource = ["Junior","College Showcase","College Clinic","National Tournament", "Adult"]
        
        self.eventdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.eventdropDown.width = 165
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.eventdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
             self.eventBtn.setTitle(item, for: UIControlState.normal)
        }
        self.eventBtn.setTitle("Choose event type", for: UIControlState.normal)
        self.eventdropDown.selectRow(0)
        
        ///////////////////////////////////
        
        self.subeventsdropDown.anchorView = self.subTypesBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.subeventsdropDown.dataSource = ["10U", "12U", "13U", "14U","15U", "16U","17U", "18U" ]
        
        self.subeventsdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.subeventsdropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.subeventsdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.subTypesBtn.setTitle(item, for: UIControlState.normal)
        }
        self.subTypesBtn.setTitle("Choose subtype", for: UIControlState.normal)
        self.subeventsdropDown.selectRow(0)
        
        ///////////////////////////////////
        
        self.yeardropDown.anchorView = self.yearBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.yeardropDown.dataSource = ["2018", "2019", "2020"]
        
        self.yeardropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.yeardropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.yeardropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.yearBtn.setTitle(item, for: UIControlState.normal)
        }
        self.yearBtn.setTitle("Choose year", for: UIControlState.normal)
        self.yeardropDown.selectRow(0)
        
        ///////////////////////////////////
        
        self.monthdropDown.anchorView = self.monthBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.monthdropDown.dataSource = ["January", "February", "March", "April","May", "June","July", "August", "September","October", "November", "December"]
        
        self.monthdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.monthdropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.monthdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.monthBtn.setTitle(item, for: UIControlState.normal)
        }
        self.monthBtn.setTitle("Choose month", for: UIControlState.normal)
        self.monthdropDown.selectRow(0)
        
        ///////////////////////////////////
        
        self.statedropDown.anchorView = self.stateBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.statedropDown.dataSource = ["January", "February", "March", "April","May", "June","July", "August", "September","October", "November", "December"]
        
        self.statedropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.statedropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.statedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.stateBtn.setTitle(item, for: UIControlState.normal)
        }
        self.stateBtn.setTitle("Choose state", for: UIControlState.normal)
        self.statedropDown.selectRow(0)
        
        ///////////////////////////////////
        
        self.regiondropDown.anchorView = self.regionBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.regiondropDown.dataSource = ["10U", "12U", "13U", "14U","15U", "16U","17U", "18U", ]
        
        self.regiondropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.regiondropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.regiondropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.regionBtn.setTitle(item, for: UIControlState.normal)
        }
        self.regionBtn.setTitle("Choose region", for: UIControlState.normal)
        self.regiondropDown.selectRow(0)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
