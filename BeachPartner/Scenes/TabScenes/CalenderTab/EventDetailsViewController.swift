//
//  EventDetailsViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsViewController: BeachPartnerViewController {

    enum EventStatus: String {
        case registered = "Registered"
        case active = "Active"
    }
    
    enum RegisterType: String {
        case organizer = "Organizer"
        case invitee = "Invitee"
    }
    
    
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
    @IBOutlet weak var athleteGoingView: UIView!
    @IBOutlet weak var coachActionView: UIView!
    
    @IBOutlet weak var invitePartnerButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var viewPartnersButton: UIButton!
    @IBOutlet weak var athleteGoingButton: UIButton!
    
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var notGoingButton: UIButton!
    @IBOutlet weak var eventTeamSizeLabel: UILabel!
     @IBOutlet weak var teamSizeLabel: UILabel!
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
        
        if event?.registerType == RegisterType.invitee.rawValue || event?.registerType == RegisterType.organizer.rawValue || isFromHomeTab {
            getAllInvitations()
        }
    }

    private func setupUI() {
        eventNameLabel.adjustsFontSizeToFitWidth = true
        
        if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
            coachActionView.isHidden = true
        }
        else {
            athleteActionView.isHidden = true
            athleteGoingView.isHidden = true
        }
        
        
        if event?.registerType == RegisterType.invitee.rawValue {
            
            invitePartnerButton.isEnabled = false
            invitePartnerButton.alpha = 0.6
            
            athleteGoingButton.isEnabled = false
            athleteGoingButton.alpha = 0.6
            athleteGoingButton.setTitleColor(.lightGray, for: .normal)
        }
        else if event?.registerType == RegisterType.organizer.rawValue {
            
            if event?.eventStaus == EventStatus.active.rawValue {
                
                invitePartnerButton.isEnabled = false
                invitePartnerButton.alpha = 0.6                
            }
            else if event?.eventStaus == EventStatus.registered.rawValue {
                
                invitePartnerButton.isEnabled = false
                invitePartnerButton.alpha = 0.6
                
                athleteGoingButton.isEnabled = false
                athleteGoingButton.alpha = 0.6
                athleteGoingButton.setTitleColor(.lightGray, for: .normal)
            }
        }
        else {
            viewPartnersButton.isEnabled = false
            viewPartnersButton.alpha = 0.6
        }
        
        
        // ~~~~~ Temporary fix ~~~~~~
        if let date = event?.eventRegistrationEndDate {
            let endDate = Date(timeIntervalSince1970: TimeInterval(date/1000))
            
            if endDate.compare(Date()) == .orderedAscending { // registration already closed
                invitePartnerButton.isEnabled = false
                invitePartnerButton.alpha = 0.6
                
                athleteGoingButton.isEnabled = false
                athleteGoingButton.alpha = 0.6
                athleteGoingButton.setTitleColor(.lightGray, for: .normal)
            }
            else {// registration open
               
            }
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
        eventLocationLabel.text = event.state
        eventVenueLabel.text = event.eventVenue
        eventAdminLabel.text = event.eventAdmin
        teamSizeLabel.text = String(event.teamSize)
        
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
        
        if UserDefaults.standard.string(forKey: "userType") == "Coach" {

            if eventInvitation.invitations?.first?.eventStatus == EventStatus.registered.rawValue {

                goingButton.isEnabled = false
                goingButton.alpha = 0.6
                
                notGoingButton.isEnabled = false
                notGoingButton.alpha = 0.6
            }
        }
        
        eventNameLabel.text = eventInvitation.eventName
        eventLocationLabel.text = eventInvitation.eventState
        eventVenueLabel.text = eventInvitation.eventVenue
        eventAdminLabel.text = eventInvitation.eventAdmin
        teamSizeLabel.text = String(eventInvitation.teamSize)
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
        
//        let eventURL = "https://www.beachpartner.com"
        
        let  eventURL = eventInvitation?.eventURL ?? event?.eventURL
        guard let eventRegisterURL = eventURL else {
            alert(message: "Event URL not found")
            return
        }
        
        let customURL = URL(string: eventRegisterURL)!
        if UIApplication.shared.canOpenURL(customURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(customURL)
            } else {
                UIApplication.shared.openURL(customURL)
            }
        }
        else {
            alert(message: "Unable to open the specified URL")
        }
    }
    
    @IBAction func didTapInvitePartnerButton(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "InviteParentView") as! InviteParentViewController
        viewController.event = self.event
        viewController.eventInvitation = self.eventInvitation
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didTapViewPartnerButton(_ sender: UIButton) {
        
        guard let invitation = eventInvitation?.invitations?.first else {
            alert(message: "Please invite partners")
            return
        }
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PartnerListView") as! PartnerListViewController
        viewController.invitation = invitation
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func didAddEventToDB(_ sender: UIButton) {
        
        //        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        //        let viewController = storyBoard.instantiateViewController(withIdentifier: "EventRegisterView") as! EventRegisterViewController
        //        viewController.eventInvitation = self.eventInvitation
        //
        //        let navController = UINavigationController(rootViewController: viewController)
        //        self.present(navController, animated: true, completion: nil)
        
        
        let alert = UIAlertController(title: "", message: "Did you successfully complete Registration?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            self.registerEvent()
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
        }
        alert.addAction(action)
        alert.addAction(noAction)
        self.present(alert, animated:true, completion: nil)
    }
    
    @IBAction func didTapGoingButton(_ sender: UIButton) {
        
        guard let event = event else { return }
        let partnerList = [Int]()
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.registerEvent(eventId: event.id, registerType: "Organizer", partners: partnerList, sucessResult: { (response) in
            ActivityIndicatorView.hiding()
            
            guard let responseModel = response as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            
            let alert = UIAlertController(title: "", message: responseModel.message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                self.showAddEventToCalendarPrompt()
            }
            alert.addAction(action)
            self.present(alert, animated:true, completion: nil)
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    func showAddEventToCalendarPrompt() {
        
        guard let startDate = self.event?.eventStartDate, let endDate = self.event?.eventEndDate else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let alert = UIAlertController(title: "", message: "Do you want to add this event to your system Calendar?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            ActivityIndicatorView.show("Loading")

            let sDate = Date(timeIntervalSince1970: TimeInterval(startDate/1000))
            let eDate = Date(timeIntervalSince1970: TimeInterval(endDate/1000))
            
            self.addEventToCalendar(title: self.event?.eventName ?? "", description: self.event?.eventDescription ?? "", startDate: sDate, endDate: eDate, completion: { (success, error) in
                
                DispatchQueue.main.async {
                    ActivityIndicatorView.hiding()
                    if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
                        self.getAllInvitations()
                    }
                    else {
                         self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            
            if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
                self.getAllInvitations()
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(action)
        alert.addAction(noAction)
        self.present(alert, animated:true, completion: nil)
    }
    
    
    @IBAction func didTapNotGoingButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func registerEvent() {
        
        guard let eventId = eventInvitation?.eventId ?? event?.id else {
            return
        }
        
        var partnerList = [Int]()
        if let eventInvitation = eventInvitation {
            if let partners = eventInvitation.invitations?.first?.partners {
                for partner in partners {
                    partnerList.append(partner.partnerId)
                }
            }
        }
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.registerEvent(eventId: eventId, registerType: "Organizer", partners: partnerList, sucessResult: { (response) in
            
            ActivityIndicatorView.hiding()
            
            guard let responseModel = response as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            
            let alert = UIAlertController(title: "", message: responseModel.message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                self.showAddEventToCalendarPrompt()
            }
            alert.addAction(action)
            self.present(alert, animated:true, completion: nil)
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }

}
