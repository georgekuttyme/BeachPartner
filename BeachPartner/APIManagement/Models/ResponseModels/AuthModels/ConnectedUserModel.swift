
import Foundation
import Tailor

struct ConnectedUserModelArray: SafeMappable {
    
    var connectedUserModel = [ConnectedUserModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try ConnectedUserModel(model as! [String : Any])
                connectedUserModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
}

struct ConnectedUserModel:SafeMappable {
    
    
    var status: String = ""
    var id: Int = 0
    var availableOnDate: Bool = false
    var connectedUser: ConnectedUser?
    
    init(_ map: [String : Any]) throws {
        
        status <- map.property("status")
        id <- map.property("id")
        availableOnDate <- map.property("availableOnDate")
        connectedUser = try map.relation("connectedUser").unwrapOrThrow()
    }
    
    struct ConnectedUser:SafeMappable {
        
        var activated: Int = 0
        var authToken: Int = 0
        var city: String = ""
        var age: Int = 0
        var fcmToken: String = ""
        var createdDate: String = ""
        var deviceId: String = ""
        var email: String = ""
        var firstName: String = ""
        var gender: String = ""
        var imageUrl: String = ""
        var langKey: String = ""
        var lastModifiedDate: String = ""
        var lastName: String = ""
        var location: String = ""
        var login: String = ""
        var loginType: String = ""
        var phoneNumber: String = ""
        var videoUrl: String = ""
        var userId: Int = 0
        var userType: String = ""
        var isBlocked: Bool = false
        var userMoreProfileDetails: userMoreDetails?
        
        init() {
            
        }
        
        init(_ map: [String : Any]) throws {
            
            activated <- map.property("activated")
            age <- map.property("age")
            authToken  <- map.property("authToken")
            city <- map.property("fcmToken")
            city <- map.property("city")
            createdDate <- map.property("createdDate")
            deviceId  <- map.property("deviceId")
            email <- map.property("email")
            
            firstName <- map.property("firstName")
            imageUrl <- map.property("imageUrl")
            
            langKey <- map.property("langKey")
            lastModifiedDate  <- map.property("lastModifiedDate")
            lastName <- map.property("lastName")
            
            location <- map.property("location")
            login  <- map.property("login")
            loginType <- map.property("loginType")
            
            phoneNumber <- map.property("phoneNumber")
            videoUrl <- map.property("videoUrl")
            userId  <- map.property("id")
            userType <- map.property("userType")
            userMoreProfileDetails = map.relation("userProfile")
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
}





