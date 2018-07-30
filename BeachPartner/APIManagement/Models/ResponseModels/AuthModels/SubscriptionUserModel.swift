//
//  SubscriptionUserModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 14/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct SubscriptionUserModelArray: SafeMappable {
    
    var subscriptionUserModel = [SubscriptionUserModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try SubscriptionUserModel(model as! [String : Any])
                subscriptionUserModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}

struct SubscriptionUserModel:SafeMappable {

    var status: String = ""
    var id: Int = 0
    var connectedUser: SubscribedUser?
    
    init(_ map: [String : Any]) throws {
        status <- map.property("status")
        id  <- map.property("id")
        connectedUser = map.relation("user")
    }
    
     struct SubscribedUser:SafeMappable {
        
        var activated: Int = 0
        var authToken: Int = 0
        var city: String = ""
        var age: Int = 0
        var id: String = ""
        var dob: String = ""
        var deviceId: String = ""
        var email: String = ""
        var firstName: String = ""
        var gender: String = ""
        var imageUrl: String = ""
        var langKey: String = ""
        var lastName: String = ""
        var location: String = ""
        var login: String = ""
        var loginType: String = ""
        var phoneNumber: String = ""
        var videoUrl: String = ""
        var userType: String = ""
        var fcmToken: String = ""
        
        init() {
            
        }
        init(_ map: [String : Any]) throws {
            activated <- map.property("activated")
            age <- map.property("age")
            authToken  <- map.property("authToken")
            city <- map.property("city")
            fcmToken <- map.property("fcmToken")
            id <- map.property("id")
            dob <- map.property("dob")
            deviceId <- map.property("deviceId")
            email <- map.property("email")
            firstName <- map.property("firstName")
            gender <- map.property("gender")
            imageUrl <- map.property("imageUrl")
            langKey <- map.property("langKey")
            lastName <- map.property("lastName")
            location <- map.property("location")
            login <- map.property("login")
            loginType <- map.property("loginType")
            phoneNumber <- map.property("phoneNumber")
            videoUrl <- map.property("videoUrl")
            userType <- map.property("userType")
        }
    }
}
