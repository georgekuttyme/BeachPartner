

//
//  FilterViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 07/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
import DropDown

protocol FilterViewControllerDelegate {
    
    func didApplyFilter(filterParams: EventFilterParams)
    func clearAllFilters()
}

struct EventFilterParams {
    var eventType: String?
    var subEventType: String?
    var year: String?
    var month: String?
    var state: String?
    var region: String?
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var subTypesBtn: UIButton!
    @IBOutlet weak var eventBtn: UIButton!
    
    var stateList = [String]()
    var regionList = [String]()
    
    let eventdropDown = DropDown()
    let subeventsdropDown = DropDown()
    let yeardropDown = DropDown()
    let monthdropDown = DropDown()
    let statedropDown = DropDown()
    let regiondropDown = DropDown()
    
    let eventList = ["Junior",
                     "College Showcase",
                     "College Clinic",
                     "National Tournament",
                     "Adult"]
    let subeventListJunior = ["10U",
                              "12U",
                              "13U",
                              "14U",
                              "15U",
                              "16U",
                              "17U",
                              "18U"]
    let subeventListAdult = ["Unrated",
                             "B",
                             "A",
                             "AA",
                             "AAA",
                             "Open",
                             "CoEd",
                             "CoEd Unrated",
                             "CoEd B",
                             "CoEd A",
                             "CoEd AA",
                             "CoEd AAA",
                             "CoEd Open"]
    let yearList = ["2018",
                    "2019",
                    "2020"]
    let monthList = ["January",
                     "February",
                     "March",
                     "April",
                     "May",
                     "June",
                     "July",
                     "August",
                     "September",
                     "October",
                     "November",
                     "December"]
    
    
    var filterParams: EventFilterParams?
    var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocations()
        loadRegion()
        
        self.eventdropDown.anchorView = self.eventBtn // UIView or UIBarButtonItem
        self.eventdropDown.dataSource = eventList
        self.eventdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.eventdropDown.width = 165
        self.eventdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.eventBtn.setTitle(item, for: UIControlState.normal)
            
