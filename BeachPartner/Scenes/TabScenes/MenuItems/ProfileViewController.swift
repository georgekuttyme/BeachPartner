//
//  ProfileViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
//import DropDown
var arrayBasicInfoDetails : [String] = []
var arrayMoreInfoDetails : [String] = []

class ProfileCell : UITableViewCell {
    @IBOutlet weak var lblLeftTitle: UILabel!
    @IBOutlet weak var textFieldRight: UITextField!
    @IBOutlet weak var bottomSeprator: UILabel!
}

class ProfileWithButtonCell : UITableViewCell {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
}

class MoreInfoWithAddButtonCell : UITableViewCell {
    @IBOutlet weak var lblLeftTitle: UILabel!
    @IBOutlet weak var textFieldRight: UITextField!
    @IBOutlet weak var bottomSeprator: UILabel!
    @IBOutlet weak var btnAddYear: UIButton!
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userData = AccountRespModel()
    var userProfileData = ProfileRespModel()
    var editCLicked = false
    
    @IBOutlet weak var editUserImageBtn: UIButton!
    @IBOutlet weak var editProfileBtnTxt: UIButton!
    @IBOutlet weak var editprofieBtn: UIButton!
    @IBOutlet weak var editVideoBtn: UIButton!
    @IBOutlet weak var videoPlayer: AGVideoPlayerView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editProfileClicked: UIButton!
    
    @IBOutlet weak var basicInfoBtn: UIButton!
    @IBOutlet weak var moreInfoBtn: UIButton!
    
    @IBOutlet weak var basicInfoColorView: UIView!
    @IBOutlet weak var moreInfoColorView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var tableViewBasicInfo: UITableView!
    @IBOutlet weak var tableViewMoreInfo: UITableView!
    
    var imagePickerController = UIImagePickerController()
    var yearCount : Int = 1
    
    var videoUrl = ""
    
    let arrayBasicInfo:[String] = ["First Name", "Last Name", "Gender", "Birth Date", "City", "Phone"]
    
    let arrayMoreInfo:[String] = ["Experience", "Court Side Preference", "Position", "Height", "Tournament Level Interest", "Tours Played", "Height Tour Rating Earned", "CBVA Player Number", "CBVA First Name", "CBVA Last Name", "Willingness To Travel", "High school attended", "Indoor club played at", "College (Club)", "College (Bearch)", "College (Indoor)", "Points", "Ranking"]

    
    @IBAction func editProfileCLicked(_ sender: Any) {
        if (self.editUserImageBtn.isHidden) {
            self.editUserImageBtn.isHidden = false
       //     self.editUserImageBtn.isUserInteractionEnabled = true
            self.editVideoBtn.isHidden = false
            self.editVideoBtn.isUserInteractionEnabled = true
            
            editCLicked = true
            
            self.tableViewBasicInfo.reloadData()
            self.tableViewMoreInfo.reloadData()
            
        }
        else{
            self.editUserImageBtn.isHidden = true
       //     self.editUserImageBtn.isUserInteractionEnabled = false
            self.editVideoBtn.isHidden = true
            self.editVideoBtn.isUserInteractionEnabled = false
            
            self.editCLicked = false
            
            self.tableViewBasicInfo.reloadData()
            
            self.tableViewMoreInfo.reloadData()
            
        }
    }
    
