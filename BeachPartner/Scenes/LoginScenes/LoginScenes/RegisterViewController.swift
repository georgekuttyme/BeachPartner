//
//  RegisterViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 15/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import M13Checkbox
import Toast_Swift
import DropDown

class RegisterViewController: UIViewController {
    var dob = ""
    var state = ""
    var flag = Bool()
    @IBOutlet weak var firstName: FloatingText!
    @IBOutlet weak var lastName: FloatingText!
    @IBOutlet weak var birthDate: FloatingText!

    @IBOutlet weak var atheleteRadioBtn: M13Checkbox!

    @IBOutlet weak var coachRadioBtn: M13Checkbox!
    
    @IBOutlet weak var emailTxt: FloatingText!
    @IBOutlet weak var paswordTxt: FloatingText!
    @IBOutlet weak var confirmPwdTxt: FloatingText!
    @IBOutlet weak var cityTxt: FloatingText!
    @IBOutlet weak var mobileTxt: FloatingText!
    
    @IBOutlet weak var maleBtn: UIButton!
     @IBOutlet weak var female: UIButton!
    
     @IBOutlet weak var athelete: UIButton!
     @IBOutlet weak var coach: UIButton!
    var stateList = [String]()
    var cityList = DropDown()
    @IBOutlet var statebtn: UIButton!
    let statedropDown = DropDown()
    
    var gender = ""
    var userType = "Athlete"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.birthDate.delegate = self
        self.emailTxt.delegate = self
        self.paswordTxt.delegate = self
        self.confirmPwdTxt.delegate = self
        
        self.mobileTxt.delegate = self
        
