//
//  UserAccountModel.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 03/04/18.
//  Copyright © 2018 dev. All rights reserved.
//
import Foundation
import Tailor

struct AccountRespModel:SafeMappable {
    
    var activated: Int = 0
    var age: Int = 0
    var authToken: String = ""
    var city: String = ""
    var deviceId: String = ""
    var dob: Int = 0
    var inputDob: String = ""
    var email: String = ""
    var firstName: String = ""
    var gender: String = ""
    var id: Int = 0
    var imageUrl: String = ""
    var langKey: String = ""
    var lastName: String = ""
    var location: String = ""
    var login: String = ""
    var loginType: String = ""
    var phoneNumber: String = ""
    var userType: String = ""
    var videoUrl: String = ""
    var userProfile: UserProfile?
    
    init() {
        
    }
    init(_ map: [String : Any]) throws {
        
        activated <- map.property("activated")
        age  <- map.property("age")
        authToken  <- map.property("authToken")
        
        city <- map.property("city")
        deviceId  <- map.property("deviceId")
        dob <- map.property("dob")
        email <- map.property("email")
        
        firstName <- map.property("firstName")
        gender <- map.property("gender")
        
        id  <- map.property("id")
        imageUrl <- map.property("imageUrl")
        
        langKey <- map.property("langKey")
        lastName <- map.property("lastName")
        
        location <- map.property("location")
        login  <- map.property("login")
        loginType <- map.property("loginType")
        
        phoneNumber <- map.property("phoneNumber")
        videoUrl <- map.property("videoUrl")
        
        userType <- map.property("userType")
        
        userProfile = map.relation("userProfile")
        
    }
    
    
    struct UserProfile:SafeMappable {
        
        var cbvaFirstName: String = ""
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
//        var height: Int = 0
        var highSchoolAttended: String = ""
        var highestTourRatingEarned: String = ""
        var id: Int = 0
        var indoorClubPlayed: String = ""
        var numOfAthlets: String = ""
        
        var position: String = ""
        var programsOffered: String = ""
        var shareAthlets: String = ""
        var topFinishes: String = ""
        var totalPoints: Int = 0
        var tournamentLevelInterest: String = ""
        var toursPlayedIn: String = ""
        var usaVolleyballRanking: Int = 0
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
            collegeBeach  <- map.property("collegeBeach")
            collegeIndoor <- map.property("collegeIndoor")
            
            courtSidePreference <- map.property("courtSidePreference")
            description <- map.property("description")
            
            division <- map.property("division")
            experience  <- map.property("experience")
            fundingStatus <- map.property("fundingStatus")
            
            height <- map.property("height")
            highSchoolAttended  <- map.property("highSchoolAttended")
            highestTourRatingEarned <- map.property("highestTourRatingEarned")
            
            id <- map.property("id")
            indoorClubPlayed <- map.property("indoorClubPlayed")
            
            numOfAthlets <- map.property("numOfAthlets")
            position  <- map.property("position")
            
            programsOffered <- map.property("programsOffered")
            
            shareAthlets <- map.property("shareAthlets")
            topFinishes  <- map.property("topFinishes")
            totalPoints <- map.property("totalPoints")
            
            tournamentLevelInterest <- map.property("tournamentLevelInterest")
            toursPlayedIn <- map.property("toursPlayedIn")
            
            usaVolleyballRanking <- map.property("usaVolleyballRanking")
            willingToTravel <- map.property("willingToTravel")
            yearsRunning <- map.property("yearsRunning")
            
            
        }
    }
    
}

struct UpdateProfileImageVideoModel:SafeMappable {
    var profileImgUrl: String = ""
    var profileVideoUrl: String = ""
    init(_ map: [String : Any]) throws {
        profileImgUrl <- map.property("profileImgUrl")
        profileVideoUrl <- map.property("profileVideoUrl")
        
    }
}


