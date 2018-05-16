//
//  GetAllUserInvitationsForEventModelArray.swift
//  BeachPartner
//
//  Created by Powermac on 5/16/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
struct  GetAllUserInvitationsForEventModelArray: SafeMappable {
    
    var  getAllUserInvitationsForEventModel = [ GetAllUserInvitationsForEventModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try  GetAllUserInvitationsForEventModel(model as! [String : Any])
                getAllUserInvitationsForEventModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct  GetAllUserInvitationsForEventModel : SafeMappable {
    
    var received : Received?
    var send : Send?
    
    init(_ map: [String : Any]) throws {
        received <- map.relation("received")
        send <- map.relation("send")
    }
    struct Received : SafeMappable {
        
        init(_ map: [String : Any]) throws {
            
        }
        
        
    }
    struct Send: SafeMappable {
        var eventId : Int = 0
        var eventEndDate :Int = 0
        var teamSize : Int = 0
        var eventLocation : String = ""
        var eventName : String = ""
        var sendCount : Int = 0
        var eventStartDate : Int = 0
        
        init(_ map: [String : Any]) throws {
            eventId <- map.property("eventId")
            eventEndDate <- map.property("eventEndDate")
            teamSize <- map.property("teamSize")
            eventLocation <- map.property("eventLocation")
            eventName <- map.property("eventName")
            sendCount <- map.property("sendCount")
            eventStartDate <- map.property("eventStartDate")
        }
    }
}

