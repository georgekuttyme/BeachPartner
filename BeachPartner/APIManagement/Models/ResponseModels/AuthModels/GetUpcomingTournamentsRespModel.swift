//
//  GetUpcomingTournamentsRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 5/21/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct GetUpcomingTournamentsRespModelArray: SafeMappable {
    
    var getUpcomingTournamentsRespModel = [GetUpcomingTournamentsRespModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try GetUpcomingTournamentsRespModel(model as! [String : Any])
                getUpcomingTournamentsRespModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct GetUpcomingTournamentsRespModel: SafeMappable {
    var id : Int = 0
    var event : Event?
    var registerType : String = ""
    var organizerUser :OrganizerUser?
    var invitationStatus :String = ""
    var eventStatus : String = ""
    var invitationList : [InvitationList]?
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        event <- map.relation("event")
        registerType <- map.property("registerType")
        organizerUser <- map.relation("organizerUser")
        invitationStatus <- map.property("invitationStatus")
        eventStatus <- map.property("eventStatus")
        invitationList <- map.relations("invitationList")
        
    }
    struct Event : SafeMappable{
        var eventId : Int = 0
        var eventName: String = ""
        var eventDescription: String = ""
        var eventLocation: String = ""
        var eventVenue: String = ""
        var eventStartDate: Int = 0
        var eventEndDate: Int = 0
        var eventRegistrationStartDate: Int = 0
        var eventRegistrationEndDate: Int = 0
        var eventAdmin: String = ""
        var masterEventId: Int = 0
        var eventType: String = ""
        var teamSize: Int = 0
        var championship: String = ""
        var region: String = ""
        var state: String = ""
        var gender: String = ""
        var eventUrl: String = ""
       
        
        init(_ map: [String : Any]) throws {
            
            eventId <- map.property("id")
            eventName <- map.property("eventName")
            eventDescription <- map.property("eventDescription")
            eventLocation <- map.property("eventLocation")
            eventVenue <- map.property("eventVenue")
            eventStartDate <- map.property("eventStartDate")
            eventEndDate <- map.property("eventEndDate")
            eventRegistrationStartDate <- map.property("eventRegStartDate")
            eventRegistrationEndDate <- map.property("eventRegEndDate")
            eventAdmin <- map.property("eventAdmin")
            eventType <- map.property("eventType")
            teamSize <- map.property("teamSize")
            championship <- map.property("championship")
            region <- map.property("region")
            state <- map.property("state")
            gender <- map.property("gender")
            eventUrl <- map.property("eventUrl")
        }
    }
    struct OrganizerUser : SafeMappable {
        var id : Int = 0
        var email : String = ""
        var firstName : String = ""
        var lastName : String = ""
        var imageUrl : String = ""
        var userType: String = ""
        init(_ map: [String : Any]) throws {
            id <- map.property("id")
            email <- map.property("login")
            firstName <- map.property("firstName")
            lastName <- map.property("lastName")
            imageUrl <- map.property("imageUrl")
            userType <- map.property("userType")
        }
    }
    struct InvitationList: SafeMappable {
        var invitorId: Int = 0
        var invitorName: String = ""
        var invitorimageURL: String = ""
        var eventStatus: String = ""
        var eventpartners: [EventPartnerList]?
        
        init(_ map: [String : Any]) throws {
            invitorId <- map.property("inviterUserId")
            invitorName <- map.property("inviterName")
            invitorimageURL <- map.property("inviterImageUrl")
            eventStatus <- map.property("eventStatus")
            eventpartners <- map.relations("partnerList")
        }
    }
    
    struct EventPartnerList: SafeMappable {
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
    
}

