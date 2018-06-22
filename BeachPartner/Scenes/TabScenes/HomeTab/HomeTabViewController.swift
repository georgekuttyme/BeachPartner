//
//  HomeTabViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 22/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import Firebase
//import DropDown

class HomeTabViewController: BeachPartnerViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITabBarControllerDelegate {
    var loggedInUserId = 0
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("messages")
    private var channelRefHandle: DatabaseHandle?
    
    
    //    @IBOutlet weak var blueBPCollectionView: UICollectionView!
    
    @IBOutlet weak var topUserListCollectionView: UICollectionView!
    
    @IBOutlet weak var upCommingTournament: UICollectionView!
    
    @IBOutlet weak var messagesCollectionView: UICollectionView!
    
    @IBOutlet weak var tournamentRequestsCollectionView: UICollectionView!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lblUserCount: UILabel!
    
    @IBOutlet weak var tournamentRequestsLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    weak var currentViewController: UIViewController?
    
    @IBOutlet var tornamentRequestLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var connectionLabel: UILabel!
    @IBOutlet var myLabel: UILabel!

    
    @IBOutlet weak var tournamentStackView: UIStackView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet var upcomingTournamentsNext: UIButton!
    @IBOutlet var messagesNext: UIButton!
    @IBOutlet var tournamentRequestsNext: UIButton!
    
    var selectedTabViewController:Int!
    var getAllEventsUsers = [GetUpcomingTournamentsRespModel]()
    var subscribedBlueBpUsers = [SearchUserModel]()
    var connectedUsers = [ConnectedUserModel]()
    var activeUsers = [ConnectedUserModel]()
    var recentChatList = [[String:String]]()
    var partnerArray = [String]()
    var tournamentRequestList: GetTournamentRequestRespModel?
    
    var tournamentRequestSentViewActive = false
    var titleOfChat = String()
    
