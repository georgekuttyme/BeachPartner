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
        var id: Int = 0
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
        var userStatus: String = ""
        var userMoreDetails : userMoreDetails?
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
            userStatus <- map.property("status")
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
            userMoreDetails <- map.relation("userProfile")
        }
    }
    struct userMoreDetails:SafeMappable {
        
        var cbvaFirstName:  String = ""
        var cbvaLastName: String = ""
        var cbvaPlayerNumber: String = ""
        var collage: String = ""
        var collageClub: String = ""
        var collegeBeach: String = ""
        var collegeIndoor: String = ""
        var courtSidePreference: String = ""
        var description: String = ""
        var division: String = ""
        var experience: String = ""
        var fundingStatus: String = ""
        var height: String = ""
        var highSchoolAttended: String = ""
        var highestTourRatingEarned: String = ""
        var indoorClubPlayed: String = ""
        var numOfAthlets: String = ""
        var position: String = ""
        var programsOffered: String = ""
        var topFinishes: String = ""
        var totalPoints: String = ""
        var toursPlayedIn: String = ""
        var usaVolleyballRanking: String = ""
        var willingToTravel: String = ""
        var yearsRunning: String = ""
        
        init() {
            
        }
        init(_ map: [String : Any]) throws {
            cbvaFirstName <- map.property("cbvaFirstName")
            cbvaLastName <- map.property("cbvaLastName")
            cbvaPlayerNumber  <- map.property("cbvaPlayerNumber")
            collage <- map.property("collage")
            collageClub <- map.property("collageClub")
            collegeBeach <- map.property("collegeBeach")
            collegeIndoor <- map.property("collegeIndoor")
            courtSidePreference <- map.property("courtSidePreference")
            description <- map.property("description")
            division <- map.property("division")
            experience <- map.property("experience")
            fundingStatus <- map.property("fundingStatus")
            height <- map.property("height")
            highSchoolAttended <- map.property("highSchoolAttended")
            highestTourRatingEarned <- map.property("highestTourRatingEarned")
            indoorClubPlayed <- map.property("indoorClubPlayed")
            numOfAthlets <- map.property("numOfAthlets")
            position <- map.property("position")
            programsOffered <- map.property("programsOffered")
            topFinishes <- map.property("topFinishes")
            totalPoints <- map.property("totalPoints")
            toursPlayedIn <- map.property("toursPlayedIn")
            usaVolleyballRanking <- map.property("usaVolleyballRanking")
            willingToTravel <- map.property("willingToTravel")
            yearsRunning <- map.property("yearsRunning")
        }
    }
    
}
