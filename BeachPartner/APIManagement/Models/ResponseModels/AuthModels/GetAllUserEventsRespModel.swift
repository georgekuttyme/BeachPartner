//
//  GetAllUserEventsRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 5/16/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct GetAllUserEventsRespModelArray: SafeMappable {
    
    var getAllUserEventsRespModel = [GetAllUserEventsRespModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try GetAllUserEventsRespModel(model as! [String : Any])
                getAllUserEventsRespModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct GetAllUserEventsRespModel : SafeMappable {
    
    
    
    var id: Int = 0
    var event : Event?
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        event <- map.relation("event")
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
        var createdDate: Int = 0
        var lastModifiedDate: Int = 0
        var status: String = ""
        var activeDates = [String]()
        //    var createdBy:
        //    var lastModifiedBy
        
        
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
            masterEventId <- map.property("masterEventId")
            eventType <- map.property("eventType")
            teamSize <- map.property("teamSize")
            championship <- map.property("championship")
            region <- map.property("region")
            state <- map.property("state")
            gender <- map.property("gender")
            createdDate <- map.property("createdDate")
            lastModifiedDate <- map.property("lastModifiedDate")
            status <- map.property("status")
        }
    }
}



