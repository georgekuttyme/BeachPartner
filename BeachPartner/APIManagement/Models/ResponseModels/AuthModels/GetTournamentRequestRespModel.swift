//
//  GetTournamentRequestRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 16/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct GetTournamentRequestRespModel : SafeMappable {
    
    var requestsReceived: [EventRequestReceived] = [EventRequestReceived]()
    var requestsSent: [EventRequestSent] = [EventRequestSent]()
    
    init(_ map: [String : Any]) throws {
        
        requestsReceived <- map.relations("received")
        requestsSent <- map.relations("send")
    }
    
    struct EventRequestReceived: SafeMappable {
        var eventId: Int = 0
        var eventName: String = ""
        var eventLocation: String = ""
        var eventStartDate: Int = 0
        var eventEndDate: Int = 0
        var invitationCount: Int = 0
        var teamSize: Int = 0
        
        init(_ map: [String : Any]) throws {
            eventId <- map.property("eventId")
            eventName <- map.property("eventName")
            eventLocation <- map.property("eventLocation")
            eventStartDate <- map.property("eventStartDate")
            eventEndDate <- map.property("eventEndDate")
            invitationCount <- map.property("invitationCount")
            teamSize <- map.property("teamSize")
        }
    }
    
    struct EventRequestSent: SafeMappable {
        var eventId: Int = 0
        var eventName: String = ""
        var eventLocation: String = ""
        var eventStartDate: Int = 0
        var eventEndDate: Int = 0
        var sentCount: Int = 0
        var teamSize: Int = 0
        
        init(_ map: [String : Any]) throws {
            eventId <- map.property("eventId")
            eventName <- map.property("eventName")
            eventLocation <- map.property("eventLocation")
            eventStartDate <- map.property("eventStartDate")
            eventEndDate <- map.property("eventEndDate")
            sentCount <- map.property("sendCount")
            teamSize <- map.property("teamSize")
        }
    }
}