    @IBOutlet weak var editprofileTxt: UIButton!
    @IBAction func editProfileTxtClicked(_ sender: Any) {
        
        if(self.editUserImageBtn.isHidden){
            self.editUserImageBtn.isHidden = false
    //        self.editUserImageBtn.isUserInteractionEnabled = true
            self.editVideoBtn.isHidden = false
            self.editVideoBtn.isUserInteractionEnabled = true
            
            editCLicked = true
            
            self.tableViewBasicInfo.reloadData()
            self.tableViewMoreInfo.reloadData()
        }
        else{
            self.editUserImageBtn.isHidden = true
   //         self.editUserImageBtn.isUserInteractionEnabled = false
            self.editVideoBtn.isHidden = true
            self.editVideoBtn.isUserInteractionEnabled = false
            
            self.editCLicked = false
            
            self.tableViewBasicInfo.reloadData()
            
            self.tableViewMoreInfo.reloadData()
        }
        
    }
    @IBAction func editVIdeoBtnClicked(_ sender: Any) {
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        //        imagePickerController.delegate = self
        imagePickerController.videoMaximumDuration = 5.0
        showImagePicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        
    }
    
    @IBAction func editUserImageClicked(_ sender: Any) {
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        showImagePicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        
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
        
        present(imagePickerController, animated: true, completion: {
            // Done presenting.
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.editCLicked = false
        self.tableViewBasicInfo.reloadData()
        self.tableViewMoreInfo.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserInfo()
        self.tableViewBasicInfo.isHidden = false
        self.tableViewMoreInfo.isHidden = true
        
        // scroller.contentSize = CGSize(width: 359, height: 283)
        self.imagePickerController.modalPresentationStyle = .currentContext
        self.imagePickerController.delegate = self
        //        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        
        self.videoPlayer.prepareVideoPlayer()
        self.videoPlayer.play()
        
        self.editUserImageBtn.isHidden = true
    //    self.editUserImageBtn.isUserInteractionEnabled = false
        self.editVideoBtn.isHidden = true
        self.editVideoBtn.isUserInteractionEnabled = false
        
        self.basicInfoColorView.isHidden = false
        self.moreInfoColorView.isHidden = true
        
        
        //addBtn.isHidden = true
        
        guard let urlOfVideo = Bundle.main.path(forResource: "videoplayback", ofType:"mp4") else {
            debugPrint("videoplayback not found")
            return
        }
        
        
        let videoUrl = NSURL(fileURLWithPath: urlOfVideo) as? NSURL
        //        let player = AVPlayer(url: URL(fileURLWithPath: path))
        
        DispatchQueue.main.async {
            if let tempPath = videoUrl {
                
                self.videoUrl = tempPath.absoluteString!
                self.videoPlayer?.videoUrl = URL(string:tempPath.absoluteString!)
                
                //                self.videoPlayer?.previewImageUrl = URL(string: "https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg")
                
                self.videoPlayer?.previewImageUrl =  Bundle.main.url(forResource: "videoloading", withExtension:"jpg")
                
                
                self.videoPlayer?.shouldAutoplay = false //Automatically play the video when its view is visible on the screen. false by default.
                self.videoPlayer?.shouldAutoRepeat = false //Automatically replay video after playback is complete. false by default.
                self.videoPlayer?.showsCustomControls = true //Use AVPlayer's controls or custom. Now custom control view has only "Play" button. Add additional controls if needed.
                self.videoPlayer?.isMuted = false //Mute the video.
                //            videoPlayer.pla
                self.videoPlayer?.minimumVisibilityValueForStartAutoPlay = 0.9 //Value from 0.0 to 1.0, which sets the minimum percentage of the video player's view visibility on the screen to start playback.
                self.videoPlayer?.shouldSwitchToFullscreen = false //Default value is
                self.videoPlayer?.contentMode = .scaleToFill
                
                self.videoPlayer?.play()
                
            }
        }
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //        self.videoPlayer.prepareVideoPlayer()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject
        
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                
                if stringType == kUTTypeMovie as String {
                    
                    self.videoPlayer?.prepareVideoPlayer()
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    DispatchQueue.main.async {
                        if let tempPath = urlOfVideo {
                            
                            self.videoUrl = tempPath.absoluteString!
                            self.videoPlayer?.videoUrl = URL(string:tempPath.absoluteString!)
                            
                            //                            self.videoPlayer?.previewImageUrl = URL(string: "https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg")
                            
                            self.videoPlayer?.previewImageUrl =  Bundle.main.url(forResource: "videoloading", withExtension:"jpg")
                            
                            
                            self.videoPlayer?.shouldAutoplay = false //Automatically play the video when its view is visible on the screen. false by default.
                            self.videoPlayer?.shouldAutoRepeat = false //Automatically replay video after playback is complete. false by default.
                            self.videoPlayer?.showsCustomControls = true //Use AVPlayer's controls or custom. Now custom control view has only "Play" button. Add additional controls if needed.
                            self.videoPlayer?.isMuted = false //Mute the video.
                            //            videoPlayer.pla
                            self.videoPlayer?.minimumVisibilityValueForStartAutoPlay = 0.9 //Value from 0.0 to 1.0, which sets the minimum percentage of the video player's view visibility on the screen to start playback.
                            self.videoPlayer?.shouldSwitchToFullscreen = false //Default value is
                            //                            self.videoPlayer.gravi
                            self.videoPlayer?.play()
                            
                        }
                    }
                }
                else if stringType == kUTTypeImage as String {
                    
                    let image = info[UIImagePickerControllerOriginalImage]
                    self.userImageView.image = image as! UIImage
                    
                    //                    let urlOfImage = info[UIImagePickerControllerMediaURL] as? NSURL
                    //
                    //                    self.videoPlayer?.previewImageUrl? = urlOfImage as! URL
                    
                    //                    capturedImages.append(image as! UIImage)
                }
            }
        }
        //
        //        if !cameraTimer.isValid {
        //            // Timer is done firing so Finish up until the user stops the timer from taking photos.
        finishAndUpdate()
        //        }
    }
    