        self.maleBtn.tag = 10
        self.maleBtn.backgroundColor = UIColor.white
        self.female.backgroundColor = UIColor.white
        
//        self.maleBtn.titleColor(for: .normal) = UIColor.black
//        self.female.backgroundColor = UIColor.white
        self.female.tag = 20
        NotificationCenter.default.addObserver(self, selector: #selector(validateInputs(notification:)), name:NSNotification.Name(rawValue: "validate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(minorPopUpAction(notification:)), name:NSNotification.Name(rawValue: "popup-Action"), object: nil)
//        self.maleBtn.backgroundColor = UIColor.clear
        loadLocations()
        self.hideKeyboardWhenTappedAround()
        
        self.coachRadioBtn.checkState = .unchecked
        self.atheleteRadioBtn.checkState = .unchecked
        self.atheleteRadioBtn.toggleCheckState()
//        self.coachRadioBtn.toggleCheckState()
        self.statedropDown.anchorView = self.statebtn
        self.statedropDown.dataSource = self.stateList
        print(self.stateList)
        self.statedropDown.bottomOffset = CGPoint(x:10, y:10)
        self.statedropDown.width = 300
        self.statedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.state = item
            print("@@@@@",self.state)
            self.statebtn.setTitle(item, for: UIControlState.normal)
            self.statebtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        }
        self.statebtn.setTitle("Select your State", for: UIControlState.normal)
        self.statedropDown.selectRow(0)

    }
    

    @IBAction func stateBtnAction(_ sender: Any) {
        statedropDown.show()
    }
    
     @objc func minorPopUpAction(notification: NSNotification){
        let chooseData = notification.userInfo as! [String:String]
        print(chooseData["type"] ?? "")
        self.birthDate.text = self.dob
    }
  
    
    @objc func validateInputs(notification: NSNotification) {
        
        print("Child method is called")
        let sucessValidation = 7
        var currentValidation = 0
        
        if firstName.isEmpty() {
            firstName.shake()
            firstName.errorText = "First name cannot be blank"
            firstName.showError()
        }
        else {
            if (firstName.text?.hasPrefix(" "))! {
                firstName.shake()
                firstName.errorText = "First name can’t start with whitespaces"
                firstName.showError()
            }
            else {
                firstName.hideError()
            }
            if let first = self.firstName.text, first.isValidName() {
                currentValidation += 1
                firstName.hideError()
            }
            else {
                firstName.shake()
                firstName.errorText = "No special characters allowed"
                firstName.showError()
            }
        }
        
        if lastName.isEmpty() {
            lastName.shake()
            lastName.errorText = "Last name cannot be blank"
            lastName.showError()
        }
        else {
            if (lastName.text?.hasPrefix(" "))! {
                lastName.shake()
                lastName.errorText = "Lastname can't start with whitespaces"
                lastName.showError()
            }
            else {
                lastName.hideError()
            }
            if let last = self.lastName.text, last.isValidName() {
                currentValidation += 1
                lastName.hideError()
            }
            else {
                lastName.shake()
                lastName.errorText = "No special characters allowed"
                lastName.showError()
            }
        }
        
        if birthDate.text == "" {
            birthDate.shake()
            birthDate.errorText = "Select date of birth"
            birthDate.showError()
        }
        else {
            birthDate.hideError()
            currentValidation += 1
        }
        
        
//
//        if(maleBtn.backgroundColor == UIColor(red: 32.0/255, green: 48.0/255, blue: 127.0/255, alpha: 1.0) || female.backgroundColor == UIColor(red: 32.0/255, green: 48.0/255, blue: 127.0/255, alpha: 1.0)){
//            currentValidation += 1
//            flag = true
//        }
//        else {
//            if(currentValidation > 2 ){
//                flag = false
//                self.view.makeToast("Please select the gender", duration: 3.0, position: .center)
//            }
//        }
        
        if emailTxt.isEmpty() {
            emailTxt.shake()
            emailTxt.errorText = "Email cannot be blank"
            emailTxt.showError()
        }
        else if let email = emailTxt.text {
            if email.isValidEmailAddress() {
                currentValidation += 1
            }
            else {
                emailTxt.shake()
                emailTxt.errorText = " Please enter a valid email"
                emailTxt.showError()
            }
        }
        
        if paswordTxt.isEmpty() {
            paswordTxt.shake()
            paswordTxt.errorText = "Please enter a valid password"
            paswordTxt.showError()
        }
        else {
            if (paswordTxt.text?.hasPrefix(" "))! || (paswordTxt.text?.hasSuffix(" "))!{
                paswordTxt.shake()
                paswordTxt.errorText = "Password can’t start or end with whitespaces"
                paswordTxt.showError()
            }
            else {
                paswordTxt.hideError()
            }
                
            if (paswordTxt.text?.count)! >= 8 {
                if (paswordTxt.text?.hasPrefix(" "))! || (paswordTxt.text?.hasSuffix(" "))!{
                    paswordTxt.shake()
                    paswordTxt.errorText = "Can’t start or end with whitespaces"
                    paswordTxt.showError()
                }
                else {
                    paswordTxt.hideError()
                    currentValidation += 1
                }
            }
            else {
                paswordTxt.shake()
                paswordTxt.errorText = "Please enter minimum eight characters"
                paswordTxt.showError()
            }
        }
       
        
        
        if confirmPwdTxt.isEmpty() {
            confirmPwdTxt.shake()
            confirmPwdTxt.errorText = "Please confirm your password"
            confirmPwdTxt.showError()
        }else{
            if (confirmPwdTxt.text?.hasPrefix(" "))! || (confirmPwdTxt.text?.hasSuffix(" "))!{
                confirmPwdTxt.shake()
                confirmPwdTxt.errorText = "Your password can't start or end with a blank space"
                confirmPwdTxt.showError()
            }
            if(confirmPwdTxt.text == paswordTxt.text){
                confirmPwdTxt.hideError()
                currentValidation += 1
            }
            else{
                confirmPwdTxt.errorText = "Password Mismatch "
                confirmPwdTxt.showError()
            }
            
        }
        
//        if cityTxt.isEmpty() {
//            cityTxt.shake()
//            cityTxt.errorText = "Please enter your location"
//            cityTxt.showError()
//        }else{
//            cityTxt.hideError()
//            currentValidation += 1
//        }
        
        if mobileTxt.isEmpty() {
            mobileTxt.shake()
            mobileTxt.errorText = "Please enter a valid mobile number "
            mobileTxt.showError()
        }
        else {
            
                if (mobileTxt.text?.count)! == 10  {
                    if mobileTxt.text == "0000000000"{
                        mobileTxt.shake()
                        mobileTxt.errorText = "Please enter a valid mobile number"
                        mobileTxt.showError()
                    }
                    else{
                        mobileTxt.hideError()
                        currentValidation += 1
                    }
                    
                }else{
                    mobileTxt.shake()
                    mobileTxt.errorText = "Please enter a valid mobile number"
                    mobileTxt.showError()
                }
        }
        
        if sucessValidation == currentValidation {
        
            if gender == "" {
                self.view.makeToast("Please select the gender", duration: 3.0, position: .center)
                return
            }
            
            if self.state == "" {
                self.view.makeToast("Please choose State", duration: 3.0, position: .center)
                return
            }
            else{
                UserDefaults.standard.set(self.state , forKey: "location")
            }
            
            //success
            ActivityIndicatorView.show("Loading...")
            
            APIManager.callServer.forRegistration(email: emailTxt.text!, password: paswordTxt.text!, location: self.state, deviceId: ApiMethods.device_UUID, dob: self.dob, firstName: firstName.text!, gender: self.gender, lastName: lastName.text!, mobileNo: mobileTxt.text!, userType: userType, sucessResult: { (responseModel) in
                
                guard let loginModel = responseModel as? LoginRespModel else {
                    return
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registered"), object: nil)

                ActivityIndicatorView.hiding()
            }, errorResult: { (error) in
                
                guard let errorString  = error else {
                    return
                }
                ActivityIndicatorView.hiding()
                self.alert(message: errorString)
            })
            
            
            
        }else{
            //failed
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        
        if sender.backgroundColor == UIColor(red: 32.0/255, green: 48.0/255, blue: 127.0/255, alpha: 1.0) {
            return
        }
        sender.backgroundColor = UIColor(red: 32.0/255, green: 48.0/255, blue: 127.0/255, alpha: 1.0)
        sender.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        switch sender {
        case self.maleBtn:
            self.female.backgroundColor = UIColor.white
            self.female.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.gender = "Male"
        case self.female:
            self.maleBtn.backgroundColor = UIColor.white
            self.maleBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.gender = "Female"
            
        default:
            return
        }
   
    }
    
    @IBAction func atheleteClicked(_ sender: Any) {
        userType = "Athlete"
        print("atheleteClicked")
      
        self.coachRadioBtn.toggleCheckState()
    }
    
    @IBAction func coachClicked(_ sender: Any) {
        userType = "Coach"
        print("CoachClicked",userType)
        self.atheleteRadioBtn.toggleCheckState()
        //        self.atheleteRadioBtn.toggleCheckState()
    }
    
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let todayDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        let datePicker = DatePickerDialog(textColor: UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0),
//                                          textColor: .blue,
                                          buttonColor: UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0),
//                                          buttonColor: .blue,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
//        yyyy-MM-dd'T'HH:mm:ss.SSS
        
        datePicker.show("Date of Birth",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
//                        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside)
//                        minimumDate: threeMonthAgo,
                        maximumDate: todayDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                if case dt.description = "" {
                                    self.birthDate.shake()
                                    self.birthDate.errorText = "Select date of birth"
                                    self.birthDate.showError()
                                }
                                self.dob = formatter.string(from: dt)
                                let formatter1 = DateFormatter()
                                formatter1.dateFormat = "yyyy-MM-dd"
                                self.dob = formatter1.string(from: dt)
                                let now = Date()
                                let birthday: Date = dt
                                let calendar = Calendar.current
                                let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                                let age = ageComponents.year!
                                self.birthDate.text = formatter1.string(from: dt)
//                                if age > 17 {
//                                   self.birthDate.text = formatter1.string(from: dt)
//                                }
//                                else{
//                                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minorPopUp"), object: nil)
//                                }
                            }
        }
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
    func dropdownList() {
        
    }
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
//        return 1
//
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//
//        return list.count
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        self.view.endEditing(true)
//        return list[row]
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        self.cityTxt.text = self.stateList[row]
//        self.cityList.isHidden = true

