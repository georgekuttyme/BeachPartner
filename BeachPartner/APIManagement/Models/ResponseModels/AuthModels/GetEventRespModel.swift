//
//  GetEventRespModel.swift
//  BeachPartner
//
//  Created by seq-mary on 10/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetEventsRespModelArray: SafeMappable {
    
    var getEventsRespModel = [GetEventRespModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try GetEventRespModel(model as! [String : Any])
                getEventsRespModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct GetEventRespModel : SafeMappable {
    
    var id: Int = 0
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
        
        id <- map.property("id")
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

