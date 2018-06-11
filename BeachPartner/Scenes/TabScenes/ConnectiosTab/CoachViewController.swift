//
//  CoachViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 22/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class CoachViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toastCoachLbl: UILabel!
    private var arrayImage = [AnyHashable]()
    var count: Int = 0
    private var i: Int = 0
    var connectedUsers = [ConnectedUserModel]()
    var filterConnectedusers = [ConnectedUserModel]()
     var displayType = ""


    
//    let name = ["Alivia Orvieto","Marti McLaurin","Liz Held","Alivia Orvieto","Marti McLaurin","Liz Held","Alivia Orvieto","Marti McLaurin","Liz Held","Alivia Orvieto"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getConnections()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func coachConnectionsSearch(searchItem:String){
        print("displayItem ==> ",self.displayType)
        self.filterConnectedusers = self.connectedUsers.filter({ (user) -> Bool in
            return Bool((user.connectedUser?.firstName.contains(searchItem))! || (user.connectedUser?.lastName.contains(searchItem))!)
        })
        print("unfiltered  -- ",self.connectedUsers,"\n\n\n\n")
        print("filtered  -- ",self.filterConnectedusers,"\n\n\n")
        
    }
    
    func blockUser(connectedUser: ConnectedUserModel, atIndex index: Int) {
        
        guard let id = connectedUser.connectedUser?.userId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.blockConnectedUser(id: id,sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let resp = responseModel as? ConnectedUserModelArray else {
                return
            }
            DispatchQueue.main.async {
                var blockedUser = connectedUser
                blockedUser.connectedUser?.isBlocked = true
                self.connectedUsers.remove(at:index)
                print(self.connectedUsers.count)
                self.connectedUsers.append(blockedUser)
                print(self.connectedUsers.count)
                self.collectionView.reloadData()
                
                print("User Blocked======",id)
            }
        }, errorResult: { (error) in
            
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
            
        })
    }
    
    func unBlockUser(connectedUser: ConnectedUserModel, atIndex index: Int) {
        
        guard let id = connectedUser.connectedUser?.userId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.unBlockConnectedUser(id: id, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let resp = responseModel as? ConnectedUserModelArray else {
                return
            }
            print("User UnBlocked======", id)
            
            DispatchQueue.main.async {
                var blockedUser = connectedUser
                blockedUser.connectedUser?.isBlocked = false
                self.connectedUsers.remove(at:index)
                print(self.connectedUsers.count)
                self.connectedUsers.insert(blockedUser, at: 0)
                print(self.connectedUsers.count)
                self.collectionView.reloadData()
            }
        }, errorResult: { (error) in
            
            guard let errorString  = error else {
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if displayType == "search"{
            return self.filterConnectedusers.count
         }else {
            return self.connectedUsers.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell
        
        var connectedUser : ConnectedUserModel.ConnectedUser?
        if displayType == "search"{
            connectedUser = self.filterConnectedusers[indexPath.row].connectedUser
        }else {
            connectedUser = self.connectedUsers[indexPath.row].connectedUser
        }
        //        cell?.nameLbl.text = name[indexPath.item]
        
        //        let n = Int(arc4random_uniform(42))
        //        let val = String((n % 3 ) + 1)
        
        let firstName = connectedUser?.firstName ?? ""
        let lastName = connectedUser?.lastName ?? ""
        cell?.nameLbl.text = firstName + " " + lastName
        cell?.ageLbl.text = String(connectedUser?.age ?? 0)
        if let imageUrl = URL(string: (connectedUser?.imageUrl)!) {
            cell?.profileImgView.sd_setIndicatorStyle(.whiteLarge)
            cell?.profileImgView.sd_setShowActivityIndicatorView(true)
            cell?.profileImgView.sd_setImage(with: imageUrl, placeholderImage:#imageLiteral(resourceName: "user"))
        }
        cell?.profileImgView.layer.cornerRadius = (cell?.profileImgView.frame.size.width)!/2
        cell?.profileImgView.clipsToBounds = true
//        cell?.profileImgView.layer.borderColor = UIColor.green.cgColor UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
        cell?.profileImgView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
        cell?.profileImgView.layer.borderWidth = 1.5
        
        //        if(cell?.profileImgView.image == nil){
        //            cell?.profileImgView.image = UIImage(named: "image_" + val)
        //        }

        
        cell?.profileImgView.layer.cornerRadius = (cell?.profileImgView.frame.size.height)! / 2
        cell?.profileImgView.layer.masksToBounds = true
        cell?.expandBtn.tag = indexPath.row
        //        cell?.expandBtn.addTarget(self, action:  #selector(btnPressed(_:)), for: .touchUpInside)
        let blockButtonTitle = (connectedUser?.isBlocked)! ? "UNBLOCK" : "BLOCK"
        cell?.blockBtn.setTitle(blockButtonTitle, for: .normal)
        cell?.blockBtn.tag = indexPath.row+200000
        cell?.blockBtn.addTarget(self, action: #selector(blockBtnPressed), for: .touchUpInside)
        
        let cellBgColor = (connectedUser?.isBlocked)! ? UIColor.lightGray : UIColor.white
        cell?.bgView.backgroundColor = cellBgColor
        
        cell?.messageBtn.tag = indexPath.row+100000
        cell?.messageBtn.addTarget(self, action: #selector(msgBtnPressed), for: .touchUpInside)
        cell?.notesBtn.tag = indexPath.row+300000
        cell?.notesBtn.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
        
        cell?.didSelectBtn.tag = indexPath.row+600000
        cell?.didSelectBtn.addTarget(self, action: #selector(didSelectItemAtIndex), for: .touchUpInside)
        
        cell?.contentView.layer.cornerRadius = 2.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true;
        
        cell?.layer.shadowColor = UIColor.gray.cgColor
        cell?.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell?.layer.shadowRadius = 4.0
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.masksToBounds = false;
        cell?.layer.shadowPath = UIBezierPath(roundedRect:(cell?.bounds)!, cornerRadius:(cell?.contentView.layer.cornerRadius)!).cgPath
        
        
        
        return cell!
    }

    @objc func didSelectItemAtIndex(sender: UIButton!){
        var connectedUser: ConnectedUserModel.ConnectedUser?
        if displayType == "search"{
            connectedUser = self.filterConnectedusers[sender.tag-600000].connectedUser
        }else{
            connectedUser = self.connectedUsers[sender.tag-600000].connectedUser
        }
        
        //        let index = sender.tag-600000
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
        vc.isFromConnectedUser = "ConnectedUser"
        vc.connectedUserId = connectedUser?.userId ?? 0
        vc.connectedUserName = connectedUser?.firstName ?? ""
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    func getConnections() {
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUserConnectionList(status:"status=Active&showReceived=false",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else {
                return
            }
            self.connectedUsers = connectedUserModelArray.connectedUserModel.filter({ (user) -> Bool in
                return Bool(user.connectedUser?.userType == "Coach")
            })
            
            self.collectionView.reloadData()
            if self.connectedUsers.count == 0{
                self.toastCoachLbl.isHidden = false
                
            }else{
                self.toastCoachLbl.isHidden = true
                
            }
            ActivityIndicatorView.hiding()
            
            self.getBlockedConnections()
            
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                
                return
            }
            ActivityIndicatorView.hiding()
            self.alert(message: errorString)
        })
    }
    func getBlockedConnections() {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUserConnectionList(status:"status=Blocked&showReceived=false",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else {
                return
            }
            let blockedUsers = connectedUserModelArray.connectedUserModel.filter({ (user) -> Bool in
                return Bool(user.connectedUser?.userType == "Coach")
            })
            
            for connectedUser in blockedUsers {
                var user = connectedUser
                user.connectedUser?.isBlocked = true
                self.connectedUsers.append(user)
            }
            
            if self.connectedUsers.count > 0 {
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
            else{
                self.collectionView.isHidden = true
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
    
    @objc func noteBtnPressed(sender: UIButton!){
        var connectedUser: ConnectedUserModel
        if displayType == "search"{
            connectedUser = self.filterConnectedusers[sender.tag-300000]
        }else{
            connectedUser = self.connectedUsers[sender.tag-300000]
        }
        let index = sender.tag-300000
        let storyboard = UIStoryboard(name: "ConnectionsTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        vc.index = index
        vc.connectedUserModel = connectedUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func msgBtnPressed(sender: UIButton!) {
        var connectedUser: ConnectedUserModel
        if displayType == "search"{
            connectedUser = self.filterConnectedusers[sender.tag-100000]
        }else{
            connectedUser = self.connectedUsers[sender.tag-100000]
        }
        if connectedUser.connectedUser?.isBlocked  == false {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let chatController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatController.connectedUserModel = [connectedUser]
            chatController.chatType = "Connections"
            let navigationController = UINavigationController(rootViewController: chatController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func blockBtnPressed(sender: UIButton!){
        
        print("displayItem ==> cell for row at",self.displayType)
        var connectedUser: ConnectedUserModel
        if displayType == "search"{
            connectedUser = self.filterConnectedusers[sender.tag-200000]
        }else{
            connectedUser = self.connectedUsers[sender.tag-200000]
        }
        let index = sender.tag-200000
        
        var message = ""
        var actionTitle = ""
        
        let userName = connectedUser.connectedUser?.firstName ?? "this user"
        
        if (connectedUser.connectedUser?.isBlocked)! {
            message = "Do you want to UnBlock \(userName)?"
            actionTitle = "UnBlock"
        }
        else {
            message = "Do you want to Block \(userName)?"
            actionTitle = "Block"
        }
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: actionTitle, style: .default) { (action) in
            
             if (connectedUser.connectedUser?.isBlocked)! {
                self.unBlockUser(connectedUser: connectedUser, atIndex: index)
             }
             else {
                self.blockUser(connectedUser: connectedUser, atIndex: index)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            self.collectionView.reloadData()
        }
        alert.addAction(actionButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
}

