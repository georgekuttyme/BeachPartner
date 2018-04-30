//
//  GetAllEventsBetweenResponseModel.swift
//  BeachPartner
//
//  Created by Admin on 20/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetAllEventsBetweenResponseModelArray: SafeMappable {
    
    var getAllEventsBetRespModel = [GetAllEventsBetweenResponseModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try GetAllEventsBetweenResponseModel(model as! [String : Any])
                getAllEventsBetRespModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct GetAllEventsBetweenResponseModel : SafeMappable {
    var event: EventModel?
    init() {
        
    }
    init(_ map: [String : Any]) throws {
        event <- map.relation("event")

    }
    struct EventModel: SafeMappable {
        
        var id:String = ""
        var eventName:String = ""
        var eventDescription:String = ""
        var eventLocation:String = ""
        var eventVenue:String = ""
        var eventStartDate:String = ""
        var eventEndDate:String = ""
        var eventRegStartDate:String = ""
        var eventRegEndDate:String = ""
        var eventadmin:EventAdminModel?
        init() {
            
        }
        init(_ map: [String : Any]) throws {
            id <- map.property("id")
            eventName <- map.property("eventName")
            eventDescription <- map.property("eventDescription")
            eventLocation <- map.property("eventLocation")
            eventVenue <- map.property("eventVenue")
            eventStartDate <- map.property("eventStartDate")
            eventEndDate <- map.property("eventEndDate")
            eventRegStartDate <- map.property("eventRegStartDate")
            eventRegEndDate <- map.property("eventRegEndDate")
            eventadmin <- map.relation("eventadmin")
            
        }
        struct EventAdminModel: SafeMappable {
            var firstName:String = ""
            init() {
                
            }
            init(_ map: [String : Any]) throws {
                firstName <- map.property("firstName")
            }
            
            
        }
        
    }
    
}
