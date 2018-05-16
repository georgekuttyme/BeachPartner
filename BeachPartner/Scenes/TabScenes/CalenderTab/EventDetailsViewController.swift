//
//  EventDetailsViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class EventDetailsViewController: BeachPartnerViewController {

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
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }

    private func setupUI() {
        eventNameLabel.adjustsFontSizeToFitWidth = true
        
        if event?.status == "Active" && event?.registerType == "Organizer" {
            registerButton.isEnabled = true
            registerButton.alpha = 1.0
        }
        else {
            registerButton.isEnabled = false
            registerButton.alpha = 0.6
        }
        
        if UserDefaults.standard.string(forKey: "userType") == "Athlete" {
            coachActionView.isHidden = true
        }
        else {
            athleteActionView.isHidden = true
        }
    }
    
    private func setupData() {
        guard let event = event else { return }
        
        if event.registerType == "Organizer" {
            generalEventDetailsLabel.text = event.userMessage
        }
        else if event.registerType == "Invitee" {
            generalEventDetailsLabel.text = event.userMessage
            
            invitePartnerButton.setTitle("View Invitation", for: .normal)
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
    
    @IBAction func didTapInvitePartnerButton(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        if event?.registerType == "Invitee" {
            
            guard let eventId = self.event?.masterEventId else { return }
            let viewController = storyBoard.instantiateViewController(withIdentifier: "InvitationListView") as! EventInvitationListViewController
            viewController.eventId = eventId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let viewController = storyBoard.instantiateViewController(withIdentifier: "InviteParentView") as! InviteParentViewController
            viewController.event = self.event
            self.navigationController?.pushViewController(viewController, animated: true)
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
