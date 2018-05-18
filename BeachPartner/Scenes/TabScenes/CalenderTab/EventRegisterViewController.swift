//
//  EventRegisterViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 18/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import EventKit

class EventRegisterViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var eventInvitation: GetEventInvitationRespModel?
    var event: GetEventRespModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let dismissButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDismissButton))
        self.navigationItem.leftBarButtonItem = dismissButton
        
        
        
        let url = URL(fileURLWithPath: (event?.eventURL)!)
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
    }

    @objc func didTapDismissButton() {
        
        let alert = UIAlertController(title: "", message: "Registration complete?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            self.registerEvent()
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(noAction)
        self.present(alert, animated:true, completion: nil)
    }
    
    func registerEvent() {
        
        guard let eventInvitation = eventInvitation else { return }
        
        guard let partners = eventInvitation.invitations?.first?.partners else { return }
        var partnerList = [Int]()
        for partner in partners {
            partnerList.append(partner.partnerId)
        }
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.registerEvent(eventId: eventInvitation.eventId, registerType: "Organizer", partners: partnerList, sucessResult: { (response) in
            
            //Add event to calendar & return
            
            
            ActivityIndicatorView.hiding()
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
            print(error)
        }
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
    
    
}
