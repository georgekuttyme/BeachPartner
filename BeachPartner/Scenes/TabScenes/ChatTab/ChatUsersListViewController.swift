//
//  ChatUsersListViewController.swift
//  BeachPartner
//
//  Created by George on 4/11/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import Floaty
import DropDown
import Firebase

class RecentChatCell: UITableViewCell {

    @IBOutlet weak var chatusersView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var statusImage: UILabel!
    
}

class ChatUsersListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var toastLbl: UILabel!
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("messages")
    private var channelRefHandle: DatabaseHandle?
    var recentChatList = [[String:String]]()
    var activeUsers = [ConnectedUserModel]()
    
    let dropDown = DropDown()
     var button1 : UIBarButtonItem!
    
    @IBOutlet weak var tblChatList: UITableView!
    
    func rightBarBtn(){
        button1 = UIBarButtonItem(image: UIImage(named: "menudot"), style: .plain, target: self, action: #selector(action))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc func action() {
        dropDown.show()
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        setDropDwonMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        self.title = "Messages"
        self.toastLbl.isHidden = true
         rightBarBtn()
        
        self.hideKeyboardWhenTappedAround()
        
        let floaty = Floaty()
        floaty.size = 45
        floaty.paddingY = 85
        floaty.buttonColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        floaty.plusColor = UIColor.white
        floaty.addItem("", icon: UIImage(named: "highfive")!,handler: { item in
            self.navigationController?.popViewController(animated: false);
            floaty.close()
        })
        floaty.addItem("", icon: UIImage(named: "chat")!,handler: { item in
            floaty.close()
        })
        self.view.addSubview(floaty)
        ActivityIndicatorView.show("Loading...")
         self.tblChatList.delegate = self
        self.tblChatList.dataSource = self
    }
    func setDropDwonMenu()  {
        
        self.dropDown.anchorView = self.button1
        self.dropDown.dataSource =  ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
        self.dropDown.width = 150
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
                self.navigationController?.pushViewController(identifier, animated: true)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
            }
                
            else if(item == "Logout"){
                let refreshAlert = UIAlertController(title: "Logout", message: "Do you really want to logout from Beach Partner?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.timoutLogoutAction()
                    
                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            }
            else if (item == "Settings"){
                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
                controller.SettingsType = "profileSettings"
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else if (item == "Help"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                self.present(vc, animated: true, completion: nil)
            }
            else {
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CommmonWebViewController") as! CommmonWebViewController
                vc.titleText = item
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.present(vc, animated: true, completion: nil)
            }
        }
        self.dropDown.selectRow(0)
    }
    
    
    @objc func didTapMenuButton() {
        
        dropDown.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Messages"
        self.getBlockedConnections()
        
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
            print("activeUsers--->            ", self.activeUsers,"          ___________________")
            if self.activeUsers.count > 0 {
                self.toastLbl.isHidden = true
            }
            else {
                self.toastLbl.isHidden = false
                self.toastLbl.numberOfLines = 3
            }
            
            DispatchQueue.main.async {
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
    
    
    // MARK: - RecentChatList property's
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : RecentChatCell = tableView.dequeueReusableCell(withIdentifier: "RecentChatCell", for: indexPath) as! RecentChatCell
        
        let userName = String(describing: UserDefaults.standard.value(forKey: "bP_userName") ?? "")
        let ChatuserName = self.recentChatList[indexPath.row]["receiver_name"] ?? "" as String
        if userName == ChatuserName {
            cell.userNameLbl.text = self.recentChatList[indexPath.row]["sender_name"]
        }
        else{
            cell.userNameLbl.text = self.recentChatList[indexPath.row]["receiver_name"]
        }
        
        cell.timeLbl.isHidden = true
        cell.statusImage.isHidden = true
        if let imageUrl = URL(string: (self.recentChatList[indexPath.row]["profileImg"])!) {
            cell.profileImage.sd_setIndicatorStyle(.whiteLarge)
            cell.profileImage.sd_setShowActivityIndicatorView(true)
            cell.profileImage.sd_setImage(with: imageUrl, placeholderImage:#imageLiteral(resourceName: "user"))
        }
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.borderColor = UIColor(red:112/255, green:122/255, blue:172/255, alpha: 1).cgColor;
        cell.profileImage.layer.borderWidth = 1.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatController.recentChatDic = self.recentChatList[indexPath.row]
        chatController.chatType = "recentChat"
        let navigationController = UINavigationController(rootViewController: chatController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
