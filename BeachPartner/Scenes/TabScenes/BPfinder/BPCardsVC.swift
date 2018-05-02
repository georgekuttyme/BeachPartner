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
    @IBOutlet weak var lblNotAviltopSpace: NSLayoutConstraint!
    
     var userData = AccountRespModel()
    let videoView = UIVideoView()
    var didPressDownArrow :Bool!
    var isFirstBlueBpCard :Bool!
    var selectedIndex:Int!
    var curentCardIndex:Int!
    var selectedType:String!
    var connectedUsers = [ConnectedUserModel]()
    var subscribedUsers = [SubscriptionUserModel]()
   var subscribedBlueBpUsers = [SearchUserModel]()
    var swipeAction = [ConnectedUserModel]()
    var searchUsers = [SearchUserModel]()
    var SwipeCardArray:[Any] = []
    
    @IBAction func topfinishesClicked(_ sender: Any) {

        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.topThreeBtn.isHidden = false
            self.topTwoBtn.isHidden = false
            self.toponeBtn.isHidden = false
            self.badgeImage.isHidden = true
            self.topthreefinishesBtn.isHidden = true
        })

    }
    
    @IBAction func topfinishesCollapseClicked(_ sender: Any) {
    
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.topThreeBtn.isHidden = true
            self.topTwoBtn.isHidden = true
            self.toponeBtn.isHidden = true
            self.badgeImage.isHidden = false
            self.topthreefinishesBtn.isHidden = false
        })
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == self.topUserListCollectionView {
            return subscribedBlueBpUsers.count
        }
        return 0;
    }
    
    @IBAction func undoBtnCLicked(_ sender: Any) {
        self.btnUndo.isEnabled = false
        self.btnUndo.setImage(UIImage(named:"grayback"), for: UIControlState.normal)
        self.imgProfile.isHidden = true
        self.lblNotAvailable.isHidden = true
        self.cardView.revertAction()
        APIManager.callServer.undoSwipeAction(userId:"\(self.swipeAction[0].id)",sucessResult: { (responseModel) in
            
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
            cell.imageView.layer.borderColor = UIColor.green.cgColor
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
            self.generateSwipeAarray()
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
        
    }
    func generateSwipeAarray() {
        
        if selectedType == "Likes" {
            SwipeCardArray = self.connectedUsers
            self.cardView.dataSource = self
            self.cardView.delegate = self
            if SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
        }
        else if selectedType == "Search"{
            SwipeCardArray = self.searchUsers
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
            self.getUsersSwipeCard()
        }
       else if selectedType == "BlueBp-New"{
            
            if self.SwipeCardArray.count>0 {
                self.SwipeCardArray.remove(at: 0)
            }
            self.SwipeCardArray.insert(self.subscribedBlueBpUsers[selectedIndex], at: 0)
            self.cardView.reloadData()
            if SwipeCardArray.count == 0{
                self.imgProfile.isHidden = false
                self.lblNotAvailable.isHidden = false
            }
            isFirstBlueBpCard = true;
          //  self.cardView.dataSource = self
          //  self.cardView.delegate = self
        }
        
    }
    
    @objc func moveDownScroll(sender:UIButton) {
        
        UIView.animate(withDuration: 1, animations: {
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
            
//            let range: CountableRange<Int> = self.curentCardIndex..<self.curentCardIndex+1
//            self.cardView.reloadCardsInIndexRange(range)
            self.cardView.reloadData()
            
        }, completion: nil)
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
            }
            else{
                self.blueBpListHeight.constant = 61
            }
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    
    func getUsersSwipeCard()  {
        
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

    
    func didSwipeToUp(user_Id:String){
        APIManager.callServer.requestHiFi(userId:user_Id,sucessResult: { (responseModel) in
            
            guard let connectedUserModelValue = responseModel as? ConnectedUserModel else{
                return
            }
            print(connectedUserModelValue)
            self.swipeAction = [connectedUserModelValue]
            print(self.swipeAction)
            
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
            print(self.swipeAction)
            
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
        if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            let  data = SwipeCardArray[index] as! SearchUserModel
            idString = String(data.id)
        }
        else {
            let  data = SwipeCardArray[index] as! ConnectedUserModel
            idString = String(data.connectedUser!.userId as Int!)
        }
        
        if direction == .up{
        self.didSwipeToUp(user_Id:idString)
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
                view.showVideo()
                self.lblNotAvailable.alpha = 1.0
                self.lblNotAvailable.isHidden = false
                self.lblNotAvailable.text = "No video available for this profile"
                 self.lblNotAviltopSpace.constant = -75
            }
           
        }
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.imgProfile.isHidden = false
        self.lblNotAvailable.isHidden = false
      //  cardView.resetCurrentCardIndex()
    }
    
}
extension BPCardsVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return SwipeCardArray.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let view = CardView.instantiateFromNib()
        if selectedType == "Search" || selectedType == "BlueBp" || selectedType == "BlueBp-New"{
            let  data = SwipeCardArray[index] as! SearchUserModel
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


