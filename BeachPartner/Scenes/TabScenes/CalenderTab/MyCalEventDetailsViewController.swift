//
//  MyCalEventDetailsViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 17/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import InitialsImageView

class MyCalEventDetailsViewController: UIViewController {

    @IBOutlet weak var generalEventDetailsView: UIView!
    @IBOutlet weak var generalEventDetailsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventAdminLabel: UILabel!
    @IBOutlet weak var eventTeamSize: UILabel!
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!
    @IBOutlet weak var partnerListHeaderLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var event: GetAllUserEventsRespModel.Event?
    var eventInvitation: GetEventInvitationRespModel?
    var isFromHomeTab = false
    var eventId: Int?
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    var loggedInUserId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
            self.loggedInUserId =  Int(id)!
        }

        if UserDefaults.standard.string(forKey: "userType") == "Coach" {
            partnerListHeaderLabel.text = "Athletes"
        }
        
        getAllInvitations()
        setupDataFromEvent()
    }
    
    private func setupDataFromEvent() {
        if isFromHomeTab{
            generalEventDetailsView.isHidden = true
            eventNameLabel.text = self.eventInvitation?.eventName
            eventLocationLabel.text = self.eventInvitation?.eventState
            eventVenueLabel.text = self.eventInvitation?.eventVenue
            eventAdminLabel.text = self.eventInvitation?.eventAdmin
            if let teamCount = self.eventInvitation?.teamSize {
                eventTeamSize.text = String(teamCount)
            }
            print(String((self.eventInvitation?.teamSize) ?? 0),"---String(event.teamSize)")
            if (self.eventInvitation?.eventStartDate) != nil {
                eventStartDateLabel.text = dateStringFromTimeInterval(interval: (self.eventInvitation?.eventStartDate)!)
            }
            if (self.eventInvitation?.eventEndDate) != nil {
                eventEndDateLabel.text = dateStringFromTimeInterval(interval: (self.eventInvitation?.eventEndDate)!)
            }
        }else {
            guard let event = event else { return }
            print("event  ==",event)
            generalEventDetailsView.isHidden = true
            eventNameLabel.text = event.eventName
            eventLocationLabel.text = event.state
            eventVenueLabel.text = event.eventVenue
            eventAdminLabel.text = event.eventAdmin
            eventTeamSize.text = String(event.teamSize)
            print(String(event.teamSize),"String(event.teamSize)")
            eventStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventStartDate)
            eventEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventEndDate)
        }
    }
    
    private func getAllInvitations() {
        
//        let eventId = event?.eventId
        let eventId = isFromHomeTab ? self.eventId : event?.eventId
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEventInvitations(eventId: eventId!, calendarType: "mycalendar", sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            
            guard let eventInvitationModel = responseModel as? GetEventInvitationRespModel else {
                print("Rep model does not match")
                return
            }
            self.eventInvitation = eventInvitationModel
            if self.isFromHomeTab{
                self.setupDataFromEvent()
            }
            self.tableView.reloadData()
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    @IBAction func didTapCourtAssignmentButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Notifications will be sent to your team partners. Coaches in your connection list and parents (if linked to your profile) will also be notified.", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Send", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text, text.count > 0 {
                self.notifyCourtNumberToOthers(courtNumber: text)
            }
            else {
                self.alert(message: "Input Field is empty")
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Court Number"
            textField.keyboardType = .numberPad
        }
        let cancelAction =  UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated:true, completion: nil)
    }
    
    func notifyCourtNumberToOthers(courtNumber: String) {
        
        guard let courtNumber = Int(courtNumber) else {
            self.alert(message: "Invalid Number")
            return
        }
        guard let eventId = event?.eventId, let orgId = eventInvitation?.invitations?.first?.invitorId else { return }

        ActivityIndicatorView.show("Loading")
        APIManager.callServer.notifyCourtNumber(eventId: eventId, organiserId: orgId, courtNumber: courtNumber, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let responseModel = responseModel as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            self.alert(message: responseModel.message)
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }
}

