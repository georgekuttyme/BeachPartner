//
//  BPCardsVC.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 02/03/18.
//  Copyright © 2018 dev. All rights reserved.
//
import Koloda
import SDWebImage
import UIKit
import AlamofireImage


private var numberOfCards: Int = 5
class BPCardsVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
     @IBOutlet weak var cardView: KolodaView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var topthreefinishesBtn: UIButton!
    @IBOutlet weak var topstackview: UIStackView!
    @IBOutlet weak var topThreeBtn: UIButton!
    @IBOutlet weak var topTwoBtn: UIButton!
    @IBOutlet weak var toponeBtn: UIButton!
    @IBOutlet weak var topsView: UIView!
    @IBOutlet weak var blueBpListHeight: NSLayoutConstraint!
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnLoc: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblNotAvailable: UILabel!
    @IBOutlet weak var btnPlaybtn: UIButton!
    @IBOutlet weak var lblSwipeGameMsg: UILabel!
    @IBOutlet weak var lblNotAviltopSpace: NSLayoutConstraint!
    @IBOutlet weak var mainStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
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
    var subscribedUsers = [SubscriptionUserModel]()
   var subscribedBlueBpUsers = [SearchUserModel]()
    var swipeAction = [ConnectedUserModel]()
    var likedPersonInfo = [ConnectedUserModel]()
    var searchUsers = [SearchUserModel]()
    var SwipeCardArray:[Any] = []
    var currentIndex : Int = 0
    
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
                    self.badgeImage.isHidden = true
                    self.topthreefinishesBtn.isHidden = true
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
            }
            
        }
    }
    
    @IBAction func topfinishesCollapseClicked(_ sender: Any) {
    
       resetTopFinishView()
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
    
    @IBAction func undoBtnCLicked(_ sender: Any) {
        print(self.currentIndex)
        if let view:CardView = (self.cardView.viewForCard(at: self.currentIndex) as? CardView) {
            view.pauseVideo()
        }
        self.btnUndo.isEnabled = false
        self.btnUndo.setImage(UIImage(named:"grayback"), for: UIControlState.normal)
        self.imgProfile.isHidden = true
        self.lblNotAvailable.isHidden = true
        self.btnPlaybtn.isHidden = true
        self.lblSwipeGameMsg.isHidden = true
        self.cardView.revertAction()
        
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
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController!.navigationBar.topItem!.title = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func HiFiBtnClicked(_ sender: Any) {
        self.cardView.swipe(.up)
    }
    
    @IBAction func btnPlaySwipeGame(_ sender: Any) {
        self.view .removeFromSuperview()
        self.tabBarController?.selectedIndex = 2        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
        
        if collectionView == self.topUserListCollectionView {
            let blueBpData = subscribedBlueBpUsers[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
            
            if let imageUrl = URL(string: (blueBpData.imageUrl)) {
                cell.imageView.sd_setIndicatorStyle(.whiteLarge)
                cell.imageView.sd_setShowActivityIndicatorView(true)
                cell.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            }
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
            cell.imageView.clipsToBounds = true
//            cell.imageView.layer.borderColor = UIColor.green.cgColor
            cell.imageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
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
        
        self.badgeImage.isHidden = false
        self.topthreefinishesBtn.isHidden = false
        self.btnUndo.isEnabled = false
        self.topThreeBtn.isHidden = true
        self.topTwoBtn.isHidden = true
        self.toponeBtn.isHidden = true
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
        self.getUsersListforBlueBp()
        self.getUserInfo()
        self.generateSwipeAarray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendMsg(notification:)), name:NSNotification.Name(rawValue: "send-Message"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(findTournament(notification:)), name:NSNotification.Name(rawValue: "find-Tournament"), object: nil)

    }

    @objc func sendMsg(notification: NSNotification){
        print("\n\n\n ???????",self.likedPersonInfo)
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatController.connectedUserModel = self.likedPersonInfo
        chatController.chatType = "Connections"
        let navigationController = UINavigationController(rootViewController: chatController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedType == "BlueBp"{
            mainStackViewTopConstraint.constant = 64
            scrlViewHeight.constant = UIScreen.main.bounds.size.height - 150
             self.cardView.reloadData()
        }
        else {
            mainStackViewTopConstraint.constant = 0
            scrlViewHeight.constant = UIScreen.main.bounds.size.height - 110
            if selectedType == "Search"{
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
                else  if selectedType == "Search"{
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
        
        resetTopFinishView()
        if didPressDownArrow == true {
            moveCardView()
        }
        
        if selectedType == "Likes" {
            SwipeCardArray = self.connectedUsers
            searchCardSatus = selectedType
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
        }
        else if selectedType == "Search"{
            SwipeCardArray = self.searchUsers
            searchCardSatus = selectedType
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
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
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
            
        }
        else if selectedType == "BlueBp"{
            SwipeCardArray.insert(self.searchUsers[selectedIndex], at: 0)
            self.searchUsers .remove(at: selectedIndex)
//            self.getUsersSwipeCard()
             searchCardSatus = selectedType
            self.cardView.reloadData()
            if self.SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
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
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
            isFirstBlueBpCard = true
            self.cardView.dataSource = self
            self.cardView.delegate = self
            self.cardView.resetCurrentCardIndex()
        }
        
    }
    
    private func moveCardView() {
        UIView.animate(withDuration: 0.5, animations: {
            // 200 or any value you like.
            if !self.didPressDownArrow {
                self.didPressDownArrow = true
                let point = CGPoint(x: 0, y: 300) // 200 or any value you like.
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
                let point = CGPoint(x: 0, y: 10)
                self.bpscrollview.contentOffset = point
                self.bpscrollview.isScrollEnabled=false
            }
            
            if let view:CardView = self.cardView.viewForCard(at: 0) as? CardView {
                
                self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
            }
            
            
//            let range: CountableRange<Int> = self.curentCardIndex..<self.curentCardIndex+1
//            self.cardView.reloadCardsInIndexRange(range)
//            self.cardView.reloadData()
            
        }, completion: nil)
    }
    
    
    @objc func moveDownScroll(sender:UIButton) {
        
       moveCardView()
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
        let location = UserDefaults.standard.string(forKey: "location")
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
                if let imageUrl = URL(string: accRespModel.imageUrl) {
                    self.imgProfile.sd_setIndicatorStyle(.whiteLarge)
                    self.imgProfile.sd_setShowActivityIndicatorView(true)
                    self.imgProfile.sd_setImage(with: imageUrl, placeholderImage:  #imageLiteral(resourceName: "user"))
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
          let endPoint="includeCoach=true&subscriptionType=BlueBP&hideConnectedUser=true&hideLikedUser=true&hideRejectedConnections=true&hideBlockedUsers=true"
        APIManager.callServer.getSearchList(endpoint:endPoint ,sucessResult: { (responseModel) in
            guard let searchUserModelArray = responseModel as? SearchUserModelArray else{
                return
            }
            self.subscribedBlueBpUsers = searchUserModelArray.searchUserModel
            
            self.topUserListCollectionView.reloadData()
            
            if self.subscribedBlueBpUsers.count == 0 && self.selectedType == "Search" {
                self.blueBpListHeight.constant = 0
                self.scrlViewHeight.constant = UIScreen.main.bounds.size.height - 110
            }
            else{
                self.blueBpListHeight.constant = 61
            }
            
//            DispatchQueue.main.async {
//                self.view.layoutIfNeeded()
//            }
            
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
        
        }, errorResult: { (error) in
           
        })
    
        self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
        self.btnUndo.isEnabled = true
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
//                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
            
        }, errorResult: { (error) in
            
        })
        self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
         self.btnUndo.isEnabled = true
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
        }, errorResult: { (error) in
            
        })
        self.btnUndo.setImage(UIImage(named:"back"), for: UIControlState.normal)
        self.btnUndo.isEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: KolodaViewDataSource
extension BPCardsVC :KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
        if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
        let data = SwipeCardArray[index] as! SearchUserModel
        if let view:CardView = koloda.viewForCard(at: index) as? CardView {
                if let videoUrl = URL(string: data.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
        }
            topFinishers = data.userMoreProfileDetails?.topFinishes ?? ""
      }
        else{
            let  data = SwipeCardArray[index] as! ConnectedUserModel
            if let view:CardView = koloda.viewForCard(at: index) as? CardView {
                if let videoUrl = URL(string: data.connectedUser!.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
                self.didPressDownArrow ? view.moveDown.setImage(UIImage(named:"arrow-up"), for: UIControlState.normal) : view.moveDown.setImage(UIImage(named:"arrow-down"), for: UIControlState.normal)
            }
             topFinishers = data.connectedUser?.userMoreProfileDetails?.topFinishes ?? ""
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
        if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            let  data = SwipeCardArray[index] as! SearchUserModel
            idString = String(data.id)
            fcmId = data.fcmToken
        }
        else {
            let  data = SwipeCardArray[index] as! ConnectedUserModel
            idString = String(data.connectedUser!.userId as Int!)
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
             self.selectedType = "Search"
            self.topUserListCollectionView.reloadData()
            if self.subscribedBlueBpUsers.count == 0  {
                self.blueBpListHeight.constant = 0
            }
            else{
                self.blueBpListHeight.constant = 61
            }
        }
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        self.currentIndex = index
        if let view:CardView = koloda.viewForCard(at: index) as? CardView {
          
            var videoString:String
            if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
                let  data = SwipeCardArray[index] as! SearchUserModel
                videoString = data.videoUrl
            }
            else {
                let  data = SwipeCardArray[index] as! ConnectedUserModel
                videoString = data.connectedUser?.videoUrl ?? ""
            }
            
            if videoString != "" {
                 view.showVideo()
            }
            else{
           //     view.showVideo()
                view.showLabel()
//                self.lblNotAvailable.alpha = 1.0
//                self.lblNotAvailable.isHidden = false
//                self.lblNotAvailable.text = "No video available for this profile"
//                self.lblNotAvailable.textColor = UIColor.white
//                lblNotAvailable.layer.shadowColor = UIColor.gray.cgColor
//                lblNotAvailable.layer.shadowOpacity = 1.0
//                lblNotAvailable.layer.shadowRadius = 3.0
//                lblNotAvailable.layer.shadowOffset = CGSize(width: 4, height: 4)
//                lblNotAvailable.layer.masksToBounds = false
//                 self.lblNotAviltopSpace.constant = -75
            }
           
        }
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.imgProfile.isHidden = false
        self.lblNotAvailable.isHidden = false
         self.lblNotAvailable.alpha = 1.0
        self.btnPlaybtn.isHidden = false
        self.lblSwipeGameMsg.isHidden = false
        self.lblSwipeGameMsg.text = "Start Swipe Game"
        if searchCardSatus == "search-remain" {
           self.lblSwipeGameMsg.text = "Resume Swipe Game"
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
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let view = CardView.instantiateFromNib()
        if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            var  data : SearchUserModel
            if  selectedType == "BlueBp-New"{
                data = SwipeCardArray[0] as! SearchUserModel
            }
            else{
                data = SwipeCardArray[index] as! SearchUserModel
            }
            
        if index == 0{
                if let videoUrl = URL(string: data.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            }
            view.moveDown.addTarget(self, action:#selector(moveDownScroll(sender:)), for: UIControlEvents.touchUpInside)
            view.displaySearchDetailsOnCard(displayData: data)
        }
        else{
            let  data = SwipeCardArray[index] as! ConnectedUserModel
            
            if index == 0 {
                if let videoUrl = URL(string: data.connectedUser!.videoUrl) {
                    self.videoView.load(videoUrl)
                    self.videoView.isMuted = true
                    view.videoView = self.videoView
                }
            }
            
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
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
    }
}

