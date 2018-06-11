//
//  InvitePartnerViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 30/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//

import UIKit
import DropDown
import XLPagerTabStrip

protocol InvitePartnerViewControllerDelegate {
    
    func successfullyInvitedPartners(sender: UIViewController)
}


class InvitePartnerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider,UISearchResultsUpdating {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Connections")
    }
    
    var event: GetEventRespModel?
    var eventInvitation: GetEventInvitationRespModel?

    var delgate:InvitePartnerViewControllerDelegate?
    
    var eventId: Int?
    var eventStartDate: Int?
    
    var numberOfInvitationsLeft: Int = 5
    
    let searchController = UISearchController(searchResultsController: nil)

    var connectedUsers = [ConnectedUserModel]()
    var filteredConnectedUsers = [ConnectedUserModel]()
    var myTeam = [ConnectedUserModel]()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        return formatter
    }()
    
    
    
    //    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    
    var startPosition: CGPoint?
    var originalHeight: CGFloat = 0
    //    var customViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myteamHeight: NSLayoutConstraint!
    //    @IBOutlet weak var tabBtnsView: UIView!
    //    @IBOutlet weak var connectionsBtn: UIButton!
    //    @IBOutlet weak var connectionsView: UIView!
    @IBOutlet weak var myTeamHeaderButton: UIButton!
    
    @IBOutlet weak var bottomview: UIView!
    
    @IBOutlet weak var partnerTableVIew: UITableView!
    @IBOutlet weak var myteamtableView: UITableView!
    //    @IBOutlet weak var findPartnerBtn: UIButton!
    //    @IBOutlet weak var findPartnerView: UIView!
    
    
    var isExpanded = false

    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
 
        
        
        self.partnerTableVIew.separatorColor = UIColor.clear
         self.myteamtableView.separatorColor = UIColor.clear
        self.bottomview.isHidden = true
        
        if let event = event {
            eventId = event.id
            eventStartDate = event.eventStartDate
        }
        if let eventInvitation = eventInvitation {
            eventId = eventInvitation.eventId
            eventStartDate = eventInvitation.eventStartDate
        }

        myTeamHeaderButton.addTarget(self, action: #selector(didTapMyTeamHeaderButton(sender:)), for: .touchUpInside)
        
        getConnectionsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        partnerTableVIew.tableHeaderView = searchController.searchBar
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.view.endEditing(true)
//    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    func filterContentForSearchText(searchText: String) {
        
        filteredConnectedUsers = connectedUsers.filter({ (user) -> Bool in
            
            if let firstName = user.connectedUser?.firstName, firstName.lowercased().contains(searchText.lowercased()) {
                return true
            }
            else if let lastName = user.connectedUser?.lastName, lastName.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        })
        partnerTableVIew.reloadData()
    }
    
    
    private func getConnectionsList() {
        
        guard let eventStartDate = eventStartDate  else { return }
        
        let date = Date(timeIntervalSince1970: TimeInterval(eventStartDate/1000))
        let eventDate = formatter.string(from: date)
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUserConnectionList(status:"status=Active&filterDate=\(eventDate)",sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()

            guard let connectedUserModelArray = responseModel as? ConnectedUserModelArray else { return }
            
            guard let userType = UserDefaults.standard.string(forKey: "userType") else { return }
            
            self.connectedUsers = connectedUserModelArray.connectedUserModel.filter({ (user) -> Bool in
                return Bool(user.connectedUser?.userType == userType)
            })
            
            self.partnerTableVIew.reloadData()
            
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else { return }
            self.alert(message: errorString)
        })
    }
    
    @objc func didTapAddButton(sender: UIButton) {
        
        if myTeam.count == numberOfInvitationsLeft {
            self.alert(message: "Only 5 invitations allowed")
            return
        }
        
        let index = sender.tag-200000
        let user = isFiltering() ? filteredConnectedUsers[index] : connectedUsers[index]
        myTeam.append(user)
        
        if isFiltering() {
            
            let index = connectedUsers.index(where: { (connectedUser) -> Bool in
                return Bool(user.connectedUser?.userId == connectedUser.connectedUser?.userId)
            })
            if let index = index {
                connectedUsers.remove(at: index)
            }
            filterContentForSearchText(searchText: searchController.searchBar.text ?? "")
        }
        else {
            connectedUsers.remove(at: index)
        }
        
        myteamtableView.reloadData()
        partnerTableVIew.reloadData()
    }
    
    @objc func didTapDeleteButton(sender: UIButton) {
        let index = sender.tag-300000
        let user = self.myTeam[index]
        let userName = String(user.connectedUser?.firstName ?? "")
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to remove \(String(describing: userName)) from your potential partners?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle NO logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle YES Logic here")
            
            
            self.connectedUsers.append(user)
            self.myTeam.remove(at: index)
            
            self.myteamtableView.reloadData()
            self.partnerTableVIew.reloadData()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func didTapMyTeamHeaderButton(sender: UIButton) {
        
        if myteamHeight.constant == 1 {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                self.myteamHeight.constant = (UIScreen.main.bounds.height/2) - 100
                self.bottomview.isHidden = false
                self.view.layoutIfNeeded()
                self.myteamtableView.reloadData()
//                self.partnerTableVIew.reloadData()
            }, completion: { (complete) in
                
            })
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                self.myteamHeight.constant = 1
                self.bottomview.isHidden = true
                self.view.layoutIfNeeded()
//                self.myteamtableView.reloadData()
                self.partnerTableVIew.reloadData()
            }, completion: { (complete) in
            })
        }
    }

    @IBAction func didTapInviteFriendButton(_ sender: UIButton) {
        
        guard let eventId = eventId else { return }
        if myTeam.count == 0 { return }
        
        var partnerList = [Int]()
        for member in myTeam {
            if let userid = member.connectedUser?.userId {
                partnerList.append(userid)
            }
        }
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.registerEvent(eventId: eventId, registerType: "Invitee", partners: partnerList, sucessResult: { (response) in
            
            ActivityIndicatorView.hiding()
            
            guard let responseModel = response as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            self.alert(message: responseModel.message)
            
            if responseModel.status == "OK" {
                self.delgate?.successfullyInvitedPartners(sender: self)
            }
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
            print(error)
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        
//       self.navigationController!.navigationBar.topItem!.title = "Event Name"
//    }
    
    // MARK:- Tableview Datasource & Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == partnerTableVIew) {
            return isFiltering() ? filteredConnectedUsers.count: connectedUsers.count
        }
        return myTeam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == partnerTableVIew) {
            
            var connectedUser : ConnectedUserModel.ConnectedUser
            
            if isFiltering() {
                connectedUser = filteredConnectedUsers[indexPath.row].connectedUser!
            }
            else {
                connectedUser = connectedUsers[indexPath.row].connectedUser!
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePartnerCell", for: indexPath) as? InvitePartnerCell
            
            if (indexPath.row == self.connectedUsers.count-1) {
                cell?.separatorInset = UIEdgeInsetsMake(0.0, (cell?.bounds.size.width)!, 0.0, 0.0);
            }
            cell?.selectionStyle = .none
            
            cell?.nameLbl.text = connectedUser.firstName
            
            let image = connectedUser.imageUrl
            let imageUrl = URL(string: image)
                cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
                cell?.profileImage.sd_setShowActivityIndicatorView(true)
                cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            
            
            cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
            cell?.profileImage.clipsToBounds = true
            //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
            cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
            cell?.profileImage.layer.borderWidth = 1.5
            
            
            
            cell?.addBtn.isHidden = isFiltering() ? !filteredConnectedUsers[indexPath.row].availableOnDate : !connectedUsers[indexPath.row].availableOnDate
            
            
            if (cell?.addBtn.isHidden)! {
                cell?.nameLbl.textColor = UIColor.gray
                cell?.unAvailableLbl.text = "Unavailable"
                cell?.unAvailableLbl.textColor = UIColor.gray
                cell?.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                cell?.nameLbl.textColor = UIColor.gray
            }else{
                cell?.unAvailableLbl.text = ""
                cell?.backgroundColor = UIColor.white
                cell?.nameLbl.textColor = UIColor.black
            }
                
            cell?.addBtn.tag = indexPath.row+200000
            cell?.addBtn.addTarget(self, action: #selector(didTapAddButton(sender:)), for: .touchUpInside)
            
            return cell!
        }
        
        
        
        else if(tableView == myteamtableView) {
            
            let user = myTeam[indexPath.row].connectedUser
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyteamCell", for: indexPath) as? MyteamCell
            cell?.selectionStyle = .none
            
            cell?.nameLbl.text = user?.firstName
            
            if let image = user?.imageUrl, let imageUrl = URL(string: image) {
                cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
                cell?.profileImage.sd_setShowActivityIndicatorView(true)
                cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            }
            
            cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
            cell?.profileImage.clipsToBounds = true
            cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
            //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
            cell?.profileImage.layer.borderWidth = 1.5
            
            cell?.addBtn.isHidden = true
            cell?.delBtn.tag = indexPath.row+300000
            cell?.delBtn.addTarget(self, action: #selector(didTapDeleteButton(sender:)), for: .touchUpInside)
            
            return cell!
        }
        else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "MyteamCell", for: indexPath) as? MyteamCell
            cell?.addBtn.isHidden = true
            //        cell?.nameLbl.text = name[indexPath.row]
            //        let n = Int(arc4random_uniform(42))
            //        cell?.profileImage.image = imageSrc[ n % 3 ]
            //        cell?.profileImage.layer.cornerRadius = (cell?.imageView?.frame.size.width)!/2
            //        cell?.profileImage.clipsToBounds = true
            //        cell?.profileImage.layer.borderColor = UIColor.lightGray.cgColor
            //        cell?.profileImage.layer.borderWidth = 1
            return cell!
        }
    }

    
    // MARK:-
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first
//        startPosition = touch?.location(in: self.myteamtableView)
//        originalHeight = myteamHeight.constant
//
//    }
//
//    //    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//
//        let endPosition = touch?.location(in: self.myteamtableView)
//        let difference = endPosition!.y - startPosition!.y
//
//        myteamHeight.constant = originalHeight - difference
//
//
//
//        print("screen size : ",(UIScreen.main.bounds.height/2) + 80 , " diff : ", (originalHeight - difference) )
////        if((UIScreen.main.bounds.height/2) - 80 > (originalHeight - difference) ){
//            myteamHeight.constant = originalHeight - difference
////            self.view.layoutSubviews()
//
//            //            if(myteamHeight.constant > 100 ){
//            //                self.bottomview.isHidden = false
//            //            }
//            //            else {
//            //                self.bottomview.isHidden = true
//            //            }
////        }
//    }
}

    

