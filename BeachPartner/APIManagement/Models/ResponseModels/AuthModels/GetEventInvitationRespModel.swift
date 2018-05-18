//
//  GetEventInvitationRespModel.swift
//  BeachPartner
//
//  Created by seq-mary on 15/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetEventInvitationRespModel : SafeMappable {
    
    var eventId: Int = 0
    var eventName: String = ""
    var eventDescription: String = ""
    var eventLocation: String = ""
    var eventVenue: String = ""
    var eventStartDate: Int = 0
    var eventEndDate: Int = 0
    var eventRegistrationStartDate: Int = 0
    var eventRegistrationEndDate: Int = 0
    var eventAdmin: String = ""
    var teamSize: Int = 0
    var invitations: [EventInvitation]?
    var eventURL: String = ""
    
    init(_ map: [String : Any]) throws {
        
        eventId <- map.property("eventId")
        eventName <- map.property("eventName")
        eventDescription <- map.property("eventDescription")
        eventLocation <- map.property("eventLocation")
        eventVenue <- map.property("eventVenue")
        eventStartDate <- map.property("eventStartDate")
        eventEndDate <- map.property("eventEndDate")
        eventRegistrationStartDate <- map.property("eventRegStartDate")
        eventRegistrationEndDate <- map.property("eventRegEndDate")
        eventAdmin <- map.property("eventAdmin")
        teamSize <- map.property("teamSize")
        invitations <- map.relations("invitationList")
        eventURL <- map.property("eventUrl")
    }
}

struct EventInvitation: SafeMappable {
    var invitorId: Int = 0
    var invitorName: String = ""
    var invitorimageURL: String = ""
    var eventStatus: String = ""
    var partners: [EventPartner]?
    
    init(_ map: [String : Any]) throws {
        invitorId <- map.property("inviterUserId")
        invitorName <- map.property("inviterName")
        invitorimageURL <- map.property("inviterImageUrl")
        eventStatus <- map.property("eventStatus")
        partners <- map.relations("partnerList")
    }
}

struct EventPartner: SafeMappable {
    var partnerId: Int = 0
    var partnerName: String = ""
    var partnerImageURL: String = ""
    var invitationStatus: String = ""
    
    init(_ map: [String : Any]) throws {
        partnerId <- map.property("partnerUserId")
        partnerName <- map.property("partnerName")
        partnerImageURL <- map.property("partnerImageUrl")
        invitationStatus <- map.property("invitationStatus")
    }
}

