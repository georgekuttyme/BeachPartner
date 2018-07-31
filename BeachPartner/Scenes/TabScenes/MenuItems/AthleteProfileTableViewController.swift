//
//  AthleteProfileTableViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 21/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//


import UIKit
import DropDown
import AVFoundation
import AVKit
import MobileCoreServices
import Floaty

class AthleteProfileTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var videoDisplayView: UIView!
    
    @IBOutlet var noVideoLbl: UILabel!
    @IBOutlet weak var videoView:UIVideoView? {
        
        willSet{
            if let view = self.videoView {
                view.removeFromSuperview()
            }
        }
        
        didSet{
            if self.videoView != nil {
                self.videoView?.layer.cornerRadius = 0
                //                self.videoDisplayView.addSubview(view)
                //                view.sizeToFitByAutoresizing(toView: self.videoDisplayView)
                
                //                self.videoDisplayView.bringSubview(toFront: self.videoView!)
                //
                //                view.isMuted = false
                //                self.muteButton.isHidden = true
                //                self.muteButton.isUserInteractionEnabled = false
                //                if view.isMuted {
                //
                //                    self.muteButton.isSelected = true
                //                } else {
                //
                //                    self.muteButton.isSelected = false
                //                }
                
            }
        }
    }
    
    
    //    let bufferingQueue = DispatchQueue(label: "beachPartner", qos: DispatchQoS.userInteractive)
    var state = ""
    var stateList = [String]()
    let statedropDown = DropDown()
    @IBOutlet var stateBtn: UIButton!
    
    @IBOutlet var heightBtn: UIButton!
    
    @IBOutlet weak var editUserImageBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editVideoBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var editProfileTxtBtn: UIButton!
    @IBOutlet weak var shareBtnView: UIView!
    @IBOutlet weak var view_BasicLine: UIView!
    @IBOutlet weak var view_MoreLine: UIView!
    @IBOutlet weak var view_BasicMoreSeperator: UIView!
    @IBOutlet weak var button_BasicInformation: UIButton!
    @IBOutlet weak var button_MoreInformation: UIButton!
    
    @IBOutlet weak var tableCell_videoView: UITableViewCell!
    @IBOutlet weak var tableCell_basicMore: UITableViewCell!
    
    
    @IBOutlet weak var tableCell_FirstName:UITableViewCell!
    @IBOutlet weak var tableCell_LastName:UITableViewCell!
    @IBOutlet weak var tableCell_Gender:UITableViewCell!
    @IBOutlet weak var tableCell_BirthDate: UITableViewCell!
    @IBOutlet weak var tableCell_City: UITableViewCell!
    @IBOutlet weak var tableCell_PhoneNumber:UITableViewCell!
    
    @IBOutlet weak var tableCell_Experience:UITableViewCell!
    @IBOutlet weak var tableCell_CrtSidePreference:UITableViewCell!
    @IBOutlet weak var tableCell_Position:UITableViewCell!
    @IBOutlet weak var tableCell_Height: UITableViewCell!
    @IBOutlet weak var tableCell_TournamentLevelInterest: UITableViewCell!
    @IBOutlet weak var tableCell_ToursPlayed:UITableViewCell!
    @IBOutlet weak var tableCell_HighestTourRatingEarned:UITableViewCell!
    @IBOutlet weak var tableCell_CBVAPlayerNumber:UITableViewCell!
    @IBOutlet weak var tableCell_CBVAFirstName:UITableViewCell!
    @IBOutlet weak var tableCell_CBVALastName: UITableViewCell!
    @IBOutlet weak var tableCell_WillingnessToTravel: UITableViewCell!
    @IBOutlet weak var tableCell_HighSchoolAttended:UITableViewCell!
    @IBOutlet weak var tableCell_IndoorClubPlayedat:UITableViewCell!
    @IBOutlet weak var tableCell_CollegeClub:UITableViewCell!
    @IBOutlet weak var tableCell_CollegeBeach:UITableViewCell!
    @IBOutlet weak var tableCell_CollegeIndoor: UITableViewCell!
    @IBOutlet weak var tableCell_SandRecruitNumber: UITableViewCell!
    
    @IBOutlet weak var tableCell_Points: UITableViewCell!
    @IBOutlet weak var tableCell_Ranking:UITableViewCell!
    @IBOutlet weak var tableCell_TopFinishesinLastYear:UITableViewCell!
    @IBOutlet weak var tableCell_TopFinishesinLastYear1:UITableViewCell!
    @IBOutlet weak var tableCell_TopFinishesinLastYear2:UITableViewCell!
    @IBOutlet weak var tableCell_SaveCancel: UITableViewCell!
    
    @IBOutlet weak var firstNameTxtFld:  FloatingText!
    @IBOutlet weak var lastNameTxtFld: FloatingText!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var birthDateTxtFld: FloatingText!
    @IBOutlet weak var cityTxtFld: FloatingText!
    @IBOutlet weak var phoneTxtFld: FloatingText!
    @IBOutlet weak var experienceBtn: UIButton!
    @IBOutlet weak var courtSidePreferenceBtn: UIButton!
    @IBOutlet weak var positionBtn: UIButton!