    fileprivate func finishAndUpdate() {
        dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.editUserImageBtn.isHidden = true
 //           self.editUserImageBtn.isUserInteractionEnabled = false
            self.editVideoBtn.isHidden = true
            self.editVideoBtn.isUserInteractionEnabled = false
            
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            // Done cancel dismiss of image picker.
            self.editUserImageBtn.isHidden = true
 //           self.editUserImageBtn.isUserInteractionEnabled = false
            self.editVideoBtn.isHidden = true
            self.editVideoBtn.isUserInteractionEnabled = false
        })
    }
    
    //Mark:- Button Actions for Basic info and More info View
    @IBAction func basicInfoBtnTap(_ sender: UIButton) {
        self.tableViewBasicInfo.isHidden = false
        self.tableViewMoreInfo.isHidden = true
        
        self.basicInfoColorView.isHidden = false
        self.moreInfoColorView.isHidden = false
//        self.basicInfoBtn.setTitleColor(UIColor.blue, for: .normal)
        self.basicInfoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.basicInfoColorView.backgroundColor = UIColor.blue
        
        self.moreInfoBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.moreInfoColorView.backgroundColor = UIColor.white
    }
    @IBAction func moreInfoBtnTap(_ sender: UIButton) {
        self.tableViewBasicInfo.isHidden = true
        self.tableViewMoreInfo.isHidden = false
        
        self.basicInfoColorView.isHidden = false
        self.moreInfoColorView.isHidden = false
//        self.moreInfoBtn.setTitleColor(UIColor.blue, for: .normal)
        self.moreInfoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        self.moreInfoColorView.backgroundColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
//        self.moreInfoColorView.backgroundColor = UIColor.blue
        self.basicInfoBtn.setTitleColor(UIColor.lightGray, for: .normal)
        self.basicInfoColorView.backgroundColor = UIColor.white
    }
    
    
    
    func getUserInfo(){
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getAccountDetails(sucessResult: { (responseModel) in
            
            guard let accRespModel = responseModel as? ProfileRespModel else{
                //                    stopLoading()
                return
            }
            
            if(accRespModel.id != 0){
                self.userProfileData = accRespModel
               
                print("bP_firstname ###", arrayBasicInfoDetails )
                print("arrayBasicInfoDetails ###", arrayBasicInfoDetails.count )
                
                if let imageUrl = URL(string: accRespModel.imageUrl) {
                    self.userImageView.sd_setIndicatorStyle(.whiteLarge)
                    self.userImageView.sd_setShowActivityIndicatorView(true)
                    self.userImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                }
                self.userName.text = accRespModel.firstName + " " + accRespModel.lastName
                
                ActivityIndicatorView.hiding()
            }else{
                //                    self.errorLabel.textColor = UIColor.red
                //                self.errorlabel.text = "Something wrong with server !"
                //                self.passwordField.text = ""
                //                    self.passwordField.shake()
                ////                    stopLoading()
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
    
    
}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableViewBasicInfo {
            return 2
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewBasicInfo {
            if section == 0 {
                return self.arrayBasicInfo.count
            }
            else {
                return 1
            }
        }
        else {
            if section == 0 {
                return self.arrayMoreInfo.count
            }
            else if section == 1 {
                return yearCount
            }
            else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewBasicInfo {
            
            if indexPath.section == 0 {
                let cell : ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
                cell.lblLeftTitle.text = arrayBasicInfo[indexPath.row]
                cell.textFieldRight.text = arrayBasicInfoDetails[indexPath.row]
            
//                if arrayMoreInfoDetails.isEmpty {
//
//                }else {
//                    cell.textFieldRight.text = arrayBasicInfoDetails[indexPath.row]
//                }
                if(self.editCLicked){
                    
                    cell.textFieldRight.isUserInteractionEnabled = true
                    cell.textFieldRight.backgroundColor = UIColor.white
                    
                }
                else
                {
                    cell.textFieldRight.isUserInteractionEnabled = false
                    cell.textFieldRight.backgroundColor = UIColor(rgb: 0xEAEAEA)
                    
                }
                return cell
            }
            else {
                let cell : ProfileWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "ProfileWithButtonCell", for: indexPath) as! ProfileWithButtonCell
                
                return cell
            }
        }
        else {
            if indexPath.section == 0 {
                let cell : ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
                cell.lblLeftTitle.text = arrayMoreInfo[indexPath.row]
                cell.textFieldRight.text = arrayMoreInfoDetails[indexPath.row]
//                let userDetails :[String:Any] = AccountRespModel
                
                
//                if arrayMoreInfoDetails.isEmpty {
//
//                }else {
//                    cell.textFieldRight.text = arrayMoreInfoDetails[indexPath.row]
//                }
                
                
                if(self.editCLicked){
                    
                    cell.textFieldRight.isUserInteractionEnabled = true
                    cell.textFieldRight.backgroundColor = UIColor.white
                    // edit code
                }
                else
                {
                    cell.textFieldRight.isUserInteractionEnabled = false
                    cell.textFieldRight.backgroundColor =  UIColor(rgb: 0xEAEAEA)
                    
                }
                
                
                return cell
            }
            else if indexPath.section == 1 {
                let cell : MoreInfoWithAddButtonCell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoWithAddButtonCell", for: indexPath) as! MoreInfoWithAddButtonCell
                
                cell.btnAddYear.addTarget(self, action: #selector(onBtnAddYearTapped), for: .touchUpInside)
                return cell
            }
            else {
                let cell : ProfileWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "ProfileWithButtonCell", for: indexPath) as! ProfileWithButtonCell
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func onBtnAddYearTapped(_ sender : UIButton) {
        yearCount += 1
        self.tableViewMoreInfo.reloadData()
    }
}


//extension UIImageView {
//
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//
//}
extension UITextField {
//    func enableTextFld() {
//        self.isUserInteractionEnabled = true
//        self.backgroundColor = UIColor.white
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.lightGray.cgColor
//    }
//    func disableTextFld() {
//        self.layer.borderWidth = 0
//        self.isUserInteractionEnabled = false
//        
//    }
//    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


