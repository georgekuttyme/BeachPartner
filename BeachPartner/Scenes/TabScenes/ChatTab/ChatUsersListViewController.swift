//
//  ChatUsersListViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 4/11/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import Floaty
import Firebase
import InitialsImageView

class RecentChatCell: UITableViewCell {

    @IBOutlet weak var chatusersView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var statusImage: UILabel!
    @IBOutlet weak var profileImgBtn: UIButton!
    
}

class ChatUsersListViewController: BeachPartnerViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var selectedTabViewController:Int!
    var filterConnectedusers = [[String:String]]()
    var searchController : UISearchController!
    var rightBarButtonItem: UIBarButtonItem!
    var activesearchBar: UISearchBar!
    var searchBtn = UIBarButtonItem()
    var selectedIndexItem = ""
    var displayType = ""
    @IBOutlet weak var toastLbl: UILabel!
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("test-messages")
    private var channelRefHandle: DatabaseHandle?
    var recentChatList = [[String:String]]()
    var activeUsers = [ConnectedUserModel]()
    
    @IBOutlet weak var tblChatList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchImage  = UIImage(named: "search")!
        searchBtn  = UIBarButtonItem(image: searchImage ,  style: .plain, target: self, action:#selector(searchBtnClicked(_:)))
        navigationItem.rightBarButtonItems = [menuBarButtonItem, searchBtn]
        
        
        self.navigationItem.setHidesBackButton(true, animated:false);
        self.navigationItem.title = "Messages"
        self.toastLbl.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
        
        let floaty = Floaty()
        floaty.size = 45
        floaty.paddingY = 85
        floaty.buttonColor = UIColor.navigationBarTintColor
        floaty.plusColor = UIColor.white
        floaty.addItem("", icon: UIImage(named: "chat")!,handler: { item in
            floaty.close()
        })
        floaty.addItem("", icon: UIImage(named: "highfive")!,handler: { item in
            let favoritesVC = self.storyboard?.instantiateViewController(withIdentifier: "HighFiveViewController") as! HighFiveViewController
            self.navigationController?.pushViewController(favoritesVC, animated: false)
            floaty.close()
        })
        self.view.addSubview(floaty)
        ActivityIndicatorView.show("Loading...")
         self.tblChatList.delegate = self
        self.tblChatList.dataSource = self
        selectedTabViewController = 4
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("\n\n\n",selectedIndexItem)
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.displayType = "search"
            print("displayItem ==> ",self.displayType)
            self.filterConnectedusers = self.recentChatList.filter({ (User) -> Bool in
                return Bool((User["sender_name"]?.contains(searchText))! || (User["sender_lastName"]?.contains(searchText))!)
            })
            print("unfiltered  -- ",self.activeUsers,"\n\n\n\n")
            print("filtered  -- ",self.filterConnectedusers,"\n\n\n")
            self.tblChatList.reloadData()
            
        }else{
        
        }
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        self.searchBtn.tintColor = UIColor.white
        self.searchBtn.isEnabled = true
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Messages"
        self.displayType = ""
        self.tblChatList.reloadData()
        
    }
    
    @objc func searchBtnClicked(_ sender: AnyObject){
        self.displayType = "search"
        self.searchController = UISearchController(searchResultsController:  nil)
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = UIColor.clear
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.showsCancelButton = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        //        searchController.searchBar.sizeToFit()
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.searchBtn.tintColor = UIColor.clear
        self.searchBtn.isEnabled = false
        //        self.becomeFirstResponder()
        self.searchController.searchBar.becomeFirstResponder()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
                self.filterConnectedusers = self.recentChatList
                self.tblChatList.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = ""
        if displayType == "search"{
            self.searchBtn.tintColor = UIColor.white
            self.searchBtn.isEnabled = true
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Messages"
            self.displayType = ""
            self.tblChatList.reloadData()
        }
//        self.title = "Messages"
        self.getBlockedConnections()
    }
    
    @IBAction func profileImageBtnClicked(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
//        vc.isFromConnectedUser = "ConnectedUser"
//        vc.connectedUserId = connectedUser.id
//        let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
//        vc1.isFromConnectedUser = "ConnectedUser"
//        vc1.connectedUserId = connectedUser.id
//        let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
//        let navController = UINavigationController(rootViewController: identifier)
//        self.present(navController, animated: true, completion: nil)
    }
    private func observeChannels() {
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
                print(channelData[channelData.keys[index]]!["sender_id"] as! String,"==== > ",channelData[channelData.keys[index]]!["receiver_id"] as! String)
                let senderId = channelData[channelData.keys[index]]!["sender_id"] as! String
                let receiverId = channelData[channelData.keys[index]]!["receiver_id"] as! String
                var isActiveUser = Bool ()
                print(bP_userId," id -------> ",id,"-----------------")
                for connectedUser in self.activeUsers {
                    let userId = String(connectedUser.connectedUser?.userId ?? 0)
                    print(userId," senderId --> ",senderId," receiverId --> ",receiverId,"")
                    if userId == senderId || userId == receiverId {
                        if bP_userId == senderId || bP_userId == receiverId {
                            latestMsgDic.updateValue(connectedUser.connectedUser?.firstName ?? "", forKey: "sender_name")
                            latestMsgDic.updateValue(connectedUser.connectedUser?.userType ?? "", forKey: "sender_userType")
                            latestMsgDic.updateValue(String(connectedUser.connectedUser?.userId ?? 0), forKey: "sender_userId")
                            latestMsgDic.updateValue(connectedUser.connectedUser?.lastName ?? "", forKey: "sender_lastName")
                            latestMsgDic.updateValue(connectedUser.connectedUser?.imageUrl ?? "", forKey: "profileImg")
                            latestMsgDic.updateValue(String(connectedUser.connectedUser?.age ?? 0), forKey: "age")
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
                    self.tblChatList .reloadData()
                }
                
            }
            ActivityIndicatorView.hiding()
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
                self.recentChatList.removeAll()
                self.observeChannels()
            }
            print("activeUsers--->            ", self.recentChatList,"          ___________________")
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
    }
    
    
    // MARK: - RecentChatList property's
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if displayType == "search" {
            if self.filterConnectedusers.count > 0 {
                self.toastLbl.isHidden = true
            }
            else {
                self.toastLbl.isHidden = false
                self.toastLbl.text = "User not found"
                self.toastLbl.numberOfLines = 0
                self.toastLbl.textColor = UIColor.gray
            }
            print(displayType,"hdddddd")
            return self.filterConnectedusers.count
        }
        else{
            if self.activeUsers.count > 0 {
                self.toastLbl.isHidden = true
            }
            else {
                self.toastLbl.isHidden = false
                self.toastLbl.text = "Messages sent or received will appear here"
                self.toastLbl.numberOfLines = 3
                self.toastLbl.textColor = UIColor.gray
            }
            print(displayType,"jghjhfghfgh")
            displayType = ""
            return self.recentChatList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : RecentChatCell = tableView.dequeueReusableCell(withIdentifier: "RecentChatCell", for: indexPath) as! RecentChatCell
        
//        let userName = String(describing: UserDefaults.standard.value(forKey: "bP_userName") ?? "")
        
//        print(self.recentChatList[indexPath.row])
        
//        let ChatuserName = self.recentChatList[indexPath.row]["receiver_name"] ?? "" as String
//        if userName == ChatuserName {
//            cell.userNameLbl.text = self.recentChatList[indexPath.row]["sender_name"]
//        }
//        else{
//            cell.userNameLbl.text = self.recentChatList[indexPath.row]["receiver_name"]
//        }
        print(displayType,"LLLLL")
        if displayType == "search" {
            var userName = ""
            var imageUrl = URL(string:"")
            if let firstName = self.filterConnectedusers[indexPath.row]["sender_name"] {
                userName = firstName + " "
            }
            if let lastName = self.filterConnectedusers[indexPath.row]["sender_lastName"] {
                userName = userName + lastName
            }
            cell.userNameLbl.text = userName
            
            
            cell.timeLbl.isHidden = true
            cell.statusImage.isHidden = true
            let image = self.filterConnectedusers[indexPath.row]["profileImg"]
            if image == "" || image == "null"{
                cell.profileImage.setImageForName(string: userName, circular: true, textAttributes: nil)
            }
            else{
                imageUrl = URL(string: (self.filterConnectedusers[indexPath.row]["profileImg"])!)
                if imageUrl != nil {
                    cell.profileImage.sd_setIndicatorStyle(.whiteLarge)
                    cell.profileImage.sd_setShowActivityIndicatorView(true)
                    cell.profileImage.sd_setImage(with: imageUrl, placeholderImage:#imageLiteral(resourceName: "user"))
                }
            }
            cell.profileImgBtn.tag = indexPath.row+600000
            cell.profileImgBtn.addTarget(self, action: #selector(didSelectItemAtIndex), for: .touchUpInside)
        }else{
            var userName = ""
            var imageUrl = URL(string:"")
            if let firstName = self.recentChatList[indexPath.row]["sender_name"] {
                userName = firstName + " "
            }
            if let lastName = self.recentChatList[indexPath.row]["sender_lastName"] {
                userName = userName + lastName
            }
            cell.userNameLbl.text = userName
            
            
            cell.timeLbl.isHidden = true
            cell.statusImage.isHidden = true
            let image = self.recentChatList[indexPath.row]["profileImg"]
            if image == "" || image == "null"{
                cell.profileImage.setImageForName(string: userName, circular: true, textAttributes: nil)
            }
            else
            {
                imageUrl = URL(string: (self.recentChatList[indexPath.row]["profileImg"])!)
                cell.profileImage.sd_setIndicatorStyle(.whiteLarge)
                cell.profileImage.sd_setShowActivityIndicatorView(true)
                cell.profileImage.sd_setImage(with: imageUrl, placeholderImage:#imageLiteral(resourceName: "user"))
            }
            cell.profileImgBtn.tag = indexPath.row+600000
            cell.profileImgBtn.addTarget(self, action: #selector(didSelectItemAtIndex), for: .touchUpInside)
        }
        
       
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.borderColor = UIColor(red:112/255, green:122/255, blue:172/255, alpha: 1).cgColor;
        cell.profileImage.layer.borderWidth = 1.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var recentChats = [[String:String]]()
        if displayType == "search" {
            recentChats = self.filterConnectedusers
        }else{
            recentChats = self.recentChatList
        }
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        print(recentChats[indexPath.row])
        
        chatController.recentChatDic = recentChats[indexPath.row]
        chatController.chatType = "recentChat"
        let navigationController = UINavigationController(rootViewController: chatController)
        self.present(navigationController, animated: true, completion: nil)
    }
    @objc func didSelectItemAtIndex(sender: UIButton!){
         if displayType == "search"{
            if let userType = self.filterConnectedusers[sender.tag-600000]["sender_userType"], userType == "Athlete"{
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                vc1.isFromConnectedUser = "ConnectedUser"
                if let age = self.filterConnectedusers[sender.tag-600000]["age"]{
                    vc1.connectedUserAge = Int(age)!
                }
                if let id = self.filterConnectedusers[sender.tag-600000]["sender_userId"]{
                    vc1.connectedUserId = Int(id)!
                }
                if let name = self.filterConnectedusers[sender.tag-600000]["sender_name"]{
                        vc1.connectedUserName = name
                }
                let navController = UINavigationController(rootViewController: vc1)
                self.present(navController, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                vc1.isFromConnectedUser = "ConnectedUser"
                if let age = self.recentChatList[sender.tag-600000]["age"]{
                    vc1.connectedUserAge = Int(age)!
                }
                if let id = self.recentChatList[sender.tag-600000]["sender_userId"]{
                    vc1.connectedUserId = Int(id)!
                }
                if let name = self.recentChatList[sender.tag-600000]["sender_name"]{
                    vc1.connectedUserName = name
                }
                let navController = UINavigationController(rootViewController: vc1)
                self.present(navController, animated: true, completion: nil)
            }
            
         }else{

            if let userType = self.recentChatList[sender.tag-600000]["sender_userType"], userType == "Athlete"{
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                vc1.isFromConnectedUser = "ConnectedUser"
                if let age = self.recentChatList[sender.tag-600000]["age"]{
                    vc1.connectedUserAge = Int(age)!
                }
                if let id = self.recentChatList[sender.tag-600000]["sender_userId"]{
                    vc1.connectedUserId = Int(id)!
                }
                if let name = self.recentChatList[sender.tag-600000]["sender_name"]{
                    vc1.connectedUserName = name
                }
                let navController = UINavigationController(rootViewController: vc1)
                self.present(navController, animated: true, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                vc1.isFromConnectedUser = "ConnectedUser"
                if let age = self.recentChatList[sender.tag-600000]["age"]{
                    vc1.connectedUserAge = Int(age)!
                }
                if let id = self.recentChatList[sender.tag-600000]["sender_userId"]{
                    vc1.connectedUserId = Int(id)!
                }
                if let name = self.recentChatList[sender.tag-600000]["sender_name"]{
                    vc1.connectedUserName = name
                }
                let navController = UINavigationController(rootViewController: vc1)
                self.present(navController, animated: true, completion: nil)
            }
         }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