//    @IBOutlet weak var heightTxtFld: UITextField!
    @IBOutlet weak var tournamentLevelInterestBtn: UIButton!
    @IBOutlet weak var toursPlayedTxtFld: UITextField!
    @IBOutlet weak var highestTourRatingEarnedBtn: UIButton!
    @IBOutlet weak var cbvaPlayerNumberTxtFld: UITextField!
    @IBOutlet weak var cbvaFirstNameTxtFld: UITextField!
    @IBOutlet weak var cbvaLastNameTxtFld: UITextField!
    @IBOutlet weak var willingnessToTravelBtn: UIButton!
    @IBOutlet weak var highSchoolAttendedTxtFld: UITextField!
    @IBOutlet weak var indoorClubPlayedAtTxtFld: UITextField!
    @IBOutlet weak var collegeClubTxtFld: UITextField!
    @IBOutlet weak var collegeBeachTxtfld: UITextField!
    @IBOutlet weak var collegeIndoorTxtFld: UITextField!
    @IBOutlet weak var sandRecruitNumberTxtFld: FloatingText!
    
    @IBOutlet weak var pointsTxtFld: UITextField!
    @IBOutlet weak var rankingTxtFld: UITextField!
    @IBOutlet weak var topFinishesTxtfld: UITextField!
    @IBOutlet weak var topFinishesAddBtn: UIButton!
    @IBOutlet weak var topFinishesoneTxtFld: UITextField!
    @IBOutlet weak var topFinishestwoTxtFld: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addToplistBtn: UIButton!
    @IBOutlet weak var delTop1: UIButton!
    @IBOutlet weak var delTop2: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var userTypeLbl: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var dateofBirthLbl: UILabel!
    var activeTextField: UITextField?
    var userData = AccountRespModel()
    var connectedUserId = Int()
    var connectedUserName = String()
    var connectedUserAge = Int()
    var videoUrl = ""
    var imageUrl = ""
    var movieData: NSData?
    
    var imagePickerclicked = false
    var editclicked = false
    var isBasicInformation: Bool!
    //    let imagepickerController = UIImagePickerController()
    var imagePickerController = UIImagePickerController()
    
    //MARK: Drop Down Declarations
    
    let shareDataDropDown = DropDown()
    let genderdropDown = DropDown()
    let experiencedropDown = DropDown()
    let courtSidePreferencedropDown = DropDown()
    let positiondropDown = DropDown()
    let tournamentLevelInterestdropDown = DropDown()
    let highestTourRatingEarneddropDown = DropDown()
    let willingnessToTraveldropDown = DropDown()
    let heightdropDown = DropDown()
    
    let datePicker = UIDatePicker()
    let dateformatter = DateFormatter()
    let date_formatter1 = DateFormatter()
    var isFromConnectedUser = ""
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
      //  tableView.contentSize = CGSize(width: self.view.frame.size.width, height: 1700)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
       
        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        self.saveData()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        editclicked = false
        self.addToplistBtn.isHidden = true
        self.delTop1.isHidden = true
        self.delTop2.isHidden = true
        self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        self.editVideoBtn.isHidden = true
        self.editVideoBtn.isUserInteractionEnabled = false
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.editclicked = false
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        self.videoView?._player = nil
////        self.videoView?._playerItem = nil
//        self.videoView?.pause()
//        self.videoView?.refreshPlayer()
        
        
    }
    @objc func didTapDismissButton() {
        self.videoView?._player = nil
        //        self.videoView?._playerItem = nil
        self.videoView?.pause()
        self.videoView?.refreshPlayer()
        if self.editclicked{
            let alert = UIAlertController(title: "Are you sure you want to discard this changes?", message: "You cannot undo this action", preferredStyle: .alert)
            let actionButton = UIAlertAction(title: "Save", style: .cancel) { (action) in
                let image = UIImage(named: "edit_btn_1x") as UIImage?
                self.editProfileBtn.setImage(image, for: .normal)
                self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
                self.saveData()
                self.dismiss(animated: true, completion: nil)
            }
            let cancelButton = UIAlertAction(title: "Discard", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let backImage = UIImage(named:"back_58")
        let dismissButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(didTapDismissButton))
        self.navigationItem.leftBarButtonItem = dismissButton
        if isFromConnectedUser == ""{
            self.navigationController!.navigationBar.topItem!.title = "My Profile"
        }
        self.addToplistBtn.isHidden = true
        self.delTop1.isHidden = true
        self.delTop2.isHidden = true
        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        editclicked = false
        self.editVideoBtn.isHidden = true
        self.editVideoBtn.isUserInteractionEnabled = false
        self.addToplistBtn.isUserInteractionEnabled = false
        self.delTop1.isUserInteractionEnabled = false
        self.delTop2.isUserInteractionEnabled = false
        self.tableView.reloadData()
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
        if parent == nil {
            //"Back pressed"
        }
    }
    
    var showtopFinish1 = false
    var showtopfinish2 = false

    @IBAction func addTopFinishes(_ sender: Any) {        
        
        if self.showtopFinish1 == true {
            self.tableCell_TopFinishesinLastYear2.isHidden = false
            self.topFinishesAddBtn.isHidden = true
            self.showtopfinish2 = true
        }
        else {
            self.tableCell_TopFinishesinLastYear1.isHidden = false
            self.topFinishesAddBtn.isHidden = false
            self.showtopFinish1 = true
        }

        self.tableView.reloadData()
    }
    
    @IBAction func delTopFinisheOne(_ sender: Any) {
        
        if self.showtopfinish2 == true {
            self.topFinishesoneTxtFld.text = self.topFinishestwoTxtFld.text
            
            self.tableCell_TopFinishesinLastYear2.isHidden = true
            self.topFinishesAddBtn.isHidden = false
            self.topFinishestwoTxtFld.text = ""
            self.showtopfinish2 = false
        }
        else {
            self.tableCell_TopFinishesinLastYear1.isHidden = true
            self.topFinishesAddBtn.isHidden = false
            self.topFinishesoneTxtFld.text = ""
            self.showtopFinish1 = false
        }

        self.tableView.reloadData()
    }
    
    @IBAction func delTopFinisheTwo(_ sender: Any) {
        self.tableCell_TopFinishesinLastYear2.isHidden = true
        self.topFinishesAddBtn.isHidden = false
        self.topFinishestwoTxtFld.text = ""
        self.showtopfinish2 = false

        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView?._player?.volume = 0
        print(connectedUserId,"====",isFromConnectedUser,"^^^^",connectedUserAge)
        if isFromConnectedUser == "ConnectedUser"{
            self.navigationController!.navigationBar.topItem!.title = connectedUserName+"'s"+" Profile"
            self.dateofBirthLbl.text = "Age"
            self.birthDateTxtFld.text = String(connectedUserAge) ?? ""
            self.tableCell_PhoneNumber.isHidden = true
            self.editUserImageBtn.isHidden = true
            self.editUserImageBtn.isUserInteractionEnabled = false
            
            self.editVideoBtn.isHidden = true
            self.editVideoBtn.isUserInteractionEnabled = false
            
            self.shareBtn.isHidden = true
            self.shareBtn.isUserInteractionEnabled = false
            
            self.editProfileTxtBtn.isHidden = true
            self.editProfileTxtBtn.isUserInteractionEnabled = false
            
            self.shareLbl.isHidden = true
            
            self.editProfileBtn.isHidden = true
            self.editProfileBtn.isUserInteractionEnabled = false
            self.getConnectedUserInfo(userId:connectedUserId)
        }else{
            self.getUserInfo()
            
        }
        
        self.hideKeyboardWhenTappedAround()
        loadLocations()
        dateformatter.dateFormat = "MM-dd-yyyy"
        date_formatter1.dateFormat = "yyyy-MM-dd"
        
        tableCell_SaveCancel.isHidden = true
        
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        self.editVideoBtn.isHidden = true
        self.editVideoBtn.isUserInteractionEnabled = false
        
        
        //MARK: Hide Cells
       // self.tableCell_TopFinishesinLastYear1.isHidden = true
       // self.tableCell_TopFinishesinLastYear2.isHidden = true
        
        self.addToplistBtn.isUserInteractionEnabled = false
        self.delTop1.isUserInteractionEnabled = false
        self.delTop2.isUserInteractionEnabled = false
        self.addToplistBtn.isHidden = true
        self.delTop1.isHidden = true
        self.delTop2.isHidden = true
        
        
        //MARK: Date of Birth
        datePicker.datePickerMode = UIDatePickerMode.date
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -5
        let fiveYearAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        datePicker.maximumDate = fiveYearAgo
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        birthDateTxtFld.inputView = datePicker
        //        self.imagePickerController.preferredStatusBarStyle  = .default
        self.imagePickerController.modalPresentationStyle = .currentContext
        self.imagePickerController.delegate = self
        
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        
        //MARK: Show basic info details by default
        isBasicInformation = true
        button_BasicInformation.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        view_BasicLine.backgroundColor = UIColor.navigationBarTintColor
        view_BasicMoreSeperator.isHidden = true
        
        self.shareDataDropDown.anchorView = self.shareBtn
        self.shareDataDropDown.dataSource = ["Profile Image","Profile Video"]
        self.shareDataDropDown.bottomOffset = CGPoint(x:20, y:30)
        self.shareDataDropDown.width = 120
        self.shareDataDropDown.direction = .bottom
        self.shareDataDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if(item == "Profile Image"){
//                 if(self.userImageView.image != nil){
                print(self.userImageView.image ?? "nothingg","\n\n\n\n")
                if(self.imageUrl != ""){
                    let imageToShare = [ self.userImageView.image! ]
                    let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }else {
                    
                    let refreshAlert = UIAlertController(title: "", message: "Please Upload a image before sharing", preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                
                   
                }
            }
            else if(item == "Profile Video"){
                print("video url :",self.userData.videoUrl)
//                if self.userData.videoUrl == "" {
                if self.videoUrl == "" {
                        let refreshAlert = UIAlertController(title: "", message: "Please Upload a video before sharing", preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
                else {
                    let text = "Hey view/download my Beach Partner video at : " + self.userData.videoUrl
                    print(text)
                    let textToShare = [ text ]
                    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        
        
        //MARK: Gender DropDown
        self.genderdropDown.anchorView = self.genderBtn
        self.genderdropDown.dataSource = ["Male","Female"]
        self.genderdropDown.bottomOffset = CGPoint(x:20, y:10)
        self.genderdropDown.width = 100
        self.genderdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderBtn.setTitle(item, for: UIControlState.normal)
            self.genderBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        }
        self.genderBtn.setTitle("", for: UIControlState.normal)
        self.genderdropDown.selectRow(0)
        
        
        //MARK: Experience DropDown
        self.experiencedropDown.anchorView = self.experienceBtn
        self.experiencedropDown.dataSource = ["Please Select","“Newbie” [New to the Game]","1-2 years [Some Indoor/Beach Experience]","2-3 years [Beach Club/Tournament Experience]","3-4 years [Experienced Tournament Player]","More than 4 years"]
        self.experiencedropDown.bottomOffset = CGPoint(x:10, y:10)
        self.experiencedropDown.width = 300
        self.experiencedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.experienceBtn.setTitle(item, for: UIControlState.normal)
            self.experienceBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        }
        self.experienceBtn.setTitle("", for: UIControlState.normal)
        self.experiencedropDown.selectRow(0)
        
        //MARK: CourtSidePreference DropDown
        self.courtSidePreferencedropDown.anchorView = self.courtSidePreferenceBtn
        self.courtSidePreferencedropDown.dataSource = ["Please Select","Left Side","Right Side","No Preference"]
        self.courtSidePreferencedropDown.bottomOffset = CGPoint(x:10, y:10)
        self.courtSidePreferencedropDown.width = 300
        self.courtSidePreferencedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.courtSidePreferenceBtn.setTitle(item, for: UIControlState.normal)
            self.courtSidePreferenceBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        }
        self.courtSidePreferenceBtn.setTitle("", for: UIControlState.normal)
        self.courtSidePreferencedropDown.selectRow(0)
        
        
        //MARK: Position DropDown
        self.positiondropDown.anchorView = self.positionBtn
        self.positiondropDown.dataSource = ["Please Select","Primary Blocker","Primary Defender","Split Block/Defense"]
        self.positiondropDown.bottomOffset = CGPoint(x:10, y:10)
        self.positiondropDown.width = 300
        self.positiondropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.positionBtn.setTitle(item, for: UIControlState.normal)
            self.positionBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        }
        self.positionBtn.setTitle("", for: UIControlState.normal)
        self.positiondropDown.selectRow(0)
        
        
        //MARK: TournamentLevelInterest DropDown
//        self.tournamentLevelInterestdropDown.anchorView = self.tournamentLevelInterestBtn
//        self.tournamentLevelInterestdropDown.dataSource = ["Please Select","Novice/Social","Unrated","B","A","AA","AAA","Pro"]
//        self.tournamentLevelInterestdropDown.bottomOffset = CGPoint(x:10, y:10)
//        self.tournamentLevelInterestdropDown.width = 200
//        self.tournamentLevelInterestdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.tournamentLevelInterestBtn.setTitle(item, for: UIControlState.normal)
//            self.tournamentLevelInterestBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
////            self.tournamentLevelInterestBtn.setTitleColor(UIColor.blue, for: .normal)
//        }
//        self.tournamentLevelInterestBtn.setTitle("", for: UIControlState.normal)
//        self.tournamentLevelInterestdropDown.selectRow(0)
        
        //MARK: HighestTourRatingEarned DropDown
//        self.highestTourRatingEarneddropDown.anchorView = self.highestTourRatingEarnedBtn
//        self.highestTourRatingEarneddropDown.dataSource = ["Please Select","PRO","Open Or AAA","AA","A","BB","B","C Or Novice","Unrated"]
//        self.highestTourRatingEarneddropDown.bottomOffset = CGPoint(x:10, y:10)
//        self.highestTourRatingEarneddropDown.width = 200
//        self.highestTourRatingEarneddropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.highestTourRatingEarnedBtn.setTitle(item, for: UIControlState.normal)
//            self.highestTourRatingEarnedBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
////            self.highestTourRatingEarnedBtn.setTitleColor(UIColor.blue, for: .normal)
//        }
//        self.highestTourRatingEarnedBtn.setTitle("", for: UIControlState.normal)
//        self.highestTourRatingEarneddropDown.selectRow(0)
        
        //MARK: Height DropDown
        self.heightdropDown.anchorView = self.heightBtn
        self.heightdropDown.dataSource = ["Please Select"," 4' 10\""," 4' 11\""," 5' 0\""," 5' 1\""," 5' 2\""," 5' 3\""," 5' 4\""," 5' 5\""," 5' 6\""," 5' 7\""," 5' 8\""," 5' 9\""," 5' 10\""," 5' 11\""," 6' 0\""," 6' 1\""," 6' 2\""," 6' 3\""," 6' 4\""," 6' 5\""," 6' 6\""," 6' 7\""," 6' 8\""," 6' 9\""," 6' 10\""," 6' 11\""," 7' 0\""]
        self.heightdropDown.bottomOffset = CGPoint(x:10, y:10)
        self.heightdropDown.width = 300
        self.heightdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.heightBtn.setTitle(item, for: UIControlState.normal)
            self.heightBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)

        }
        self.heightBtn.setTitle("", for: UIControlState.normal)
        self.heightdropDown.selectRow(0)
        
        //MARK: State DropDown
        self.statedropDown.anchorView = self.stateBtn
        self.statedropDown.dataSource = self.stateList
        print(self.stateList)
        self.statedropDown.bottomOffset = CGPoint(x:10, y:10)
        self.statedropDown.width = 300
        self.statedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.state = item
            print("@@@@@",self.state)
            self.stateBtn.setTitle(item, for: UIControlState.normal)
            self.stateBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        }
        self.stateBtn.setTitle("Select your State", for: UIControlState.normal)
        self.statedropDown.selectRow(0)


        //MARK: HighestTourRatingEarned DropDown
        self.willingnessToTraveldropDown.anchorView = self.willingnessToTravelBtn
        self.willingnessToTraveldropDown.dataSource = ["Please Select","Not Willing","Up to 25 miles","Up to 50 miles","Up to 100 miles","Up to 250 miles","Up to 500 miles","Nationwide","International"]
        self.willingnessToTraveldropDown.bottomOffset = CGPoint(x:10, y:10)
        self.willingnessToTraveldropDown.width = 300
        self.willingnessToTraveldropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.willingnessToTravelBtn.setTitle(item, for: UIControlState.normal)
            self.willingnessToTravelBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)

        }
        self.willingnessToTravelBtn.setTitle("", for: UIControlState.normal)
        self.willingnessToTraveldropDown.selectRow(0)
        
        self.firstNameTxtFld.delegate = self
        self.lastNameTxtFld.delegate = self
        self.phoneTxtFld.delegate = self
