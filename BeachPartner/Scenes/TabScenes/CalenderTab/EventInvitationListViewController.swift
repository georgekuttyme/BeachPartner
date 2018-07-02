//
//  EventInvitationListViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 14/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

protocol EventInvitationListViewControllerDelegate {
    func refreshInvitationList()
}

class EventInvitationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventAdminLabel: UILabel!
    @IBOutlet weak var eventTeamSize: UILabel!
    
//    var event: GetEventRespModel?
    var eventInvitation: GetEventInvitationRespModel?
    var eventId: Int = 0
    
    var delegate: EventInvitationListViewControllerDelegate?
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toastAlert()
        getAllInvitations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Invitations"
    }
    func toastAlert() {
        let alert = UIAlertController(title: "Direction", message: "Please swipe left to accept or reject invitation", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Continue", style: .default) { (action) in
        }
        alert.addAction(actionButton)
        present(alert, animated: true, completion: nil)
    }
    private func setupData() {
        guard let event = eventInvitation else { return }

        eventNameLabel.text = event.eventName
        eventLocationLabel.text = event.eventState
        eventVenueLabel.text = event.eventVenue
        eventAdminLabel.text = event.eventAdmin
        eventTeamSize.text = String(event.teamSize)
        eventStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventStartDate)
        eventEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventEndDate)
        
        
        
    }
    
    private func getAllInvitations() {
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEventInvitations(eventId: eventId, calendarType: "mastercalendar", sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            
            guard let eventInvitationModel = responseModel as? GetEventInvitationRespModel else {
                print("Rep model does not match")
                return
            }
            
            
            
            guard let invitations = eventInvitationModel.invitations, invitations.count > 0 else {
                
                self.delegate?.refreshInvitationList()
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.eventInvitation = eventInvitationModel
            self.setupData()
            
            self.tableView.reloadData()
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func responsdToInvitation(action: String, index: Int) {
        
        guard let eventId = eventInvitation?.eventId else { return }
        guard let organiserId = eventInvitation?.invitations?[index].invitorId else { return }
        
        ActivityIndicatorView.show("Loading")
        
        APIManager.callServer.respondToInvitation(eventId: eventId, organiserId: organiserId, action: action, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            guard let responseModel = responseModel as? CommonResponse else {
                print("Rep model does not match")
                return
            }

            self.alert(message: responseModel.message)

            if responseModel.status == "OK" {
             
                // If accept action -leave page, if reject - reload page,
                if action == "Accept" {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.getAllInvitations()
                }
            }

        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func confirmAction(action: String, index: Int) {
        
        let alert = UIAlertController(title: "", message: "Do you really want to \(action) this invitation?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { (handlr) in
            self.responsdToInvitation(action: action, index: index)
        })
        let cancel =  UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = eventInvitation?.invitations?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventInvitationCell", for: indexPath) as? EventInvitationCell
        cell?.selectionStyle = .none
        
        let invitation = eventInvitation?.invitations![indexPath.row]
        
        
        cell?.nameLabel.text = invitation?.invitorName

        if let image = invitation?.invitorimageURL, let imageUrl = URL(string: image) {
            cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
            cell?.profileImage.sd_setShowActivityIndicatorView(true)
            cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
        }
        
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
        cell?.profileImage.clipsToBounds = true
        //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
        cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
        cell?.profileImage.layer.borderWidth = 1.5
        
        cell?.viewDetailsButton.addTarget(self, action: #selector(didTapDetailButton(sender:)), for: .touchUpInside)
        cell?.viewDetailsButton.tag = indexPath.row + 20000
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "Accept") { (rowAction, indexPath) in
            self.confirmAction(action: "Accept", index: indexPath.row)
        }
        acceptAction.backgroundColor = UIColor(red: 152/255.0, green: 227/255.0, blue: 231/255.0, alpha: 1.0)
        
        let rejectAction = UITableViewRowAction(style: .normal, title: "Reject") { (rowAction, indexPath) in
           self.confirmAction(action: "Reject", index: indexPath.row)
        }
        rejectAction.backgroundColor = UIColor(red: 244/255.0, green: 73/255.0, blue: 84/255.0, alpha: 1.0)
        return [acceptAction,rejectAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        guard let invitation = eventInvitation?.invitations?[indexPath.row] else { return }
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PartnerListView") as! PartnerListViewController
        viewController.invitation = invitation
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @objc func didTapDetailButton(sender: UIButton) {
        
        let index =  sender.tag - 20000
        guard let invitation = eventInvitation?.invitations?[index] else { return }
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PartnerListView") as! PartnerListViewController
        viewController.invitation = invitation
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }

}
