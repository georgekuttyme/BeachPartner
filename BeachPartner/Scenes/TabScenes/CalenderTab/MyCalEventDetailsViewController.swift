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

    
    var event: GetAllUserEventsRespModel.Event?

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//            self.eventInvitation = eventInvitationModel
//            self.setupDataFromEventInvitation()
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }
}