//        self.toursPlayedTxtFld.delegate = self
//        self.cbvaPlayerNumberTxtFld.delegate = self
//        self.cbvaFirstNameTxtFld.delegate = self
//        self.cbvaLastNameTxtFld.delegate = self
        self.highSchoolAttendedTxtFld.delegate = self
        self.indoorClubPlayedAtTxtFld.delegate = self
//        self.collegeClubTxtFld.delegate = self
        self.collegeBeachTxtfld.delegate = self
        self.collegeBeachTxtfld.delegate = self
        self.collegeIndoorTxtFld.delegate = self
        self.sandRecruitNumberTxtFld.delegate = self
//        self.pointsTxtFld.delegate = self
//        self.rankingTxtFld.delegate = self
        self.topFinishesTxtfld.delegate = self
        self.topFinishesoneTxtFld.delegate = self
        self.topFinishestwoTxtFld.delegate = self
        
        
    }
    
    @IBAction func stateBtnAction(_ sender: Any) {
        statedropDown.show()
    }
    
    @IBAction func heightBtnAction(_ sender: Any) {
        heightdropDown.show()
    }
    //  MARK: Button Actions for Dropdowns
    
    @IBAction func genderBtnClick(_ sender: Any) {
        genderdropDown.show()
    }
    @IBAction func experienceBtnClick(_ sender: Any) {
        experiencedropDown.show()
    }
    @IBAction func courtSidePreferenceBtnClick(_ sender: Any) {
        courtSidePreferencedropDown.show()
    }
    @IBAction func PositionBtnClick(_ sender: Any) {
        positiondropDown.show()
    }
