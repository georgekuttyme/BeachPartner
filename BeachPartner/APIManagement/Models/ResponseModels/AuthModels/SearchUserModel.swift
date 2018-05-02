//
//  SearchUserModel.swift
//  BeachPartner
//
//  Created by Georgekutty on 18/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct SearchUserModelArray: SafeMappable {
    
    var searchUserModel = [SearchUserModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try SearchUserModel(model as! [String : Any])
                searchUserModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}

struct SearchUserModel:SafeMappable {
    
    var status: String = ""
    var id: Int = 0
     var activated: Int = 0
     var authToken: Int = 0
    var city: String = ""
    var age: Int = 0
    var doblong: Double = 0
    var deviceId: String = ""
    var email: String = ""
    var dob: String = ""
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
    
    var connectedUser: SearchUser?
    
    init(_ map: [String : Any]) throws {

        id  <- map.property("id")
        firstName <- map.property("firstName")
        activated <- map.property("activated")
        authToken <- map.property("authToken")
        city <- map.property("city")
        age <- map.property("age")
        dob <- map.property("dob")
        doblong <- map.property("dob")
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
        
        connectedUser = map.relation("createdBy")
    }
    
    struct SearchUser:SafeMappable {
        
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
        
        init() {
            
        }
        init(_ map: [String : Any]) throws {
            activated <- map.property("activated")
            age <- map.property("age")
            authToken  <- map.property("authToken")
            city <- map.property("city")
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
        }
    }
}