extension MyCalEventDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = eventInvitation?.invitations?.first?.partners?.count {
            return count 
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath) as? PartnerListCell
        
        if (indexPath.row == (self.eventInvitation?.invitations?.first?.partners?.count)!-1) {
            cell?.separatorInset = UIEdgeInsetsMake(0.0, (cell?.bounds.size.width)!, 0.0, 0.0);
        }
        cell?.selectionStyle = .none
        
        if eventInvitation?.invitations?.first?.invitorId != loggedInUserId {
            if indexPath.row == 0 {
                let partner = eventInvitation?.invitations?.first
                cell?.nameLabel.text = partner?.invitorName
                cell?.statusLabel.text = "Organizer"
                let username = partner?.invitorName
                let image = partner?.invitorimageURL
                let status = partner?.inviterStatus
                if status == "Flagged"{
                    cell?.profileImageView.image = UIImage(named:"user")
                }else{
                    if image == "" || image == "null"{
                        cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                    }
                    else{
                        if let imageUrl = URL(string: (partner?.invitorimageURL)!) {
                            cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                            cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                            cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                        }
                    }
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                cell?.profileImageView.layer.borderWidth = 1.5
                
                cell?.noteButton.tag = (partner?.invitorId)!+300000
                cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
                
                if partner?.invitorId == loggedInUserId {
                    cell?.noteButton.isHidden = true
                }
                else {
                    cell?.noteButton.isHidden = false
                }
            }
            else {
                if eventInvitation?.invitations?.first?.partners![indexPath.row - 1].partnerId == loggedInUserId {
                    cell?.noteButton.isHidden = true
                    let partner = eventInvitation?.invitations?.first?.partners![(eventInvitation?.invitations?.first?.partners?.count)! - 1]
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = ""
                    let username = partner?.partnerName
                    let image = partner?.partnerImageURL
                    let status = partner?.partnerStatus
                    if status == "Flagged"{
                        cell?.profileImageView.image = UIImage(named:"user")
                    }else{
                        if image == "" || image == "null"{
                            cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                        }else{
                            if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                                cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                                cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                            }
                        }
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                    
                    cell?.noteButton.tag = (partner?.partnerId)!+300000
                    cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
                }
                else {
                    cell?.noteButton.isHidden = false
                    let partner = eventInvitation?.invitations?.first?.partners![indexPath.row - 1]
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = ""
                    let username = partner?.partnerName
                    let image = partner?.partnerImageURL
                    let status = partner?.partnerStatus
                    if status == "Flagged"{
                        cell?.profileImageView.image = UIImage(named:"user")
                    }else{
                        if image == "" || image == "null"{
                            cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                        }else{
                            if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                                cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                                cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                            }
                        }
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                    
                    cell?.noteButton.tag = (partner?.partnerId)!+300000
                    cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
                    
                }
            }
        }
        else{
            let partner = eventInvitation?.invitations?.first?.partners![indexPath.row]
            cell?.nameLabel.text = partner?.partnerName
            cell?.statusLabel.text = ""
            let username = partner?.partnerName
            let image = partner?.partnerImageURL
            let status = partner?.partnerStatus
            if status == "Flagged"{
                cell?.profileImageView.image = UIImage(named:"user")
            }else{
                if image == "" || image == "null"{
                    cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                }else{
                    if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                        cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                        cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                        cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                    }
                }
            }
            cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
            cell?.profileImageView.clipsToBounds = true
            //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
            cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
            cell?.profileImageView.layer.borderWidth = 1.5
            
            cell?.noteButton.tag = (partner?.partnerId)!+300000
            cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
        }
        
        
        cell?.contentView.layer.cornerRadius = 4.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = false
        cell?.layer.shadowColor = UIColor.gray.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell?.layer.shadowRadius = 4.0
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: (cell?.bounds)!, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    @objc func noteBtnPressed(sender: UIButton!) {
        let index = sender.tag-300000
        
        let storyboard = UIStoryboard(name: "ConnectionsTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        vc.toId = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

