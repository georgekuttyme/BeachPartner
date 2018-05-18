//
//  EventDetailsViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class EventDetailsViewController: BeachPartnerViewController {

    @IBOutlet weak var generalEventDetailsView: UIView!
    @IBOutlet weak var generalEventDetailsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventVenueLabel: UILabel!
    @IBOutlet weak var eventAdminLabel: UILabel!
    
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!
    @IBOutlet weak var regStartDateLabel: UILabel!
    @IBOutlet weak var regEndDateLabel: UILabel!
    
    @IBOutlet weak var athleteActionView: UIView!
    @IBOutlet weak var coachActionView: UIView!
    
    @IBOutlet weak var invitePartnerButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    var event: GetEventRespModel?
    
    var eventId: Int?
    var isFromHomeTab = false
    var eventInvitation: GetEventInvitationRespModel?
        
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDataFromEvent()
        
        if event?.registerType == "Invitee" || event?.registerType == "Organizer" || isFromHomeTab {
            getAllInvitations()
        }
    }

    private func setupUI() {
        eventNameLabel.adjustsFontSizeToFitWidth = true
        
        if event?.registerType == "Invitee" {
            
            invitePartnerButton.isEnabled = false
            invitePartnerButton.alpha = 0.6
            
            registerButton.isEnabled = false
            registerButton.alpha = 0.6
            
            self.backButton.setTitle("View Partners", for: .normal)
        }
        else if event?.registerType == "Organizer" {
            
            if event?.eventStaus == "Active" {
                
                invitePartnerButton.isEnabled = false
                invitePartnerButton.alpha = 0.6                
            }
            else if event?.eventStaus == "Registered" {
                
                invitePartnerButton.isEnabled = false
                invitePartnerButton.alpha = 0.6
                
                registerButton.isEnabled = false
                registerButton.alpha = 0.6
            }
            else {
                registerButton.isEnabled = false
                registerButton.alpha = 0.6
            }
            self.backButton.setTitle("View Partners", for: .normal)
        }
        else {
            registerButton.isEnabled = false
            registerButton.alpha = 0.6
        }
        
        if isFromHomeTab {
            self.backButton.setTitle("View Partners", for: .normal)
        }
        
        
        if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
            coachActionView.isHidden = true
        }
        else {
            athleteActionView.isHidden = true
        }
    }
    
    private func setupDataFromEvent() {
        guard let event = event else { return }
        
        if event.userMessage.count > 0 {
            generalEventDetailsView.isHidden = false
            generalEventDetailsLabel.text = event.userMessage
        }
        else {
            generalEventDetailsView.isHidden = true
        }
        
        eventNameLabel.text = event.eventName
        eventLocationLabel.text = event.eventLocation
        eventVenueLabel.text = event.eventVenue
        eventAdminLabel.text = event.eventAdmin
        
        eventStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventStartDate)
        eventEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventEndDate)
        regStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventRegistrationStartDate)
        regEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventRegistrationEndDate)
    }
    
    private func setupDataFromEventInvitation() {
        guard let eventInvitation = eventInvitation else { return }
        
        if isFromHomeTab {
            generalEventDetailsView.isHidden = true
        }
        
//        if isFromHomeTab && (eventInvitation.invitations?.first?.partners?.count)! < 5 {
//            
//            invitePartnerButton.isEnabled = true
//            invitePartnerButton.alpha = 1.0
//        }
//        
//        if event?.eventStaus != "Active" && event?.eventStaus != "Registered" && (eventInvitation.invitations?.first?.partners?.count)! < 5 {
//            invitePartnerButton.isEnabled = true
//            invitePartnerButton.alpha = 1.0
//        }
        
        
        
        
        
        
//        if eventInvitation.invitations?.first?.eventStatus == "Active" {
//
//        }
        
        
        
//        if event.registerType == "Organizer" {
//            generalEventDetailsLabel.text = event.userMessage
//        }
//        else if event.registerType == "Invitee" {
//            generalEventDetailsLabel.text = event.userMessage
//
//            invitePartnerButton.setTitle("View Invitation", for: .normal)
//        }
        
        eventNameLabel.text = eventInvitation.eventName
        eventLocationLabel.text = eventInvitation.eventLocation
        eventVenueLabel.text = eventInvitation.eventVenue
        eventAdminLabel.text = eventInvitation.eventAdmin
        
        eventStartDateLabel.text = dateStringFromTimeInterval(interval: eventInvitation.eventStartDate)
        eventEndDateLabel.text = dateStringFromTimeInterval(interval: eventInvitation.eventEndDate)
        regStartDateLabel.text = dateStringFromTimeInterval(interval: eventInvitation.eventRegistrationStartDate)
        regEndDateLabel.text = dateStringFromTimeInterval(interval: eventInvitation.eventRegistrationEndDate)
    }
    
    
    private func getAllInvitations() {
        
        let eventId = isFromHomeTab ? self.eventId : event?.id
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEventInvitations(eventId: eventId!, calendarType: "mastercalendar", sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            
            guard let eventInvitationModel = responseModel as? GetEventInvitationRespModel else {
                print("Rep model does not match")
                return
            }
            self.eventInvitation = eventInvitationModel
            self.setupDataFromEventInvitation()
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "EventRegisterView") as! EventRegisterViewController
        viewController.eventInvitation = self.eventInvitation
        
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func didTapInvitePartnerButton(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "InviteParentView") as! InviteParentViewController
        viewController.event = self.event
        viewController.eventInvitation = self.eventInvitation
        viewController.delegate1 = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "View Partners" {
            guard let invitation = eventInvitation?.invitations?.first else { return }
            
            let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "PartnerListView") as! PartnerListViewController
            viewController.invitation = invitation
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func didTapGoingButton(_ sender: UIButton) {
        
        guard let event = event else { return }
        let partnerList = [Int]()
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.registerEvent(eventId: event.masterEventId, registerType: "Organizer", partners: partnerList, sucessResult: { (response) in
            ActivityIndicatorView.hiding()
            
            guard let responseModel = response as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            
            self.alert(message: responseModel.message)
            self.navigationController?.popViewController(animated: true)

        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
            print(error)
        }
    }
    
    @IBAction func didTapNotGoingButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }
}

extension EventDetailsViewController: InviteParentViewControllerDelegate {
    
    func successfullyInvitedPartners(sender: UIViewController) {
        self.navigationController?.popViewController(animated: false)
    }

}