//    @IBAction func tournamentLevelInterestBtnClick(_ sender: Any) {
//        tournamentLevelInterestdropDown.show()
//    }
//    @IBAction func highestTourRatingEarned(_ sender: Any) {
//        highestTourRatingEarneddropDown.show()
//    }
    @IBAction func willingnessToTravelBtnClick(_ sender: Any) {
        willingnessToTraveldropDown.show()
    }
    
    //  MARK: Basic Info Button Action
    @IBAction func buttonActionForBasicInformation(_ basicInfoBtn: UIButton) {
        view_BasicLine.backgroundColor = UIColor.navigationBarTintColor
        basicInfoBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        isBasicInformation = true
        view_MoreLine.backgroundColor = UIColor.white
        button_MoreInformation.setTitleColor(.white, for: .normal)
        self.tableView.reloadData()
    }
    //  MARK: More Info Button Action
    @IBAction func buttonActionForMoreInformation(_ moreInfoBtn: UIButton) {
        view_MoreLine.backgroundColor = UIColor.navigationBarTintColor
        view_BasicLine.backgroundColor = UIColor.white
        button_BasicInformation.setTitleColor(UIColor.white, for: .normal)
        isBasicInformation = false
        
        moreInfoBtn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        self.tableView.reloadData()
    }
    @IBAction func editBtnClicked(_ sender: Any) {

        self.addToplistBtn.isHidden = false
        self.delTop1.isHidden = false
        self.delTop2.isHidden = false
        let image = UIImage(named: "edit_btn_active_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        if (self.editUserImageBtn.isHidden) {
            
            self.topFinishesAddBtn.isHidden = showtopfinish2
            
            self.editUserImageBtn.isHidden = false
            self.editUserImageBtn.isUserInteractionEnabled = true
            editclicked = true
            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
            self.editVideoBtn.isHidden = false
            self.editVideoBtn.isUserInteractionEnabled = true
            self.addToplistBtn.isUserInteractionEnabled = true
            self.delTop1.isUserInteractionEnabled = true
            self.delTop2.isUserInteractionEnabled = true
            self.tableView.reloadData()
        }
//        else {
//            self.topFinishesAddBtn.isHidden = true
//            self.addToplistBtn.isHidden = true
//            self.delTop1.isHidden = true
//            self.delTop2.isHidden = true
//            let image = UIImage(named: "edit_btn_1x") as UIImage?
//            editProfileBtn.setImage(image, for: .normal)
//            self.editUserImageBtn.isHidden = true
//            self.editUserImageBtn.isUserInteractionEnabled = false
//            editclicked = false
//            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
//            self.editVideoBtn.isHidden = true
//            self.editVideoBtn.isUserInteractionEnabled = false
//            self.addToplistBtn.isUserInteractionEnabled = false
//            self.delTop1.isUserInteractionEnabled = false
//            self.delTop2.isUserInteractionEnabled = false
//            self.tableView.reloadData()
//        }
    }
    @IBAction func editProfileTxtBtnClicked(_ sender: Any) {
        self.editProfileTxtBtn.isUserInteractionEnabled = false
    }
    
    
    func saveData(){
        //        var isValidated = false
        let sucessValidation = 6
        var currentValidation = 0
        
        if firstNameTxtFld.isEmpty() {
            firstNameTxtFld.shake()
            firstNameTxtFld.errorText = "Empty!"
            firstNameTxtFld.showError()
        }else{
            firstNameTxtFld.hideError()
            self.userData.firstName = firstNameTxtFld.text!
            currentValidation += 1
        }
        
        if lastNameTxtFld.isEmpty() {
            lastNameTxtFld.shake()
            lastNameTxtFld.errorText = "Empty!"
            lastNameTxtFld.showError()
        }else{
            lastNameTxtFld.hideError()
            self.userData.lastName = lastNameTxtFld.text!
            currentValidation += 1
        }
        
        if birthDateTxtFld.isEmpty() {
            birthDateTxtFld.shake()
            birthDateTxtFld.errorText = "Empty!"
            birthDateTxtFld.showError()
        }else{
            birthDateTxtFld.hideError()
            let date = dateformatter.date(from: birthDateTxtFld.text!)
            date_formatter1.dateFormat = "yyyy-MM-dd"
            let dateForSave = date_formatter1.string(from: date!)
            self.userData.inputDob = dateForSave
            currentValidation += 1
        }
        
        if (self.genderBtn.titleLabel?.text == ""){
            self.genderBtn.shake()
            self.view.makeToast("Please select the gender", duration: 3.0, position: .center)
        }
        else{
            self.userData.gender = (self.genderBtn.titleLabel?.text)!
            currentValidation += 1
        }

        if (self.stateBtn.titleLabel?.text == ""){
            self.stateBtn.shake()
            self.view.makeToast("Please select your State", duration: 3.0, position: .center)
        }
        else{
            self.userData.city = (self.stateBtn.titleLabel?.text)!
            self.userData.location = (self.stateBtn.titleLabel?.text)!
            UserDefaults.standard.set((self.stateBtn.titleLabel?.text)! , forKey: "location")
            currentValidation += 1
        }
        
        if phoneTxtFld.isEmpty() {
            phoneTxtFld.shake()
            phoneTxtFld.errorText = "Please enter a valid mobile number "
            phoneTxtFld.showError()
        }
        else {
            
            if (phoneTxtFld.text?.count)! == 10  {
                if phoneTxtFld.text == "0000000000"{
                    phoneTxtFld.shake()
                    phoneTxtFld.errorText = "Please enter a valid mobile number"
                    phoneTxtFld.showError()
                }
                else{
                    phoneTxtFld.hideError()
                    self.userData.phoneNumber = phoneTxtFld.text!
                    currentValidation += 1
                }
                
            }else{
                phoneTxtFld.shake()
                phoneTxtFld.errorText = "Please enter a valid mobile number"
                phoneTxtFld.showError()
            }
        }
        
        if let value = experienceBtn.titleLabel?.text, value != "Please Select" {
            self.userData.userProfile?.experience = value
        }
        else { self.userData.userProfile?.experience = "" }
        
        if let value = courtSidePreferenceBtn.titleLabel?.text, value != "Please Select" {
            self.userData.userProfile?.courtSidePreference = value
        }
        else { self.userData.userProfile?.courtSidePreference = "" }
        
        if let value = positionBtn.titleLabel?.text, value != "Please Select" {
            self.userData.userProfile?.position = value
        }
        else { self.userData.userProfile?.position = "" }
        
        if let value = heightBtn.titleLabel?.text, value != "Please Select" {
            self.userData.userProfile?.height = String(value)
        }
        else { self.userData.userProfile?.height = "" }
        
//        if let value = tournamentLevelInterestBtn.titleLabel?.text, value != "Please Select" {
//            self.userData.userProfile?.tournamentLevelInterest = value
//        }
//        else { self.userData.userProfile?.tournamentLevelInterest = "" }
        
//        if let value = highestTourRatingEarnedBtn.titleLabel?.text, value != "Please Select" {
//            self.userData.userProfile?.highestTourRatingEarned = value
//        }
//        else { self.userData.userProfile?.highestTourRatingEarned = "" }
        
        if let value = willingnessToTravelBtn.titleLabel?.text, value != "Please Select" {
            self.userData.userProfile?.willingToTravel = value
        }
        else { self.userData.userProfile?.willingToTravel = "" }
        
        
//        self.userData.userProfile?.toursPlayedIn = toursPlayedTxtFld.text!
//        self.userData.userProfile?.cbvaPlayerNumber = cbvaPlayerNumberTxtFld.text!
//        self.userData.userProfile?.cbvaFirstName = cbvaFirstNameTxtFld.text!
//        self.userData.userProfile?.cbvaLastName = cbvaLastNameTxtFld.text!
        self.userData.userProfile?.highSchoolAttended = highSchoolAttendedTxtFld.text!
        self.userData.userProfile?.indoorClubPlayed = indoorClubPlayedAtTxtFld.text!
//        self.userData.userProfile?.collageClub = collegeClubTxtFld.text!
        self.userData.userProfile?.collegeBeach = collegeBeachTxtfld.text!
        self.userData.userProfile?.collegeIndoor = collegeIndoorTxtFld.text!
        self.userData.userProfile?.sandRecruitNumber = sandRecruitNumberTxtFld.text!
//        self.userData.userProfile?.totalPoints = pointsTxtFld.text!
//        self.userData.userProfile?.usaVolleyballRanking = rankingTxtFld.text!
        var topfinishesVal = String()
        
        if let trimmedString = topFinishesTxtfld.text?.trimmingCharacters(in: .whitespaces), trimmedString.count > 0 {
            topfinishesVal = "\(self.topFinishesTxtfld.text ?? "")"
        }
        if let trimmedString = topFinishesoneTxtFld.text?.trimmingCharacters(in: .whitespaces), trimmedString.count > 0 {
            topfinishesVal = "\(topfinishesVal)" + "," + self.topFinishesoneTxtFld.text!
        }
        if let trimmedString = topFinishestwoTxtFld.text?.trimmingCharacters(in: .whitespaces), trimmedString.count > 0 {
            topfinishesVal = "\(topfinishesVal)" + "," + self.topFinishestwoTxtFld.text!
        }
        self.userData.userProfile?.topFinishes = topfinishesVal
        if sucessValidation == currentValidation {

            self.updateUserInfo()
            
        }
    }
    
    @IBAction func editVIdeoBtnClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Choose your profile Video", preferredStyle: UIAlertControllerStyle.alert)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerController.delegate = self
                self.imagePickerController.mediaTypes = [kUTTypeMovie as String]
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.videoMaximumDuration = 30.0
                self.showImagePicker(sourceType: UIImagePickerControllerSourceType.camera)
            } else {
                print("Camera not available.")
            }
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.imagePickerController.mediaTypes = [kUTTypeMovie as String]
            self.showImagePicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareImageButton(_ sender: UIButton) {
            shareDataDropDown.show()
    }
    
    
    
    @IBAction func editUserImageClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Choose your profile image", preferredStyle: UIAlertControllerStyle.alert)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerController.delegate = self
                self.imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.imagePickerController.allowsEditing = true
             //   self.imagePickerController.showsCameraControls = true
                self.showImagePicker(sourceType: UIImagePickerControllerSourceType.camera)
            } else {
                print("Camera not available.")
            }
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            self.showImagePicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        self.imagePickerclicked = true
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle =
            (sourceType == UIImagePickerControllerSourceType.camera) ?
                UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
        
        let presentationController = imagePickerController.popoverPresentationController
        //        presentationController?.barButtonItem = button     // Display popover from the UIBarButtonItem as an anchor.
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        //        if sourceType == UIImagePickerControllerSourceType.camera {
        //            // The user wants to use the camera interface. Set up our custom overlay view for the camera.
        //            imagePickerController.showsCameraControls = false
        //
        //            // Apply our overlay view containing the toolar to take pictures in various ways.
        //            overlayView?.frame = (imagePickerController.cameraOverlayView?.frame)!
        //            imagePickerController.cameraOverlayView = overlayView
        //        }
        
        imagePickerController.navigationBar.barTintColor = UIColor.navigationBarTintColor // Background color
        imagePickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
        imagePickerController.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ] // Title color
         UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        present(imagePickerController, animated: true, completion: {
            // Done presenting.
        })
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if (isBasicInformation){
            if (cell == self.tableCell_Experience ||
                cell == self.tableCell_CrtSidePreference ||
                cell == self.tableCell_Position ||
                cell == self.tableCell_Height ||
                cell == self.tableCell_TournamentLevelInterest ||
                cell == self.tableCell_ToursPlayed ||
                cell == self.tableCell_HighestTourRatingEarned ||
                cell == self.tableCell_CBVAPlayerNumber  ||
                cell == self.tableCell_CBVAFirstName  ||
                cell == self.tableCell_CBVALastName  ||
                cell == self.tableCell_WillingnessToTravel  ||
                cell == self.tableCell_HighSchoolAttended  ||
                cell == self.tableCell_IndoorClubPlayedat  ||
                cell == self.tableCell_CollegeClub  ||
                cell == self.tableCell_CollegeBeach  ||
                cell == self.tableCell_CollegeIndoor  ||
                cell == self.tableCell_SandRecruitNumber ||
                cell == self.tableCell_Points  ||
                cell == self.tableCell_Ranking  ||
                cell == self.tableCell_TopFinishesinLastYear  ||
                cell == self.tableCell_TopFinishesinLastYear1  ||
                cell == self.tableCell_TopFinishesinLastYear2)
            {
                return 0
            }
            else {
                if (cell == self.tableCell_videoView || cell == self.tableCell_basicMore || cell == self.tableCell_SaveCancel)
                {
                }
                else{
                    
                    let screenSize: CGRect = UIScreen.main.bounds
                    let myView = UIView(frame: CGRect(x: 10, y: 63, width: screenSize.width-20, height: 1))
                    myView.backgroundColor = UIColor.lightGray
                    cell.addSubview(myView)
                    
                    
                }
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        }
        else {
            if (cell == self.tableCell_City || cell == self.tableCell_FirstName || cell == self.tableCell_LastName || cell == self.tableCell_Gender || cell == self.tableCell_PhoneNumber || cell == self.tableCell_BirthDate) {
                return 0
            }
            else {
                
                if (cell == self.tableCell_videoView || cell == self.tableCell_basicMore || cell == self.tableCell_SaveCancel)
                {
                }
                else{
                    let screenSize: CGRect = UIScreen.main.bounds
                    let myView = UIView(frame: CGRect(x: 10, y: 63, width: screenSize.width - 20, height: 1))
                    myView.backgroundColor = UIColor.lightGray
                    cell.addSubview(myView)
                }
                
                if( cell == self.tableCell_TopFinishesinLastYear1)
                {
                    if(!self.showtopFinish1){
                        return 0
                    }
                }
                if( cell == self.tableCell_TopFinishesinLastYear2)
                {
                    if(!self.showtopfinish2){
                        return 0
                    }
                }
                
                return super.tableView(tableView, heightForRowAt: indexPath)
                
            }
            
        }
    }
    @IBAction func topFinisesAddBtnClick(_ sender: Any) {
        
        self.tableCell_TopFinishesinLastYear1.isHidden = false
        self.topFinishesTxtfld.isUserInteractionEnabled = true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if (self.editclicked){
            firstNameTxtFld.enableTextFld()
            lastNameTxtFld.enableTextFld()
            genderBtn.enableBtn()
            birthDateTxtFld.enableTextFld()
            stateBtn.enableBtn()
//            cityTxtFld.enableTextFld()
            phoneTxtFld.enableTextFld()
            experienceBtn.enableBtn()
            courtSidePreferenceBtn.enableBtn()
            positionBtn.enableBtn()
//            tournamentLevelInterestBtn.enableBtn()
            heightBtn.enableBtn()
//            heightTxtFld.enableTextFld()
//            toursPlayedTxtFld.enableTextFld()
//            highestTourRatingEarnedBtn.enableBtn()
//            cbvaPlayerNumberTxtFld.enableTextFld()
//            cbvaFirstNameTxtFld.enableTextFld()
//            cbvaLastNameTxtFld.enableTextFld()
            willingnessToTravelBtn.enableBtn()
            highSchoolAttendedTxtFld.enableTextFld()
            indoorClubPlayedAtTxtFld.enableTextFld()
//            collegeClubTxtFld.enableTextFld()
            collegeBeachTxtfld.enableTextFld()
            collegeIndoorTxtFld.enableTextFld()
            sandRecruitNumberTxtFld.enableTextFld()
//            pointsTxtFld.enableTextFld()
//            rankingTxtFld.enableTextFld()
            topFinishesTxtfld.enableTextFld()
            topFinishesoneTxtFld.enableTextFld()
            topFinishestwoTxtFld.enableTextFld()
            tableCell_SaveCancel.isHidden = false
        }
        else
        {
            firstNameTxtFld.disableTextFld()
            lastNameTxtFld.disableTextFld()
            genderBtn.disableBtn()
            birthDateTxtFld.disableTextFld()
            stateBtn.disableBtn()
//            cityTxtFld.disableTextFld()
            phoneTxtFld.disableTextFld()
            experienceBtn.disableBtn()
            courtSidePreferenceBtn.disableBtn()
            positionBtn.disableBtn()
//            tournamentLevelInterestBtn.disableBtn()
            heightBtn.disableBtn()
//            heightTxtFld.disableTextFld()
//            toursPlayedTxtFld.disableTextFld()
//            highestTourRatingEarnedBtn.disableBtn()
//            cbvaPlayerNumberTxtFld.disableTextFld()
//            cbvaFirstNameTxtFld.disableTextFld()
//            cbvaLastNameTxtFld.disableTextFld()
            willingnessToTravelBtn.disableBtn()
            highSchoolAttendedTxtFld.disableTextFld()
            indoorClubPlayedAtTxtFld.disableTextFld()
//            collegeClubTxtFld.disableTextFld()
            collegeBeachTxtfld.disableTextFld()
            collegeIndoorTxtFld.disableTextFld()
            sandRecruitNumberTxtFld.disableTextFld()
//            pointsTxtFld.disableTextFld()
//            rankingTxtFld.disableTextFld()
            topFinishesTxtfld.disableTextFld()
            topFinishesoneTxtFld.disableTextFld()
            topFinishestwoTxtFld.disableTextFld()
            tableCell_SaveCancel.isHidden = true
        }
        /*
         if (cell == self.tablecell || cell == self.tableCell_CrtSidePreference
         let screenSize: CGRect = UIScreen.main.bounds
         let myView = UIView(frame: CGRect(x: 0, y: 63, width: screenSize.width - 10, height: 1))
         myView.backgroundColor = UIColor.lightGray
         cell.addSubview(myView)
         */
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if  textField == firstNameTxtFld {
            lastNameTxtFld.becomeFirstResponder()
        }
        else if  textField == lastNameTxtFld {
            textField.resignFirstResponder()
        }
        else if  textField == phoneTxtFld {
            textField.resignFirstResponder()
        }
//        if  textField == toursPlayedTxtFld {
//            textField.resignFirstResponder()
//        }
//        else if textField == cbvaPlayerNumberTxtFld {
//            cbvaFirstNameTxtFld.becomeFirstResponder()
//        }
//        else if textField == cbvaFirstNameTxtFld{
//            cbvaLastNameTxtFld.becomeFirstResponder()
//        }
//        else if textField == cbvaLastNameTxtFld{
//            textField.resignFirstResponder()
//        }
        else if textField == highSchoolAttendedTxtFld{
            indoorClubPlayedAtTxtFld.becomeFirstResponder()
        }
        else if textField == indoorClubPlayedAtTxtFld{
            collegeBeachTxtfld.becomeFirstResponder()
        }
//        else if textField == collegeClubTxtFld{
//            collegeBeachTxtfld.becomeFirstResponder()
//        }
        else if textField == collegeBeachTxtfld{
            collegeIndoorTxtFld.becomeFirstResponder()
        }
        else if textField == collegeIndoorTxtFld{
           sandRecruitNumberTxtFld.becomeFirstResponder()
        }
        else if textField == sandRecruitNumberTxtFld{
             topFinishesTxtfld.becomeFirstResponder()
        }
//        else if textField == pointsTxtFld{
//            rankingTxtFld.becomeFirstResponder()
//        }
//        else if textField == rankingTxtFld{
//            topFinishesTxtfld.becomeFirstResponder()
//        }
        else if textField == topFinishesTxtfld {
            topFinishesoneTxtFld.becomeFirstResponder()
        }else if textField == topFinishesoneTxtFld{
            textField.resignFirstResponder()
        }
        else if textField == topFinishestwoTxtFld{
            textField.resignFirstResponder()
        }
        return true;
    }
 
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
            self.tableView.contentInset = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            var activeTextFieldRect: CGRect?
            var activeTextFieldOrigin: CGPoint?
            
            if self.activeTextField != nil {
                activeTextFieldRect = self.activeTextField?.superview?.superview?.frame
                activeTextFieldOrigin = activeTextFieldRect?.origin
                self.tableView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInsets
        self.activeTextField = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        return true
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        //        formatter.dateStyle = DateFormatter.Style.medium
        //        formatter.timeStyle = DateFormatter.Style.none
        
        birthDateTxtFld.text = formatter.string(from: sender.date)
    }
    
    func updateUserInfo(){
        
        ActivityIndicatorView.show("Saving...")
        
        APIManager.callServer.updateUserDetails(userData: self.userData, sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? AccountRespModel else{
                //                    stopLoading()
                
                
                return
            }
            
            if(accRespModel.id != 0){
                UserDefaults.standard.set(accRespModel.location , forKey: "location")
                UserDefaults.standard.set(accRespModel.id, forKey: "bP_userProfileId")
                self.alert(message: "User profile updated successfully! ")
                UserDefaults.standard.set(1, forKey: "NewUser")
                ActivityIndicatorView.hiding()
                DispatchQueue.main.async {
                let image = UIImage(named: "edit_btn_1x") as UIImage?
                self.editProfileBtn.setImage(image, for: .normal)
                self.editUserImageBtn.isHidden = true
                self.editUserImageBtn.isUserInteractionEnabled = false
                self.editclicked = false
                self.addToplistBtn.isHidden = true
                self.delTop1.isHidden = true
                self.delTop2.isHidden = true
                self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
                self.editVideoBtn.isHidden = true
                self.editVideoBtn.isUserInteractionEnabled = false
                    self.loadDataToUi(accResponseModel: accRespModel)
                    
                self.tableView.reloadData()
                    
                }
            }else{
                
                ActivityIndicatorView.hiding()
                
            }
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
    }
    
    func getConnectedUserInfo(userId:Int){
        ActivityIndicatorView.show("Loading...")
//        let userId:Int = 10
        APIManager.callServer.getConnectedUserAccountDetails(userID: userId,sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? AccountRespModel else{
                return
            }
            print("****\n\n",accRespModel,"\n\n\n\n\n")
            if(accRespModel.id != 0){
                
                self.userData = accRespModel
                print("bP_userId", accRespModel.id )
                print("accRespimageUrl", accRespModel.videoUrl)
                
                if let imageUrl = URL(string: accRespModel.imageUrl) {
                    self.userImageView.sd_setIndicatorStyle(.whiteLarge)
                    self.userImageView.sd_setShowActivityIndicatorView(true)
                    self.userImageView.sd_setImage(with: imageUrl, placeholderImage:  #imageLiteral(resourceName: "user"))
                     self.imageUrl = accRespModel.imageUrl
                }
                
                self.videoUrl = accRespModel.videoUrl
                if self.videoUrl == ""
                {
                    self.noVideoLbl.text = "No Video Available"
                }
                
                ActivityIndicatorView.hiding()
                
                DispatchQueue.main.async {
                    self.loadVideoOnPlayer(videoUrlVal: accRespModel.videoUrl)
                    
                    self.loadDataToUi(accResponseModel: accRespModel)
                }
                
            }else{
                
                ActivityIndicatorView.hiding()
                
            }
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
    }
    
    
    
    func getUserInfo(){
        
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getAccountDetails(sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? AccountRespModel else{
                //                    stopLoading()
                return
            }
            
            if(accRespModel.id != 0){
                
                self.userData = accRespModel
                print("bP_userId", accRespModel.id )
                print("accRespimageUrl", accRespModel.videoUrl)
                
                if let imageUrl = URL(string: accRespModel.imageUrl) {
                    self.userImageView.sd_setIndicatorStyle(.whiteLarge)
                    self.userImageView.sd_setShowActivityIndicatorView(true)
                    self.userImageView.sd_setImage(with: imageUrl, placeholderImage:  #imageLiteral(resourceName: "user"))
                    self.imageUrl = accRespModel.imageUrl
                }
                
                self.videoUrl = accRespModel.videoUrl
                if self.videoUrl == ""
                {
                    self.noVideoLbl.text = "No Video Available"
                }
                
                ActivityIndicatorView.hiding()

                DispatchQueue.main.async {
                    self.loadVideoOnPlayer(videoUrlVal: accRespModel.videoUrl)
                    
                    self.loadDataToUi(accResponseModel: accRespModel)
                }
                
                
                
//                Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
            }else{
                
                ActivityIndicatorView.hiding()
                
            }
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
    }
    @objc func runTimedCode(){
        print("^^^&&*(()))")
        ActivityIndicatorView.hiding()
    }
    
    func loadDataToUi( accResponseModel : AccountRespModel){
        
        self.topFinishesAddBtn.isHidden = true
        topFinishesTxtfld.text = ""
        topFinishesoneTxtFld.text = ""
        topFinishestwoTxtFld.text = ""
        
        self.userName.text = accResponseModel.firstName
//        + " " + accResponseModel.lastName
        self.userTypeLbl.text = accResponseModel.userType
        self.firstNameTxtFld.text = accResponseModel.firstName
        self.lastNameTxtFld.text = accResponseModel.lastName
        self.genderBtn.setTitle(accResponseModel.gender, for: .normal)
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(accResponseModel.dob/1000))
//        let dayTimePeriodFormatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateformatter.string(from: date as Date)
        
        datePicker.date = date as Date
        if isFromConnectedUser == "ConnectedUser"{
            self.birthDateTxtFld.text = String(connectedUserAge) ?? ""
        }
        else{
            self.birthDateTxtFld.text = dateString
        }
           print(accResponseModel.userProfile?.sandRecruitNumber)
        
//        self.birthDateTxtFld.text = String(accResponseModel.dob)
//        self.cityTxtFld.text = accResponseModel.city
        self.stateBtn.setTitle(accResponseModel.location, for: .normal)
        self.phoneTxtFld.text = accResponseModel.phoneNumber
        self.experienceBtn.setTitle(accResponseModel.userProfile?.experience, for: .normal)
        self.courtSidePreferenceBtn.setTitle(accResponseModel.userProfile?.courtSidePreference, for: .normal)
        self.positionBtn.setTitle(accResponseModel.userProfile?.position, for: .normal)
        self.heightBtn.setTitle(accResponseModel.userProfile?.height, for: .normal)
//        self.heightTxtFld.text = String(accResponseModel.userProfile?.height ?? "0")
//        self.tournamentLevelInterestBtn.setTitle(accResponseModel.userProfile?.tournamentLevelInterest, for: .normal)
//        self.toursPlayedTxtFld.text = accResponseModel.userProfile?.toursPlayedIn
//        self.highestTourRatingEarnedBtn.setTitle(accResponseModel.userProfile?.highestTourRatingEarned, for: .normal)
//        self.cbvaPlayerNumberTxtFld.text = accResponseModel.userProfile?.cbvaPlayerNumber
//        self.cbvaFirstNameTxtFld.text = accResponseModel.userProfile?.cbvaFirstName
//        self.cbvaLastNameTxtFld.text = accResponseModel.userProfile?.cbvaLastName
        self.willingnessToTravelBtn.setTitle(accResponseModel.userProfile?.willingToTravel, for: .normal)
        self.highSchoolAttendedTxtFld.text = accResponseModel.userProfile?.highSchoolAttended
        self.indoorClubPlayedAtTxtFld.text = accResponseModel.userProfile?.indoorClubPlayed
//        self.collegeClubTxtFld.text = accResponseModel.userProfile?.collageClub
        self.collegeBeachTxtfld.text = accResponseModel.userProfile?.collegeBeach
        self.collegeIndoorTxtFld.text = accResponseModel.userProfile?.collegeIndoor
        self.sandRecruitNumberTxtFld.text = accResponseModel.userProfile?.sandRecruitNumber
//        self.pointsTxtFld.text = accResponseModel.userProfile?.totalPoints
//        self.rankingTxtFld.text = accResponseModel.userProfile?.usaVolleyballRanking
        UserDefaults.standard.set(accResponseModel.location , forKey: "location")

        self.tableCell_TopFinishesinLastYear1.isHidden = false
        self.tableCell_TopFinishesinLastYear2.isHidden = false
        
        if(accResponseModel.userProfile?.topFinishes != ""){
            
            var toplist = accResponseModel.userProfile?.topFinishes.components(separatedBy: ",")
            //            print("top list count :", toplist?.count ?? 0, toplist![0])

            toplist = toplist?.filter{ $0 != "" }
            
            if(toplist?.count == 3){
                self.topFinishesoneTxtFld.text = toplist![1]
                self.topFinishestwoTxtFld.text = toplist![2]
                self.topFinishesTxtfld.text = toplist![0]
                self.showtopFinish1 = true
                self.showtopfinish2 = true
            }
            if(toplist?.count == 2){
                self.topFinishesoneTxtFld.text = toplist![1]
                self.topFinishesTxtfld.text = toplist![0]
                self.showtopFinish1 = true
                self.showtopfinish2 = false
                self.tableCell_TopFinishesinLastYear2.isHidden = true
            }
            if(toplist?.count == 1){
                self.showtopFinish1 = false
                self.showtopfinish2 = false
                self.topFinishesTxtfld.text = toplist![0]
                self.tableCell_TopFinishesinLastYear1.isHidden = true
                self.tableCell_TopFinishesinLastYear2.isHidden = true
            }
        }
        self.tableView.reloadData()
    }
    
    
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    
    func loadVideoOnPlayer( videoUrlVal: String){
        
        self.videoView?.refreshPlayer()
        
        if let videoUrl = URL(string: videoUrlVal) {
            self.videoView?.load(videoUrl)
            self.videoView?.isMuted = true
            self.videoView?.play()
        }
    }
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            self.imagePickerclicked = false;        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
      
        
        var videoUrlValue: NSURL? = nil
        
        //        self.videoUrl = ""UIImagePickerControllerMediaURL
        self.imageUrl = ""
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject
        
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                
                
                if stringType == kUTTypeMovie as String {
                    
                    //                    self.videoPlayer?.prepareVideoPlayer()
                    
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    
                    videoUrlValue = info[UIImagePickerControllerMediaURL] as? NSURL
                    
                    print("Sizee : ",self.sizePerMB(url: urlOfVideo! as URL))
                    
                    if(self.sizePerMB(url: urlOfVideo! as URL) <= 15.0){
                        //                    DispatchQueue.main.async {
                        if let tempPath = urlOfVideo {
                            
                            self.videoUrl = tempPath.absoluteString!
                            
                            do {
                                
                                self.movieData = try NSData(contentsOfFile: (tempPath.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
                                
                                print(">>>>>",self.movieData)
                            } catch _ {
                                self.movieData = nil
                                return
                            }
                            print(">>>>>",self.movieData)
                            
                            self.loadVideoOnPlayer(videoUrlVal: self.videoUrl)
                            
                            if( self.movieData != nil){
                                self.noVideoLbl.isHidden = true
                                self.uploadProfileVideo(profileVideo: self.movieData!)
                            }
                            else{
                                print("not null  !!! ")
                            }
                        }
                    }
                        
                    else{
                        print(self.sizePerMB(url: urlOfVideo! as URL) )
                        self.alert(message: "The selected video exceeds the permissible file size. Please select another video")
                        //                        self.alert(message: errorString)
                        
                    }
                }
                else if stringType == kUTTypeImage as String {
                    
                    let urlOfImage = info[UIImagePickerControllerMediaURL] as? NSURL
                    //                    if(self.sizePerMB(url: urlOfImage! as URL) <= 4.0){
                    
                    if let tempImgPath = urlOfImage {
                        
                        self.imageUrl = tempImgPath.absoluteString!
                    }
                    let image = info[UIImagePickerControllerOriginalImage]
                    self.userImageView.image = image as! UIImage
                    print("video url : ",self.videoUrl)
                 //   self.loadVideoOnPlayer(videoUrlVal: self.videoUrl)
                    if(self.userImageView.image != nil){
                        self.uploadProfilePic(profilePic: self.userImageView.image!)
                    }
                    
                    //                    }
                    //
                    //                    else{
                    //                        self.alert(message: "The selected image exceeds the permissible file size. Please select another image.", title: "Faild To Select")
                    //                    }
                    
                }
            }
        }
        
        finishAndUpdate()
        
    }
    
    func uploadProfileVideo(profileVideo:NSData){
        let profilePic = UIImage()
        APIManager.callServer(withBusy: BusyScreen(isShow: true, text: "Preparing video ...")).updateAtheleteProfilePicAndVideo(userimage: profilePic, videoData: profileVideo, sucessResult: { (responseModel) in
            
            guard let updationResult = responseModel as? UpdateProfileImageVideoModel else{
                return
            }
            
            if(updationResult != nil){
                print("profileImgUrl",updationResult.profileImgUrl)
                print("profileVideoUrl",updationResult.profileVideoUrl)
                
                self.userData.videoUrl = updationResult.profileVideoUrl
             //   self.userData.imageUrl = updationResult.profileImgUrl
            }
             self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        }) { (error) in
            self.alert(message: error!, title: "Faild To Update")
              self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        }
    }
    
    
    func uploadProfilePic(profilePic:UIImage){
         let profileVideo = NSData()
        APIManager.callServer(withBusy: BusyScreen(isShow: true, text: "Preparing Image ...")).updateAtheleteProfilePicAndVideo(userimage: profilePic, videoData: profileVideo, sucessResult: { (responseModel) in
            guard let updationResult = responseModel as? UpdateProfileImageVideoModel else{
                return
            }
            
            if(updationResult != nil){
                print("n.n.n.n")
                self.userData.imageUrl = updationResult.profileImgUrl
            }
              self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        }) { (error) in
            self.alert(message: error!, title: "Faild To Update")
             self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        }
    }
    
    
    fileprivate func finishAndUpdate() {
        dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else {
                return
            }

            self.addToplistBtn.isUserInteractionEnabled = true
            self.delTop1.isUserInteractionEnabled = true
            self.delTop2.isUserInteractionEnabled = true
            let image = UIImage(named: "edit_btn_active_1x") as UIImage?
            self.editProfileBtn.setImage(image, for: .normal)
            self.editclicked = true
            self.addToplistBtn.isHidden = true
            self.delTop1.isHidden = (self.delTop1 != nil)
            self.delTop2.isHidden = (self.delTop2 != nil)
            print(self.delTop2)
            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
            self.editUserImageBtn.isHidden = false
            self.editUserImageBtn.isUserInteractionEnabled = true
            self.editVideoBtn.isHidden = false
            self.editVideoBtn.isUserInteractionEnabled = true
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        dismiss(animated: true, completion: {
            // Done cancel dismiss of image picker.
            self.addToplistBtn.isUserInteractionEnabled = true
            self.delTop1.isUserInteractionEnabled = true
            self.delTop2.isUserInteractionEnabled = true
            let image = UIImage(named: "edit_btn_active_1x") as UIImage?
            self.editProfileBtn.setImage(image, for: .normal)
            self.editclicked = true
            self.addToplistBtn.isHidden = true
            self.delTop1.isHidden = false
            self.delTop2.isHidden = false
            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
            self.editUserImageBtn.isHidden = false
            self.editUserImageBtn.isUserInteractionEnabled = true
            self.editVideoBtn.isHidden = false
            self.editVideoBtn.isUserInteractionEnabled = true
        })
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
}



extension UITextField {
    
    func enableTextFld() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.textColor = UIColor.navigationBarTintColor
        
    }
    func disableTextFld() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor(rgb: 0xECECEF).cgColor
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(rgb: 0xECECEF)
//
    }
}
extension UIButton{
    func enableBtn(){
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    func disableBtn() {
        self.layer.borderWidth = 0
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(rgb: 0xECECEF)
        self.borderColor = UIColor(rgb: 0xECECEF)
    }
}

