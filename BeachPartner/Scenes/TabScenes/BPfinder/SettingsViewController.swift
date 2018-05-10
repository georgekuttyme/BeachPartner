//
//  SettingsViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import DropDown

class SettingsViewController: UIViewController {
    
    var searchUsers = [SearchUserModel]()
    let dropDown = DropDown()
    var SettingsType = String()
    var stateList = [String]()
    var minAge = String()
    var maxAge = String()
    
    @IBOutlet var topSpace: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var selectLoc: UIButton!
//    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var showMeLbl: UILabel!
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var couachSwitch: UISwitch!
    @IBOutlet weak var playBtnStack: UIStackView!
    @IBOutlet weak var saveBtnStack: UIStackView!
    
    @IBOutlet weak var includeCoachesView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBAction func selectLocClicked(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func playButtonClicked(_ sender: Any) {
        DispatchQueue.main.async {
            var paramString = String()
            
            if self.couachSwitch.isOn {
                paramString = "includeCoach=true"
            }
            else{
                 paramString = "includeCoach=false"
            }
            
            var gender = self.showMeLbl.text
            if(gender == "Both"){
                gender = ""
            }
            
            paramString = paramString+"&minAge="+"\(self.minAge)"+"&maxAge="+"\(self.maxAge)"+"&gender="+"\(gender ?? "" )"
            
            if self.selectLoc.titleLabel?.text != "Choose State"{
                   paramString = paramString+"&location="+"\(self.selectLoc.titleLabel?.text ?? "" )"
            }
            paramString = paramString+"&hideConnectedUser=true&hideLikedUser=true&hideRejectedConnections=true&hideBlockedUsers=true"
            
            paramString = paramString.replacingOccurrences(of: " ", with: "%20")
            
            self.getUsersSwipeCard(endPoint: paramString)
            
            }
//        }
    }
    @IBAction func btnSave(_ sender: Any) {
        
        UserDefaults.standard.set(minAge, forKey: "minAge")
        UserDefaults.standard.set(maxAge, forKey: "maxAge")
        if self.selectLoc.titleLabel?.text != "Choose State"{
            UserDefaults.standard.set(self.selectLoc.titleLabel?.text ?? "", forKey: "location")
        }
        else{
            UserDefaults.standard.set("", forKey: "location")
        }
         UserDefaults.standard.set(self.showMeLbl.text ?? "Both", forKey: "gender")
        
        if self.couachSwitch.isOn {
           UserDefaults.standard.set("1", forKey: "includeCoaches")
        }
        else{
            UserDefaults.standard.set("0", forKey: "includeCoaches")
        }
        self.navigationController?.popViewController(animated: true)
    }
    var result: [String] = [String]()
    
    var maleIsSelected: Bool = false {
        didSet{
            if maleIsSelected {
                menBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                menBtn.backgroundColor = UIColor.init(red: 29/255, green: 46/255, blue: 123/255, alpha: 1)
            }
            else {
                menBtn.backgroundColor = UIColor.lightGray
                menBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
        }
    }
    
    var womenIsSelected: Bool = false {
        didSet{
            if womenIsSelected {
                womenBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                womenBtn.backgroundColor = UIColor.init(red: 29/255, green: 46/255, blue: 123/255, alpha: 1)
            }
            else {
                womenBtn.backgroundColor = UIColor.lightGray
                womenBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
        }
    }

    weak var bpDelegate: BpFinderDelegate?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
//self.navigationController!.navigationBar.topItem!.title = ""
//        self.navigationItem.title = "Settings"
//        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Settings"
        rangeSlider.delegate = self
        self.loadLocations()
        
        self.dropDown.anchorView = self.selectLoc // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //        self.dropDown.direction = .bottom
        self.dropDown.dataSource = self.stateList
        
        self.dropDown.bottomOffset = CGPoint(x: -50, y:45)
        self.dropDown.width = 230
        //        self.dropDown.selectionBackgroundColor = UIColor.lightGray
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            self.selectLoc.setTitle(item , for: UIControlState.normal)
        }
        self.selectLoc.setTitle("Choose State", for: UIControlState.normal)
        customView()
    }
    
    
    func customView() {
   
        if SettingsType == "SearchSettings" {
            topSpace.constant = 40
            saveBtnStack.isHidden = true
            playBtnStack.isHidden = false
        }
        else{
            topSpace.constant = 80
            saveBtnStack.isHidden = false
            playBtnStack.isHidden = true
        }
            minAge = "5"
            maxAge = "100"
            let minValue = UserDefaults.standard.string(forKey: "minAge")
            let maxValue = UserDefaults.standard.string(forKey: "maxAge")
            if (minValue != nil)  && (maxValue != nil)   {
                minAge = minValue!
                maxAge = maxValue!
                rangeSlider.selectedMinValue = CGFloat(NSString(string: minValue!).floatValue)
                rangeSlider.selectedMaxValue = CGFloat(NSString(string: maxValue!).floatValue)
                ageLabel.text = minValue! + " - " + maxValue!
            }
            let location = UserDefaults.standard.string(forKey: "location") ?? "Choose State"
            if (location.count>0){
                self.selectLoc.setTitle(location, for: UIControlState.normal)
            }
            else{
               self.selectLoc.setTitle("Choose State", for: UIControlState.normal)
            }
        
        
        maleIsSelected = false
        womenIsSelected = false
        if let gender = UserDefaults.standard.string(forKey: "gender") {
            self.showMeLbl.text = gender
            if gender == "Male"{
                maleIsSelected = true
            }
            else if gender == "Female"{
                womenIsSelected = true
            }
            else {
                maleIsSelected = true
                womenIsSelected = true
            }
        }
        else {
            maleIsSelected = true
            womenIsSelected = true
            showMeLbl.text="Both"
        }
            let includeCoaches = UserDefaults.standard.string(forKey: "includeCoaches")
            if (includeCoaches != nil){
                if(includeCoaches == "1" ){
                    self.couachSwitch.isOn = true
                }
                else{
                    self.couachSwitch.isOn = false
                }
            }
    }
    
    
    @IBAction func sliderMovement(_ sender: UISlider) {
        let selectedValue = Int(sender.value)
        ageLabel.text = String(stringInterpolationSegment: selectedValue)
    }
    @IBAction func menBtnClicked(_ menButton: UIButton) {
        maleIsSelected = !maleIsSelected
        
        if maleIsSelected && womenIsSelected {
            showMeLbl.text="Both"
        }
        else if !maleIsSelected && !womenIsSelected {
            womenIsSelected = true
            showMeLbl.text="Female"
        }
        else if maleIsSelected {
            showMeLbl.text="Male"
        }
        else {
             showMeLbl.text="Female"
        }
    }
    
    @IBAction func womenBtnClicked(_ sender: UIButton) {
        
        womenIsSelected = !womenIsSelected
        
        if maleIsSelected && womenIsSelected {
            showMeLbl.text="Both"
        }
        else if !maleIsSelected && !womenIsSelected {
            maleIsSelected = true
            showMeLbl.text="Male"
        }
        else if maleIsSelected {
            showMeLbl.text="Male"
        }
        else {
            showMeLbl.text="Female"
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Settings"
    }
    
    func getUsersSwipeCard(endPoint:String)  {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getSearchList(endpoint:endPoint ,sucessResult: { (responseModel) in
            guard let searchUserModelArray = responseModel as? SearchUserModelArray else{
                
                return
            }
            self.searchUsers = searchUserModelArray.searchUserModel
            print(self.searchUsers)
            ActivityIndicatorView.hiding()
            if self.searchUsers.count > 0{
                self.bpDelegate?.playButtonPressed(searchList: self.searchUsers)
            }
            else{
                self.alert(message: "No users found with this criteria. Please change the search parameters and play again")
            }
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
    }
}


// MARK: - RangeSeekSliderDelegate

extension SettingsViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider {
//            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            minAge = String(Int(round(minValue)))
            maxAge = String(Int(round(maxValue)))
            ageLabel.text = minAge + " - " + maxAge
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}


