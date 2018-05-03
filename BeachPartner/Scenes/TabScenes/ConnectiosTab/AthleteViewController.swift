//
//  AthleteViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 22/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class AthleteViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate  {
    var blockStatus = "Block"
    @IBOutlet weak var collectionView: UICollectionView!
    var count: Int = 0
    private var i: Int = 0
    var connectedUsers = [ConnectedUserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getConnections()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.connectedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell
        
        //         let data = Dummy.data[indexPath.row]
        let connectedUser = self.connectedUsers[indexPath.row].connectedUser
        //        cell?.nameLbl.text = name[indexPath.item]
        
        //        let n = Int(arc4random_uniform(42))
        //        let val = String((n % 3 ) + 1)
        
        cell?.nameLbl.text = connectedUser?.firstName
        cell?.ageLbl.text = String(connectedUser?.age ?? 0)
        if let imageUrl = URL(string: (connectedUser?.imageUrl)!) {
            cell?.profileImgView.sd_setIndicatorStyle(.whiteLarge)
            cell?.profileImgView.sd_setShowActivityIndicatorView(true)
            cell?.profileImgView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
        }
        cell?.profileImgView.layer.cornerRadius = (cell?.profileImgView.frame.size.width)!/2
        cell?.profileImgView.clipsToBounds = true
        cell?.profileImgView.layer.borderColor = UIColor.green.cgColor
        cell?.profileImgView.layer.borderWidth = 1.5
        
        //        if(cell?.profileImgView.image == nil){
        //            cell?.profileImgView.image = UIImage(named: "image_" + val)
        //        }
        
        
        cell?.profileImgView.layer.cornerRadius = (cell?.profileImgView.frame.size.height)! / 2
        cell?.profileImgView.layer.masksToBounds = true
        cell?.expandBtn.tag = indexPath.row
        
        let blockButtonTitle = (connectedUser?.isBlocked)! ? "UNBLOCK" : "BLOCK"
        cell?.blockBtn.setTitle(blockButtonTitle, for: .normal)
        cell?.blockBtn.tag = indexPath.row+200000
        cell?.blockBtn.addTarget(self, action: #selector(blockBtnPressed(sender:)), for: .touchUpInside)
        cell?.messageBtn.tag = indexPath.row+100000
        cell?.messageBtn.addTarget(self, action: #selector(msgBtnPressed), for: .touchUpInside)
        cell?.notesBtn.tag = indexPath.row+300000
        cell?.notesBtn.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
        //        cell?.expandBtn.addTarget(self, action:  #selector(btnPressed(_:)), for: .touchUpInside)
        return cell!
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
            ActivityIndicatorView.hiding()
        })
    }
    
    func getConnections() {
        
        ActivityIndicatorView.show("Loading...")
        
        APIManager.callServer.getUserConnectionList(status:"status=Active&showReceived=false",sucessResult: { (responseModel) in
            
            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else {
                return
            }
            self.connectedUsers = connectedUserModelArray.connectedUserModel.filter({ (user) -> Bool in
                return Bool(user.connectedUser?.userType == "Athlete")
            })
            self.getBlockedConnections()

//            self.collectionView.reloadData()
//            ActivityIndicatorView.hiding()
                    
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
                return Bool(user.connectedUser?.userType == "Athlete")
            })

            for connectedUser in blockedUsers {
                var user = connectedUser
                user.connectedUser?.isBlocked = true
                self.connectedUsers.append(user)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
    
    @objc func noteBtnPressed(sender: UIButton!){
        let connectedUser = self.connectedUsers[sender.tag-300000]
        let index = sender.tag-300000
        let storyboard = UIStoryboard(name: "ConnectionsTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        vc.index = index
        vc.connectedUserModel = connectedUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func msgBtnPressed(sender: UIButton!) {
       let connectedUser = self.connectedUsers[sender.tag-100000]
        if connectedUser.connectedUser?.isBlocked  == false {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            secondViewController.connectedUserModel = [connectedUser]
            secondViewController.chatType = "Connections"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else{
            
        }
    }
    
    @objc func blockBtnPressed(sender: UIButton!) {
        
        let connectedUser = self.connectedUsers[sender.tag-200000]
        let index = sender.tag-200000

        if (connectedUser.connectedUser?.isBlocked)! {
            unBlockUser(connectedUser: connectedUser, atIndex: index)
        }
        else {
            blockUser(connectedUser: connectedUser, atIndex: index)
        }
    }
}
