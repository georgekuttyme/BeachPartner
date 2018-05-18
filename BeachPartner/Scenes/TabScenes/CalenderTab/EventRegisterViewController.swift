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
    var eventURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backImage = UIImage(named:"back_58")
        let dismissButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(didTapDismissButton))
        self.navigationItem.leftBarButtonItem = dismissButton
        
       
        guard let eventURL = eventInvitation?.eventURL else {
            dismiss(animated: true, completion: nil)
            return
        }
        if let url =  URL(string: eventURL) {
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
        }
    }

    @objc func didTapDismissButton() {
        
        let alert = UIAlertController(title: "", message: "Did you successfully complete Registration?", preferredStyle: UIAlertControllerStyle.alert)
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
            
            ActivityIndicatorView.hiding()
            
            guard let responseModel = response as? CommonResponse else {
                print("Rep model does not match")
                return
            }
            self.alert(message: responseModel.message)
            
            if responseModel.status == "OK" {
                
                let alert = UIAlertController(title: "", message: "Do you want to add this event to your system Calendar?", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                    
                    let startDate = Date(timeIntervalSince1970: TimeInterval((self.eventInvitation?.eventStartDate)!/1000))
                    let endDate = Date(timeIntervalSince1970: TimeInterval((self.eventInvitation?.eventEndDate)!/1000))
                    
                    
                    self.addEventToCalendar(title: (self.eventInvitation?.eventName)!, description: self.eventInvitation?.eventDescription, startDate: startDate, endDate: endDate, completion: { (success, error) in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                let noAction = UIAlertAction(title: "No", style: .default) { (alertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                alert.addAction(noAction)
                self.present(alert, animated:true, completion: nil)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
            print(error)
            
            self.dismiss(animated: true, completion: nil)
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
