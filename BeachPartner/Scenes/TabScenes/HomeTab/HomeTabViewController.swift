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
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("messages")
    private var channelRefHandle: DatabaseHandle?
    
    //    let dropDown = DropDown()
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
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
    @IBAction func menuBtnClicked(_ sender: Any) {
        //        dropDown.show()
    }
    
    var selectedTabViewController:Int!
    var getAllEventsUsers = [GetAllEventsBetweenResponseModel]()
    var subscribedBlueBpUsers = [SearchUserModel]()
    var connectedUsers = [ConnectedUserModel]()
    var recentChatList = [[String:String]]()
    
    var date = ["04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018","04/01/2018"]
    var eventName = ["America","America","America","America","America","America","America"]
    
    var partners = ["Martin,David,John,Hari","Martin,David,John,Hari","Tom, Jerry","Robin, Chris","Evan, Chris","Evan, Chris","Sam, Thomas"]
    var name = ["Alivia Orvieto","Marti McLaurin","Liz Held"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tornamentRequestLabel.isHidden = false
        getAllUserEventsList()
        userImg.image = UIImage(named: "likes")!
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
        self.userImg.clipsToBounds = true
        selectedTabViewController=0
        self.tabBarController?.delegate = self
        self.getUsersListforBlueBp()
        self.getNewUsersList()
        self.observeChannels()
        let loggedIn = UserDefaults.standard.string(forKey: "isFirstLoggedIn") ?? "1"
        if loggedIn != "0" {
            UserDefaults.standard.set("0", forKey: "isFirstLoggedIn")
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func getAllUserEventsList(){
        APIManager.callServer.getAllEventBetweenDetails(sucessResult: {(response) in
            guard let eventModelArray = response as? GetAllEventsBetweenResponseModelArray else{
                return
            }
            self.getAllEventsUsers = eventModelArray.getAllEventsBetRespModel
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
    
    
    @IBAction func tournamentRequestsSentBtnClicked(_ sender: UIButton) {
        self.tournamentRequestsLbl.text = "     Tournament Requests Sent"
    }
    
    @IBAction func tournamentRequestsReceivedBtnClicked(_ sender: UIButton) {
        self.tournamentRequestsLbl.text = "     Tournament Requests Received"
    }
    
    @IBAction func btnLikesClicked(_ sender: Any) {
        if lblUserCount.text != ""{
            self.getAllConnectedUsers()
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
            cell.imageView.layer.borderColor = UIColor.green.cgColor
            cell.imageView.layer.borderWidth = 1.5
            
            return cell
        }
        if collectionView == self.upCommingTournament {
            print("=========")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingTournamentCollectionViewCell", for: indexPath) as! UpcomingTournamentCollectionViewCell
            //            if self.getAllEventsUsers.count != 0 {
            
            cell.calendarImageView.image = UIImage(named: "calender")!
            cell.partnerImage.image = UIImage(named: "partners_1x")!
            
            let n = Int(arc4random_uniform(42))
            cell.dateLabel?.text = self.getAllEventsUsers[indexPath.row].event?.eventStartDate
            //            cell.dateLabel?.text = date[n % 3]
            cell.dateLabel.textColor = UIColor.lightGray
            //            cell.tournamentlabel?.text = eventName[n % 3]
            cell.tournamentlabel?.text = self.getAllEventsUsers[indexPath.row].event?.eventName
            cell.tournamentlabel.textColor = UIColor.lightGray
            cell.partnersName?.text = partners[n % 3]
            cell.partnersName.textColor = UIColor.lightGray
            
            return cell
        }
        
        if collectionView == self.messagesCollectionView {
            print("collectionView == messagesCollectionView")
            print("====dfhfdghvbhj====")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
            
            //            let n = Int(arc4random_uniform(42))
            //            cell.messageUserProfille.image = imageSrc[n % 3]
            
            if let imageUrl = URL(string: (self.recentChatList[indexPath.row]["profileImg"])!) {
            
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
            
            let userName = String(describing: UserDefaults.standard.value(forKey: "bP_userName") ?? "")
            let ChatuserName = self.recentChatList[indexPath.row]["receiver_name"] ?? "" as String
            if userName == ChatuserName {
              cell.nameLbl?.text = self.recentChatList[indexPath.row]["sender_name"]
            }
            else{
               cell.nameLbl?.text = self.recentChatList[indexPath.row]["receiver_name"]
            }
            
            cell.nameLbl.textColor = UIColor.lightGray
            return cell
        }
        let data = Dummy.data[indexPath.row]
        
        if collectionView == self.tournamentRequestsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentRequestsCollectionViewCell", for: indexPath) as! TournamentRequestsCollectionViewCell
            
            //            let n = Int(arc4random_uniform(42))
            //            cell.partnerImage.image = imageSrc[n % 3]
            //            cell.partnerImage.layer.cornerRadius = cell.partnerImage.frame.size.width/2
            
            if let imageUrl = URL(string: data.imageUrl) {
                cell.partnerImage.sd_setIndicatorStyle(.whiteLarge)
                cell.partnerImage.sd_setShowActivityIndicatorView(true)
                 cell.partnerImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            }
            //            let width = cell.partnerImage.bounds.size.width
            //            let height = cell.partnerImage.bounds.size.height
            
            //            let backView = UIView()
            //            backView.frame = CGRect(x:0,y:0,width:width,height:height)
            //           backView.backgroundColor = .red
            //            cell.addSubview(backView)
            //            cell.sendSubview(toBack: backView)
            
            //            cell.bringSubview(toFront: cell.partnerImage)
            
            cell.partnerImage.layer.cornerRadius = cell.partnerImage.frame.size.height/2
            
            cell.partnerImage.clipsToBounds = true
            cell.partnerImage.layer.borderColor = UIColor.lightGray.cgColor
            cell.partnerImage.layer.borderWidth = 1
            cell.partnerName?.text = data.name
            cell.partnerName.textColor = UIColor.lightGray
            
            
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
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            secondViewController.recentChatDic = self.recentChatList[indexPath.row]
            secondViewController.chatType = "recentChat"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        //         if collectionView == self.upCommingTournament {
        //
        //        }
        
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
    
    override func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
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
                self.lblUserCount.text = ""
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
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["sender_name"] as? String ?? "", forKey: "sender_name")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["text"] as! String, forKey: "text")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["profileImg"] as? String ?? "", forKey: "profileImg")
                latestMsgDic.updateValue(channelData[channelData.keys[index]]!["date"] as! String, forKey: "date")
                self.recentChatList.insert(latestMsgDic, at: 0)
                if self.recentChatList.count == 0{
                    self.msgLabel.isHidden = false
                }else{
                    self.msgLabel.isHidden = true
                    self.messagesCollectionView.reloadData()
                }
            }
            ActivityIndicatorView.hiding()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