//    }
    
}



extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.birthDate {
            datePickerTapped()
            return false
        }
        
        if textField == self.firstName || textField == self.lastName {
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
//        if textField == self.cityTxt {
////            cityList.show()
//            self.cityList.isHidden = false
//            //if you dont want the users to se the keyboard type:
//
//            textField.endEditing(true)
//            return true
//        }
      
        
        return true
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == self.firstName {
            if firstName.isEmpty() {
                firstName.shake()
                firstName.errorText = "First name cannot be blank"
                firstName.showError()
            }
            else{
                if (firstName.text?.hasPrefix(" "))! {
                    firstName.shake()
                    firstName.errorText = "First name can’t start with whitespaces"
                    firstName.showError()
                }
                else {
                    firstName.hideError()
                }
                if let first = self.firstName.text {
                    if first.isValidName(){
                        firstName.hideError()
                    }else{
                        firstName.shake()
                        firstName.errorText = "No special characters allowed"
                        firstName.showError()
                    }
                }
            }
        }
        else if textField == self.lastName {
            if lastName.isEmpty() {
                lastName.shake()
                lastName.errorText = "Last name cannot be blank"
                lastName.showError()
            }
            else{
                if (lastName.text?.hasPrefix(" "))! {
                    lastName.shake()
                    lastName.errorText = "Lastname can't start with whitespaces"
                    lastName.showError()
                }
                else {
                    lastName.hideError()
                }
                if let last = self.lastName.text {
                    if last.isValidName(){
                        
                        lastName.hideError()
                    }else{
                        lastName.shake()
                        lastName.errorText = "No special characters allowed"
                        lastName.showError()
                        
                    }
                }
                
            }
        }
        if textField == self.birthDate {
            if birthDate.text == "" {
                birthDate.shake()
                birthDate.errorText = "Select date of birth"
                birthDate.showError()
            }else{
                birthDate.hideError()
            }
            
        }
        if textField == self.emailTxt {
            if emailTxt.isEmpty() {
                emailTxt.shake()
                emailTxt.errorText = "Email cannot be blank"
                emailTxt.showError()
            }else{
                if let email = emailTxt.text {
                    if email.isValidEmailAddress() {
                        
                    }else{
                        emailTxt.shake()
                        emailTxt.errorText = " Please enter a valid email"
                        emailTxt.showError()
                    }
                }
            }
            
        }
        if textField == self.paswordTxt {
            if paswordTxt.isEmpty() {
                paswordTxt.shake()
                paswordTxt.errorText = "Please enter a valid password"
                paswordTxt.showError()
            }
            else{
                if (paswordTxt.text?.hasPrefix(" "))! || (paswordTxt.text?.hasSuffix(" "))!{
                    paswordTxt.shake()
                    paswordTxt.errorText = "Password can’t start or end with whitespaces"
                    paswordTxt.showError()
                }else{
                    paswordTxt.hideError()
                }
                
                if (paswordTxt.text?.count)! >= 8 {
                    if (paswordTxt.text?.hasPrefix(" "))! || (paswordTxt.text?.hasSuffix(" "))!{
                        paswordTxt.shake()
                        paswordTxt.errorText = "Password can’t start or end with whitespaces"
                        paswordTxt.showError()
                    }else{
                        paswordTxt.hideError()
                    }
                }else{
                    paswordTxt.shake()
                    paswordTxt.errorText = "Please enter minimum eight characters"
                    paswordTxt.showError()
                }
                
            }
        }
        if textField == self.confirmPwdTxt {
            
            if confirmPwdTxt.isEmpty() {
                confirmPwdTxt.shake()
                confirmPwdTxt.errorText = "Please confirm your password"
                confirmPwdTxt.showError()
            }else{
                if (confirmPwdTxt.text?.hasPrefix(" "))! || (paswordTxt.text?.hasSuffix(" "))!{
                    confirmPwdTxt.shake()
                    confirmPwdTxt.errorText = "Your password can't start or end with a blank space"
                    confirmPwdTxt.showError()
                }
                if(confirmPwdTxt.text == paswordTxt.text){
                    confirmPwdTxt.hideError()
                    
                }
                else{
                    confirmPwdTxt.errorText = "Password Mismatch "
                    confirmPwdTxt.showError()
                }
                
            }
            
        }
        if textField == self.mobileTxt {
            //            textField.autocapitalizationType = UITextAutocapitalizationType.words
            if mobileTxt.isEmpty() {
                mobileTxt.shake()
                mobileTxt.errorText = "Please enter a valid mobile number "
                mobileTxt.showError()
            }
            else {
                
                
                
                if (mobileTxt.text?.count)! == 10  {
                    if mobileTxt.text == "0000000000"{
                        mobileTxt.shake()
                        mobileTxt.errorText = "Please enter a valid mobile number"
                        mobileTxt.showError()
                    }
                    else{
                        mobileTxt.hideError()
                    }
                    
                }else{
                    mobileTxt.shake()
                    mobileTxt.errorText = " Please enter a valid mobile number"
                    mobileTxt.showError()
                }
                
            }
            
        }
    }

 
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if  textField == firstName {
            lastName.becomeFirstResponder()
        }
        else if  textField == lastName {
            emailTxt.becomeFirstResponder()
        }
        else if  textField == emailTxt {
            paswordTxt.becomeFirstResponder()
        }
        else if  textField == paswordTxt {
            confirmPwdTxt.becomeFirstResponder()
        }
        else if textField == confirmPwdTxt {
            mobileTxt.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
       
        return true;
    }
}




extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