            if item == "Junior" || item == "Adult" {
                self.subTypesBtn.setTitle("Choose subtype", for: UIControlState.normal)
            }
            else {
                self.subTypesBtn.setTitle("Not Applicable", for: UIControlState.normal)
            }
            self.subeventsdropDown.clearSelection()
        }
        self.eventBtn.setTitle("Choose event type", for: UIControlState.normal)
        
        if let eventType = filterParams?.eventType, let index = eventList.index(of: eventType) {
            self.eventdropDown.selectRow(index)
            self.eventBtn.setTitle(eventType, for: UIControlState.normal)
        }
        
        ///////////////////////////////////
        
        self.subeventsdropDown.anchorView = self.subTypesBtn // UIView or UIBarButtonItem
        self.subeventsdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.subeventsdropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.subeventsdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.subTypesBtn.setTitle(item, for: UIControlState.normal)
        }
        self.subTypesBtn.setTitle("Choose subtype", for: UIControlState.normal)
        
        if let subEventType = filterParams?.subEventType, let eventType = filterParams?.eventType {
            
            if eventType == "Junior" {
                
                if let index = subeventListJunior.index(of: subEventType) {
                    self.subeventsdropDown.selectRow(index)
                    self.subTypesBtn.setTitle(subEventType, for: UIControlState.normal)
                }
            }
            else if eventType == "Adult" {
                
                if let index = subeventListAdult.index(of: subEventType) {
                    
                    self.subeventsdropDown.selectRow(index)
                    self.subTypesBtn.setTitle(subEventType, for: UIControlState.normal)
                }
            }
        }
        
        
        ///////////////////////////////////
        
        self.yeardropDown.anchorView = self.yearBtn // UIView or UIBarButtonItem
        //        self.dropDown.direction = .bottom
        self.yeardropDown.dataSource = yearList
        self.yeardropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.yeardropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.yeardropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.yearBtn.setTitle(item, for: UIControlState.normal)
        }
        self.yearBtn.setTitle("Choose year", for: UIControlState.normal)
        
        if let year = filterParams?.year, let index = yearList.index(of: year) {
            self.yeardropDown.selectRow(index)
            self.yearBtn.setTitle(year, for: UIControlState.normal)
        }
        
        
        ///////////////////////////////////
        
        self.monthdropDown.anchorView = self.monthBtn // UIView or UIBarButtonItem
        self.monthdropDown.dataSource = monthList
        self.monthdropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.monthdropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.monthdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.monthBtn.setTitle(item, for: UIControlState.normal)
        }
        self.monthBtn.setTitle("Choose month", for: UIControlState.normal)
        
        if let month = filterParams?.month, let index = monthList.index(of: month) {
            self.monthdropDown.selectRow(index)
            self.monthBtn.setTitle(month, for: UIControlState.normal)
        }
        
        ///////////////////////////////////
        
        self.statedropDown.anchorView = self.stateBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        self.statedropDown.dataSource = self.stateList
        
        self.statedropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.statedropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.statedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.stateBtn.setTitle(item, for: UIControlState.normal)
        }
        self.stateBtn.setTitle("Choose state", for: UIControlState.normal)
        
        if let state = filterParams?.state, let index = stateList.index(of: state) {
            self.statedropDown.selectRow(index)
            self.stateBtn.setTitle(state, for: UIControlState.normal)
        }
        
        ///////////////////////////////////
        
        self.regiondropDown.anchorView = self.regionBtn // UIView or UIBarButtonItem
        self.regiondropDown.dataSource = self.regionList
        self.regiondropDown.bottomOffset = CGPoint(x: 0, y:0)
        self.regiondropDown.width = 150
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.regiondropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.regionBtn.setTitle(item, for: UIControlState.normal)
        }
        self.regionBtn.setTitle("Choose region", for: UIControlState.normal)
        
        if let region = filterParams?.region, let index = regionList.index(of: region) {
            self.regiondropDown.selectRow(index)
            self.regionBtn.setTitle(region, for: UIControlState.normal)
        }
    }
    
    @IBAction func eventBtnClicked(_ sender: Any) {
        eventdropDown.show()
    }
    
    @IBAction func subeventBtnClicked(_ sender: Any) {
        
        if eventdropDown.selectedItem == "Junior" {
            self.subeventsdropDown.dataSource = subeventListJunior
        }
        else if eventdropDown.selectedItem == "Adult" {
            self.subeventsdropDown.dataSource = subeventListAdult
        }
        else {
            self.subeventsdropDown.dataSource = []
        }
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
        
        if filterParams == nil {
            filterParams = EventFilterParams(eventType: nil, subEventType: nil, year: nil, month: nil, state: nil, region: nil)
        }
        filterParams?.eventType = eventdropDown.selectedItem
        filterParams?.subEventType = subeventsdropDown.selectedItem
        filterParams?.year = yeardropDown.selectedItem
        filterParams?.month = monthdropDown.selectedItem
        filterParams?.state = statedropDown.selectedItem
        filterParams?.region = regiondropDown.selectedItem
        
        delegate?.didApplyFilter(filterParams: filterParams!)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    func loadLocations(){
        stateList.append("Alabama");
        stateList.append("Alaska");
        stateList.append("Arizona");
        stateList.append("Arkansas");
        stateList.append("California");
        stateList.append("Colorado");
        stateList.append("Connecticut");
        stateList.append("Delaware");
        stateList.append("Florida");
        stateList.append("Georgia");
        stateList.append("Hawaii");
        stateList.append("Idaho");
        stateList.append("Illinois");
        stateList.append("Indiana");
        stateList.append("Iowa");
        stateList.append("Kansas");
        stateList.append("Kentucky");
        stateList.append("Louisiana");
        stateList.append("Maine");
        stateList.append("Maryland");
        stateList.append("Massachusetts");
        stateList.append("Michigan");
        stateList.append("Minnesota");
        stateList.append("Mississippi");
        stateList.append("Missouri");
        stateList.append("Montana");
        stateList.append("Nebraska");
        stateList.append("Nevada");
        stateList.append("New Hampshire");
        stateList.append("New Jersey");
        stateList.append("New Mexico");
        stateList.append("New York");
        stateList.append("North Carolina");
        stateList.append("North Dakota");
        stateList.append("Ohio");
        stateList.append("Oklahoma");
        stateList.append("Oregon");
        stateList.append("Pennsylvania");
        stateList.append("Rhode Island");
        stateList.append("South Carolina");
        stateList.append("South Dakota");
        stateList.append("Tennessee");
        stateList.append("Texas");
        stateList.append("Utah");
        stateList.append("Vermont");
        stateList.append("Virginia");
        stateList.append("Washington");
        stateList.append("West Virginia");
        stateList.append("Wisconsin");
        stateList.append("Wyoming");
    }
    func loadRegion(){
        regionList.append("Alaska Region (AK)");
        regionList.append("Aloha Region (AH)");
        regionList.append("Arizona Region (AZ)");
        regionList.append("Badger Region (BG)");
        regionList.append("Bayou Region (BY)");
        regionList.append("Carolina Region (CR)");
        regionList.append("Chesapeake Region (CH)");
        regionList.append("Columbia Empire Region (CE)");
        regionList.append("Delta Region (DE)");
        regionList.append("Evergreen Region (EV)");
        regionList.append("Florida Region (FL)");
        regionList.append("Garden Empire Region (GE)");
        regionList.append("Gateway Region (GW)");
        regionList.append("Great Lakes Region (GL)");
        regionList.append("Great Plains Region (GP)");
        regionList.append("Gulf Coast Region (GC)");
        regionList.append("Heart of America Region (HA)");
        regionList.append("Hoosier Region (HO)");
        regionList.append("Intermountain Region (IM)");
        regionList.append("Iowa Region (IA)");
        regionList.append("Iroquois Empire Region (IE)");
        regionList.append("Keystone Region (KE)");
        regionList.append("Lakeshore Region (LK)");
        regionList.append("Lone Star Region (LS)");
        regionList.append("Moku O Keawe Region (MK)");
        regionList.append("New England Region (NE)");
        regionList.append("North Country Region (NO)");
        regionList.append("North Texas Region (NT)");
        regionList.append("Northern California Region (NC)");
        regionList.append("Ohio Valley Region (OV)");
        regionList.append("Oklahoma Region (OK)");
        regionList.append("Old Dominion Region (OD)");
        regionList.append("Palmetto Region (PM)");
        regionList.append("Pioneer Region (PR)");
        regionList.append("Puget Sound Region (PS)");
        regionList.append("Rocky Mountain Region (RM)");
        regionList.append("Southern Region (SO)");
        regionList.append("Southern California Region (SC)");
        regionList.append("Sun Country Region (SU)");
        regionList.append("Western Empire Region (WE)");
    }
    
    
}
