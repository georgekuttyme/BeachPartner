//
//  BPCardsVC.swift
//  BeachPartner
//
//  Created by Beach Partner LLCon 02/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//
import Koloda
import SDWebImage
import UIKit
import AlamofireImage
import FSCalendar


protocol BPCardsVCDelegate {
    
    func resumeSwipeGame()
}

private var numberOfCards: Int = 5
class BPCardsVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var btnHifi: UIButton!
    @IBOutlet weak var profileBoostButton: UIButton!
    @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var topthreefinishesBtn: UIButton!
    @IBOutlet weak var topstackview: UIStackView!
    @IBOutlet weak var topThreeBtn: UIButton!
    @IBOutlet weak var topTwoBtn: UIButton!
    @IBOutlet weak var toponeBtn: UIButton!
    @IBOutlet weak var blueBpListHeight: NSLayoutConstraint!
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnLoc: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNotAvailable: UILabel!
    @IBOutlet weak var btnPlaybtn: UIButton!
    @IBOutlet weak var lblSwipeGameMsg: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var topfinishesHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNotAviltopSpace: NSLayoutConstraint!
    @IBOutlet weak var mainStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var topFinishesStackView: UIStackView!
    var userData = AccountRespModel()
    let videoView = UIVideoView()
    var didPressDownArrow :Bool!
    var isFirstBlueBpCard :Bool!
    var selectedIndex:Int!
    var curentCardIndex:Int!
    var selectedType:String!
    var searchCardSatus:String!
    var topFinishers:String!
    var connectedUsers = [ConnectedUserModel]()
 //   var subscribedUsers = [SubscriptionUserModel]()
   var subscribedBlueBpUsers = [SubscriptionUserModel]()
    var swipeAction = [ConnectedUserModel]()
    var likedPersonInfo = [ConnectedUserModel]()
    var searchUsers = [SearchUserModel]()
    var SwipeCardArray:[Any] = []
    var currentIndex : Int = 0
    var eventDateArray = [String]()
    var eventNameToList = [GetAllUserEventsRespModel]()
    var eventListToShow = [GetAllUserEventsRespModel]()
    var delegate: BPCardsVCDelegate?
    var eventNames = String()
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    @IBAction func didTapProfileBoostButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddonsViewController") as! AddonsViewController
        vc.profileBoostmode = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func topfinishesClicked(_ sender: Any) {
     
        if SwipeCardArray.count > 0 {
            print(topFinishers)
//            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//
//
//            })
            if(self.topFinishers != ""){
                var toplist = self.topFinishers.components(separatedBy: ",")
                
                toplist = toplist.filter { $0 != "" }
                
                if toplist.count == 0 {
                    self.toponeBtn.isHidden = false
                    self.toponeBtn.setTitle("No notable finishes", for: UIControlState.normal)
//                    self.topfinishesHeight = 
                    self.badgeImage.isHidden = true
                    self.topthreefinishesBtn.isHidden = true
                    self.topfinishesHeight.constant = 40
                }
                else
                {
                    self.topfinishesHeight.constant = CGFloat(toplist.count * 40)
                }
                
                if(toplist.count == 3){
                    let firstFinish = toplist[2]
                    if firstFinish == " " || firstFinish == "," || firstFinish == "" {
                        self.topThreeBtn.isHidden = true
                    }
                    else{
                        self.topThreeBtn.isHidden = false
                        self.topThreeBtn.setTitle(firstFinish, for: UIControlState.normal)
                    }
                    
                    toplist.removeLast()
                }
                if(toplist.count == 2){
                    
                    let firstFinish = toplist[1]
                    if firstFinish == " " || firstFinish == "," || firstFinish == "" {
                        self.topTwoBtn.isHidden = true
                    }
                    else{
                        self.topTwoBtn.isHidden = false
                        self.topTwoBtn.setTitle(firstFinish, for: UIControlState.normal)
                    }
                    toplist.removeLast()
                }
                if(toplist.count == 1){
                    
                    let firstFinish = toplist[0]
                    if firstFinish == " " || firstFinish == ","  || firstFinish == "" {
                        self.toponeBtn.isHidden = true
                        self.badgeImage.isHidden = false
                        self.topthreefinishesBtn.isHidden = false
                    }
                    else{
                        self.toponeBtn.isHidden = false
                        self.toponeBtn.setTitle(firstFinish, for: UIControlState.normal)
                        self.badgeImage.isHidden = true
                        self.topthreefinishesBtn.isHidden = true
                    }
                    toplist.removeLast()
                }
            }
            else {
                self.toponeBtn.isHidden = false
                self.toponeBtn.setTitle("No notable finishes", for: UIControlState.normal)
                self.badgeImage.isHidden = true
                self.topthreefinishesBtn.isHidden = true
                 self.topfinishesHeight.constant = 40
            }
            
        }
    }
    
    @IBAction func topfinishesCollapseClicked(_ sender: Any) {
       resetTopFinishView()
        self.topfinishesHeight.constant = 75
    }
    
    private func resetTopFinishView() {
//        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
//        })
        self.topThreeBtn.isHidden = true
        self.topTwoBtn.isHidden = true
        self.toponeBtn.isHidden = true
        self.badgeImage.isHidden = false
        self.topthreefinishesBtn.isHidden = false
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == self.topUserListCollectionView {
            return subscribedBlueBpUsers.count
        }
        return 0;
    }
    
    
    private func revertCardAction() {
        self.btnUndo.isEnabled = false
        self.btnUndo.setImage(UIImage(named:"grayback"), for: UIControlState.normal)
        self.imgProfile.isHidden = true
        self.lblNotAvailable.isHidden = true
        self.btnPlaybtn.isHidden = true
        self.lblSwipeGameMsg.isHidden = true
        self.cardView.revertAction()
    }
    
    @IBAction func undoBtnCLicked(_ sender: Any) {
        
        if Subscription.current.supportForFunctionality(featureId: BenefitType.UndoSwipe) == false {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
            vc.benefitCode = BenefitType.UndoSwipe
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        print(self.currentIndex)
        if let view:CardView = (self.cardView.viewForCard(at: self.currentIndex) as? CardView) {
            view.pauseVideo()
        }

        revertCardAction()
        
        let firstElement = self.swipeAction.first
        guard let undoId = firstElement?.id else {
            return
        }
            APIManager.callServer.undoSwipeAction(userId:"\(undoId)",sucessResult: { (responseModel) in
                
                guard let connectedUserModelValue = responseModel as? ConnectedUserModel else{
                    return
                }
                print(connectedUserModelValue)
                
            }, errorResult: { (error) in
                
            })
      
        
         print(self.swipeAction)
        
    }
    @IBAction func btnLocClicked(_ sender: Any) {
        UserDefaults.standard.set("1", forKey: "LocationSettings")
        let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
        controller.SettingsType = "location"
        let navController = UINavigationController(rootViewController: controller)
//        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController!.navigationBar.topItem!.title = ""
        self.present(navController, animated: true, completion: nil)
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func HiFiBtnClicked(_ sender: Any) {
        self.cardView.swipe(.up)
    }
    
    @IBAction func btnPlaySwipeGame(_ sender: Any) {
        //        self.view .removeFromSuperview()
        delegate?.resumeSwipeGame()
        self.tabBarController?.selectedIndex = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
        
        if collectionView == self.topUserListCollectionView {
            let blueBpData = subscribedBlueBpUsers[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
            let image = blueBpData.connectedUser?.imageUrl
            if image == ""{
                cell.imageView.image = UIImage(named: "user")
            }else{
                if let imageUrl = URL(string: (blueBpData.connectedUser?.imageUrl)!) {
                    cell.imageView.sd_setIndicatorStyle(.whiteLarge)
                    cell.imageView.sd_setShowActivityIndicatorView(true)
                    cell.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                }
            }
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
            cell.imageView.layer.borderWidth = 1
            
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == self.topUserListCollectionView {
            self.selectedIndex = indexPath.row
            self.selectedType = "BlueBp-New"
            self.btnPlaybtn.isHidden = true
            self.lblSwipeGameMsg.isHidden = true
            self.generateSwipeAarray()
            self.btnUndo.isEnabled = false
            self.btnUndo.setImage(UIImage(named:"grayback"), for: UIControlState.normal)
           // self.cardView.reloadData()  //uncomment
        }
 }
    
    var array: [UIImage] = []
    
    //    @IBOutlet weak var menuView: CVCalendarMenuView!
    //    @IBOutlet weak var calendarView: CVCalendarView!
    //
    @IBOutlet weak var topUserListCollectionView: UICollectionView!
    @IBOutlet weak var bpscrollview: UIScrollView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = "Beach Partner"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView.gravityMode = .resizeAspectFill
        videoView._player?.isMuted=true
        videoView._player?.volume = 0
        
        self.topFinishesStackView.isHidden = true
        
        self.badgeImage.isHidden = false
        self.topthreefinishesBtn.isHidden = false
        self.btnUndo.isEnabled = false
        self.topThreeBtn.isHidden = true
        self.topTwoBtn.isHidden = true
        self.toponeBtn.isHidden = true
        self.topfinishesHeight.constant = 75
        self.didPressDownArrow = false
        isFirstBlueBpCard = false
        self.bpscrollview.isScrollEnabled=false
        userImg.image = UIImage(named: "likes")!
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
        self.userImg.clipsToBounds = true
        self.userImg.layer.borderColor = UIColor.lightGray.cgColor
        self.userImg.layer.borderWidth = 1
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.cardView.dataSource = self
        self.cardView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOn(_:)))
        tap.numberOfTapsRequired = 2
        cardView.addGestureRecognizer(tap)
        self.getUsersListforBlueBp()
        self.getUserInfo()
        self.generateSwipeAarray()
        
        if self.selectedType == "BlueBp" && Subscription.current.statusOfAddOn(addOnId: AddOnType.ProfileBoost) == false {
            profileBoostButton.isHidden = false
        }
        else {
            profileBoostButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendMsg(notification:)), name:NSNotification.Name(rawValue: "send-Message"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(findTournament(notification:)), name:NSNotification.Name(rawValue: "find-Tournament"), object: nil)

    }
    @objc func findTournament(notification: NSNotification){
        self.tabBarController?.selectedIndex = 3
    }

    @objc func sendMsg(notification: NSNotification){
        print("\n\n\n ???????",self.likedPersonInfo)
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        chatController.connectedUserModel = self.likedPersonInfo
        chatController.connectedUserModel = self.swipeAction
        chatController.chatType = "Connections"
        let navigationController = UINavigationController(rootViewController: chatController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(selectedType)
        if selectedType == "BlueBp"{
            mainStackViewTopConstraint.constant = 64
            scrlViewHeight.constant = UIScreen.main.bounds.size.height - 150
             self.cardView.reloadData()
        }
        else {
            mainStackViewTopConstraint.constant = 0
            scrlViewHeight.constant = UIScreen.main.bounds.size.height - 110
            if selectedType == "Search" || selectedType == "invitePartner"{
                scrlViewHeight.constant = UIScreen.main.bounds.size.height - 150
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenSize = UIScreen.main.bounds.size;
            if screenSize.height == 812.0{
                cardHeight.constant = -220
                if selectedType == "BlueBp"{
                    cardHeight.constant = -200
                    mainStackViewTopConstraint.constant = 84
                }
                else  if selectedType == "Search" || selectedType == "invitePartner"{
                    mainStackViewTopConstraint.constant = 0
                }
                else if selectedType == "Likes"{
                    cardHeight.constant = -190
                    mainStackViewTopConstraint.constant = 20
                }
                else if selectedType == "Hifi" {
                    cardHeight.constant = -190
                    mainStackViewTopConstraint.constant = 20
                }
                else {
                    mainStackViewTopConstraint.constant = 20
                }
            }
        }
    }
    
    func generateSwipeAarray() {
        
       
        var userType : String = ""
        if selectedType == "Likes" {
            SwipeCardArray = self.connectedUsers
            searchCardSatus = selectedType
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
//                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
            let  data : ConnectedUserModel
            data = SwipeCardArray[0] as! ConnectedUserModel
            userType = (data.connectedUser?.userType) ?? ""
        }
        else if selectedType == "Search" || selectedType == "invitePartner" {
            SwipeCardArray = self.searchUsers
            print(SwipeCardArray)
            searchCardSatus = selectedType
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
//                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }else{
                let  data : SearchUserModel
                data = SwipeCardArray[0] as! SearchUserModel
                userType = data.userType ?? ""
            }
        }
        else if selectedType == "Hifi"{
            SwipeCardArray.insert(self.connectedUsers[selectedIndex], at: 0)
            self.connectedUsers .remove(at: selectedIndex)
            for var i in (0..<self.connectedUsers.count)
            {
                SwipeCardArray.append(self.connectedUsers[i])
            }
             searchCardSatus = selectedType
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
//                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }else{
                let  data : ConnectedUserModel
                data = SwipeCardArray[0] as! ConnectedUserModel
                userType = (data.connectedUser?.userType) ?? ""
                
            }
           
        }
        else if selectedType == "BlueBp"{
            SwipeCardArray.insert(self.subscribedBlueBpUsers[selectedIndex], at: 0)
            self.subscribedBlueBpUsers .remove(at: selectedIndex)
//            self.getUsersSwipeCard()
             searchCardSatus = selectedType
            self.cardView.reloadData()
            if self.SwipeCardArray.count == 0{
//                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }else{
                let  data : SubscriptionUserModel
                data = SwipeCardArray[0] as! SubscriptionUserModel
                userType = (data.connectedUser?.userType) ?? ""
                
            }
           
        }
       else if selectedType == "BlueBp-New"{
            
            if self.SwipeCardArray.count > 0 {
                if searchCardSatus == "Search"{
                    searchCardSatus = "search-remain"
                }
            }
           self.SwipeCardArray.removeAll()
            self.SwipeCardArray.insert(self.subscribedBlueBpUsers[selectedIndex], at: 0)
            self.cardView.reloadData()
            if SwipeCardArray.count == 0{
//                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }else{
                let  data : SubscriptionUserModel
                data = SwipeCardArray[0] as! SubscriptionUserModel
                userType = (data.connectedUser?.userType) ?? ""
            }
            isFirstBlueBpCard = true
            self.cardView.dataSource = self
            self.cardView.delegate = self
            self.cardView.resetCurrentCardIndex()
           
        }
        resetTopFinishView()
        if didPressDownArrow == true {
            moveCardView(userType: userType)
        }
        
    }
    
    private func moveCardView(userType: String) {
        UIView.animate(withDuration: 0.3, animations: {
            
            // 200 or any value you like.
            if !self.didPressDownArrow {
                if userType == "Coach"
                {
                    print("abckjkllkhl")
                    self.topFinishesStackView.isHidden = true
                    self.topthreefinishesBtn.isHidden = true
                    self.topfinishesHeight.constant = 0
                    
                }
                self.didPressDownArrow = true
                self.btnUndo.isHidden = true
                self.btnLoc.isHidden = true
                self.btnHifi.isHidden = true
                self.imageBackground.isHidden = true
//                self.topFinishesStackView.isHidden = false
//                self.topFinishesStackView.isHidden = false
//                self.topthreefinishesBtn.isHidden = false
//                self.topfinishesHeight.constant = 40
                var point = CGPoint()
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let screenSize = UIScreen.main.bounds.size;
                    if screenSize.height == 568.0{
                        point = CGPoint(x: 0, y: 200)
                    }else{
                        point = CGPoint(x: 0, y: 300)
                    }
                }
                // 200 or any value you like.
                if(self.bpscrollview.contentOffset.y < point.y){
                    
                    self.bpscrollview.contentOffset = point
                }
                else{
                    let point = CGPoint(x: 0, y: self.bpscrollview.contentOffset.y)
                    self.bpscrollview.contentOffset = point
                }
                self.bpscrollview.isScrollEnabled=true
            }
            else{
                self.didPressDownArrow = false
                self.didPressDownArrow = false
                self.btnUndo.isHidden = false
                self.btnLoc.isHidden = false
                self.btnHifi.isHidden = false
                self.imageBackground.isHidden = false
                self.topFinishesStackView.isHidden = true
                let point = CGPoint(x: 0, y: 0)
                self.bpscrollview.contentOffset = point
                self.bpscrollview.isScrollEnabled=false
                self.calendar.isHidden = true
            }
            
            if let view:CardView = self.cardView.viewForCard(at: 0) as? CardView {
                
                self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
            }
            
            
//            let range: CountableRange<Int> = self.curentCardIndex..<self.curentCardIndex+1
//            self.cardView.reloadCardsInIndexRange(range)
//            self.cardView.reloadData()
            
        },completion: { (comlete) in
            if self.didPressDownArrow {
                if userType == "Coach"
                {
                    print("abckjkllkhl")
                    self.topFinishesStackView.isHidden = true
                    self.topthreefinishesBtn.isHidden = true
                    self.topfinishesHeight.constant = 0
                    
                }else{
                    self.topFinishesStackView.isHidden = false
                    self.topthreefinishesBtn.isHidden = false
                    self.topfinishesHeight.constant = 75
                }

                self.calendar.isHidden = false
            }
            })
        }
    
    
    @objc func moveDownScroll(sender:UIButton) {
        print("khghghgh")
        let index = sender.tag
        var usertypeAtIndexCard = String()
        if selectedType == "Search"  || selectedType == "invitePartner" {
            //||
            let  data : SearchUserModel
            data = SwipeCardArray[index] as! SearchUserModel
            usertypeAtIndexCard = data.userType
        }
        else if selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            let data : SubscriptionUserModel
            data = SwipeCardArray[index] as! SubscriptionUserModel
            usertypeAtIndexCard = (data.connectedUser?.userType) ?? ""
        }
        else{
            let  data : ConnectedUserModel
            data = SwipeCardArray[index] as! ConnectedUserModel
            usertypeAtIndexCard = (data.connectedUser?.userType) ?? ""
        }
       moveCardView(userType: usertypeAtIndexCard)
    }
 
    @objc func flagBtnClick(sender:UIButton) {
        let index = sender.tag
        var flagUserId :Int = 0
        var titleString :NSString = ""

        if selectedType == "Search"  || selectedType == "invitePartner" {
            //||
            let  data : SearchUserModel
            data = SwipeCardArray[index] as! SearchUserModel
            flagUserId = data.id
            titleString = "Are you sure you want to Flag \(data.firstName + " " + data.lastName)?" as NSString
        }
        else if selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            let data : SubscriptionUserModel
            data = SwipeCardArray[index] as! SubscriptionUserModel
            flagUserId = data.connectedUser?.id ?? 0
            titleString = "Are you sure you want to Flag \((data.connectedUser?.firstName)! + " " + (data.connectedUser?.lastName)!)?" as NSString
        }
        else{
            let  data : ConnectedUserModel
            data = SwipeCardArray[index] as! ConnectedUserModel
            flagUserId = data.connectedUser?.userId ?? 0
            titleString = "Are you sure you want to Flag \((data.connectedUser?.firstName)! + " " + (data.connectedUser?.lastName)!)?" as NSString
        }
        let flagReason = "Inappropriate Image"
        let range = (titleString).range(of: "Flag")
        let attribute = NSMutableAttributedString.init(string: titleString as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor as NSAttributedStringKey, value: UIColor.red, range:range)
        let alertController = UIAlertController(title: titleString as String, message: "The profile of flagged users will be reviewed by Beach Partner admin team for any violations of terms and conditions with respect to profile photo or video. If violations found, flagged accounts will be deactivated. Please be judicious and genuine while flagging other users. Bogus or negligent flagging may result in your account being deactivated." , preferredStyle: UIAlertControllerStyle.alert)
       alertController.setValue(attribute, forKey: "attributedTitle")
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.flagingUser(flagId: flagUserId, flagReason: flagReason)
           print("YES Clicked")
            
        }
        alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func flagingUser(flagId:Int,flagReason:String){
        APIManager.callServer.flagInappropriateUser(flagId: flagId, flagReason: flagReason, sucessResult: { (response) in
            
            guard let flagRespModel = response as? FlagRespModel else{
                return
            }

            print("===",flagRespModel)
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
       
    }
    func getEnPointForSearch() -> String {
        var enPoint = String()
        let includeCoaches = UserDefaults.standard.string(forKey: "includeCoaches")
        if (includeCoaches != nil){
            if includeCoaches == "1" {
               enPoint = "includeCoach=true"
            }
            else {
                enPoint = "includeCoach=false"
            }
        }
        let minValue = UserDefaults.standard.string(forKey: "minAge")
        let maxValue = UserDefaults.standard.string(forKey: "maxAge")
        if (minValue != nil)  && (maxValue != nil)   {
            enPoint = enPoint+"&minAge="+"\(minValue ?? "")"+"&maxAge="+"\(maxValue ?? "")"
        }
        let gender = UserDefaults.standard.string(forKey: "gender")
        if (gender != nil){
            if gender == "Both"{
                 enPoint = enPoint+"&gender="
        }
        else{
               enPoint = enPoint+"&gender="+"\(gender ?? "")"
            }
        }
        let location = UserDefaults.standard.string(forKey: "locationInitial")
        if (location != nil){
            enPoint = enPoint+"&location="+"\(location ?? "")"
        }
        enPoint = enPoint.replacingOccurrences(of: " ", with: "%20")
        if enPoint.count == 0  {
           enPoint = "includeCoach=true&gender="
        }
        enPoint = enPoint+"&hideConnectedUser=true&hideLikedUser=true&hideRejectedConnections=true&hideBlockedUsers=true"

        return enPoint
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
                let image = accRespModel.imageUrl
                if image == ""{
                    self.imgProfile.image = UIImage(named: "user")
                }else{
                    if let imageUrl = URL(string: accRespModel.imageUrl) {
                        self.imgProfile.sd_setIndicatorStyle(.whiteLarge)
                        self.imgProfile.sd_setShowActivityIndicatorView(true)
                        self.imgProfile.sd_setImage(with: imageUrl, placeholderImage:  #imageLiteral(resourceName: "user"))
                    }
                }
            }else{
                
            }
            ActivityIndicatorView.hiding()
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
        
    }
    
    func getUsersListforBlueBp()  {
        APIManager.callServer.getUserSubscriptionList(sucessResult: { (responseModel) in
            guard let subscriptionUserModelArray = responseModel as? SubscriptionUserModelArray else{
                return
            }
            self.subscribedBlueBpUsers = subscriptionUserModelArray.subscriptionUserModel
            self.topUserListCollectionView.reloadData()
            
            if self.subscribedBlueBpUsers.count == 0 && self.selectedType == "Search" {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let screenSize = UIScreen.main.bounds.size;
                    if screenSize.height == 812.0{
                        self.blueBpListHeight.constant = 40
                        self.scrlViewHeight.constant = UIScreen.main.bounds.size.height - 110
                    }
                }else{
                    self.blueBpListHeight.constant = 61
                    self.scrlViewHeight.constant = UIScreen.main.bounds.size.height - 110
                }
            }
            else{
                self.blueBpListHeight.constant = 61
                if UIDevice.current.userInterfaceIdiom == .phone {
                    let screenSize = UIScreen.main.bounds.size;
                    if screenSize.height == 812.0{
                        self.cardHeight.constant = -220
                        if self.selectedType == "BlueBp"{
                            self.cardHeight.constant = -200
                            self.mainStackViewTopConstraint.constant = 84
                        }
                        else if self.selectedType == "Likes"{
                            self.cardHeight.constant = -190
                            self.mainStackViewTopConstraint.constant = 20
                        }
                        else if self.selectedType == "Hifi" {
                            self.cardHeight.constant = -190
                            self.mainStackViewTopConstraint.constant = 20
                        }
                        else {
                            self.mainStackViewTopConstraint.constant = 20
                        }
                    }
                }
                if self.selectedType == "invitePartner" {
                    self.cardHeight.constant = -180
                }
            }
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
        
    }
    
    
/*    func getUsersSwipeCard()  {
        
        let endPoint = self.getEnPointForSearch()
        APIManager.callServer.getSearchList(endpoint:endPoint ,sucessResult: { (responseModel) in
            guard let searchUserModelArray = responseModel as? SearchUserModelArray else{
                
                return
            }
            
            self.searchUsers = searchUserModelArray.searchUserModel
            for var i in (0..<self.searchUsers.count)
            {
                self.SwipeCardArray.append(self.searchUsers[i])
            }
           self.cardView.reloadData()
            if self.SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
       
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
*/
    
    func didSwipeToUp(user_Id:String, fcmId: String) {
        
        APIManager.callServer.requestHiFi(userId:user_Id,sucessResult: { (responseModel) in
            
            guard let connectedUserModelValue = responseModel as? ConnectedUserModel else{
                return
            }
            print(connectedUserModelValue)
            self.swipeAction = [connectedUserModelValue]
            print(self.swipeAction)
            if self.selectedType == "BlueBp"{
                 self.getUsersListforBlueBp()
            }
            if (self.swipeAction[0].status == "Active") {
                self.likedPersonInfo = [connectedUserModelValue]
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MutualLikesViewController") as! MutualLikesViewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
            self.btnUndo.isEnabled = true
        
        }, errorResult: { (error, code) in
          
            if let message = error {
                let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let okbutton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    if let code = code, code == "QuotaExpired" {
                        
                        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
                        vc.benefitCode = BenefitType.SwipeAction
                        self.tabBarController?.present(vc, animated: true, completion: nil)
                        return
                    }
                })
                alertView.addAction(okbutton)
                self.present(alertView, animated: true, completion: nil)
            }
            self.revertCardAction()
        })
    }
    func didSwipeToRight(user_Id:String){
        APIManager.callServer.requestFriendship(userId:user_Id,sucessResult: { (responseModel) in
            guard let connectedUserModelValue = responseModel as? ConnectedUserModel else{
                return
            }
            print(connectedUserModelValue)
            self.swipeAction = [connectedUserModelValue]
            if self.selectedType == "BlueBp"{
                self.getUsersListforBlueBp()
            }
            
            if (self.swipeAction[0].status == "Active") {
                self.likedPersonInfo = [connectedUserModelValue]
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MutualLikesViewController") as! MutualLikesViewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
            self.btnUndo.isEnabled = true
            
        }, errorResult: { (error, code) in
            
            if let message = error {
                let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let okbutton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    if let code = code, code == "QuotaExpired" {
                        
                        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
                        vc.benefitCode = BenefitType.SwipeAction
                        self.tabBarController?.present(vc, animated: true, completion: nil)
                        return
                    }
                })
                alertView.addAction(okbutton)
                self.present(alertView, animated: true, completion: nil)
            }
            self.revertCardAction()
        })
    }
    func didSwipeToLeft(user_Id:String){
        APIManager.callServer.rejectFriendship(userId:user_Id,sucessResult: { (responseModel) in
            guard let connectedUserModelValue = responseModel as? ConnectedUserModel else{
                return
            }
            print(connectedUserModelValue)
            self.swipeAction = [connectedUserModelValue]
            print(self.swipeAction)
            if self.selectedType == "BlueBp"{
                self.getUsersListforBlueBp()
            }
            
            self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
            self.btnUndo.isEnabled = true
        }, errorResult: { (error, code) in
            
            if let message = error {
                let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let okbutton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    if let code = code, code == "QuotaExpired" {
                        
                        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
                        vc.benefitCode = BenefitType.SwipeAction
                        self.tabBarController?.present(vc, animated: true, completion: nil)
                        return
                    }
                })
                alertView.addAction(okbutton)
                self.present(alertView, animated: true, completion: nil)
            }
            self.revertCardAction()
        })
    }

    
 // MARK: UserEventsDetails
    
    private func getAllUserEvents(userId:String) {
        APIManager.callServer.getAllUserEvents(userId:userId ,sucessResult: { (responseModel) in
            
            guard let eventsArrayModel = responseModel as? GetAllUserEventsRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.eventNameToList = eventsArrayModel.getAllUserEventsRespModel
            print("",self.eventNameToList,"*......*********")
            self.eventDateArray.removeAll()
            for event in eventsArrayModel.getAllUserEventsRespModel{
                
                let startDate = Date(timeIntervalSince1970: TimeInterval((event.event?.eventStartDate)!/1000))
                let endDate = Date(timeIntervalSince1970: TimeInterval((event.event?.eventEndDate)!/1000))
                print(startDate)
                print(endDate)
                let dates = self.generateDateArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
                self.eventDateArray.append(contentsOf: dates)
                var eventObject = event
                eventObject.event?.activeDates = dates
                self.eventNameToList.append(eventObject)
            }
            self.calendar.reloadData()
            
        }) { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }

    // MARK:- FSCalendar Data source & Delegates
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        let selectedDate = formatter.string(from: date)
        let count = eventDateArray.filter { $0 == selectedDate}.count
        
        if count > 0 { return "\(count)" }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.eventNames.removeAll()
        print("---***----",self.eventNameToList,"\n\n\n\n\n")
        self.eventListToShow = eventNameToList.filter { (event) -> Bool in
            print(event.event?.activeDates ?? "")
            let selectedDate = formatter.string(from: date)
            return Bool((event.event?.activeDates.contains(selectedDate))!)
        }
        
        print("-----",eventListToShow,"-----")
        let limit = self.eventListToShow.count
        for index1 in 0..<limit {
            if let names = self.eventListToShow[index1].event?.eventName{
                self.eventNames.append(names + "\n\n")
            }
        }
        print(self.eventNames)
        if self.eventNames.count > 0 {
            self.eventNames.removeLast()
            self.eventNames.removeLast()
        }
        if eventListToShow.count > 0 {
            let alert = UIAlertController(title: "Events", message: self.eventNames, preferredStyle: .alert)
            let actionButton = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alert.addAction(actionButton)
            present(alert, animated: true, completion: nil)
        }else {
            
        }
        
    }
    // MARK:- Helper Methods
    func generateDateArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[String] {
        
        var datesArray: [String] =  [String]()
        var startDate = startDate
        let calendar = Calendar.current
        
        while startDate <= endDate {
            datesArray.append(formatter.string(from: startDate))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return datesArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: KolodaViewDataSource
extension BPCardsVC :KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
        if selectedType == "Search"  || selectedType == "invitePartner" {
            var data : SearchUserModel
            data = SwipeCardArray[index] as! SearchUserModel
        if let view:CardView = koloda.viewForCard(at: index) as? CardView {
                if let videoUrl = URL(string: data.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
        }
            topFinishers = data.userMoreProfileDetails?.topFinishes ?? ""
            getAllUserEvents(userId: String(data.id))
      }
    else if selectedType == "BlueBp" || selectedType == "BlueBp-New"
        {
            var data : SubscriptionUserModel
            data = SwipeCardArray[index] as! SubscriptionUserModel
            if let view:CardView = koloda.viewForCard(at: index) as? CardView {
                if let videoUrl = URL(string: (data.connectedUser?.videoUrl)!) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
                self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
            }
            topFinishers = data.connectedUser?.userMoreDetails?.topFinishes ?? ""
            getAllUserEvents(userId:String(data.connectedUser?.id ?? 0))
        }
        else{
            var data : ConnectedUserModel
            data = SwipeCardArray[index] as! ConnectedUserModel
            if let view:CardView = koloda.viewForCard(at: index) as? CardView {
                if let videoUrl = URL(string: data.connectedUser!.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
                self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
            }
             topFinishers = data.connectedUser?.userMoreProfileDetails?.topFinishes ?? ""
            getAllUserEvents(userId:String(data.connectedUser?.userId ?? 0))
        }
        curentCardIndex = index
        self.imgProfile.isHidden = true
        self.lblNotAvailable.isHidden = true
        if selectedType == "Likes" || selectedType == "Hifi" {
            if selectedType == "Likes"{
               self.lblNotAvailable.text = "No Like cards available"
            }
            else{
                 self.lblNotAvailable.text = "No Hifi cards available"
            }
        }else{
          self.lblNotAvailable.text = "No cards available"
        }
        self.lblNotAvailable.textColor = UIColor.gray
        self.lblNotAviltopSpace.constant = 0
    }
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        
        if finishPercentage > 96.0 {
            self.videoView.pause()
        } else {
            
            if !videoView.isHidden{
                self.videoView.play()
            }
        }
       
       self.lblNotAvailable.alpha = (100 - finishPercentage)/100
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection)
    {
        var idString:String
        var fcmId:String
        if selectedType == "Search" || selectedType == "invitePartner"{
            //|| selectedType == "BlueBp"
            var data : SearchUserModel
            data = SwipeCardArray[index] as! SearchUserModel
            idString = String(data.id)
            fcmId = data.fcmToken
        }
        else if selectedType == "BlueBp" || selectedType == "BlueBp-New"
        {
            var data : SubscriptionUserModel
            data = SwipeCardArray[index] as! SubscriptionUserModel
            idString = String(data.connectedUser?.id ?? 0)
            fcmId = data.connectedUser?.fcmToken ?? ""
        }
        else {
            var data : ConnectedUserModel
            data = SwipeCardArray[index] as! ConnectedUserModel
            idString = String(data.connectedUser?.userId ?? 0)
            fcmId = data.connectedUser?.fcmToken ?? ""
        }
        if direction == .up{
        self.didSwipeToUp(user_Id: idString, fcmId: fcmId)
        }
        else if direction == .right {
            self.didSwipeToRight(user_Id:idString)
        }
        else if direction == .left {
          self.didSwipeToLeft(user_Id:idString)
        }
        
        if isFirstBlueBpCard {
            isFirstBlueBpCard = false;
            self.subscribedBlueBpUsers.remove(at:selectedIndex)
//             self.selectedType = "Search"
            self.topUserListCollectionView.reloadData()
            if self.subscribedBlueBpUsers.count == 0  {
                self.blueBpListHeight.constant = 61
            }
            else{
                self.blueBpListHeight.constant = 61
            }
        }
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.currentIndex = index
        
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        self.imgProfile.isHidden = false
        self.lblNotAvailable.isHidden = false
         self.lblNotAvailable.alpha = 1.0
        self.btnPlaybtn.isHidden = false
        self.lblSwipeGameMsg.isHidden = false
        self.lblSwipeGameMsg.text = "Start Swiping For Partners"
        if searchCardSatus == "search-remain" {
           self.lblSwipeGameMsg.text = "Resume Swiping For Partners"
        }

        if selectedType == "BlueBp" {
           self.lblNotAvailable.isHidden = true
        }
    }
    
}
extension BPCardsVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return SwipeCardArray.count
    }
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool{
        return false
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let view = CardView.instantiateFromNib()
        if selectedType == "Search" || selectedType == "invitePartner"{
            var data : SearchUserModel
            data = SwipeCardArray[index] as! SearchUserModel
            if index == 0{
                if let videoUrl = URL(string: data.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            }
            if data.status == "Flagged"{
                view.flagBtn.isEnabled = false
                view.flagBtn.isHidden = true
                //view.flagBtn.setImage(UIImage(named:"grayback"), for: .normal)
            }
            view.flagBtn.tag = index
            view.flagBtn.addTarget(self, action: #selector(flagBtnClick(sender:)), for: UIControlEvents.touchUpInside)
            view.moveDown.addTarget(self, action:#selector(moveDownScroll(sender:)), for: UIControlEvents.touchUpInside)
            view.displaySearchDetailsOnCard(displayData: data)
            
        }
        else if selectedType == "BlueBp" || selectedType == "BlueBp-New"
        {
            var data :SubscriptionUserModel
            if  selectedType == "BlueBp-New"{
                data = SwipeCardArray[0] as! SubscriptionUserModel
            }
            else{
                data = SwipeCardArray[index] as! SubscriptionUserModel
            }
            
            if index == 0 {
                if let videoUrl = URL(string: (data.connectedUser?.videoUrl)!) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            }
            if data.connectedUser?.userStatus == "Flagged"{
                view.flagBtn.isEnabled = false
                view.flagBtn.isHidden = true
                //view.flagBtn.setImage(UIImage(named:"grayback"), for: .normal)
            }
            
            view.flagBtn.addTarget(self, action: #selector(flagBtnClick(sender:)), for: UIControlEvents.touchUpInside)
            view.moveDown.addTarget(self, action:#selector(moveDownScroll(sender:)), for: UIControlEvents.touchUpInside)
            view.displaySubscribeDataOnCard(displayData: data)
            
        }
        else{
            var data : ConnectedUserModel
            data = SwipeCardArray[index] as! ConnectedUserModel
            
            if index == 0 {
                if let videoUrl = URL(string: data.connectedUser!.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            }
            if data.connectedUser?.userStatus == "Flagged"{
                view.flagBtn.isEnabled = false
                view.flagBtn.isHidden = true
            }
            view.flagBtn.addTarget(self, action: #selector(flagBtnClick(sender:)), for: UIControlEvents.touchUpInside)
            
            view.moveDown.addTarget(self, action:#selector(moveDownScroll(sender:)), for: UIControlEvents.touchUpInside)
            view.displayDataOnCard(displayData: data.connectedUser!)
        }
       
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let overlay = CardOverlayView.instantiateFromNib()
        
        return overlay
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
extension BPCardsVC: UIGestureRecognizerDelegate {

   @objc func tappedOn(_ sender : UITapGestureRecognizer) {
    print("tapped")
    if let view:CardView = self.cardView.viewForCard(at: self.currentIndex) as? CardView {
        
        var videoString:String
        if selectedType == "Search" || selectedType == "invitePartner"{
            //|| selectedType == "BlueBp"
            let  data = SwipeCardArray[self.currentIndex] as! SearchUserModel
            videoString = data.videoUrl
        }
        else if selectedType == "BlueBp"  || selectedType == "BlueBp-New" {
            let  data = SwipeCardArray[self.currentIndex] as! SubscriptionUserModel
            videoString = data.connectedUser?.videoUrl ?? ""
        }
        else {
            let  data = SwipeCardArray[self.currentIndex] as! ConnectedUserModel
            videoString = data.connectedUser?.videoUrl ?? ""
        }
        
        if videoString != "" {
            view.showVideo()
        }
        else{
            
            view.showLabel()
            
        }
        
    }
    }
}

