//
//  SearchUserModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 18/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
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
     var fcmToken: String = ""
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
    var userMoreProfileDetails: userMoreDetails?
    
    init(_ map: [String : Any]) throws {

        id  <- map.property("id")
        status <- map.property("status")
        firstName <- map.property("firstName")
        activated <- map.property("activated")
        authToken <- map.property("authToken")
        fcmToken <- map.property("fcmToken")
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
        userMoreProfileDetails = map.relation("userProfile")
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