    var date = ["04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018"]
    var eventName = ["America","America","America","America","America","America","America"]
    var name = ["Alivia Orvieto","Marti McLaurin","Liz Held"]
    var partners = String()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tornamentRequestLabel.isHidden = false
        getAllUserEventsList()
        getAllTournamentRequests()
        userImg.image = UIImage(named: "likes")!
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
        self.userImg.clipsToBounds = true
        selectedTabViewController=0
        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
            self.loggedInUserId =  Int(id)!
        }
        self.tabBarController?.delegate = self
        self.getUsersListforBlueBp()
        self.getNewUsersList()
        self.getBlockedConnections()
        let isNewUserFirstLogin = UserDefaults.standard.string(forKey: "isNewUserFirstLogin") ?? ""
        let loggedIn = UserDefaults.standard.string(forKey: "isFirstLoggedIn")
        if loggedIn != "0" {
            UserDefaults.standard.set(1,forKey: "isNewUserFirstLogin")
            UserDefaults.standard.set("0", forKey: "isFirstLoggedIn")
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
            tournamentStackView.isHidden = false
        }
        else {
            tournamentStackView.isHidden = true
            self.msgLabel.textColor = UIColor.white
            
            if let bgImage = UIImage(named: "BP - Cal_Events") {
                messageContainerView.backgroundColor = UIColor(patternImage: bgImage)
            }
        }
        
        Subscription.current.getAllSubscriptionPlans()
        Subscription.current.getUsersActivePlans()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let image : UIImage = UIImage(named: "BP.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
//        self.msgLabel.isHidden = true
//        self.connectionLabel.isHidden = true
//        tornamentRequestLabel.isHidden = true
//        self.myLabel.isHidden = true
        let isNewUser = UserDefaults.standard.string(forKey: "NewUser")
        if isNewUser == "0" {
            popUpAlertForCompleteProfile()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapOnPush(notification:)), name:NSNotification.Name(rawValue: "foreground-pushNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapOnHome(notification:)), name:NSNotification.Name(rawValue: "HOME-pushNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapOnActive(notification:)), name:NSNotification.Name(rawValue: "ACTIVE-pushNotification"), object: nil)
    }
    
    @objc func tapOnPush(notification: NSNotification) {
        self.tabBarController?.selectedIndex = 4
    }
    
    @objc func tapOnHome(notification: NSNotification) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func tapOnActive(notification: NSNotification) {
        self.tabBarController?.selectedIndex = 1
    }
    
   func popUpAlertForCompleteProfile(){
        let alert = UIAlertController(title: "Update Profile", message: "Please take a moment to complete your profile", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Later", style: .cancel) { (action) in
            
        }
        let cancelButton = UIAlertAction(title: "Now", style: .default) { (action) in
            
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
            let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
            let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
            let navController = UINavigationController(rootViewController: identifier)
            self.present(navController, animated: true, completion: nil)
            
        }
        alert.addAction(actionButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getAllUserEventsList(){
        APIManager.callServer.getAllEventBetweenDetails(sucessResult: {(response) in
            guard let eventModelArray = response as? GetUpcomingTournamentsRespModelArray else{
                return
            }
            self.getAllEventsUsers = eventModelArray.getUpcomingTournamentsRespModel
            print("#@$%^&*()",self.getAllEventsUsers.count)
            if self.getAllEventsUsers.count == 0 {
                self.myLabel.isHidden = false
            }else {
                self.myLabel.isHidden = true
                self.upCommingTournament.reloadData()
            }
        }, errorResult: {(error) in
            
        })
    }
    
    func getAllTournamentRequests() {
        
        APIManager.callServer.getAllEventInvitations(sucessResult: { (responseModel) in
            
            guard let tournaments = responseModel as? GetTournamentRequestRespModel else {
                return
            }
            
            self.tournamentRequestList = tournaments
            self.tournamentRequestsCollectionView.reloadData()
            
        }) { (error) in
            
        }
    }
    
//    func getUserSubscriptionDetails() {
//
//        APIManager.callServer.getUsersActivePlans(sucessResult: { (responseModel) in
//
//            guard let subscriptions = responseModel as? GetUserSubscriptionModel else {
//                return
//            }
//
//            print(subscriptions.addons)
//            print(subscriptions.subscriptions)
//
//
//        }) { (error) in
//
//
//        }
//    }
    
    
    @IBAction func tournamentRequestsSentBtnClicked(_ sender: UIButton) {
        if Subscription.current.supportForFunctionality(featureId: BenefitType.PlayerLikeVisibility) == false {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
            vc.benefitCode = BenefitType.PlayerLikeVisibility
            self.present(vc, animated: true, completion: nil)
            return
        }else{
            tournamentRequestSentViewActive = true
            self.tournamentRequestsLbl.text = "     Tournament Requests Sent"
            self.tournamentRequestsCollectionView.reloadData()
        }
        
        //        tornamentRequestLabel.text = "No tournament Requests Sent"
    }
    
    @IBAction func tournamentRequestsReceivedBtnClicked(_ sender: UIButton) {
        
        tournamentRequestSentViewActive = false
        self.tournamentRequestsLbl.text = "     Tournament Requests Received"
        self.tournamentRequestsCollectionView.reloadData()
        
        
        //        tornamentRequestLabel.text = "No tournament Requests Received"
    }
    
    @IBAction func btnLikesClicked(_ sender: Any) {
       
        if Subscription.current.supportForFunctionality(featureId: BenefitType.PlayerLikeVisibility) == false {
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
            vc.benefitCode = BenefitType.PlayerLikeVisibility
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        if lblUserCount.text != "No"{
            self.getAllConnectedUsers()
        }
    }
    
    @IBAction func UpcomingTournamentsNextBtnClicked(_ sender: Any) {
        let visibleItems: NSArray = self.upCommingTournament.indexPathsForVisibleItems as NSArray
        if visibleItems.count == 0 {
            return
        }
        let currentItem: IndexPath = visibleItems.lastObject as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < getAllEventsUsers.count {
            self.upCommingTournament.scrollToItem(at: nextItem, at: .left, animated: true)
            
        }
        
    }
    
    @IBAction func messagesNextBtnClicked(_ sender: Any) {
        
        let visibleItems: NSArray = self.messagesCollectionView.indexPathsForVisibleItems as NSArray
        if visibleItems.count == 0 {
            return
        }
        let currentItem: IndexPath = visibleItems.lastObject as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < recentChatList.count {
            self.messagesCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
            
        }
    }
    
    @IBAction func tournamentRequestsNextBtnClicked(_ sender: Any) {
        let visibleItems: NSArray = self.tournamentRequestsCollectionView.indexPathsForVisibleItems as NSArray
        if visibleItems.count == 0 {
            return
        }
        if tournamentRequestSentViewActive {
            if Subscription.current.supportForFunctionality(featureId: BenefitType.PlayerLikeVisibility) == false {
                let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
                vc.benefitCode = BenefitType.PlayerLikeVisibility
                self.present(vc, animated: true, completion: nil)
                return
            }else{
                let currentItem: IndexPath = visibleItems.lastObject as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
                if nextItem.row < (tournamentRequestList?.requestsSent.count)! {
                    self.tournamentRequestsCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                }
                
            }
        }else{
            let currentItem: IndexPath = visibleItems.lastObject as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < (tournamentRequestList?.requestsReceived.count)! {
                self.tournamentRequestsCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
        if  tabBarController.selectedIndex == 0 {
            let newViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController")as! HomeTabViewController
            if newViewController != self.currentViewController {
                self.currentViewController = newViewController
                self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.addChildViewController(self.currentViewController!)
                self.addSubview(subView: self.currentViewController!.view, toView: self.view)
            }
        }
        selectedTabViewController = tabBarController.selectedIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topUserListCollectionView {
            return subscribedBlueBpUsers.count
        }
        else if collectionView == self.upCommingTournament {
            if self.getAllEventsUsers.count != 0{
                return self.getAllEventsUsers.count
            }else {
                return 0
            }
        }
        else if collectionView == self.messagesCollectionView {
            return self.recentChatList.count
        }
        else if collectionView == self.tournamentRequestsCollectionView {
            
            if tournamentRequestSentViewActive {
                
                if let count = tournamentRequestList?.requestsSent.count, count > 0 {
                    tornamentRequestLabel.text = ""
                    return count
                }
                else {
                    tornamentRequestLabel.text = "No Tournament Requests Sent"
                }
            }
            else {
                if let count = tournamentRequestList?.requestsReceived.count, count > 0 {
                    tornamentRequestLabel.text = ""
                    return count
                }
                else {
                    tornamentRequestLabel.text = "No Tournament Requests Received"
                }
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("collectionView == ", collectionView)
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
            cell.imageView.layer.borderWidth = 1.5
            
            return cell
        }
        if collectionView == self.upCommingTournament {
            print("=========")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingTournamentCollectionViewCell", for: indexPath) as! UpcomingTournamentCollectionViewCell
            cell.calendarImageView.image = UIImage(named: "calender")!
            cell.partnerImage.image = UIImage(named: "partners_1x")!

            var partnerList = self.getAllEventsUsers[indexPath.row]
            if self.getAllEventsUsers.count != 0 {
                let limit = partnerList.invitationList?.count
                
                self.partners.removeAll()
                
                for index1 in 0..<limit! {
                    let partnerCount = partnerList.invitationList![index1].eventpartners?.count
                    for index2 in 0..<partnerCount! {
                        if let id = partnerList.invitationList![index1].eventpartners?[index2].partnerId , id != loggedInUserId{
                            if let firstName = partnerList.invitationList![index1].eventpartners?[index2].partnerName {
                                self.partners.append(firstName + ",")
                            }
                        }
                    }
                }

                let startDate = dateStringFromTimeInterval(interval: (partnerList.event?.eventStartDate)!)
                cell.dateLabel?.text = startDate
//                cell.dateLabel.textColor = UIColor.lightGray

                cell.tournamentlabel?.text = partnerList.event?.eventName
                cell.tournamentlabel?.font = UIFont.systemFont(ofSize: 13)
//                cell.tournamentlabel.textColor = UIColor.lightGray
                print("+++>>",self.partners.count)

                if self.partners.count > 0 {
                    self.partners.removeLast()
                }
                cell.partnersName?.text = self.partners
//                cell.partnersName.textColor = UIColor.lightGray
            }
            
            return cell
        }
        
        if collectionView == self.messagesCollectionView {
            print("collectionView == messagesCollectionView")
            print("====dfhfdghvbhj====")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
            self.titleOfChat.removeAll()
            //            let n = Int(arc4random_uniform(42))
            //            cell.messageUserProfille.image = imageSrc[n % 3]
            
            if let imageUrl = URL(string: (self.recentChatList[indexPath.row]["profileImg"])!) {
                print("hdgh  ",self.recentChatList)
                cell.messageUserProfille.sd_setIndicatorStyle(.whiteLarge)
                cell.messageUserProfille.sd_setShowActivityIndicatorView(true)
                cell.messageUserProfille.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                
            }
            
            if let imageUrl = URL(string: (self.recentChatList[indexPath.row]["profileImg"])!) {
                cell.messageUserProfille.sd_setIndicatorStyle(.whiteLarge)
                cell.messageUserProfille.sd_setShowActivityIndicatorView(true)
                cell.messageUserProfille.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            }
            
            cell.messageUserProfille.layer.cornerRadius = cell.messageUserProfille.frame.size.width/2
            cell.messageUserProfille.clipsToBounds = true
            cell.messageUserProfille.layer.borderColor = UIColor.lightGray.cgColor
            cell.messageUserProfille.layer.borderWidth = 1
            
//            let userName = String(describing: UserDefaults.standard.value(forKey: "bP_userName") ?? "")
//            let ChatuserName = self.recentChatList[indexPath.row]["receiver_name"] ?? "" as String
//            if userName == ChatuserName {
//                cell.nameLbl?.text = self.recentChatList[indexPath.row]["sender_name"]
//
//            }
//            else{
//                cell.nameLbl?.text = self.recentChatList[indexPath.row]["receiver_name"]
//            }
            if let fName = self.recentChatList[indexPath.row]["sender_name"] {
                titleOfChat = fName
            }
            if let lName = self.recentChatList[indexPath.row]["sender_lastName"] {
                titleOfChat = titleOfChat + " " + lName
            }
            print(titleOfChat, "jjindexPath")
            cell.nameLbl.text = titleOfChat
            cell.nameLbl.textColor = UIColor.lightGray
            
            cell.contentView.layer.cornerRadius = 4.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 5.0
            cell.layer.shadowPath = UIBezierPath(roundedRect: (cell.bounds), cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
    
            return cell
        }
        
        if collectionView == self.tournamentRequestsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentRequestsCollectionViewCell", for: indexPath) as! TournamentRequestsCollectionViewCell
            
            if tournamentRequestSentViewActive == true {
                
                let request = tournamentRequestList?.requestsSent[indexPath.row]
                cell.eventNameLabel.text = request?.eventName
                if let date = request?.eventStartDate {
                    cell.eventStartDateLabel.text = dateStringFromTimeInterval(interval: date)
                }
                else {
                    cell.eventStartDateLabel.text = ""
                }
                cell.eventLocationLabel.text = request?.eventLocation
                
                cell.invitationCountLabel.text = ""
//                if let count = request?.sentCount, count > 0 {
//                    cell.invitationCountLabel.text = "\(count)"
//                }
//                else {
//                    cell.invitationCountLabel.text = ""
//                }
            }
            else {
                let request = tournamentRequestList?.requestsReceived[indexPath.row]
                cell.eventNameLabel.text = request?.eventName
                if let date = request?.eventStartDate {
                    cell.eventStartDateLabel.text = dateStringFromTimeInterval(interval: date)
                }
                else {
                    cell.eventStartDateLabel.text = ""
                }
                cell.eventLocationLabel.text = request?.eventLocation
                
                cell.invitationCountLabel.text = ""
//                if let count = request?.invitationCount, count > 0 {
//                    cell.invitationCountLabel.text = "\(count)"
//                }
//                else {
//                    cell.invitationCountLabel.text = ""
//                }
            }
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlueBPCollectionViewCell", for: indexPath) as! BlueBPCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == self.topUserListCollectionView {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentBPcardsNew") as! BPCardsVC
            //     newViewController.selectedNation = self.nationListdata[index]
            newViewController.selectedIndex = indexPath.row
            newViewController.selectedType = "BlueBp"
            newViewController.searchUsers = self.subscribedBlueBpUsers
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            let curentViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController")as! HomeTabViewController
            self.currentViewController = curentViewController
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        }
        if collectionView == self.messagesCollectionView {
            self.navigationItem.setHidesBackButton(true, animated:false);
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatController.recentChatDic = self.recentChatList[indexPath.row]
            print(self.recentChatList[indexPath.row]," ??self.recentChatList[indexPath.row]")
            chatController.chatType = "recentChat"
            let navigationController = UINavigationController(rootViewController: chatController)
            self.present(navigationController, animated: true, completion: nil)
        }
        if collectionView == self.tournamentRequestsCollectionView {
            
            if tournamentRequestSentViewActive == true {
                guard let eventId = tournamentRequestList?.requestsSent[indexPath.row].eventId else { return }
                
                let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
                let eventDetailsVC = storyBoard.instantiateViewController(withIdentifier: "EventDetailsView") as! EventDetailsViewController
                eventDetailsVC.eventId = eventId
                eventDetailsVC.isFromHomeTab = true
                self.navigationController?.pushViewController(eventDetailsVC, animated: true)
            }
            else {
                guard let eventId = tournamentRequestList?.requestsReceived[indexPath.row].eventId else { return }
                
                let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "InvitationListView") as! EventInvitationListViewController
                viewController.eventId = eventId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        if collectionView == self.upCommingTournament {
             guard let eventId = self.getAllEventsUsers[indexPath.row].event?.eventId else { return }
            let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
            let eventDetailsVC = storyBoard.instantiateViewController(withIdentifier: "MyCalEventDetailsView") as! MyCalEventDetailsViewController
            eventDetailsVC.eventId = eventId
            eventDetailsVC.isFromHomeTab = true
            self.navigationController?.pushViewController(eventDetailsVC, animated: true)
            
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
//    override func addSubview(subView:UIView, toView parentView:UIView) {
//        parentView.addSubview(subView)
//        
//        var viewBindingsDict = [String: AnyObject]()
//        viewBindingsDict["subView"] = subView
//        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
//                                                                 options: [], metrics: nil, views: viewBindingsDict))
//        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
//                                                                 options: [], metrics: nil, views: viewBindingsDict))
//    }
    
    func getUsersListforBlueBp()  {
        
        let endPoint="includeCoach=true&subscriptionType=BlueBP&hideConnectedUser=true&hideLikedUser=true&hideRejectedConnections=true&hideBlockedUsers=true"
        APIManager.callServer.getSearchList(endpoint:endPoint ,sucessResult: { (responseModel) in
            guard let searchUserModelArray = responseModel as? SearchUserModelArray else{
                return
            }
            self.subscribedBlueBpUsers = searchUserModelArray.searchUserModel
            
            if self.subscribedBlueBpUsers.count == 0 {
               
                self.connectionLabel.isHidden = false
            }else {
                self.connectionLabel.isHidden = true
                self.topUserListCollectionView.reloadData()
            }
            
        }, errorResult: { (error) in
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    func getNewUsersList()  {
        
        APIManager.callServer.getUsersConnectionCount(status:"status=New&showReceived=true",sucessResult: { (responseModel) in
            
            guard let connectedUserModel = responseModel as? ConnectedUsersCountModel else{
                return
            }
            if connectedUserModel.count > 0{
                self.lblUserCount.text = "\(connectedUserModel.count)"
            }
            else{
                self.lblUserCount.text = "No"
            }
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    func getAllConnectedUsers()  {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUserConnectionList(status:"status=New&showReceived=true",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else{
                ActivityIndicatorView.hiding()
                return
            }
            ActivityIndicatorView.hiding()
            self.connectedUsers = connectedUserModelArray.connectedUserModel
            
            if self.connectedUsers.count>0 {
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentBPcardsNew") as! BPCardsVC
                //     newViewController.selectedNation = self.nationListdata[index]
                newViewController.selectedIndex = 0
                newViewController.selectedType = "Likes"
                newViewController.connectedUsers = self.connectedUsers
                newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                let curentViewController =  self.storyboard?.instantiateViewController(withIdentifier: "HomeTabViewController")as! HomeTabViewController
                self.currentViewController = curentViewController
                self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
                self.currentViewController = newViewController
                self.addSubview(subView: self.currentViewController!.view, toView: self.view)
            }
            
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    func getBlockedConnections() {
        
        APIManager.callServer.getUserConnectionList(status:"status=Active&showReceived=false",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else {
                return
            }
            for connectedUser in connectedUserModelArray.connectedUserModel {
                self.activeUsers.append(connectedUser)
            }
            DispatchQueue.main.async {
                print(self.activeUsers)
                self.recentChatList.removeAll()
                self.observeChannels()
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
    
    func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            let bP_userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
            var latestMsgDic = [String:String]()
            if id.contains("-"+"\(bP_userId)")||id.contains("\(bP_userId)"+"-"){
                let index = channelData.startIndex
                latestMsgDic.updateValue(id, forKey: "chatId")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["receiver_id"] as! String, forKey: "receiver_id")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["receiver_name"] as! String, forKey: "receiver_name")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["sender_id"] as! String, forKey: "sender_id")
                //                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["sender_name"] as? String ?? "", forKey: "sender_name")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["text"] as! String, forKey: "text")
                //                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["profileImg"] as? String ?? "", forKey: "profileImg")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["date"] as! String, forKey: "date")
                
                let senderId = channelData[channelData.keys[index]]!["sender_id"] as! String
                let receiverId = channelData[channelData.keys[index]]!["receiver_id"] as! String
                var isActiveUser = Bool ()
                
                for connectedUser in self.activeUsers {
                    let userId = String(connectedUser.connectedUser?.userId ?? 0)
                    if userId == senderId || userId == receiverId {
                        if bP_userId == senderId || bP_userId == receiverId {
                            latestMsgDic.updateValue(connectedUser.connectedUser?.firstName ?? "", forKey: "sender_name")
                            latestMsgDic.updateValue(connectedUser.connectedUser?.lastName ?? "", forKey: "sender_lastName")
                            latestMsgDic.updateValue(connectedUser.connectedUser?.imageUrl ?? "", forKey: "profileImg")
                            isActiveUser = true
                            break
                        }
                    }
                    else {
                        isActiveUser = false
                    }
                }
                
                if isActiveUser {
                    self.recentChatList.insert(latestMsgDic, at: 0)
                    if self.recentChatList.count == 0{

                        self.msgLabel.isHidden = false
                    }else{
                        self.msgLabel.isHidden = true
                        self.messagesCollectionView.reloadData()
                    }
                }
            }
            ActivityIndicatorView.hiding()
        })
    }
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeTabViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topUserListCollectionView {
            return CGSize(width: 52, height: 52)
        }
        if collectionView == messagesCollectionView {
            return CGSize(width: 100, height: 100)
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topUserListCollectionView || collectionView == messagesCollectionView {
            return 10.0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topUserListCollectionView {
            return 10
        }
        return 0
    }
}


extension HomeTabViewController: EventInvitationListViewControllerDelegate {
    
    func refreshInvitationList() {
        self.getAllTournamentRequests()
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


