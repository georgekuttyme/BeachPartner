//
//  CoachProfileTableViewController.swift
//  BeachPartner
//
//  Created by Powermac on 5/3/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import DropDown
import AVFoundation
import AVKit
import MobileCoreServices
import Floaty

class CoachProfileTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    
    //    let bufferingQueue = DispatchQueue(label: "beachPartner", qos: DispatchQoS.userInteractive)
    var state = ""
    var stateList = [String]()
    let statedropDown = DropDown()

    

    @IBOutlet weak var editUserImageBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var editProfileTxtBtn: UIButton!
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
    
    

    @IBOutlet weak var tableCell_SaveCancel: UITableViewCell!
    
    @IBOutlet weak var tableCell_College: UITableViewCell!
    @IBOutlet weak var tableCell_Description: UITableViewCell!
    
    @IBOutlet weak var tableCell_YearsRunning: UITableViewCell!
    
    @IBOutlet weak var tableCell_NumberOfAthletes: UITableViewCell!
    @IBOutlet weak var tableCell_ProgramsOffered: UITableViewCell!
    
    @IBOutlet weak var tableCell_Division: UITableViewCell!
    
    @IBOutlet weak var tableCell_Funded: UITableViewCell!
    
    @IBOutlet weak var tableCell_ShareAthletes: UITableViewCell!
    
    
    
    
    
    @IBOutlet weak var firstNameTxtFld:  FloatingText!
    @IBOutlet weak var lastNameTxtFld: FloatingText!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var birthDateTxtFld: FloatingText!
    @IBOutlet var stateBtn: UIButton!
    @IBOutlet weak var phoneTxtFld: FloatingText!
    
    @IBOutlet weak var collegeTxtFld: FloatingText!
    @IBOutlet weak var descriptionTxtFld: FloatingText!
    @IBOutlet weak var numberOfYearsTxtFld: FloatingText!
    
    @IBOutlet weak var numberOfAthletesTxtFld: FloatingText!
    
    @IBOutlet weak var programsOffered: FloatingText!
    @IBOutlet weak var divisionTxtFld: FloatingText!
    
    @IBOutlet weak var fundedBtn: UIButton!
    @IBOutlet weak var shareAthletesBtn: UIButton!
    
    
    
    

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var userTypeLbl: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var activeTextField: UITextField?
    var userData = AccountRespModel()
    var videoUrl = ""
    var imageUrl = ""
    var movieData: NSData?
    
    var editclicked = false
    var isBasicInformation: Bool!
    //    let imagepickerController = UIImagePickerController()
    var imagePickerController = UIImagePickerController()
    
    //MARK: Drop Down Declarations
    
    let genderdropDown = DropDown()
    let fundeddropDown = DropDown()
    let shareAthletesDropDown = DropDown()
    
    let datePicker = UIDatePicker()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //  tableView.contentSize = CGSize(width: self.view.frame.size.width, height: 1700)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.saveData()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        editclicked = false
        self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.editclicked = false
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let image = UIImage(named: "edit_btn_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        editclicked = false
        self.tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getUserInfo()
        self.hideKeyboardWhenTappedAround()
        loadLocations()
        //
        //        let floaty = Floaty()
        //        floaty.addItem("I got a handler", icon: UIImage(named: "chat")!, handler: { item in
        //            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
        //            self.present(alert, animated: true, completion: nil)
        ////            alert.close()
        //        })
        //        self.shareBtnView.addSubview(floaty)
        //
        //        let floaty = Floaty()
        //        floaty.addItem("Hello, World!", icon: UIImage(named: "chat")!)
        //        self.shareBtnView.addSubview(floaty)
        
        
        tableCell_SaveCancel.isHidden = true
        
        
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false

        
        
        //MARK: Hide Cells
        //        self.tableCell_TopFinishesinLastYear1.isHidden = true
        //        self.tableCell_TopFinishesinLastYear2.isHidden = true
        
        
        //MARK: Date of Birth
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        birthDateTxtFld.inputView = datePicker
        //        self.imagePickerController.preferredStatusBarStyle  = .default
        self.imagePickerController.modalPresentationStyle = .currentContext
        self.imagePickerController.delegate = self
        
        self.editUserImageBtn.isHidden = true
        self.editUserImageBtn.isUserInteractionEnabled = false
        
        //MARK: Show basic info details by default
        isBasicInformation = true
        //        button_BasicInformation.setTitleColor(UIColor.blue, for: .normal)
        button_BasicInformation.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        view_BasicLine.backgroundColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        //        view_BasicLine.backgroundColor = UIColor.blue
        view_BasicMoreSeperator.isHidden = true
        
        //MARK: Gender DropDown
        self.genderdropDown.anchorView = self.genderBtn
        self.genderdropDown.dataSource = ["Male","Female"]
        self.genderdropDown.bottomOffset = CGPoint(x:20, y:10)
        self.genderdropDown.width = 100
        self.genderdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderBtn.setTitle(item, for: UIControlState.normal)
            self.genderBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
            //            self.genderBtn.setTitleColor(UIColor.blue, for: .normal)
        }
        self.genderBtn.setTitle("Please Select", for: UIControlState.normal)
        self.genderdropDown.selectRow(0)
        
        
        //MARK: Funded DropDown
        self.fundeddropDown.anchorView = self.fundedBtn
        self.fundeddropDown.dataSource = ["Yes","No"]
        self.fundeddropDown.bottomOffset = CGPoint(x:20, y:10)
        self.fundeddropDown.width = 100
        self.fundeddropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fundedBtn.setTitle(item, for: UIControlState.normal)
            self.fundedBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
            //            self.genderBtn.setTitleColor(UIColor.blue, for: .normal)
        }
        self.fundedBtn.setTitle("Please Select", for: UIControlState.normal)
        self.fundeddropDown.selectRow(0)
        
        
        //MARK: Share Athlete DropDown
        self.shareAthletesDropDown.anchorView = self.shareAthletesBtn
        self.shareAthletesDropDown.dataSource = ["Yes","No"]
        self.shareAthletesDropDown.bottomOffset = CGPoint(x:20, y:10)
        self.shareAthletesDropDown.width = 100
        self.shareAthletesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.shareAthletesBtn.setTitle(item, for: UIControlState.normal)
            self.shareAthletesBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
            //            self.genderBtn.setTitleColor(UIColor.blue, for: .normal)
        }
        self.shareAthletesBtn.setTitle("Please Select", for: UIControlState.normal)
        self.shareAthletesDropDown.selectRow(0)
        
        

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
            self.stateBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        }
        self.stateBtn.setTitle("Select your State", for: UIControlState.normal)
        self.statedropDown.selectRow(0)
        
        

        
        self.firstNameTxtFld.delegate = self
        self.lastNameTxtFld.delegate = self
        self.phoneTxtFld.delegate = self
        

        self.collegeTxtFld.delegate = self
        self.descriptionTxtFld.delegate = self
        self.numberOfYearsTxtFld.delegate = self
        
        self.numberOfAthletesTxtFld.delegate = self
        
        self.programsOffered.delegate = self
        self.divisionTxtFld.delegate = self
    }
    
    @IBAction func stateBtnAction(_ sender: Any) {
        statedropDown.show()
    }
    
    @IBAction func genderBtnClick(_ sender: Any) {
        genderdropDown.show()
    }
   
    @IBAction func fundedBtnClick(_ sender: Any) {
        fundeddropDown.show()
    }
    
    @IBAction func shareAthletesBtnClick(_ sender: Any) {
        shareAthletesDropDown.show()
    }
    
    
    
    //  MARK: Basic Info Button Action
    @IBAction func buttonActionForBasicInformation(_ basicInfoBtn: UIButton) {
        //        view_BasicLine.backgroundColor = UIColor.blue
        view_BasicLine.backgroundColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        //        basicInfoBtn.setTitleColor(UIColor.blue, for: .normal)
        basicInfoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        isBasicInformation = true
        view_MoreLine.backgroundColor = UIColor.white
        button_MoreInformation.setTitleColor(.white, for: .normal)
        self.tableView.reloadData()
    }
    //  MARK: More Info Button Action
    @IBAction func buttonActionForMoreInformation(_ moreInfoBtn: UIButton) {
        //        view_MoreLine.backgroundColor = UIColor.blue
        view_MoreLine.backgroundColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        view_BasicLine.backgroundColor = UIColor.white
        button_BasicInformation.setTitleColor(UIColor.white, for: .normal)
        isBasicInformation = false
        
        moreInfoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        self.tableView.reloadData()
        //        moreInfoBtn.setTitleColor(UIColor.blue, for: .normal)
        
    }
    
    
    
    @IBAction func editBtnClicked(_ sender: Any) {
        
        let image = UIImage(named: "edit_btn_active_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        if (self.editUserImageBtn.isHidden) {
            self.editUserImageBtn.isHidden = false
            self.editUserImageBtn.isUserInteractionEnabled = true
            editclicked = true
            self.editProfileTxtBtn.setTitle("Save profile", for: UIControlState.normal)
            self.tableView.reloadData()
        }
        else {
            let image = UIImage(named: "edit_btn_1x") as UIImage?
            editProfileBtn.setImage(image, for: .normal)
            self.editUserImageBtn.isHidden = true
            self.editUserImageBtn.isUserInteractionEnabled = false
            editclicked = false
            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
            self.tableView.reloadData()
        }
    }
    @IBAction func editProfileTxtBtnClicked(_ sender: Any) {
        
        let image = UIImage(named: "edit_btn_active_1x") as UIImage?
        editProfileBtn.setImage(image, for: .normal)
        if (self.editUserImageBtn.isHidden) {
            self.editUserImageBtn.isHidden = false
            self.editUserImageBtn.isUserInteractionEnabled = true
            editclicked = true
            self.editProfileTxtBtn.setTitle("Save profile", for: UIControlState.normal)
            self.tableView.reloadData()
        }
        else {
            let image = UIImage(named: "edit_btn_1x") as UIImage?
            editProfileBtn.setImage(image, for: .normal)
            self.editUserImageBtn.isHidden = true
            self.editUserImageBtn.isUserInteractionEnabled = false
            editclicked = false
            self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)
            self.tableView.reloadData()
        }
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
            self.userData.inputDob = birthDateTxtFld.text!
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
        //        if cityTxtFld.isEmpty() {
        //            cityTxtFld.shake()
        //            cityTxtFld.errorText = "Empty!"
        //            cityTxtFld.showError()
        //        }else{
        //            cityTxtFld.hideError()
        //            self.userData.city = cityTxtFld.text!
        //            currentValidation += 1
        //        }
        
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
        
        self.userData.userProfile?.collage = collegeTxtFld.text ?? ""
        self.userData.userProfile?.description = descriptionTxtFld.text ?? ""
        self.userData.userProfile?.yearsRunning = numberOfYearsTxtFld.text ?? ""
        self.userData.userProfile?.numOfAthlets = numberOfAthletesTxtFld.text ?? ""
        self.userData.userProfile?.programsOffered = programsOffered.text ?? ""
        self.userData.userProfile?.division = divisionTxtFld.text ?? ""
        self.userData.userProfile?.fundingStatus = fundedBtn.titleLabel?.text ?? ""
        self.userData.userProfile?.shareAthlets = shareAthletesBtn.titleLabel?.text ?? ""
        
        
        self.userData.userProfile?.experience =  ""
        self.userData.userProfile?.courtSidePreference =  ""
        self.userData.userProfile?.position = ""
        self.userData.userProfile?.height = ""
        self.userData.userProfile?.tournamentLevelInterest =  ""
        self.userData.userProfile?.toursPlayedIn = ""
        self.userData.userProfile?.highestTourRatingEarned =  ""
        self.userData.userProfile?.cbvaPlayerNumber = ""
        self.userData.userProfile?.cbvaFirstName = ""
        self.userData.userProfile?.cbvaLastName = ""
        self.userData.userProfile?.willingToTravel = ""
        self.userData.userProfile?.highSchoolAttended = ""
        self.userData.userProfile?.indoorClubPlayed = ""
        self.userData.userProfile?.collageClub = ""
        self.userData.userProfile?.collegeBeach = ""
        self.userData.userProfile?.collegeIndoor = ""
        self.userData.userProfile?.totalPoints = ""
        self.userData.userProfile?.usaVolleyballRanking = ""
        self.userData.userProfile?.topFinishes = ""
        
        if sucessValidation == currentValidation {
            
            self.updateUserInfo()
            
        }
        
    }
    

    @IBAction func editUserImageClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Choose your profile image", preferredStyle: UIAlertControllerStyle.alert)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePickerController.delegate = self
                self.imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.imagePickerController.allowsEditing = false
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
        
        imagePickerController.navigationBar.barTintColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)// Background color
        imagePickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
        imagePickerController.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ] // Title color
        present(imagePickerController, animated: true, completion: {
            // Done presenting.
        })
        
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if (isBasicInformation){
            
            if (cell == self.tableCell_College || cell == self.tableCell_Description || cell == self.tableCell_YearsRunning || cell == self.tableCell_NumberOfAthletes || cell == self.tableCell_ProgramsOffered || cell == self.tableCell_Division || cell == self.tableCell_Funded || cell == self.tableCell_ShareAthletes) {
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
                return super.tableView(tableView, heightForRowAt: indexPath)
                
            }
            
        }
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

           
            collegeTxtFld.enableTextFld()
            descriptionTxtFld.enableTextFld()
            numberOfYearsTxtFld.enableTextFld()
            numberOfAthletesTxtFld.enableTextFld()
            programsOffered.enableTextFld()
            divisionTxtFld.enableTextFld()
            fundedBtn.enableBtn()
            shareAthletesBtn.enableBtn()
            
            
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

            collegeTxtFld.disableTextFld()
            descriptionTxtFld.disableTextFld()
            numberOfYearsTxtFld.disableTextFld()
            numberOfAthletesTxtFld.disableTextFld()
            programsOffered.disableTextFld()
            divisionTxtFld.disableTextFld()
            fundedBtn.disableBtn()
            shareAthletesBtn.disableBtn()
            
            
            
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
        if  textField == collegeTxtFld {
            descriptionTxtFld.becomeFirstResponder()
        }
        else if textField == descriptionTxtFld {
            numberOfYearsTxtFld.becomeFirstResponder()
        }
        else if textField == numberOfYearsTxtFld{
            numberOfAthletesTxtFld.becomeFirstResponder()
        }
        else if textField == numberOfAthletesTxtFld{
            programsOffered.resignFirstResponder()
        }
        else if textField == programsOffered{
            divisionTxtFld.becomeFirstResponder()
        }
        else if textField == divisionTxtFld{
           textField.resignFirstResponder()
        }
        
        return true;
    }
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to: tableView)
    //        var contentOffset:CGPoint = tableView.contentOffset
    //        contentOffset.y  = pointInTable.y
    //        print(pointInTable.y)
    //        if let accessoryView = textField.inputAccessoryView {
    //            contentOffset.y -= accessoryView.frame.size.height
    //        }
    //        tableView.contentOffset = contentOffset
    //        return true;
    //    }
    //
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        if (textField.superview?.superview is UITableViewCell) {
    //            let buttonPosition = textField.convert(CGPoint.zero, to: tableView)
    //            let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
    //            if let aPath = indexPath {
    //                tableView.scrollToRow(at: aPath, at: .middle, animated: true)
    //            }
    //        }
    //        return true
    //    }
    
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
        formatter.dateFormat = "yyyy-MM-dd"
        
        //        formatter.dateStyle = DateFormatter.Style.medium
        //        formatter.timeStyle = DateFormatter.Style.none
        
        birthDateTxtFld.text = formatter.string(from: sender.date)
    }
    
    func updateUserInfo(){
        
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.updateUserDetails(userData: self.userData, sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? AccountRespModel else{
                //                    stopLoading()
                
                
                return
            }
            
            if(accRespModel.id != 0){
                
                UserDefaults.standard.set(accRespModel.id, forKey: "bP_userProfileId")
                self.alert(message: "User profile updated successfully! ")
                ActivityIndicatorView.hiding()
                DispatchQueue.main.async {
                    let image = UIImage(named: "edit_btn_1x") as UIImage?
                    self.editProfileBtn.setImage(image, for: .normal)
                    self.editUserImageBtn.isHidden = true
                    self.editUserImageBtn.isUserInteractionEnabled = false
                    self.editclicked = false
                    
                    self.editProfileTxtBtn.setTitle("Edit profile", for: UIControlState.normal)

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
                    
                    self.backgroundImageView.sd_setIndicatorStyle(.whiteLarge)
                    self.backgroundImageView.sd_setShowActivityIndicatorView(true)
                    self.backgroundImageView.sd_setImage(with: imageUrl, placeholderImage:  #imageLiteral(resourceName: "user"))
                }
                
//                self.videoUrl = accRespModel.videoUrl
                
//                self.loadVideoOnPlayer(videoUrlVal: accRespModel.videoUrl)
                
                self.loadDataToUi(accResponseModel: accRespModel)
                
                ActivityIndicatorView.hiding()
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
    
    func loadDataToUi( accResponseModel : AccountRespModel){
        self.userName.text = accResponseModel.firstName
        //        + " " + accResponseModel.lastName
        self.userTypeLbl.text = accResponseModel.userType
        self.firstNameTxtFld.text = accResponseModel.firstName
        self.lastNameTxtFld.text = accResponseModel.lastName
        self.genderBtn.setTitle(accResponseModel.gender, for: .normal)
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(accResponseModel.dob/1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        datePicker.date = date as Date
        if accResponseModel.dob > 0 {
            self.birthDateTxtFld.text = dateString
        }
        else{
            self.birthDateTxtFld.text = ""
        }
        
        //        self.birthDateTxtFld.text = String(accResponseModel.dob)
        //        self.cityTxtFld.text = accResponseModel.city
        self.stateBtn.setTitle(accResponseModel.city, for: .normal)
        self.phoneTxtFld.text = accResponseModel.phoneNumber
        
        self.collegeTxtFld.text = accResponseModel.userProfile?.collage
        self.descriptionTxtFld.text = accResponseModel.userProfile?.description
        self.numberOfYearsTxtFld.text = accResponseModel.userProfile?.yearsRunning
        
        self.numberOfAthletesTxtFld.text = accResponseModel.userProfile?.numOfAthlets
        
        self.programsOffered.text = accResponseModel.userProfile?.programsOffered
        self.divisionTxtFld.text = accResponseModel.userProfile?.division
        
        self.fundedBtn.setTitle(accResponseModel.userProfile?.fundingStatus, for: .normal)
        self.shareAthletesBtn.setTitle(accResponseModel.userProfile?.shareAthlets, for: .normal)
        
 
        
        
        
//        self.experienceBtn.setTitle(accResponseModel.userProfile?.experience, for: .normal)
//        self.courtSidePreferenceBtn.setTitle(accResponseModel.userProfile?.courtSidePreference, for: .normal)
//        self.positionBtn.setTitle(accResponseModel.userProfile?.position, for: .normal)
//        self.heightBtn.setTitle(accResponseModel.userProfile?.height, for: .normal)
//        //        self.heightTxtFld.text = String(accResponseModel.userProfile?.height ?? "0")
//        self.tournamentLevelInterestBtn.setTitle(accResponseModel.userProfile?.tournamentLevelInterest, for: .normal)
//        self.toursPlayedTxtFld.text = accResponseModel.userProfile?.toursPlayedIn
//        self.highestTourRatingEarnedBtn.setTitle(accResponseModel.userProfile?.highestTourRatingEarned, for: .normal)
//        self.cbvaPlayerNumberTxtFld.text = accResponseModel.userProfile?.cbvaPlayerNumber
//        self.cbvaFirstNameTxtFld.text = accResponseModel.userProfile?.cbvaFirstName
//        self.cbvaLastNameTxtFld.text = accResponseModel.userProfile?.cbvaLastName
//        self.willingnessToTravelBtn.setTitle(accResponseModel.userProfile?.willingToTravel, for: .normal)
//        self.highSchoolAttendedTxtFld.text = accResponseModel.userProfile?.highSchoolAttended
//        self.indoorClubPlayedAtTxtFld.text = accResponseModel.userProfile?.indoorClubPlayed
//        self.collegeClubTxtFld.text = accResponseModel.userProfile?.collageClub
//        self.collegeBeachTxtfld.text = accResponseModel.userProfile?.collegeBeach
//        self.collegeIndoorTxtFld.text = accResponseModel.userProfile?.collegeIndoor
//        self.pointsTxtFld.text = accResponseModel.userProfile?.totalPoints
//        self.rankingTxtFld.text = accResponseModel.userProfile?.usaVolleyballRanking
        UserDefaults.standard.set(accResponseModel.city , forKey: "location")
        
//        if(accResponseModel.userProfile?.topFinishes != ""){
//
//            let toplist = accResponseModel.userProfile?.topFinishes.components(separatedBy: ",")
//            //            print("top list count :", toplist?.count ?? 0, toplist![0])
//
//
//            if(toplist?.count == 3){
//                self.topFinishesoneTxtFld.text = toplist![1]
//                self.topFinishestwoTxtFld.text = toplist![2]
//                self.topFinishesTxtfld.text = toplist![0]
//                self.showtopFinish1 = true
//                self.showtopfinish2 = true
//            }
//            if(toplist?.count == 2){
//                self.topFinishesoneTxtFld.text = toplist![1]
//                self.topFinishesTxtfld.text = toplist![0]
//                self.showtopFinish1 = true
//                self.showtopfinish2 = false
//            }
//            if(toplist?.count == 1){
//                self.showtopFinish1 = false
//                self.showtopfinish2 = false
//                self.topFinishesTxtfld.text = toplist![0]
//            }
//        }
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
    
    
//    func loadVideoOnPlayer( videoUrlVal: String){
//
//        self.videoView?.refreshPlayer()
//
//        if let videoUrl = URL(string: videoUrlVal) {
//            self.videoView?.load(videoUrl)
//            self.videoView?.isMuted = false
//            self.videoView?.play()
//        }
//    }
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var videoUrlValue: NSURL? = nil
        
        //        self.videoUrl = ""
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
                            
//                            self.loadVideoOnPlayer(videoUrlVal: self.videoUrl)
                            
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
//                    self.loadVideoOnPlayer(videoUrlVal: self.videoUrl)
                    //                    }
                    //
                    //                    else{
                    //                        self.alert(message: "The selected image exceeds the permissible file size. Please select another image.", title: "Faild To Select")
                    //                    }
                    
                }
            }
        }
        
        
        
        print("####")
        
        print(">>>>>",self.movieData)
        print(self.userImageView.image)
        print("%%%%%%")
        if( self.movieData != nil && self.userImageView.image != nil){
            
            print("testttttttt !!! ")
            self.uploadProfilePicAndVideo(profilePic: self.userImageView.image!, profileVideo: self.movieData!)
            
        }
        else{
            print("not null  !!! ")
        }
        
        finishAndUpdate()
        
    }
    
    func uploadProfilePicAndVideo(profilePic:UIImage, profileVideo:NSData){
        
        APIManager.callServer(withBusy: BusyScreen(isShow: true, text: "Preparing video ...")).updateAtheleteProfilePicAndVideo(userimage: profilePic, videoData: profileVideo, sucessResult: { (responseModel) in
            
            guard let updationResult = responseModel as? UpdateProfileImageVideoModel else{
                return
            }
            
            if(updationResult != nil){
                
                print("profileImgUrl",updationResult.profileImgUrl)
                print("profileVideoUrl",updationResult.profileVideoUrl)
                
                self.userData.videoUrl = updationResult.profileVideoUrl
                //                self.userData.videoUrl = "http://seqato.com/bp/videos/1.mp4"
                self.userData.imageUrl = updationResult.profileImgUrl
            }
            
            
        }) { (error) in
            self.alert(message: error!, title: "Faild To Update")
        }
    }
    
    
    
    fileprivate func finishAndUpdate() {
        dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.editUserImageBtn.isHidden = true
            self.editUserImageBtn.isUserInteractionEnabled = false
//            self.editVideoBtn.isHidden = true
//            self.editVideoBtn.isUserInteractionEnabled = false
            
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            // Done cancel dismiss of image picker.
            self.editUserImageBtn.isHidden = true
            self.editUserImageBtn.isUserInteractionEnabled = false
//            self.editVideoBtn.isHidden = true
//            self.editVideoBtn.isUserInteractionEnabled = false
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
