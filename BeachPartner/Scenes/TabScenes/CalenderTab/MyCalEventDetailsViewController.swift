//
//  MyCalEventDetailsViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 17/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class MyCalEventDetailsViewController: UIViewController {

    @IBOutlet weak var generalEventDetailsView: UIView!
    @IBOutlet weak var generalEventDetailsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventAdminLabel: UILabel!
    
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var event: GetAllUserEventsRespModel.Event?
    var eventInvitation: GetEventInvitationRespModel?

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    var loggedInUserId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
            self.loggedInUserId =  Int(id)!
        }
        
        setupDataFromEvent()
        getAllInvitations()
    }
    
    private func setupDataFromEvent() {
        guard let event = event else { return }
        
        generalEventDetailsView.isHidden = true
//        if event.userMessage.count > 0 {
//            generalEventDetailsView.isHidden = false
//            generalEventDetailsLabel.text = event.userMessage
//        }
//        else {
//            generalEventDetailsView.isHidden = true
//        }
        
        eventNameLabel.text = event.eventName
        eventLocationLabel.text = event.eventLocation
        eventVenueLabel.text = event.eventVenue
        eventAdminLabel.text = event.eventAdmin
        
        eventStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventStartDate)
        eventEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventEndDate)
    }
    
    private func getAllInvitations() {
        
        let eventId = event?.eventId
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEventInvitations(eventId: eventId!, calendarType: "mycalendar", sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            
            guard let eventInvitationModel = responseModel as? GetEventInvitationRespModel else {
                print("Rep model does not match")
                return
            }
            self.eventInvitation = eventInvitationModel
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
        
        let alert = UIAlertController(title: "", message: "Notifications will be sent to your team partners. Coaches in your connection list and parents (if linked to your profile)will also be notified", preferredStyle: UIAlertControllerStyle.alert)
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
        cell?.selectionStyle = .none
        
        if eventInvitation?.invitations?.first?.invitorId != loggedInUserId {
            if indexPath.row == 0 {
                let partner = eventInvitation?.invitations?.first
                cell?.nameLabel.text = partner?.invitorName
                cell?.statusLabel.text = "Organiser"
                
                if let imageUrl = URL(string: (partner?.invitorimageURL)!) {
                    cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                    cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                cell?.profileImageView.layer.borderWidth = 1.5
                
                cell?.noteButton.tag = indexPath.row+300000
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
                    
                    if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                        cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                        cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                        cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                    
                    cell?.noteButton.tag = indexPath.row+300000
                    cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
                }
                else {
                    cell?.noteButton.isHidden = false
                    let partner = eventInvitation?.invitations?.first?.partners![indexPath.row - 1]
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = ""
                    
                    if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                        cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                        cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                        cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                    
                    cell?.noteButton.tag = indexPath.row+300000
                    cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
                    
                }
            }
        }
        else{
            let partner = eventInvitation?.invitations?.first?.partners![indexPath.row]
            cell?.nameLabel.text = partner?.partnerName
            cell?.statusLabel.text = ""
            
            if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
            }
            cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
            cell?.profileImageView.clipsToBounds = true
            //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
            cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
            cell?.profileImageView.layer.borderWidth = 1.5
            
            cell?.noteButton.tag = indexPath.row+300000
            cell?.noteButton.addTarget(self, action: #selector(noteBtnPressed), for: .touchUpInside)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    @objc func noteBtnPressed(sender: UIButton!) {
        let index = sender.tag-300000
        
        let storyboard = UIStoryboard(name: "ConnectionsTabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        if index == 0 {
            if let partnerId = eventInvitation?.invitations?.first?.invitorId {
                vc.toId = partnerId
            }
        }
        else {
            if let partnerId = eventInvitation?.invitations?.first?.partners![index - 1].partnerId {
                vc.toId = partnerId
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

